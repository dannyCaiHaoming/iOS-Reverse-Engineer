# 第 2 周作业：从调用链到授权根因

总分 100。提交本地文件和 Demo 修改，不接受只有截图或口头说明。

## 作业 A：业务状态机与信任边界，15 分

使用 `business-flow-map-template.md`：

- 列出主体、资产、动作、资源和入口。
- 画出不少于 7 个节点的状态/调用链。
- 标注 token、role、premium、owner 的来源和权威级别。
- 至少提出 3 个风险假设及证伪条件。

扣分：只抄类型名，没有业务语义，最多 6 分。

## 作业 B：LLDB 调用链证据，25 分

使用 `lldb-evidence-template.md`，覆盖：

- baseline、local-tamper、server-trusts-client 三个场景。
- 入口、本地策略、服务端授权三个层次。
- 一条不少于 5 个节点的实际调用链。
- token 主体、owner、role、premium 的动态值。
- 至少一次断点命令或条件断点尝试。

扣分：只有命令清单或最终输出，没有解释，每项证据减半。

## 作业 C：75 分钟盲分析，20 分

使用 `blind-analysis-log-template.md`：

- 严格记录开始/结束时间。
- 保留候选入口排序。
- 至少记录一个错误入口和排除理由。
- 写出已证明、未证明和第 3 周待补证据。

如果中途查看源码，应如实标记，本项最高 10 分；隐瞒则本周不通过。

## 作业 D：修复与测试，20 分

修复 `authorizeUsingClientClaims` 的错误授权：

- 不再仅凭客户端 claims 放行。
- 根据 token 找到服务端权威会话。
- 校验主体与 requested owner。
- 校验服务端 entitlement。
- 更新测试，使跨用户请求被拒绝。
- 保证 baseline 仍然通过。

提交：代码 diff 说明、`swift run BusinessLogicLabChecks` 输出摘要和复测矩阵。

## 作业 E：迷你审计报告，10 分

使用 `week02-mini-audit-report-template.md`，写一条完整发现：

- 标题和风险等级。
- 业务背景与资产。
- 根因。
- 静态与动态证据。
- 利用前提和影响。
- 已证明/未证明。
- 服务端修复、客户端改进、复测。

报告必须注明这是自建 Lab，不得包装成真实生产漏洞。

## 作业 F：面试口述，10 分

录制或自行计时 8-10 分钟：

1. 为什么选择这条调用链？
2. LLDB 如何证明数据流？
3. 两个 tamper 场景为什么风险不同？
4. 根因和修复是什么？
5. 第 3 周移除源码后怎么办？

另回答 `04-assessment/interview-qna.md` 中随机 5 题。

## 一票否决

- 未运行 Demo。
- 没有动态调用栈或变量证据。
- 把本地字段修改直接等同于服务端越权。
- 修复只改客户端 UI。
- 使用未授权商业 App 作为练习目标。

## 提交目录建议

```text
week02-submission/
  business-flow-map.md
  lldb-call-chain-evidence.md
  blind-analysis-log.md
  week02-mini-audit-report.md
  week02-interview-pitch.md
  check-output.txt
```
