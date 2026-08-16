# iOS 移动安全半年训练营 - 第 2 周

本周主题：**业务代码审计与 LLDB 调用链追踪**。

这不是工程配置周。你已有 iOS 开发和 Web 渗透经验，本周直接进入公司真正关心的对象：业务状态如何产生、客户端如何做决策、请求如何携带安全相关数据、服务端最终如何授权。

## 本周结束时必须做到

面对一个有源码但不熟悉的 Swift 业务模块，你能够：

1. 从资产、入口和信任边界画出业务状态机。
2. 从 UI/命令入口追到本地策略、请求构造和服务端授权模拟点。
3. 使用 LLDB 的符号断点、条件断点、调用栈、变量/对象观察和断点命令获得证据。
4. 隐藏源码后，仅依靠场景行为、符号和动态调用栈重新定位关键路径。
5. 区分“客户端展示被绕过”和“服务端授权真正失守”。
6. 输出一份有已证明、未证明、误报排除、修复和复测的报告。

本周是逆向过渡周，还不要求独立阅读复杂 ARM64。第 3 周会移除源码依赖，进入 Mach-O、ObjC/Swift 元数据和反汇编定位。

## 本地学习顺序

1. `00-overview/week02-plan.md`
2. `05-resources/week02-knowledge-map.md`
3. `01-lessons/lesson01-business-security-model.md`
4. `01-lessons/lesson02-source-assisted-reverse.md`
5. `01-lessons/lesson03-lldb-business-call-chain.md`
6. `02-labs/demo/README.md`
7. `02-labs/lab01-guided-call-chain.md`
8. `01-lessons/lesson04-blind-dynamic-analysis.md`
9. `02-labs/lab02-blind-analysis.md`
10. `01-lessons/lesson05-risk-boundary-reporting.md`
11. `03-assignments/homework.md`
12. `04-assessment/interviewer-rubric.md`
13. `04-assessment/instructor-review.md`

`05-resources/local-reference.md` 是本周的本地命令与原理手册。外部链接只列作出处，不承担教学内容。

## 本周交付物

- `business-flow-map.md`
- `lldb-call-chain-evidence.md`
- `blind-analysis-log.md`
- `week02-mini-audit-report.md`
- `week02-interview-pitch.md`
- Demo 的一次安全修复及对应测试

## 硬性门槛

- LLDB 证据必须覆盖至少 3 个不同层次的观察点：入口、本地策略、服务端授权。
- 至少解释一条不少于 5 个节点的调用链。
- 必须完成 `local-tamper` 与 `server-trusts-client` 两个对照场景。
- 不能把修改内存或本地字段本身写成高危漏洞；必须继续追踪到服务端决策。
- 总分至少 70，且“动态分析证据”不得低于 18/25。

## 合法边界

所有调试和状态修改只针对本目录自建 Demo、开源靶场或明确授权目标。不要把实验方法用于未授权商业 App。
