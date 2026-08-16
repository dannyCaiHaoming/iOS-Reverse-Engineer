# Lab 01：引导式业务调用链与 LLDB 取证

建议用时：4 小时。授权范围仅限 `02-labs/demo`。

## 实验目标

完成三条链路的静态和动态对应：

```text
场景入口 -> 会话状态 -> 本地策略 -> 请求 -> 服务端授权 -> 结果
```

最终不是得到“allowed”，而是解释为什么 allowed/denied。

## Step 0：基线与环境记录

```bash
cd mobile-security/week02/02-labs/demo
swift --version
swift run BusinessLogicLabChecks
swift run BusinessLogicLabCLI all
```

记录：Swift 版本、CPU 架构、构建模式、三个场景输出。当前工作区可能只启用了 Command Line Tools，这足以运行 SwiftPM Demo；完整 iOS App 调试仍需要 Xcode。

## Step 1：先画候选链

只阅读 `LabScenarioRunner.swift`、`Models.swift` 和 CLI `main.swift`，填写：

- 入口；
- 会话生产者；
- 会话缓存；
- 敏感动作；
- 预期客户端决策；
- 预期服务端决策。

先不要阅读 `MockExportAPI.swift` 的私有授权函数。写出你对两个模式差异的假设。

## Step 2：构建并加载 LLDB

```bash
swift build
lldb .build/debug/BusinessLogicLabCLI
```

```lldb
settings set target.run-args baseline
target modules list
image lookup -rn 'SensitiveActionCoordinator.*exportReport'
image lookup -rn 'ClientPolicyEvaluator.*evaluate'
image lookup -rn 'MockExportAPI.*perform'
```

将搜索结果写入证据日志。若一个正则出现多个符号，标记哪些可能是方法主体、thunk 或编译器辅助符号。

## Step 3：验证 baseline 调用链

```lldb
breakpoint set -r 'SensitiveActionCoordinator.*exportReport'
breakpoint set -r 'ClientPolicyEvaluator.*evaluate'
breakpoint set -r 'MockExportAPI.*perform'
breakpoint set -r 'authorizeSecurely'
run
```

每次停住执行：

```lldb
bt 8
frame info
frame variable
```

只在必要时：

```lldb
po session
po request
```

记录 Alice 的 token、userID、requestedOwnerID、role、premium。token 为教学值；真实项目必须脱敏。

## Step 4：验证 local-tamper

重新启动目标：

```lldb
process kill
settings set target.run-args local-tamper
run
```

观察点：

1. `ClientPolicyEvaluator.evaluate` 收到的 Bob 本地 session 是否已变成 analyst + premium。
2. `ExportRequestFactory.makeRequest` 是否把本地 claims 复制进请求。
3. `MockExportAPI.perform` 收到的 bearer token 属于谁。
4. `authorizeSecurely` 使用的是 request claims 还是 `serverSession`。
5. 拒绝发生在 entitlement 还是 owner 检查。

结论必须包含：客户端已放行，但安全服务端拒绝，因此当前证据没有证明跨用户资源泄露。

## Step 5：验证 server-trusts-client

增加错误授权函数断点：

```lldb
breakpoint set -r 'authorizeUsingClientClaims'
process kill
settings set target.run-args server-trusts-client
run
```

记录：

- token 仍属于 Bob；
- requestedOwnerID 为 Alice；
- client claims 为 analyst + premium；
- 错误授权函数是否比较 token 主体与 owner；
- 最终是否返回 allowed。

这是本周唯一可写成完整服务端授权风险的对照场景。

## Step 6：一次条件断点或自动日志

选择一个断点，添加命令：

```lldb
breakpoint list
breakpoint command add <breakpoint-id>
> bt 6
> frame variable
> continue
> DONE
```

如果当前工具链对 Swift 条件表达式支持稳定，再尝试条件断点。失败不扣分，但必须记录失败原因和替代方案。

## Step 7：证据对应

把结果整理为：

| 判断 | 静态证据 | 动态证据 | 结论 |
| --- | --- | --- | --- |
| 本地 claims 可变 | SessionStore 修改方法 | evaluate 中对象值 | 客户端字段不可信 |
| 安全模式检查 owner | 源码条件 | secure 分支命中与拒绝 | 未形成服务端越权 |
| 错误模式信任 claims | 错误授权函数 | claims/owner/allowed | 构成模拟跨用户授权问题 |

## Step 8：修复和复测

修改 `authorizeUsingClientClaims`，使其不再仅依据客户端 claims。推荐两种实现：

1. 删除该模式，统一调用权威授权。
2. 保留模式名用于实验，但内部根据 token 查找 server session，并执行 owner + entitlement 校验。

运行：

```bash
swift run BusinessLogicLabChecks
swift run BusinessLogicLabCLI all
```

修复后更新测试预期：`server-trusts-client` 应被拒绝。合法 baseline 必须继续允许。

## 验收失败条件

- 只有最终输出，没有调用栈和参数证据。
- 只证明本地字段被改，没有继续到服务端。
- 把自建服务端模拟说成真实远程漏洞。
- 修复只删除客户端按钮或写死 `false`。
- 修复导致合法 baseline 同时失败，却没有发现。
