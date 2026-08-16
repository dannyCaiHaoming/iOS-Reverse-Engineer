# 第 1 周复盘清单

## 基础理解

- [ ] 我能解释 iOS 沙盒的作用和限制。
- [ ] 我能说明 UserDefaults 和 Keychain 的适用场景差异。
- [ ] 我知道 `Info.plist` 中哪些字段值得做安全审计。
- [ ] 我能解释 ATS 的目的。
- [ ] 我知道 URL Scheme 为什么可能带来安全风险。
- [ ] 我知道 WKWebView/JSBridge 为什么是移动安全高频风险点。

## Demo 完成度

- [ ] 我创建了 `iOS Security Lab` Demo App。
- [ ] Demo 有本地存储实验入口。
- [ ] Demo 有 Keychain 实验入口。
- [ ] Demo 有 URL Scheme 实验入口。
- [ ] Demo 有 WKWebView/JSBridge 实验入口。
- [ ] 我能运行 Demo 并观察每个实验点。

## 输出材料

- [ ] 我写了 300 字方向说明：为什么做 iOS 移动安全。
- [ ] 我写了 UserDefaults 明文 token 风险说明。
- [ ] 我写了一个面试回答：iOS App 安全审计第一步看什么。
- [ ] 我整理了本周遇到的问题和下周要补的知识。
- [ ] 我写了 `attack-surface-map.md`，列出 Demo 的攻击面。
- [ ] 我写了 `week01-mini-audit-report.md`，包含风险、影响、验证、修复建议。
- [ ] 我写了 `interview-qna.md`，至少 10 个面试问答。
- [ ] 我写了 `week01-project-pitch.md`，能 2 分钟讲清本周项目。
- [ ] 我写了 `week01-evidence-log.md`，至少两条发现具有静态/配置线索、运行证据和结论边界。
- [ ] 我为每条发现明确写出“已证明”和“仍需服务端或 Release 构建确认”的事项。
- [ ] 我用 `instructor-review.md` 给自己打分，并记录扣分原因。

## 面试表达练习

请用自己的话回答：

1. iOS App 安全测试有哪些入口？
2. 为什么本地鉴权不能作为安全边界？
3. 为什么 Keychain 比 UserDefaults 更适合保存 token？
4. URL Scheme 的风险是什么？
5. WebView JSBridge 的风险是什么？

## 本周通过标准

满足以下条件即可进入第 2 周：

- 能运行 Demo App。
- 能说清楚 5 个关键词：沙盒、Keychain、Info.plist、ATS、WebView。
- 能写出 2 个本地存储风险点。
- 能用职业化语言描述本周项目成果。
- 能回答 `interview-qna.md` 和 `instructor-review.md` 里的核心追问。
- 能把任意一个实验点讲成完整闭环：风险是什么、怎么验证、影响是什么、怎么修复、怎么复测。
- 能解释“客户端绕过不等于服务端失守”。
- 能区分线索、已验证事实、风险结论和待确认事项。
- `instructor-review.md` 自评不低于 70 分。

## 公司视角自检

请在本周结束时回答：

1. 如果我是公司移动安全面试官，我会不会相信这个 Demo 证明了你的能力？为什么？
2. 这个 Demo 目前更像学习玩具，还是审计项目雏形？差距在哪里？
3. 哪个实验点最能体现你的 iOS 开发背景？
4. 哪个实验点最能体现你的安全分析能力？
5. 哪个实验点可以继续工程化成扫描工具？
