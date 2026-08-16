# Demo：iOS Security Lab 第 1 周版本

这个 Demo 是后续 24 周训练营的实验 App。第 1 周只实现基础攻击面入口，不追求复杂逆向。

## 创建方式

1. 打开 Xcode。
2. 新建项目：`iOS App`。
3. Product Name: `iOSSecurityLab`
4. Interface: `SwiftUI`
5. Language: `Swift`
6. 将本目录中的 Swift 文件加入项目。
7. 如果 Xcode 已生成 `iOSSecurityLabApp.swift` 和 `ContentView.swift`，用这里的版本替换或对照修改。

## 本周 Demo 模块

- `InsecureStorageLab.swift`：演示 UserDefaults 保存 token 的错误模式。
- `SecurityLabKeychain.swift`：演示 Keychain 基础封装。
- `URLSchemeLab.swift`：演示 URL Scheme 处理入口。
- `WebViewBridgeLab.swift`：演示 WKWebView 与 JSBridge。
- `Info.plist.snippet`：演示需要添加的 URL Scheme 和权限声明片段。

## 安全边界

这个 Demo 只用于你自己的学习环境。后续所有 Hook、调试、绕过实验都应只针对：

- 自己写的 App
- 明确授权的测试 App
- OWASP/DVIA/iGoat 这类靶场

不要对第三方商业 App 做未授权逆向或绕过。

## 第 1 周观察点

运行 App 后重点观察：

1. UserDefaults 可以很容易写入和读取 token。
2. Keychain API 使用更复杂，但更适合凭据存储。
3. URL Scheme 是外部输入入口，必须校验参数。
4. JSBridge 会把 Web 输入传入 Native，必须限制能力和校验参数。
