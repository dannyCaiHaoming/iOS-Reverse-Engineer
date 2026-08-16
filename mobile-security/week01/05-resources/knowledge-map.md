# 第 1 周知识点地图

## 1. iOS 平台安全模型

iOS 安全不是单靠某一个机制，而是多层机制叠加：

- 硬件安全：Secure Enclave、设备密钥、硬件级加密能力。
- 系统安全：安全启动、系统完整性、软件更新、运行时保护。
- App 安全：代码签名、沙盒、权限隔离、App Store 审核。
- 数据保护：Data Protection、Keychain、文件加密保护级别。
- 网络安全：TLS、ATS、证书校验、证书绑定。

面试表达：

> 我理解 iOS 安全不是只看 App 代码，而是要结合平台安全机制、App 实现方式和业务安全边界一起分析。

## 2. 沙盒 Sandbox

每个 App 都运行在自己的容器内，常见目录包括：

- `Documents`：用户生成或需要持久保存的数据。
- `Library`：应用支持文件、缓存、偏好设置。
- `Library/Preferences`：UserDefaults 常见落点。
- `Library/Caches`：缓存，可能被系统清理。
- `tmp`：临时文件。

安全关注点：

- 敏感数据是否明文存储。
- 文件是否被备份到 iCloud。
- 日志、缓存、截图是否泄露敏感信息。
- 本地数据库是否保存 token、身份证、手机号、定位等敏感信息。

## 3. Keychain

Keychain 适合保存：

- 登录 token
- refresh token
- 密码类凭据
- 对称密钥或私钥引用

但要注意：

- 访问控制策略是否合理。
- 是否绑定设备锁屏或生物识别。
- 是否允许迁移或备份恢复。
- App Group 共享 Keychain 是否扩大了暴露面。

面试表达：

> Keychain 是敏感凭据优先考虑的存储位置，但审计时不能只看“是否用了 Keychain”，还要看访问控制、生命周期、备份迁移和业务使用方式。

## 4. UserDefaults 风险

UserDefaults 适合保存：

- 用户偏好
- 开关状态
- 非敏感配置

不适合保存：

- token
- 密码
- 身份证号
- 银行卡信息
- 会话密钥

原因：

- 它本质是偏好配置存储，不是安全存储。
- 数据容易被本地备份、调试、越狱环境或取证工具发现。
- 常见开发习惯会导致明文落盘。

## 5. Info.plist 审计入口

`Info.plist` 是 iOS 安全审计第一入口之一。

重点看：

- 权限声明：相机、相册、定位、麦克风、通讯录等。
- `CFBundleURLTypes`：自定义 URL Scheme。
- `NSAppTransportSecurity`：ATS 是否被弱化。
- App Groups、Associated Domains、Background Modes。
- 隐私相关描述是否过度或不准确。

## 6. ATS 与网络安全

ATS 是 App Transport Security，用于推动 App 默认使用更安全的网络连接。

安全关注点：

- 是否全局允许 HTTP 明文。
- 是否对特定域名放宽 TLS 要求。
- 是否使用过期 TLS 版本。
- 是否做了证书校验或证书绑定。

面试表达：

> 我做网络安全测试时会先看 ATS 配置，再结合抓包验证实际流量，确认是否存在明文传输、弱 TLS、证书校验不严等问题。

## 7. URL Scheme 风险

URL Scheme 用来让外部通过链接唤起 App，例如：

```text
securitylab://open?token=abc
```

风险点：

- 参数未校验导致越权跳转。
- URL 中携带敏感 token。
- 多 App 抢占同一 Scheme。
- 外部输入直接进入 WebView 或业务逻辑。

安全做法：

- 不在 URL 中传敏感凭据。
- 校验来源和参数格式。
- 对跳转目标做白名单。
- 高风险操作需要二次确认或服务端校验。

## 8. WKWebView 与 JSBridge

WebView 风险高，是因为它连接了 Web 世界和 Native 世界。

风险点：

- 加载不可信 URL。
- JSBridge 暴露过多 Native 能力。
- JavaScript 输入未校验。
- Web 内容可触发敏感 Native 操作。
- Cookie、token、localStorage 管理不当。

安全做法：

- 限制可加载域名。
- JSBridge 方法最小化。
- 所有 JS 参数都做校验。
- 敏感操作走 Native 鉴权或服务端校验。
- 禁止把 token 直接注入页面。

## 9. 第一周不做什么

这一周不追求：

- 绕过商业 App 防护。
- 研究真实 App 破解。
- 深入 Mach-O patch。
- 复杂反调试和脱壳。

这一周只做：

- 建立安全模型。
- 建立 Demo App。
- 形成可扩展实验环境。
- 训练安全审计表达方式。

## 10. 和服务端边界的关系

移动端安全审计不能只停在客户端。

客户端问题有两类：

- 直接风险：敏感数据明文落盘、日志泄露、隐私数据暴露。
- 条件风险：客户端本地判断可绕过，但是否有业务影响取决于服务端是否重新校验。

例子：

```text
Hook 客户端 isVIP = true
  -> 如果服务端重新校验会员状态，业务风险较低
  -> 如果服务端相信客户端字段，业务风险较高
```

面试表达：

> 我会先证明客户端风险，再继续判断服务端边界。客户端绕过不一定等于业务漏洞，真正定级要看服务端鉴权、授权、状态校验和 token 生命周期。

## 11. 本周知识点与后续项目的关系

第 1 周不是孤立内容，它会进入后续 3 个项目：

- `iOS Security Lab`：本周 Demo 会继续扩展证书绑定、反调试、越狱检测、Frida 检测。
- `Mobile App Inspector`：本周的 Info.plist、ATS、URL Scheme、权限、敏感字符串检查会变成工具规则。
- `Mobile App Security Audit Report`：本周的小型审计报告会扩展成正式报告。

## 12. 证据链与逆向衔接

第 1 周形成的工作法会贯穿后续静态审计和逆向：

```text
静态/配置线索 -> 运行验证 -> 调用链或数据流 -> 结论边界 -> 修复和复测
```

第 2 周用源码和构建配置补强第一步；第 5 周会用 IPA、Mach-O 和 LLDB 在无源码或符号不完整场景继续找线索；第 9 周再用 Frida 验证运行时行为。任何阶段都不能把“看到了一个 API”或“Hook 修改了一个返回值”直接等同于完整安全结论。
