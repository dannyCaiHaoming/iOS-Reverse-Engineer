# 已验证观察值

这份文件用于实验后的结果校准，不应在第一次 LLDB 实操前照抄。

验证环境：Apple Swift 6.3.2，arm64 macOS，SwiftPM Debug 构建。

## 构建与回归检查

`swift run BusinessLogicLabChecks` 六项检查全部通过：

- 合法同用户 premium 导出允许。
- baseline 使用权威授权。
- 本地篡改被安全服务端拒绝。
- 安全服务端检查资源归属。
- 错误模式可复现授权缺陷。
- trace 标明错误信任客户端声明。

## 符号断点

正则：

```lldb
image lookup -rn 'SensitiveActionCoordinator.*exportReport'
```

当前构建返回一个方法主体：

```text
BusinessLogicCore.SensitiveActionCoordinator.exportReport(requestedOwnerID:)
```

不同 Swift 版本的摘要和地址会变化，不应把地址写死。

## Local Tamper 入口现场

断在 `exportReport` 时，业务调用栈可见：

```text
SensitiveActionCoordinator.exportReport
  <- LabScenarioRunner.run
  <- BusinessLogicLabCLI_main
```

关键对象同时显示：

```text
requestedOwnerID = alice
cachedSession.token = lab-token-bob
cachedSession.userID = bob
cachedSession.role = analyst
cachedSession.isPremium = true
exportAPI.mode = secure
serverSessions[lab-token-bob].role = viewer
serverSessions[lab-token-bob].isPremium = false
```

安全意义：本地 Bob 的 claims 已被修改，但服务端保存的 Bob 权威会话未改变。这一帧只能证明信任源发生差异；还必须继续到 `authorizeSecurely` 的 owner 检查和最终拒绝，才能完成结论。

## 工具环境说明

当前仅激活 Command Line Tools，未提供 XCTest/Swift Testing 模块，所以课程使用 `BusinessLogicLabChecks`。LLDB 第一次受桌面执行环境限制启动较慢，但最终成功命中断点并读取变量。用户本机若遇到启动失败，应保留错误输出并检查开发者工具权限或改用 Xcode 调试自建 App。
