# 第 1 周小型审计报告模板

报告名称：iOS Security Lab v0.1 小型安全审计报告

审计对象：自建授权 Demo `iOS Security Lab`

审计范围：

- UserDefaults 本地存储
- Keychain 凭据存储
- Info.plist 配置
- URL Scheme
- WKWebView/JSBridge
- ATS/网络配置

审计标准参考：

- OWASP MASVS / MASTG
- Apple Platform Security
- Apple Developer Security Documentation

## 1. 总体结论

示例：

> 本次审计对象是自建教学 Demo，目的是验证移动 App 常见攻击面。本次发现 2 个中风险和 1 个低风险问题。风险主要集中在敏感 token 本地存储、URL Scheme 外部输入和 JSBridge 能力暴露。由于 Demo 没有真实服务端，业务影响以风险假设形式描述，后续需要结合服务端鉴权和授权逻辑进一步判断。

## 2. 攻击面地图

| 攻击面 | 资产 | 外部输入 | 风险假设 | 备注 |
| --- | --- | --- | --- | --- |
| UserDefaults | token | 无 | 敏感凭据明文落盘 | 不适合保存 token |
| Keychain | token | 无 | 访问控制配置不当 | 需要检查 accessibility |
| URL Scheme | 路由参数 | 外部 URL | 参数注入、敏感数据泄露 | 需要白名单和参数校验 |
| WKWebView/JSBridge | Native 能力 | Web 页面 | Web 输入调用 Native 敏感能力 | 需要限制域名和 Bridge |
| Info.plist | 平台能力 | 配置项 | 权限、ATS、Scheme 暴露面 | 静态审计入口 |

## 3. 风险详情

### 风险 1：UserDefaults 保存敏感 token

风险等级：中

风险描述：

```text
Demo 将 access token 保存到 UserDefaults。UserDefaults 是偏好配置存储，不适合保存敏感凭据。若设备处于越狱、调试、备份分析或取证场景，明文 token 可能被读取。
```

影响范围：

```text
如果 token 泄露且服务端缺少过期、吊销、设备绑定和异常检测，攻击者可能复用 token 访问用户账号资源。
```

验证步骤：

```text
1. 打开 Insecure Storage Lab。
2. 输入 demo-access-token-123。
3. 点击 Save token to UserDefaults。
4. 点击 Load token from UserDefaults。
5. 观察 App 能直接读取 token。
```

证据：

```text
代码位置：InsecureStorageLab.swift
关键代码：UserDefaults.standard.set(token, forKey: tokenKey)
运行结果：App 展示 Loaded token: demo-access-token-123
```

修复建议：

```text
1. 不使用 UserDefaults 保存 token。
2. token 类凭据优先使用 Keychain。
3. Keychain 设置合理 accessibility。
4. 服务端实现 token 过期、刷新、吊销和异常检测。
5. 日志、缓存、截图中不得输出 token。
```

复测方法：

```text
1. 搜索 UserDefaults 中是否仍保存 token。
2. 检查 token 是否改存 Keychain。
3. 检查日志和 UI 是否不再展示 token 明文。
4. 验证服务端 token 生命周期策略。
```

面试讲法：

```text
我不会简单说 UserDefaults 不安全，而会说明它是偏好存储，不适合凭据。即使改用 Keychain，也要继续看访问控制和服务端 token 策略，因为本地安全存储不能替代服务端鉴权。
```

### 风险 2：URL Scheme 参数携带 token

风险等级：中

风险描述：

```text
Demo 支持 securitylab://open?token=demo-token 形式的 URL Scheme。URL Scheme 是外部输入边界，如果业务在 URL 中传递 token 或直接信任 query 参数，可能导致敏感信息泄露或业务流程被外部触发。
```

影响范围：

```text
如果真实 App 使用 Scheme 承载登录态、订单号、支付参数、账号绑定参数，并且缺少服务端校验，可能造成越权跳转或敏感操作触发。
```

验证步骤：

```text
1. 在 Info.plist 注册 securitylab Scheme。
2. 运行 App。
3. 在 Safari 或命令中触发 securitylab://open?token=demo-token。
4. 观察 App 接收并打印 URL 参数。
```

证据：

```text
代码位置：URLSchemeLab.swift
关键代码：URLSchemeLab.handle(url)
测试 URL：securitylab://open?token=demo-token
```

修复建议：

```text
1. 禁止在 URL 中传递 token。
2. 对 scheme、host、path、query 做白名单和格式校验。
3. 敏感操作必须走服务端鉴权。
4. 高风险操作增加用户确认。
5. 记录异常 Scheme 调用用于风控分析。
```

复测方法：

```text
1. 构造异常 host/path/query，确认 App 拒绝处理。
2. 构造携带 token 的 URL，确认 App 不接受或不记录敏感信息。
3. 验证敏感业务必须经过服务端校验。
```

面试讲法：

```text
URL Scheme 不是天然漏洞，关键在于它是外部输入边界。我会验证它是否承载敏感参数、是否触发敏感业务、是否做白名单和服务端校验。
```

### 风险 3：JSBridge 暴露 Native 调用入口

风险等级：低到中，取决于暴露能力

风险描述：

```text
Demo 通过 WKScriptMessageHandler 暴露 securityLab message handler。当前 Demo 只打印消息，风险较低。但在真实 App 中，如果 JSBridge 暴露账号、支付、文件、设备信息等能力，且缺少域名限制和参数校验，可能造成 Web 输入滥用 Native 能力。
```

影响范围：

```text
取决于 Bridge 暴露的 Native 能力。如果只是日志打印，影响较低；如果能读取 token、打开任意页面、调用支付或账号操作，影响较高。
```

验证步骤：

```text
1. 打开 WebView Bridge Lab。
2. 点击 H5 页面按钮。
3. 观察 Native console 收到 JSBridge message。
```

证据：

```text
代码位置：WebViewBridgeLab.swift
Bridge 名称：securityLab
关键调用：window.webkit.messageHandlers.securityLab.postMessage(...)
```

修复建议：

```text
1. 限制 WebView 可加载域名。
2. JSBridge 方法最小化。
3. 参数强类型校验。
4. 敏感 Native 能力二次鉴权。
5. 禁止向 H5 直接注入 token。
```

复测方法：

```text
1. 尝试从非白名单页面调用 Bridge，确认失败。
2. 传入异常参数，确认被拒绝。
3. 检查 Bridge 不暴露敏感能力。
```

面试讲法：

```text
JSBridge 的本质风险是 Web 输入跨边界进入 Native。我会重点看页面来源、Bridge 方法、参数校验和敏感能力调用，而不是只说 WebView 有风险。
```

## 4. 修复优先级

| 优先级 | 问题 | 原因 |
| --- | --- | --- |
| P1 | UserDefaults token | 直接涉及凭据存储 |
| P1 | URL 传 token | 外部输入和敏感数据混用 |
| P2 | JSBridge 缺少约束 | 当前 Demo 影响低，但真实 App 中可能升高 |

## 5. 复测清单

- [ ] UserDefaults 不再保存 token。
- [ ] Keychain 使用合理 accessibility。
- [ ] URL Scheme 不接受敏感 token。
- [ ] URL Scheme 做 host/path/query 白名单。
- [ ] JSBridge 方法最小化。
- [ ] JSBridge 参数做校验。
- [ ] 敏感操作走服务端鉴权。
