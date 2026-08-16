# Business Logic Lab

这是第 2 周的可运行 Swift Demo。它把移动 App 常见业务链抽成一个小型核心模块：

```text
登录会话 -> 本地权限缓存 -> 客户端策略 -> 请求声明 -> 服务端授权 -> 导出结果
```

核心代码使用纯 Swift，因此可由命令行工具直接构建和 LLDB 调试；同一模块可以在后续接入 SwiftUI App。这样做的目的是先把调用链、对象状态和授权边界练扎实，不把时间消耗在 Xcode 工程配置上。

注意：命令行环境不等于完整 iOS 运行时。本周证据覆盖 Swift 编译产物和业务调用链，不宣称覆盖 UIKit/SwiftUI 生命周期、iOS 沙盒、代码签名或真机反调试。这些边界必须写入报告。

`iOSAdapter/BusinessFlowLabView.swift` 提供了接入第 1 周 SwiftUI App 的薄 UI。它不是本周必做项；有完整 Xcode 时，可把本目录作为 Local Package 加入自建 App，再把该 View 加入导航。安全分析仍以 `BusinessLogicCore` 调用链为主。

## 构建和测试

在本目录执行：

```bash
swift run BusinessLogicLabChecks
swift run BusinessLogicLabCLI all
```

本工作区当前 Command Line Tools 不提供 `XCTest`/Swift Testing 模块，因此 Demo 使用零依赖的可执行回归检查器，失败时返回非零状态。安装并切换到完整 Xcode 后，可以再把这些用例迁移到 XCTest；本周不把环境配置作为学习重点。

预期业务结果：

| 场景 | 本地状态 | 服务端模式 | 预期结果 | 安全含义 |
| --- | --- | --- | --- | --- |
| `baseline` | Alice，analyst + premium | 安全 | allowed | 合法用户访问自己的资源 |
| `local-tamper` | Bob 本地改成 analyst + premium | 安全 | deniedByServer | 本地策略可改不等于服务端失守 |
| `server-trusts-client` | Bob 本地改成 analyst + premium | 信任客户端声明 | allowed | 服务端未做资源归属和权威权限校验 |

## 启动 LLDB

先构建 Debug 版本：

```bash
swift build
lldb .build/debug/BusinessLogicLabCLI
```

进入 LLDB 后：

```lldb
settings set target.run-args local-tamper
breakpoint set -r 'SensitiveActionCoordinator.*exportReport'
breakpoint set -r 'ClientPolicyEvaluator.*evaluate'
breakpoint set -r 'MockExportAPI.*perform'
run
```

如果 Swift 版本导致正则命中多个 thunk 或泛型辅助符号，先使用：

```lldb
image lookup -rn 'SensitiveActionCoordinator.*exportReport'
breakpoint list
```

再根据列出的完整符号缩小正则。不要假设不同 Swift/Xcode 版本生成的符号完全一致。

本工作区已经验证：当前 Swift 6.3.2 Debug 构建可搜索到一个 `SensitiveActionCoordinator.exportReport` 方法主体，断点处 `frame variable` 能读取本地缓存与服务端会话差异。你的证据仍应自行重做，不能直接引用该结论。

## 目录阅读建议

第一次只看：

- `LabScenarioRunner.swift`
- `Models.swift`
- CLI 的 `main.swift`

先画候选链，再读其他实现验证。完成引导实验后，关闭源码编辑器，根据 `lab02-blind-analysis.md` 做 75 分钟盲定位。

## 故意存在的安全对照

`ServerAuthorizationMode.trustsClientClaims` 是自建实验中的故意错误实现。正确服务端授权必须使用服务端会话和资源归属关系，不可信任客户端提交的角色、会员状态或 owner 声明。

修复作业应保留对照价值：可以删除错误模式，也可以让它最终调用统一的权威授权函数。测试必须证明跨用户请求被拒绝且合法请求仍成功。
