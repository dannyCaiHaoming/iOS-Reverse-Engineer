# Lesson 03：用 LLDB 证明业务调用链

建议用时：120 分钟，另安排至少 120 分钟实操。

## 1. LLDB 的角色

LLDB 在移动安全中不是“改返回值工具”，而是运行时证据采集器。它主要回答：

- 当前场景是否真的经过候选函数？
- 是谁调用了它，后续又走向哪里？
- 关键参数、对象状态和返回值是什么？
- 同一函数在不同场景下走了哪个分支？
- 静态猜测何时被运行时事实推翻？

本周只对自建 Demo 调试。

## 2. 四层调试模型

```text
target：待调试程序、模块、符号和断点
process：正在运行的进程、内存与线程
thread：当前执行线程和停靠原因
frame：某一层函数调用及其局部变量
```

常用检查：

```lldb
target modules list
process status
thread list
thread backtrace
frame info
frame variable
```

命令报错时先判断自己处于哪一层。例如进程尚未启动时不能读取当前 frame。

## 3. 符号发现优先于盲目下断点

Swift 符号包含模块、类型、方法签名，且不同编译器版本可能生成 thunk、特化版本或闭包符号。先搜索：

```lldb
image lookup -rn 'SensitiveActionCoordinator.*exportReport'
image lookup -rn 'ClientPolicyEvaluator.*evaluate'
image lookup -rn 'MockExportAPI.*perform'
image lookup -rn 'authorizeSecurely|authorizeUsingClientClaims'
```

再下正则断点：

```lldb
breakpoint set -r 'SensitiveActionCoordinator.*exportReport'
breakpoint set -r 'ClientPolicyEvaluator.*evaluate'
breakpoint set -r 'MockExportAPI.*perform'
```

验收重点不是断点数量，而是每个断点对应哪个安全假设。

## 4. 调用栈是控制流证据

断住后执行：

```lldb
bt
thread backtrace all
frame select 0
frame info
up
down
```

`bt` 至少要解释：

- frame 0 当前函数为什么停住；
- 上一层是谁调用它；
- 哪一层对应业务入口；
- 系统/运行时 frame 哪些可以暂时忽略；
- 调用栈是否与源码候选图一致。

只截图 `bt` 不算完成。证据日志要写成人能读懂的调用链。

## 5. 变量观察：先静态读取，再执行表达式

优先使用：

```lldb
frame variable
frame variable request
frame variable session
```

`frame variable` 主要读取调试信息和内存，不主动调用对象方法。需要更灵活时再用：

```lldb
expression -- request.requestedOwnerID
expression -- request.claimedRole
po request
```

`expression`/`po` 可能执行代码、触发 getter、改变状态，甚至因当前线程或优化状态失败。因此证据中要记录使用了哪一种方式。

Swift 常见问题：

- 参数可能显示为 `$arg1` 或被优化掉。
- enum/struct 的显示依赖调试信息和 formatter。
- Release 优化后局部变量可能不可用。
- 私有函数可能出现多个编译器生成符号。

本周使用 Debug 构建建立方法，第 3 周再面对优化和符号不完整。

## 6. 单步策略

```lldb
next
step
finish
continue
```

- `next`：跨过当前源码行，不进入调用。
- `step`：进入当前调用，可能进入标准库或编译器辅助代码。
- `finish`：运行到当前函数返回，适合观察返回前后差异。
- `continue`：继续到下一个有意义断点。

安全分析中优先使用“少量高价值断点 + continue”。连续单步几十层通常会进入 Swift Runtime，耗时且没有业务信息。

## 7. 条件断点与差分场景

同一方法被频繁调用时使用条件，但 Swift 表达式条件可能受版本和变量可见性影响。先确认变量可读，再设置：

```lldb
breakpoint list
breakpoint modify -c 'requestedOwnerID == "alice"' 1
```

如果条件表达式不稳定，可用更可靠的差分方式：每次只运行一个 CLI 场景，并在证据中记录启动参数。

```lldb
settings set target.run-args local-tamper
run
```

## 8. 断点命令用于证据自动化

为某个断点增加自动命令：

```lldb
breakpoint command add 1
> bt 6
> frame variable
> continue
> DONE
```

适用场景：

- 函数调用频率高，不希望每次手工操作；
- 比较多个场景的参数差异；
- 保留可复现的调用栈日志。

输出仍需人工解释。自动日志不是风险结论。

## 9. 本周三层断点设计

### 入口层

`SensitiveActionCoordinator.exportReport`

要证明：场景确实进入敏感动作，`requestedOwnerID` 是什么，调用者是谁。

### 客户端策略层

`ClientPolicyEvaluator.evaluate`

要证明：本地 session 的 role/premium 是否已被修改，客户端是否放行。

### 服务端授权模拟层

`MockExportAPI.perform` 与两个私有授权函数。

要证明：token、requested owner、client claims 分别是什么；服务端选择了哪种信息源和分支。

完整证据必须把三层连接起来。单独证明任何一层都不足以判断真实业务影响。

## 10. 返回值与状态修改的正确用途

在授权 Lab 中，修改状态可以用于验证“若此条件改变，后续路径是否可达”。它是路径探索手段，不是最终结论。

正确实验结构：

```text
修改本地状态
  -> 客户端策略是否变化
  -> 请求是否变化
  -> 服务端授权是否变化
  -> 敏感结果是否产生
```

错误表达：

> 我把 premium 返回值改成 true，所以存在高危会员绕过。

正确表达：

> 本地 premium 属于可变客户端状态，修改后客户端准入被绕过；在安全服务端模式下，token 对应的权威角色和资源归属仍被检查，因此未形成服务端越权。错误模式下服务端直接信任客户端 role/premium 且缺少 owner 校验，跨用户导出才构成真实授权问题。

## 11. iOS App 中的迁移

在 Xcode/iOS 场景中，同一方法通常这样迁移：

- 用按钮 action、ViewModel、service 方法作为业务入口。
- 对 URLSession/网络库请求构造处设符号断点。
- 在模拟器调试自建 App；真机需合法签名和调试权限。
- ObjC 方法可使用 `breakpoint set -n '-[Class method:]'`。
- SwiftUI/async 调用栈可能包含大量框架 frame，需要识别自己的模块。

本周 CLI 不覆盖 iOS 特有代码签名、沙盒和进程附加限制，不能把成功调试 CLI 写成“已掌握真机 App 逆向”。

## 12. 面试官验真与自测

- `frame variable` 与 `po` 的差异是什么？
- 符号断点命中多个位置时你怎么处理？
- 为什么 Debug 下能看到变量，Release 下可能看不到？
- 调用栈中出现大量 Swift Runtime frame，如何回到业务函数？
- 条件断点不稳定时，有什么替代实验设计？
- 你如何证明一个客户端字段最终参与了服务端授权？
