# 当前教学体系审计

审计日期：2026-08-16
审计范围：`AGENTS.md`、`README.md`、`bootcamp/six-month-bootcamp.md`、`week01/`、`week02/`，包括 Lessons、Lab 源码、作业、模板与 Assessment。

## 结论

仓库已有比普通“课程大纲”更强的教学资产：授权 Demo、风险边界、盲分析、作业、评分量规、修复与复测要求齐全。它仍然是**高质量课程资料仓库**，而不是能长期判断学习状态的**交互式训练系统**：没有学习者 Evidence 索引、能力状态、Gate 决策、失败到补救闭环和 Session 级控制。

## 已符合长期要求的部分

| 维度 | 证据 | 判断 |
| --- | --- | --- |
| 职业定位与合法边界 | README、总纲、两周 Lab 均限定自建/授权目标 | 符合；避免“破解 App”叙事。 |
| 双证据与结论边界 | Week 1 Lesson 07；Week 2 报告/动态证据要求 | 符合；区分线索、事实、风险、待确认。 |
| 真实业务视角 | Week 2 主体/动作/资源、权威数据源、跨用户授权对照 | 强项；不止 Hook 或改返回值。 |
| 可运行实践 | Week 1 SwiftUI Lab；Week 2 SwiftPM CLI、回归检查、LLDB | 符合；还记录环境差异。 |
| 独立性设计 | Week 2 的 75 分钟盲分析、禁用源码、错误入口记录 | 强项；接近 Gate 考试形态。 |
| 企业交付 | 作业/量规涵盖风险、修复、复测、SDL、面试 | 符合；可迁移到岗位交付。 |

## 仍偏大纲或深度不足

1. Week 1 的 7 节课主要是“概念—清单—作业”。安全模型、攻击面、Keychain、ATS/WebView 有业务解释和 Demo 关联，但多数缺少“最小代码 -> 编译后二进制表现 -> 真实工具输出逐行解释 -> 逆向迁移”的完整链；它不能证明二进制分析能力。
2. Week 2 的 LLDB 内容较深入，但按 12 小时周计划一次投放业务建模、源码审计、LLDB、盲分析、修复和报告，用户可能读完许多文件却没有完成一个即时验收的单一 Objective。
3. “不看源码”仍是带 Debug 符号的盲动态分析。课程也承认这不是无符号 iOS 逆向；没有 Gate 时容易被误记为 Week 3 Mach-O/Release 能力。
4. Week 1/2 尚未把每个关键概念完整拆成源码、二进制、工具观察、独立迁移的 Session；这是后续 Instructor 改造的准入标准，而不是现在继续堆 Lesson 的理由。

## 实践与独立验证缺口

- Week 1 目录没有学习者本人的攻击面图、证据日志、报告、运行记录、评分或复测产物；模板和参考报告不能证明完成。
- Week 2 有 Guided Lab、Blind Lab、修复作业和量规，但没有 `week02-submission/`、原始 LLDB 日志、时间线、修复 diff 或实际分数。
- `verified-observations.md` 是课程作者的环境校准，不能当成学习者动态证据；考核前读取还会破坏独立性。
- Assessment 只是供自行对照的材料，未定义谁在何时以何种 Evidence 把分数写回，因此没有可执行的通过记录。
- 本次受限终端中，Week 2 SwiftPM 回归检查还暴露了 Swift 6.3.3 编译器与 6.3.2 Command Line Tools SDK 不匹配的问题；这属于环境可用性条件，不能写成学习者失败。

## 为什么下一次 Codex 仍可能不知道教什么

1. 课程、Demo、模板、答案与未来学习者提交物没有分层或索引。
2. 没有 `unknown/not assessed/developing/passed` 状态；“第 1 周已完成”容易被误读为能力已掌握。
3. 没有“最近 Evidence -> 当前能力 -> 最近失败 -> 当前 Gate -> 下一 Objective”的入口，只能从 README/总纲猜测继续 Week 3。
4. 讲义、引导实验、独立考核的提示边界没有运行协议，Challenge 容易泄题。
5. 没有错误日志与 Remediation，失败后只能重读或继续堆新内容。

## 本次改造

- `learning/` 分离背景、教学契约、运行协议、能力矩阵、进度和错误记录。
- 用 `G2-Entry` 独立校准作为当前入口；通过前不进入 Week 3。
- `teaching-contract.md` 规定概念深度与 Session 约束；`coach-protocol.md` 强制三种模式和提示上限。
- `progress.md` 只登记学习者 Evidence 并明确下一 Session；所有后续推进必须回写状态。
