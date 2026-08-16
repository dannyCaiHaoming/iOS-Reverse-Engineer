# iOS 移动安全半年训练营

这个项目不是普通自学笔记，而是按“半年训练营出班”设计、由 Evidence 和能力 Gate 驱动的求职准备项目。

目标：帮助用户在 24 周内，从 iOS 开发 + Web 渗透背景，训练成能够投递广州移动安全、应用安全、SDL、隐私安全岗位的候选人，并围绕 25k 月薪、30w+ 年包目标做作品、简历和面试准备。

## 核心路线

职业定位：

```text
iOS 开发背景
  + 移动端逆向分析
  + App 安全审计
  + 隐私合规/数据安全
  + SDL 工具化落地
```

## 训练系统入口

不要根据目录里已有的 Week 或 Lesson 推断学习进度。每次训练前先阅读：

1. `learning/learner-profile.md`
2. `learning/teaching-contract.md`
3. `learning/coach-protocol.md`
4. `learning/capability-matrix.md`
5. `learning/progress.md`
6. `learning/mistakes.md`

实际学习以 60–90 分钟、单一目标的 Session 进行。下一节由“最近 Evidence → 当前能力 → 最近失败 → 当前 Gate → 下一 Objective”决定；只有 Gate 通过才推进总纲。课程、Demo、模板和参考答案是教学资产，不是学习者能力证据。

训练原则：

- 不做浅层资料搬运。
- 不只跑 Demo。
- 不以“破解”作为职业叙事。
- 每周都要有作业、验收、面试问答和可沉淀材料。
- 每 4 周形成一个阶段作品或答辩材料。

## 目录

- `bootcamp/six-month-bootcamp.md`：半年训练营总纲。
- `week01/`：第 1 周基础校准材料，已完成。
- `week02/`：新版第 2 周材料，业务代码审计、LLDB 调用链、隐藏源码动态定位和授权边界修复。

新版逆向里程碑：第 2 周开始 LLDB 与业务调用链，第 3 周进入 Mach-O/ObjC/Swift 二进制定位，第 4 周完成首个陌生授权 iOS 样本的静态与动态分析。详见总纲开头的里程碑表。

## 出班成果

半年结束至少要拿出：

1. 自建 `iOS Security Lab` 实验 App。
2. `Mobile App Inspector` 静态扫描工具。
3. 基于 OWASP MASVS/MASTG 的移动 App 安全审计报告。
4. 至少 80 个面试问答。
5. 面向移动安全/应用安全/隐私安全岗位的简历项目描述。
6. 岗位投递和面试复盘记录。
7. 7 个授权逆向样本与一次未知 IPA/APK 限时分析记录。

## 每周学习标准

每周都必须回答：

- 公司为什么需要这个能力？
- 面试官怎么判断是真会还是浅学？
- 对应真实风险是什么？
- 如何在授权环境中验证？
- 如何给研发团队修复建议？
- 如何沉淀成工具、报告、检查表或 SDL 流程？
