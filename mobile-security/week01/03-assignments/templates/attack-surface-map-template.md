# 第 1 周攻击面地图模板

对象：`iOS Security Lab v0.1`

## 使用方法

复制本模板为 `attack-surface-map.md`，然后根据你实际 Demo 和观察结果填写。

## 攻击面总览

| 编号 | 攻击面 | 资产 | 信任边界 | 风险等级 | 是否可工具化 |
| --- | --- | --- | --- | --- | --- |
| A-01 | UserDefaults | token、配置 | App 本地存储 | 中 | 是 |
| A-02 | Keychain | token、密钥 | App 与系统凭据存储 | 中 | 部分 |
| A-03 | Info.plist | 权限、Scheme、ATS | 静态配置 | 中 | 是 |
| A-04 | URL Scheme | 路由参数 | 外部 App/浏览器 -> App | 中 | 是 |
| A-05 | WKWebView | Web 内容、JSBridge | Web -> Native | 中 | 部分 |
| A-06 | ATS/Network | 网络流量 | App -> 服务端 | 中 | 是 |

## A-01 UserDefaults

攻击面：

```text
UserDefaults 本地偏好存储
```

资产：

```text
access token、用户标识、业务开关
```

外部输入：

```text
无直接外部输入，但可能由登录接口、业务配置或本地逻辑写入
```

信任边界：

```text
App 业务逻辑 -> 本地普通存储
```

风险假设：

```text
敏感凭据被明文写入偏好配置，可能在调试、备份、越狱或取证场景泄露
```

验证方法：

```text
检查代码中 UserDefaults.standard.set 调用；运行 Demo 写入 token；确认 App 可直接读取
```

影响判断：

```text
取决于 token 是否真实、生命周期、服务端是否支持吊销和设备绑定
```

修复建议：

```text
改用 Keychain 保存凭据；禁止日志和 UI 展示 token；服务端增加 token 生命周期控制
```

后续是否可工具化：

```text
是。Mobile App Inspector 可扫描 UserDefaults key、敏感字符串和硬编码 token 线索
```

## A-02 Keychain

攻击面：

```text
Keychain 凭据存储
```

资产：

```text
access token、refresh token、密钥
```

风险假设：

```text
Keychain 使用不当，例如 accessibility 过宽、允许迁移、App Group 共享范围过大
```

验证方法：

```text
检查 SecItemAdd 参数；确认 kSecAttrAccessible 配置；确认是否使用 Access Control
```

影响判断：

```text
Keychain 降低本地泄露风险，但不能替代服务端会话安全
```

修复建议：

```text
选择合理 accessibility；必要时绑定设备解锁或生物识别；服务端支持 token 过期、刷新、吊销
```

后续是否可工具化：

```text
部分。静态扫描可识别 SecItemAdd 和 accessibility 字符串，最终仍需人工判断业务语义
```

## A-03 Info.plist

攻击面：

```text
App 静态配置和平台能力声明
```

资产：

```text
权限、URL Scheme、ATS、Associated Domains、后台能力
```

风险假设：

```text
过度权限、ATS 弱化、Scheme 暴露、Associated Domains 配置不当
```

验证方法：

```text
使用 Xcode 或 plutil 查看 Info.plist；记录敏感字段
```

影响判断：

```text
配置本身是线索，不一定直接构成漏洞，需要结合运行行为验证
```

修复建议：

```text
最小权限；ATS 不全局放开；Scheme/Universal Link 白名单；权限描述与实际采集一致
```

后续是否可工具化：

```text
是。Mobile App Inspector v0.1 应优先支持 Info.plist 扫描
```

## A-04 URL Scheme

攻击面：

```text
外部 URL 唤起 App
```

资产：

```text
路由参数、token、业务页面、账号状态
```

外部输入：

```text
securitylab://open?token=demo-token
```

信任边界：

```text
外部 App/浏览器 -> Native 路由逻辑
```

风险假设：

```text
外部构造参数触发敏感业务，或通过 URL 泄露 token
```

验证方法：

```text
构造不同 host/path/query；观察 App 如何处理
```

影响判断：

```text
如果仅打印日志，影响低；如果触发登录、支付、账号绑定等业务，影响升高
```

修复建议：

```text
白名单、参数校验、禁止传 token、敏感动作服务端校验
```

后续是否可工具化：

```text
是。可扫描 CFBundleURLTypes，并生成测试 URL 模板
```

## A-05 WKWebView / JSBridge

攻击面：

```text
Web 内容调用 Native 能力
```

资产：

```text
Native API、token、设备信息、账号操作、文件能力
```

信任边界：

```text
Web 页面 -> Native message handler
```

风险假设：

```text
非可信页面或异常参数调用 Native 敏感能力
```

验证方法：

```text
检查 WKUserContentController.add；记录 message handler 名称；构造 JS 调用
```

影响判断：

```text
取决于 Bridge 暴露的 Native 能力
```

修复建议：

```text
域名白名单、Bridge 最小化、参数校验、敏感能力二次鉴权、禁止 token 注入
```

后续是否可工具化：

```text
部分。可扫描 handler 名称和 WebView 使用点，风险语义需人工判断
```
