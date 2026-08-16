# 第 1 周 Demo 实验手册：iOS Security Lab v0.1

本手册用于指导你完成第 1 周 Demo 实验，并留下可面试的证据。

## 实验目标

你不是为了写一个漂亮 App，而是为了构造一个可控安全实验环境。后续 LLDB、Frida、证书绑定、反调试、隐私扫描都会围绕这个 App 扩展。

第 1 周 Demo 覆盖 4 个实验点：

1. UserDefaults 保存 token 的错误示范。
2. Keychain 保存 token 的相对推荐示范。
3. URL Scheme 外部输入边界。
4. WKWebView JSBridge Native 调用边界。

## 环境要求

- macOS
- Xcode
- iOS Simulator 或自己的 iPhone

本周不要求：

- 越狱设备
- Frida
- LLDB 深度调试
- 商业 App 逆向

## 创建 Xcode 工程

1. 打开 Xcode。
2. 新建项目，选择 `iOS App`。
3. Product Name: `iOSSecurityLab`
4. Interface: `SwiftUI`
5. Language: `Swift`
6. 将 `demo/` 目录下的 Swift 文件加入项目。
7. 如果 Xcode 已生成同名文件，用本目录文件替换或合并。
8. 将 `Info.plist.snippet` 中的 URL Scheme 配置合并到项目的 `Info.plist`。

## 实验 1：UserDefaults 保存 token

文件：`InsecureStorageLab.swift`

操作：

1. 运行 App。
2. 打开 `Insecure Storage Lab`。
3. 输入 `demo-access-token-123`。
4. 点击 `Save token to UserDefaults`。
5. 点击 `Load token from UserDefaults`。

观察：

- token 可以被直接写入和读取。
- 代码实现非常简单，开发者容易误用。
- 这类存储适合偏好配置，不适合敏感凭据。

需要记录的证据：

```text
实验名称：UserDefaults 明文 token 存储
输入 token：demo-access-token-123
观察结果：App 能直接读取并展示 token
风险判断：不适合作为敏感凭据存储
修复建议：改用 Keychain，并结合服务端 token 生命周期管理
```

面试表达：

> 我在 Demo 里故意把 token 存入 UserDefaults，用来说明偏好配置存储和敏感凭据存储的边界。真正审计时，我会检查 UserDefaults、plist、SQLite、日志和缓存中是否出现 token、手机号、身份证、定位等敏感字段。

## 实验 2：Keychain 保存 token

文件：`SecurityLabKeychain.swift`

操作：

1. 打开 `Keychain Lab`。
2. 输入 `demo-access-token-456`。
3. 点击 `Save token to Keychain`。
4. 点击 `Read token from Keychain`。
5. 点击 `Delete token`。

观察：

- Keychain API 比 UserDefaults 复杂。
- Demo 使用 `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`。
- Keychain 更适合凭据存储，但不是业务安全边界。

需要记录的证据：

```text
实验名称：Keychain token 存储
Keychain service：com.example.iossecuritylab.auth
account：access_token
访问策略：kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
风险边界：本地安全存储不能替代服务端鉴权
```

面试表达：

> Keychain 是 iOS 保存凭据的常见方案，但审计时我不会只看是否用了 Keychain，还会看 accessibility、是否可迁移、是否共享、token 生命周期和服务端吊销能力。

## 实验 3：URL Scheme 外部输入

文件：`URLSchemeLab.swift`

操作：

1. 合并 `Info.plist.snippet` 中的 `securitylab` Scheme。
2. 运行 App。
3. 在模拟器 Safari 中输入：

```text
securitylab://open?token=demo-token
```

4. 观察 Xcode console 输出。

观察：

- 外部输入可以进入 App。
- URL 中携带 token 是坏设计。
- 当前 Demo 只打印参数，还没有做敏感动作。

需要记录的证据：

```text
实验名称：URL Scheme 外部输入
测试 URL：securitylab://open?token=demo-token
观察结果：App 收到 scheme、host、query
风险判断：如果业务直接信任 query 参数，可能造成敏感数据泄露或越权跳转
修复建议：禁止 URL 传 token；路由白名单；参数校验；敏感动作服务端二次校验
```

面试表达：

> 我会把 URL Scheme 当成外部输入边界看待。真正风险不在于注册 Scheme 本身，而在于参数是否可信、是否携带敏感信息、是否能触发登录、支付、账号绑定或 WebView 打开等敏感流程。

## 实验 4：WKWebView JSBridge

文件：`WebViewBridgeLab.swift`

操作：

1. 打开 `WebView Bridge Lab`。
2. 点击 H5 页面里的按钮。
3. 观察 Xcode console 输出 `JSBridge message`。

观察：

- Web 页面可以通过 message handler 调用 Native。
- Demo 只打印消息，但真实 App 可能暴露设备信息、账号能力、文件能力、支付能力。

需要记录的证据：

```text
实验名称：WKWebView JSBridge
Bridge 名称：securityLab
Web 调用：window.webkit.messageHandlers.securityLab.postMessage(...)
风险判断：Web 输入进入 Native 能力，需要限制来源、方法和参数
修复建议：域名白名单；Bridge 最小化；参数强校验；敏感动作二次鉴权
```

面试表达：

> JSBridge 风险的本质是 Web 输入跨过边界进入 Native。审计时我会看页面来源、Bridge 暴露方法、参数校验、token 注入和敏感能力调用。

## 本周证据包

请在你的笔记中整理这些证据：

```text
1. Demo 是否能运行
2. 4 个实验点截图或文字记录
3. 每个实验点的风险假设
4. 每个实验点的验证步骤
5. 每个实验点的修复建议
6. 至少 5 个面试追问和回答
```

这些证据会用于第 4 周阶段答辩。
