# 第 2 周本地参考手册

这份文件用于实验时快速查阅。必需知识已整理在本地，不要求跳转外部材料。

## 1. 构建命令

在 `02-labs/demo` 下执行：

```bash
swift build
swift run BusinessLogicLabChecks
swift run BusinessLogicLabCLI baseline
swift run BusinessLogicLabCLI local-tamper
swift run BusinessLogicLabCLI server-trusts-client
```

Debug 可执行文件通常位于：

```text
.build/debug/BusinessLogicLabCLI
```

具体架构目录由 SwiftPM 管理，可用以下命令查询：

```bash
swift build --show-bin-path
```

## 2. LLDB 启动

```bash
lldb .build/debug/BusinessLogicLabCLI
```

或先启动 LLDB 再创建 target：

```lldb
target create .build/debug/BusinessLogicLabCLI
settings set target.run-args baseline
run
```

## 3. LLDB 对象模型

| 层级 | 常用命令 | 作用 |
| --- | --- | --- |
| target | `target modules list`、`image lookup` | 模块、符号、断点 |
| process | `process status`、`process kill` | 进程状态和生命周期 |
| thread | `thread list`、`bt` | 线程和调用栈 |
| frame | `frame info`、`frame variable` | 当前函数和局部状态 |

## 4. 符号与模块

```lldb
target modules list
image list
image lookup -rn 'export|Export'
image lookup -rn 'authorize|Authorize'
image lookup -rn 'Session|Policy'
```

`-r` 表示正则搜索，`-n` 表示按符号名。Swift 符号可能包含模块、类型、参数标签和编译器辅助后缀。

## 5. 断点

```lldb
breakpoint set -r 'SensitiveActionCoordinator.*exportReport'
breakpoint set -r 'ClientPolicyEvaluator.*evaluate'
breakpoint set -r 'MockExportAPI.*perform'
breakpoint set -r 'authorizeSecurely|authorizeUsingClientClaims'
breakpoint list
breakpoint disable 2
breakpoint enable 2
breakpoint delete 2
```

按源码文件/行断点仅用于引导阶段：

```lldb
breakpoint set --file MockExportAPI.swift --line <line-number>
```

不要把固定行号写进长期脚本，源码变化会使它失效。

## 6. 运行参数和生命周期

```lldb
settings set target.run-args baseline
run
process kill
settings set target.run-args local-tamper
run
```

如果进程已退出，可以直接修改参数后再次 `run`。

## 7. 调用栈与 frame

```lldb
bt
bt 8
thread backtrace all
frame select 0
frame info
up
down
```

分析时先找到属于 `BusinessLogicCore` 和 `BusinessLogicLabCLI` 的 frame，再解释系统 Runtime frame。

## 8. 变量和表达式

```lldb
frame variable
frame variable request
frame variable session
expression -- request.requestedOwnerID
po request
```

选择原则：

- 只读现有局部变量时优先 `frame variable`。
- 需要 Swift 表达式或 getter 时使用 `expression`。
- 需要对象描述时使用 `po`。
- 记录 `expression` 可能执行代码并影响现场。

## 9. 单步

```lldb
next
step
finish
continue
```

优先依赖高价值断点和 `continue`。`step` 进入 Runtime 后，可用 `finish` 返回或重新命中下一个业务断点。

## 10. 断点命令

```lldb
breakpoint command add <id>
> bt 6
> frame variable
> continue
> DONE
```

查看配置：

```lldb
breakpoint list <id>
```

## 11. 条件断点

```lldb
breakpoint modify -c 'requestedOwnerID == "alice"' <id>
```

Swift 条件依赖当前 frame 中变量是否可见。若失败：

1. 先无条件断住并确认变量名。
2. 尝试完整字段访问。
3. 改用每次运行一个场景的差分实验。

## 12. Debug 与 Release 差异

Debug 通常具备：

- 较完整符号和源码映射；
- 较少优化；
- 局部变量更容易观察；
- 调用结构更接近源码。

Release 可能出现：

- 函数内联和消除；
- 变量放入寄存器或不再保留；
- 函数合并、特化和 thunk；
- 调用栈与源码结构不同。

因此本周结论必须写明 Debug 构建。第 3 周开始比较 Release。

## 13. Swift 常见符号现象

- 同一方法可能有主体、thunk、协议见证、闭包和泛型特化符号。
- `private` 不代表二进制中一定完全没有可定位痕迹。
- `@inline(never)` 仅用于稳定教学断点，生产代码不应为方便逆向而添加。
- 结构体按值传递可能产生复制，观察到两个实例不一定是异常。
- async 函数的逻辑调用链可能跨 task 恢复点。

## 14. 故障排查

### 找不到可执行文件

运行 `swift build --show-bin-path`，用返回目录下的 `BusinessLogicLabCLI`。

### 正则断点 0 locations

先确认 `swift build` 成功，再用更宽的 `image lookup -rn 'Export|export'`；根据实际符号缩小。

### 断点命中很多位置

查看 `breakpoint list` 和每个 location 的完整符号，禁用 thunk/辅助符号，或使用更完整正则。

### `frame variable` 看不到参数

确认当前 frame 是否为预期函数；切换到正确 frame；使用 Debug 构建；必要时尝试 `expression`。不要伪造观察结果。

### 无法启动进程

确认当前系统允许 LLDB 调试本地自建程序。公司受管设备、沙箱或开发者工具权限可能阻止进程控制。保留错误信息，不要把环境失败当成知识失败。

## 15. 可靠资料出处

以下只用于核验，不是本周必读任务：

- LLDB 官方 Tutorial：`https://lldb.llvm.org/use/tutorial.html`
- LLDB 官方命令映射：`https://lldb.llvm.org/use/map.html`
- Apple Archived LLDB Guide：`https://developer.apple.com/library/archive/documentation/General/Conceptual/lldb-guide/`
- Swift 官方 Debugging 文档入口：`https://www.swift.org/documentation/`

教案中的命令以当前 Demo 实测为准；不同 Swift/Xcode 版本的符号名称和变量显示可能变化。
