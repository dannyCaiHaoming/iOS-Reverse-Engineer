# 能力矩阵与 Gate

最后更新：2026-08-16。只计学习者本人、可复核的 Evidence；课程源码、模板、参考答案和课程作者的 `verified-observations.md` 均不计入。

## 当前能力状态

| ID | 能力 | 目标 | 当前状态 | 现有证据 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| F-01 | 从资产、入口、信任边界建立 iOS 攻击面 | L3 | not assessed | E0；仅 Week 01 教学资产 | G2 校准；必要时 W1 补救 |
| F-02 | 区分线索、事实、风险与服务端确认项 | L3 | not assessed | E0 | G2 结论边界 |
| W2-01 | 建模主体、动作、资源与权威数据源 | L3 | not assessed | E0 | G2-Entry |
| W2-02 | 用 PTC 建立候选调用链 | L3 | not assessed | E0 | G2-Entry |
| W2-03 | 用 LLDB 符号、调用栈、变量取得证据 | L3 | not assessed | E0 | G2-Entry |
| W2-04 | 区分本地篡改与服务端授权风险 | L3 | not assessed | E0 | G2-Entry |
| W2-05 | 无源码记录候选、错误路径、边界 | L3 | not assessed | E0 | G2-Entry |
| W2-06 | 修复错误授权并覆盖合法/攻击回归 | L3 | not assessed | E0 | G2-Full |
| W3-01 | 对 iOS 二进制完成 Mach-O 基础侦察 | L3 | not assessed | E0；未开始教学 | G2-Full 后 Instructor |
| W3-02 | 由 ObjC/Swift/字符串/API 建立候选入口 | L3 | not assessed | E0；未开始教学 | W3 Gate |
| W3-03 | 用反汇编排除错误入口并规划动态验证 | L3 | not assessed | E0；未开始教学 | W3 Gate |
| W4-01 | 首次陌生授权 iOS 样本的双证据分析 | L3 | not assessed | E0；未开始教学 | W4 Gate |

职业背景可以影响 Instructor 起点，不能改变以上测评状态。

## Gate 地图：Week 2 → Week 3 → Week 4

```text
G2-Entry（短校准）
  -> G2-Full（完整调用链、盲分析、修复）
  -> G3-Binary-Recon（Week 3 二进制侦察）
  -> G4-Unknown-iOS（Week 4 首次陌生授权样本）
```

### G2-Entry：独立业务调用链校准（当前 Gate）

目的：确认是否具备进入/继续 Week 2 的真实起点；不是默认判定 Week 2 已完成。以下均须独立 E3 Evidence：

1. 60 分钟内对 `week02/02-labs/demo` 已构建 Debug CLI 做行为差分与符号/动态定位；不读 `Sources/`、测试、讲义、答案或 `verified-observations.md`。
2. 写出至少 5 个节点的实际业务调用链，并说明为何选入口和最终决策点。
3. 用原始命令/LLDB 日志证明 token 主体、requested owner、客户端 claims、最终结果中的至少 3 组关键值。
4. 区分 `local-tamper` 和 `server-trusts-client`：哪个只证明本地现象、哪个在该 Lab 中形成授权问题，以及不外推真实服务端的原因。
5. 记录一个候选入口或假设被排除/降级的 Evidence。

未完成调用链、未写边界或使用答案，判 `partial`/`developing` 并按根因补救；工具环境失败不判能力失败。

### G2-Full：Week 2 可迁移调用链能力

前置：G2-Entry `passed`。通过条件：

1. 75 分钟无源码盲分析，含时间线、候选评分、错误入口和 5 节点链；
2. LLDB Evidence 覆盖入口、本地策略、服务端授权三层，并解释静态/动态对应；
3. 完成安全/错误授权对照，结论不夸大客户端现象；
4. 修复错误服务端信任源，复测合法路径与跨用户攻击路径；
5. Week 2 量规至少 70/100，动态证据至少 18/25、风险边界至少 9/15。

通过 G2-Full 仅证明进入二进制静态定位前的调用链与证据能力，不代表会无源码 iOS 逆向。

### G3-Binary-Recon：进入 Week 4 前的二进制定位能力

前置：G2-Full `passed`。Week 3 不在本次生成，Gate 只定义：

1. 在授权、自建 Release iOS 样本记录 IPA/App Bundle、Mach-O 基本结构和代码签名位置；
2. 由至少两类线索（ObjC 元数据、Swift 符号、字符串、导入 API、数据引用）提出并排序两个候选入口；
3. 用反汇编/交叉引用排除一个错误候选，并说明调用者、依赖或动态验证计划；
4. 明确静态线索与仍需运行时验证的边界。

### G4-Unknown-iOS：首次陌生授权 iOS 样本

前置：G3-Binary-Recon `passed`。通过条件：首次接触的授权样本中，独立建立攻击面与入口优先级，保留静态定位、动态验证和一条调用链/数据流的双证据；记录错误路径、已证明/未证明和服务端确认项；给出修复/复测；完成答辩且独立逆向证据达门槛。未通过不得直接推进 ARM64/JNI 主线。
