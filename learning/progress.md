# 学习进度：Evidence 驱动

最后更新：2026-08-16

## 当前状态

| 字段 | 值 |
| --- | --- |
| 路线日历 | Week 01 材料标记为已完成；Week 02 材料已就绪 |
| 最近学习者 Evidence / 评分 / 失败 | 无 / 无 / 无已记录失败（不代表通过） |
| 当前 Gate | `G2-Entry：独立业务调用链校准` |
| Gate 状态 | not assessed |
| 当前模式 | Examiner（能力校准，不提供教学提示） |
| 是否可进入 Week 3 | 否；G2-Entry 与 G2-Full 均未通过 |

## 已知环境条件（不属于学习者评分）

- 本次仓库验证中，`week02/02-labs/demo` 的 `swift run BusinessLogicLabChecks` 未能在当前受限终端启动：Swift 编译器为 6.3.3，而 Command Line Tools SDK 接口标记为 6.3.2；同时用户级 Swift/Clang 缓存目录不可写。
- 这不是学习者失败，也不改变任何能力状态。开始 `S-CAL-02-01` 前应先确认本机 Xcode/Command Line Tools 工具链一致且 SwiftPM 可构建；若仍受阻，按 `environment` 记录后安排环境恢复 Session。

## 已核实的仓库证据

| 项目 | 归类 | 能否证明学习者能力 |
| --- | --- | --- |
| Week 01 SwiftUI Demo、作业模板、量规 | 教学资产 | 否 |
| Week 02 SwiftPM Demo、LLDB Lab、盲分析题、量规 | 教学资产 | 否 |
| `week02/02-labs/verified-observations.md` | 参考答案/环境校准 | 否 |
| 学习者提交的报告、原始日志、修复或评分 | 未发现 | 否 |

## 下一学习 Session（尚未执行）

| 字段 | 定义 |
| --- | --- |
| Session ID / 模式 | `S-CAL-02-01` / Examiner |
| 时间盒 | 60 分钟（纯环境安装另记） |
| 下一学习目标 | 不看源码与课程答案，独立建立并用动态证据支持一条 Swift 业务授权调用链。 |
| 为什么选择它 | 当前只确认教学资产存在；它同时校准 Week 1 的证据边界意识和 Week 2 的入口选择、LLDB、业务风险判断，是进入 Week 3 的最小前置检验。 |
| 前置能力 | 无需先宣称掌握；这是校准。需要能运行本地 SwiftPM Demo 和 LLDB。环境受阻则记录并安排等价恢复 Session。 |
| 授权范围 | 仅 `week02/02-labs/demo` 自建 Demo。 |
| 禁止资料 | `Sources/`、测试、Week 2 lessons/labs、模板、`verified-observations.md`、网络题解和自动完整调用图工具。 |
| 允许资料 | CLI 行为输出、LLDB 自带 `help`、系统/工具报错；可构建本地 Demo。 |
| 提交物 | `learning/evidence/S-CAL-02-01/submission.md`、原始命令/LLDB 输出索引、60 分钟时间线。 |
| 通过条件 | 完整满足 `capability-matrix.md` 的 G2-Entry 五项条件。 |
| 失败后的路线 | 不重做整周；按 `mistakes.md` 分别补业务模型、工具观察、调用链解释或风险边界，再用新小题复测。 |

## 更新日志

| 日期 | 事件 | Evidence | Gate 决定 |
| --- | --- | --- | --- |
| 2026-08-16 | 初始化交互式学习状态系统；审计 Week 01/02 教学资产 | 未发现学习者提交物 | G2-Entry = not assessed；不进入 Week 3 |
