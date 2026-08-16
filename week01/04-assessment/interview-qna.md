# 第 1 周面试问答库

本文件是第 1 周标准答案。你可以先照着练，但最终要改成自己的语言。

## 1. 如果让你做一个 iOS App 安全审计，你第一步看什么？

我会先建立攻击面地图，而不是直接跑工具。第一步看 `Info.plist` 和包结构，识别权限声明、URL Scheme、ATS、Associated Domains、Background Modes、App Groups 等平台能力。然后看本地存储和敏感数据，包括 UserDefaults、文件、SQLite、缓存、日志、Keychain。接着看网络通信和 WebView/JSBridge。最后结合运行行为判断这些攻击面是否能形成真实风险。

## 2. iOS 沙盒保护什么，不保护什么？

沙盒主要提供 App 间隔离，限制一个 App 直接访问另一个 App 的数据。但沙盒不等于 App 内数据自动安全。如果 App 自己把 token、身份证、手机号、定位等敏感数据明文写入本地文件、UserDefaults、日志或缓存，在越狱、调试、备份分析或取证场景仍可能泄露。所以沙盒是隔离边界，不是敏感数据加密方案。

## 3. 为什么 UserDefaults 不适合保存 token？

UserDefaults 是偏好配置存储，适合保存 UI 开关、展示配置、用户偏好，不适合保存凭据。token 属于会话凭据，如果明文写入 UserDefaults，在调试、备份、越狱或取证场景可能被读取。更合理的做法是使用 Keychain，并且服务端要配合 token 过期、刷新、吊销、设备绑定和异常检测。

## 4. Keychain 是否绝对安全？

不是。Keychain 更适合保存凭据，但不是绝对安全，也不能替代服务端鉴权。审计时我会看 accessibility 配置、是否允许迁移、是否需要设备解锁或生物识别、是否被 App Group 共享、token 生命周期是否合理。即使 token 放在 Keychain，如果服务端 token 长期有效且无法吊销，泄露后仍有业务风险。

## 5. Info.plist 里哪些字段和安全有关？

我会重点看权限声明、`CFBundleURLTypes`、`NSAppTransportSecurity`、Associated Domains、Background Modes、App Groups 等。权限声明能反映隐私采集面，URL Scheme 和 Universal Link 是外部输入入口，ATS 反映网络安全配置，App Groups 可能引入共享数据边界。Info.plist 本身通常是线索，需要结合代码和运行行为确认风险。

## 6. ATS 放开是否一定是漏洞？

不一定。ATS 放开是风险信号，不一定直接构成漏洞。要看是否真的存在明文 HTTP、弱 TLS、敏感数据传输或证书校验不严。如果只是对特定历史域名做兼容，且不传敏感数据，风险可能较低。但如果全局允许 arbitrary loads，并且登录、支付、个人信息接口走明文或弱校验，就是高风险。

## 7. URL Scheme 的风险是什么？

URL Scheme 是外部输入边界。风险不在于注册 Scheme 本身，而在于 App 是否信任外部传入的 host、path、query 参数，是否在 URL 中传 token，是否能触发登录、支付、账号绑定、WebView 打开等敏感业务。安全做法是路由白名单、参数校验、禁止传敏感凭据，敏感动作必须服务端校验。

## 8. 怎么验证 URL Scheme 是真实风险，不是理论问题？

我会构造授权测试 URL，观察 App 是否接收参数、是否进入敏感页面、是否触发敏感动作。然后继续看服务端是否二次校验。如果 URL 只是打开普通页面，风险较低；如果外部 URL 能直接绑定账号、发起支付、携带 token 登录，且服务端没有校验，就是真实业务风险。

## 9. WKWebView 和 JSBridge 为什么危险？

因为它们连接 Web 世界和 Native 世界。Web 页面可以通过 JSBridge 调用 Native 能力，如果页面来源不可信、Bridge 方法暴露过多、参数不校验，Web 输入可能触发读取设备信息、打开页面、访问 token、调用支付等敏感操作。审计时要看加载域名、Bridge 方法、参数校验、token 注入和敏感能力边界。

## 10. 只允许 HTTPS 页面调用 JSBridge 是否足够？

不够。HTTPS 只能保证传输过程相对安全，不代表页面业务逻辑可信。如果授权域名存在 XSS、配置错误或供应链污染，仍可能滥用 JSBridge。还需要域名白名单、Bridge 方法最小化、参数强校验、敏感操作二次鉴权和日志审计。

## 11. 客户端本地鉴权为什么不能作为安全边界？

客户端运行在用户设备上，攻击者在授权测试环境中可以调试、Hook、篡改本地状态，所以本地判断只能用于体验优化，不能作为最终安全边界。真正的权限、支付、会员状态、订单归属必须由服务端校验。客户端绕过是否有业务影响，要看服务端是否再次鉴权和授权。

## 12. 如果你 Hook 客户端把 `isVIP` 改成 true，是否说明有漏洞？

不一定。它说明客户端本地判断可以被绕过，但不一定说明业务漏洞。如果服务端在下发会员资源前重新校验用户会员状态，业务风险较低。如果服务端相信客户端字段，导致非会员拿到会员资源，那就是业务漏洞。面试时要避免把客户端绕过直接等同于服务端失守。

## 13. 第 1 周 Demo 能证明什么能力？

它证明我能建立移动 App 攻击面模型，并把基础风险讲成审计闭环。Demo 覆盖 UserDefaults、Keychain、URL Scheme 和 WebView/JSBridge。我不仅实现了实验点，还能说明每个点的风险、验证方法、影响边界、修复建议和后续工具化方向。

## 14. 第 1 周 Demo 还不能证明什么？

它还不能证明我具备复杂逆向、真实 App 审计、Frida Hook、证书绑定绕过或加固对抗能力。它只是基础攻击面训练。后续需要通过 IPA 静态分析、LLDB、Frida、陌生授权目标审计和 Mobile App Inspector 工具来证明更强能力。

## 15. 你如何把第 1 周内容转化为后续工具？

第 1 周的 `Info.plist`、URL Scheme、ATS、权限声明、敏感字符串、WebView 使用点，都可以沉淀到 `Mobile App Inspector`。第一版工具可以先扫描 `Info.plist` 和工程目录，输出权限、ATS、URL Scheme、敏感 API 和硬编码风险线索。这样就从人工审计走向工具化。
