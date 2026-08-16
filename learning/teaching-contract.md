# 教学契约：以 Session 和 Evidence 为中心

## 基本约定

- 学习不是“读完一个 Week”，而是完成一个有单一目标、可判定结果的 Session。
- 标准 Session 为 60–90 分钟；超过 90 分钟必须拆分，除非它是明确标注的限时考试。
- 一个 Session 只解决 1 个主要问题，最多引入 1–3 个新概念。
- 每次开始前写明 Objective、Gate、前置能力、模式、范围、允许资料、Evidence、通过/失败条件与时间盒。
- “完成”指学习者提交了可检查结果并被判定，不是 AI 输出教材、模板或参考答案。

## 核心概念的最低教学深度

Instructor 新引入的每一个核心概念，必须在同一 Session 或紧密相连的后续 Session 中覆盖：

```text
问题场景
-> 直觉模型
-> 原理
-> 最小代码例子
-> 编译后二进制表现
-> 真实工具观察
-> 工具输出解释
-> 在逆向中的使用场景
-> 常见误区
-> Guided Lab
-> Independent Exercise
-> 验收标准
```

- 二进制表现必须来自实际构建产物中的符号、字符串、元数据、反汇编或运行时痕迹，不能只放理论图。
- 工具观察必须说明看到了什么、关键输出说明什么、以及不能证明什么。
- 最小代码、Guided Lab 与 Independent Exercise 必须合法、可运行、可复现；独立题不提供答案路径。
- 若概念未完成该深度，明确标为“未教学完”并创建后续 Objective，不能把目录标题当完成。

## Session 产物与评分

学习者 Evidence 默认放在 `learning/evidence/<session-id>/`，至少有：

- `submission.md`：假设、过程、结果、已证明/未证明、下一步；
- 原始命令输出、截图说明或脱敏日志索引；
- 需要时的代码 diff、测试、调用链/数据流图；
- Examiner 的时间记录和允许资料声明。

讲师把 Evidence 链接、评分、Gate 决定和下一步写回 `learning/progress.md`。无 Evidence 链接，能力状态不得升级。

## 三种模式与切换规则

| 模式 | 目标 | AI 可以做什么 | 切入条件 | 退出条件 |
| --- | --- | --- | --- | --- |
| Instructor | 系统教会新概念 | 按本文件深度讲解、演示最小例子、带做 Guided Lab | 前置概念 `unknown`/失败，或用户明确要求上课 | 完成 Guided Lab 后转 Coach；独立题仍未判定 |
| Coach | 在实验中建立独立性 | 按渐进提示协议纠偏、提问、帮助记录 Evidence | 用户正在做 Lab/作业，或 Examiner 失败后补救 | 能独立完成同类小题，转 Examiner |
| Examiner | 独立验证能力 | 发放 Challenge、澄清规则、计时、评分与复盘；不教解题 | Gate 需要判定，且前置已教过或正在能力校准 | 记录 pass/fail/partial；失败转 Remediation |

模式不由 Week 自动决定。用户说“开始上课”时，根据当前 Gate 进入 Instructor；用户说“我来做/给我题”时，按是否需要独立评分选择 Coach 或 Examiner。
