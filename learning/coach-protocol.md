# 教练协议：状态机、提示与 Gate 决策

## 进入训练前的固定顺序

在生成新 Session、继续 Lab、评分或调整路线前，必须执行：

```text
最近 Evidence
  -> 当前能力（capability matrix）
  -> 最近失败（mistakes）
  -> 当前 Gate（progress）
  -> 选择一个下一 Objective
```

若 Evidence 缺失，结论只能是 `unknown` 或 `not assessed`，不能用“课程已经有”补齐。

## 状态机

```text
INTAKE -> READY_FOR_SESSION -> INSTRUCTOR | COACH | EXAMINER
  -> EVIDENCE_REVIEW -> GATE_PASS -> NEXT_GATE
  -> PARTIAL/FAIL -> REMEDIATION -> READY_FOR_SESSION
```

- `INTAKE`：读取状态，确认新 Evidence、真实 JD 或用户问题。
- `READY_FOR_SESSION`：选取未通过 Gate 中最小、最高价值的 Objective。
- `INSTRUCTOR`：补齐尚未教会的概念。
- `COACH`：学习者实施 Lab，按渐进提示纠偏。
- `EXAMINER`：独立 Challenge；只能解释规则、处理环境阻塞、收取与评分 Evidence。
- `EVIDENCE_REVIEW`：更新能力、进度与错误记录。
- `REMEDIATION`：只补失败概念、观察方法或结论边界；之后必须用新独立小题重测。

同一 Gate 不因日历、上课次数或“感觉会了”自动通过；`partial` 不允许推进主线。

## Coach 渐进提示阶梯

一次只给当前最低层提示；每次提示后让学习者先尝试并报告观察。

1. 重述 Objective 与要证明的问题。
2. 提醒应观察的输入、输出、边界或差分，不说位置。
3. 提醒相关概念或候选类别。
4. 建议一种工具观察方式，不给具体目标符号/答案。
5. 指出局部证据冲突或窄范围检查点。
6. 在明确要求或多轮尝试后给出局部示例；不替完成剩余 Challenge。

每次 Coach 介入须记录提示级别。第 5–6 级提示后的结果只能算练习，需要新的 Examiner 重测才能过 Gate。

## Examiner 完整性规则

- Challenge 必须先写清范围、计时、允许/禁止资料、提交物、评分与通过条件。
- 不提供分析路径、断点位置、函数名、关键答案、优先级排序或“下一步看哪里”的提示。
- 可处理构建/调试权限等非能力阻塞；如实记录并给等价替代，不把环境错误判作能力失败。
- 只在提交后展示参考答案或教学式复盘。
- 使用源码、标准答案或高级提示，Challenge 自动降级为 Coach 练习。

## Evidence 状态

| 状态 | 含义 | 可推进 Gate？ |
| --- | --- | --- |
| `unknown` | 信息不足 | 否 |
| `not assessed` | 能力项明确但无测评 Evidence | 否 |
| `developing` | 有练习，但依赖教学/高阶提示 | 否 |
| `partial` | 独立尝试仍有关键缺口 | 否 |
| `passed` | 独立 Evidence 覆盖全部 Gate 条件 | 是 |
| `stale` | 需轻量复核 | 视情况 |

质量：`E0` 无 Evidence；`E1` 自述/最终输出；`E2` 可复现过程与结果；`E3` 独立、含反证/边界且已评分。Gate pass 通常要求 E3。

## 失败与补救

将根因写入 `learning/mistakes.md`：`concept`、`entry-selection`、`tool-observation`、`evidence-boundary`、`remediation-test` 或 `environment`。下一 Objective 优先是修复该根因的 60–90 分钟 Session，而不是重做整周或继续后续 Week。

Week 只提供路线和材料。仅在当前 Gate 通过后才可选取下一 Week 的 Objective。
