# Lesson 05：WKWebView 与 JSBridge，Web 输入如何跨进 Native

## 本课目标

本课训练你理解移动端高频风险：WebView 和 JSBridge。

你要能回答：

- 为什么 WebView 是高风险模块。
- JSBridge 的本质风险是什么。
- 如何判断 Bridge 暴露是否危险。
- 如何设计安全的 WebView/Bridge。

## 公司为什么关心 WebView

很多 App 都混合使用 Native 和 H5：

- 活动页
- 支付页
- 客服页
- 帮助中心
- 营销页面
- 账号绑定流程
- 内嵌业务模块

WebView 让业务迭代更快，但也引入风险：

- Web 页面来源复杂。
- H5 可能有 XSS。
- JSBridge 能调用 Native 能力。
- token 可能被注入页面。
- Cookie/localStorage 可能管理不当。
- 外部 URL 可能打开任意页面。

面试官听到你会 WebView 安全，会觉得你不是只懂逆向技巧，而是懂真实 App 攻击面。

## WKWebView 基础

WKWebView 是 iOS 常用 WebView 组件。

关键对象：

```text
WKWebView
WKWebViewConfiguration
WKUserContentController
WKScriptMessageHandler
```

Bridge 典型代码：

```swift
contentController.add(context.coordinator, name: "securityLab")
```

H5 调用：

```javascript
window.webkit.messageHandlers.securityLab.postMessage({
  action: "demo",
  value: "hello-from-webview"
});
```

这条链路意味着：

```text
Web 页面 -> JavaScript -> Native message handler -> App 能力
```

这就是信任边界。

## JSBridge 风险的本质

风险不在于“有 JSBridge”，而在于：

- 谁能调用。
- 能调用什么。
- 参数是否可信。
- 调用后会触发什么 Native 能力。

### 低风险 Bridge

只做日志、展示、无敏感能力，且页面来源可信。

### 中风险 Bridge

能打开页面、读取设备信息、控制 UI、获取业务配置。

### 高风险 Bridge

能访问 token、账号数据、文件、支付、订单、联系人、定位、登录态。

## 审计 WebView 的 8 个问题

1. WebView 加载哪些域名？
2. 是否允许加载任意 URL？
3. 是否支持 URL Scheme 打开 WebView？
4. JSBridge 暴露哪些方法？
5. Bridge 参数是否做类型、长度、白名单校验？
6. 是否向 H5 注入 token 或用户隐私？
7. Cookie/localStorage 是否保存敏感数据？
8. 敏感 Native 能力是否需要服务端鉴权或用户确认？

## 为什么 HTTPS 不够

面试官常问：

> 如果只加载 HTTPS 页面，是不是就安全？

答案：不够。

原因：

- HTTPS 只保护传输。
- 页面本身可能有 XSS。
- 授权域名可能被配置错误。
- 第三方脚本可能被污染。
- Bridge 仍然可能暴露过多能力。

所以还需要：

- 域名白名单。
- Bridge 最小化。
- 参数校验。
- 敏感操作二次鉴权。
- CSP、XSS 防护和 Web 安全治理。
- token 不直接注入页面。

## Demo 关联

本周 Demo 中：

- `WebViewBridgeLab.swift` 注册 `securityLab` handler。
- HTML 页面通过 JS 调用 Native。
- Native 目前只打印消息。

你要在报告里说明：

```text
当前 Demo 只打印消息，影响较低。
但这个模式代表 Web -> Native 的信任边界。
真实 App 中如果 Bridge 暴露敏感能力，风险会升高。
```

## 修复建议模板

WebView/JSBridge 安全建议：

- 限制 WebView 加载域名。
- 禁止任意 URL 跳转。
- Bridge 方法按业务最小化。
- 参数做强类型校验。
- 敏感能力服务端鉴权。
- 不向 H5 注入 token。
- 日志脱敏。
- 下线无用 Bridge。

## 工具化思路

后续 `Mobile App Inspector` 可先做静态线索扫描：

- 搜索 `WKWebView`。
- 搜索 `WKScriptMessageHandler`。
- 搜索 `.add(_, name:)` 注册的 handler 名称。
- 搜索 `loadHTMLString`、`load(_:)`。
- 搜索硬编码 URL。

注意：工具只能发现线索，Bridge 方法是否危险需要人工结合业务判断。

## 面试官追问

1. JSBridge 为什么危险？
2. 如何判断 Bridge 风险等级？
3. HTTPS 页面为什么还可能滥用 Bridge？
4. 如何安全设计 Bridge？
5. 如何把 WebView 审计工具化？

## 本课作业

可选完成审计报告风险 3：`JSBridge 暴露 Native 调用入口`。

要求：

- 说明当前 Demo 风险为什么较低。
- 说明真实 App 中哪些 Native 能力会让风险升高。
- 给出至少 5 条修复建议。
