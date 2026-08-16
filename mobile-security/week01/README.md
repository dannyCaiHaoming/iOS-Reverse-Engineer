# iOS 移动安全半年训练营 - 第 1 周

本周主题：iOS 安全基础、攻击面建模、证据链与 Demo 起步。

这一周不是马上开始逆向题或复杂工具，而是建立移动安全岗位真正需要的底层能力：能把一个 iOS App 拆成攻击面，提出风险假设，用静态和运行证据支持结论，判断风险是否有业务影响，并写出研发能执行的修复建议。

建议投入：12 小时。

## 目录结构

```text
week01/
  00-overview/       本周计划
  01-lessons/        7 节正式课
  02-labs/           Demo 实验和 Swift 源码
  03-assignments/    作业与报告模板
  04-assessment/     面试问答、清单、讲师验收
  05-resources/      本地必修讲义和知识地图
```

## 学习顺序

1. [00-overview/week01-plan.md](00-overview/week01-plan.md)
2. [05-resources/references.md](05-resources/references.md)，这是本地必修讲义，不需要跳转外部网站。
3. [01-lessons/lesson01-ios-security-model.md](01-lessons/lesson01-ios-security-model.md)
4. [01-lessons/lesson02-attack-surface-modeling.md](01-lessons/lesson02-attack-surface-modeling.md)
5. [01-lessons/lesson03-local-storage-keychain.md](01-lessons/lesson03-local-storage-keychain.md)
6. [01-lessons/lesson04-infoplist-ats-urlscheme.md](01-lessons/lesson04-infoplist-ats-urlscheme.md)
7. [01-lessons/lesson05-webview-jsbridge.md](01-lessons/lesson05-webview-jsbridge.md)
8. [01-lessons/lesson06-client-server-boundary.md](01-lessons/lesson06-client-server-boundary.md)
9. [01-lessons/lesson07-evidence-led-security-analysis.md](01-lessons/lesson07-evidence-led-security-analysis.md)
10. [02-labs/demo/lab-manual.md](02-labs/demo/lab-manual.md)
11. [03-assignments/templates/evidence-log-template.md](03-assignments/templates/evidence-log-template.md)
12. [03-assignments/homework.md](03-assignments/homework.md)
13. [04-assessment/interview-qna.md](04-assessment/interview-qna.md)
14. [04-assessment/instructor-review.md](04-assessment/instructor-review.md)

## 本周课程

| 课程 | 主题 | 训练目标 |
| --- | --- | --- |
| Lesson 01 | iOS 安全模型 | 理解沙盒、代码签名、权限、Keychain、Data Protection、ATS 的边界 |
| Lesson 02 | 攻击面建模 | 能把 App 拆成资产、入口、信任边界、风险假设 |
| Lesson 03 | 本地存储与 Keychain | 能讲清 UserDefaults、文件、日志、Keychain 和 token 生命周期 |
| Lesson 04 | Info.plist、ATS、URL Scheme | 能从静态配置建立审计入口 |
| Lesson 05 | WKWebView 与 JSBridge | 能判断 Web 输入进入 Native 的风险 |
| Lesson 06 | 客户端与服务端边界 | 能避免把客户端绕过误判为业务漏洞 |
| Lesson 07 | 证据链与结论边界 | 能把“看到线索”升级为“有证据的安全结论” |

## 本周需要你自己产出的文件

这些文件不预先替你写死，因为它们要体现你的个人理解：

- `my-direction-note.md`
- `attack-surface-map.md`
- `week01-mini-audit-report.md`
- `interview-qna.md`，可基于标准版改写。
- `week01-project-pitch.md`
- `week01-evidence-log.md`

模板位置：

- [03-assignments/templates/attack-surface-map-template.md](03-assignments/templates/attack-surface-map-template.md)
- [03-assignments/templates/mini-audit-report-template.md](03-assignments/templates/mini-audit-report-template.md)
- [03-assignments/templates/evidence-log-template.md](03-assignments/templates/evidence-log-template.md)

## 本周通过标准

你完成本周后，至少要能做到：

- Demo 能运行，4 个实验点能操作。
- 能解释沙盒、UserDefaults、Keychain、Info.plist、URL Scheme、WebView。
- 能写出 2 个风险的审计报告，并为每个风险保留静态或配置证据、运行证据与结论边界。
- 能讲清客户端风险和服务端安全边界。
- 能用 2 分钟讲清第 1 周项目价值。
- 能区分“线索、已验证事实、风险结论、仍需服务端确认的事项”。
- 用 [04-assessment/instructor-review.md](04-assessment/instructor-review.md) 自评不低于 70 分。
