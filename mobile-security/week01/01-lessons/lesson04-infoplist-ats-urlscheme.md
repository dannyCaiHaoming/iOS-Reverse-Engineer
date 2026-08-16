# Lesson 04：Info.plist、ATS 与 URL Scheme，静态配置里藏着攻击面

## 本课目标

学完本课，你要能把 `Info.plist` 当成移动安全审计入口，而不是只把它看成工程配置文件。

你要掌握：

- `Info.plist` 中哪些字段和安全有关。
- ATS 配置如何判断。
- URL Scheme 为什么是外部输入边界。
- 如何把配置线索变成验证步骤。

## 为什么公司关心静态配置

静态配置有三个价值：

1. 快速建立攻击面地图。
2. 低成本发现明显风险。
3. 适合后续工具化和 CI 检查。

安全平台或 SDL 流程里，很多检查点都是从配置开始：

- 是否全局关闭 ATS。
- 是否声明过多权限。
- 是否注册 URL Scheme。
- 是否配置 Associated Domains。
- 是否开启后台能力。
- 是否使用 App Groups。

这些不一定直接是漏洞，但能告诉你应该往哪里查。

## Info.plist 核心检查点

### 1. 权限声明

常见字段：

```text
NSCameraUsageDescription
NSPhotoLibraryUsageDescription
NSLocationWhenInUseUsageDescription
NSMicrophoneUsageDescription
NSContactsUsageDescription
```

审计问题：

- 权限是否必要。
- 描述是否清晰。
- 描述是否和实际功能一致。
- 是否有未使用权限。
- 是否有第三方 SDK 触发权限。

面试表达：

> 权限声明是隐私审计入口。我会把声明、代码调用、SDK 行为和隐私政策一起对照，而不是只看字段是否存在。

### 2. ATS

字段：

```text
NSAppTransportSecurity
NSAllowsArbitraryLoads
NSExceptionDomains
```

判断逻辑：

- 全局 `NSAllowsArbitraryLoads = true` 是强风险信号。
- 对单个域名例外需要看原因。
- ATS 配置安全不代表实际证书校验一定安全。
- ATS 放开不一定直接定漏洞，需要抓包验证真实流量。

审计问题：

```text
是否允许 HTTP 明文？
是否降低 TLS 版本？
是否允许任意加载？
例外域名是否传输敏感数据？
```

### 3. URL Scheme

字段：

```text
CFBundleURLTypes
CFBundleURLSchemes
```

安全含义：

- 外部 App、浏览器、短信、网页可能通过 Scheme 唤起 App。
- Scheme 参数是外部输入。
- 如果路由逻辑信任参数，就可能触发风险。

### 4. Associated Domains

用途：

- Universal Links
- Web Credentials
- App Clips 等能力

安全含义：

- Web 域名和 App 之间建立信任关系。
- 配置错误可能导致跳转、凭据、链接处理风险。

第 1 周只做概念识别，后续再深入 Universal Link。

### 5. Background Modes

安全含义：

- App 后台能力可能影响数据采集、定位、音频、蓝牙等。
- 隐私合规审计时需要关注。

## URL Scheme 风险展开

示例：

```text
securitylab://open?token=demo-token
```

### 风险 1：敏感数据放在 URL

URL 可能出现在：

- 系统日志
- 浏览器历史
- 其他 App 调用链
- 用户截图
- 统计埋点

所以 token 不应该通过 URL 传递。

### 风险 2：参数未校验

危险模式：

```text
securitylab://webview?url=https://evil.example
securitylab://pay?amount=1&orderId=123
securitylab://bind?account=attacker
```

如果 App 直接信任参数，就可能造成跳转、支付、账号绑定等风险。

### 风险 3：业务只靠客户端判断

如果 Scheme 触发敏感动作，但服务端没有重新鉴权，就可能从客户端问题变成业务漏洞。

## 如何验证 URL Scheme

第 1 周验证方法：

1. 在 `Info.plist` 中确认 Scheme。
2. 构造正常 URL。
3. 构造异常 host/path/query。
4. 观察 App 是否接收、打印、跳转或触发业务。
5. 判断是否涉及敏感数据或敏感动作。

测试 URL 示例：

```text
securitylab://open?token=demo-token
securitylab://open?redirect=https://example.com
securitylab://pay?amount=1&orderId=10001
securitylab://webview?url=https://example.com
```

注意：本周只在自建 Demo 测试。

## 修复建议

URL Scheme 安全设计：

- 不传 token。
- Scheme、host、path 白名单。
- query 参数类型、长度、格式校验。
- 高风险操作服务端鉴权。
- 高风险操作用户二次确认。
- 异常调用记录日志，但日志脱敏。

ATS 安全设计：

- 不全局允许 arbitrary loads。
- 例外域名最小化。
- 敏感接口必须 HTTPS。
- 服务端 TLS 配置达标。
- 证书校验和证书绑定后续单独验证。

## 面试官追问

1. ATS 放开是否一定是漏洞？
2. URL Scheme 是否天然危险？
3. 如何判断 Scheme 风险等级？
4. 为什么不能在 URL 中传 token？
5. Info.plist 检查如何工具化？

## 本课作业

完成审计报告风险 2：`URL Scheme 参数携带 token`。

并在攻击面地图中补充：

- `Info.plist`
- `ATS/Network`
- `URL Scheme`
