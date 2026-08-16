# 岗位反推审查：半年训练营深度是否足够

首次审查：2026-07-11。最近复核：2026-07-22。

目的：从公司和面试官角度检查现有半年训练营是否足够支撑广州移动安全、应用安全、SDL、隐私安全岗位，尤其是 25k 月薪、30w+ 年包目标。

## 数据和判断来源

本审查基于：

- 广州网络安全岗位公开薪酬样本。
- 移动安全、应用安全、SDL、隐私安全岗位的共性 JD 要求。
- OWASP MASVS/MASTG、OWASP ASVS、NIST SSDF、Apple 和 Android 官方安全资料。

说明：BOSS、脉脉等平台的职位详情常依赖登录态、反爬或动态渲染，不适合作为可稳定引用材料写入项目文档。后续用户手动投递时，应把真实 JD 复制到 `job-search-tracker.md`，再由 Codex 做逐条差距分析。

## 市场信号

广州普通网络安全工程师薪酬中位并不高。职友集近一年样本显示，广州网络安全工程师 54.6% 岗位在 8-15K/月，20-30K 和 30-50K 各约 10%。这意味着 25K 不是普通安全岗水平，而是需要“高级能力组合”。

25K+ 更可能出现在这些岗位叙事里：

- 移动安全 / 客户端安全
- 应用安全 / AppSec
- SDL 安全工程
- 安全开发 / 安全平台工具
- 隐私安全 / 数据安全技术治理
- 业务安全与接口安全结合的岗位

因此训练营不能只培养“会测 App 的人”，而要培养：

```text
能审计移动端 + 能看懂服务端接口风险 + 能工具化 + 能推动研发修复 + 能讲清隐私合规
```

## 现有总纲优点

现有总纲已经覆盖了几个关键点：

- iOS 安全基础
- IPA 静态分析
- LLDB
- Frida
- Keychain、本地存储、URL Scheme、WebView
- 证书绑定
- 反调试、越狱检测
- 隐私合规
- 审计报告
- 简历和面试

这些方向是对的，尤其适合用户的 iOS 背景。

## 主要缺口

### 缺口 1：Android 最低可用能力不足

市场上的“移动安全工程师”多数默认覆盖 Android 和 iOS。即使主攻 iOS，完全不会 Android 会缩小岗位面。

不要求用户成为 Android 逆向高手，但至少要能：

- 看懂 APK 结构。
- 使用 jadx、apktool、adb 做基础分析。
- 理解 Android Manifest、exported components、deeplink、WebView、Keystore、Network Security Config。
- 能用 Frida 在 Android 靶场做 2-3 个基础 Hook。
- 能把 iOS 风险模型迁移到 Android。

补强方式：

- 第 7-8 周完成 APK/DEX/Smali 与 JNI/ELF/ARM64 跨层分析最低线。
- 第 10 周完成 Android Frida 与 JNI 联动实验。
- `IPA Inspector` 升级为 `Mobile App Inspector`，至少保留 Android 扫描路线。

### 缺口 1A：逆向能力缺少可证明的深度

原总纲虽包含 Mach-O、LLDB、Frida 和 Android 最低线，但没有规定陌生样本分析、跨层调用、JNI/ARM64 或 iOS ObjC/Swift 动态分析的硬性门槛。这样完成课程后，用户可能只会按照 Demo 或现成脚本操作，无法证明具有面对未知二进制和混淆逻辑时的独立分析能力。

对于用户“iOS 开发 + 渗透测试”转移动安全的叙事，逆向不应替代 AppSec/SDL/隐私能力，但必须成为可信的技术支撑。面试官通常会通过以下方式验证：给一个未见过的 IPA/APK，询问入口如何选、静态线索如何转化为动态验证、JNI 或运行时调用如何跟踪、Hook 结论是否能转化为真实风险。

补强方式：

- 逆向从第 2 周开始：第 2-4 周每周至少 6 小时，第 5-12 周每周至少 7 小时用于逆向和动态验证。
- 第 2 周完成有源码业务调用链与 LLDB 过渡训练，第 3 周进入 Mach-O/ObjC/Swift 二进制定位，第 4 周强制完成第一个陌生授权 iOS 样本。
- 定义 7 个结构化授权样本、3 个中等以上难度样本、一次 90 分钟未知样本限时分析的毕业标准。
- 样本必须覆盖 Android Java/Smali、JNI/ARM64、Android Frida、iOS ObjC/Swift 动态分析和 iOS/Android 防护验证。
- 每个样本强制输出静态证据、动态证据、调用链或数据流、结论边界和面试讲解稿；不能以 flag、答案或修改返回值代替分析。

### 缺口 2：AppSec/SDL 工程化不够

25K+ 应用安全岗经常不只要“会挖问题”，还要能落流程：

- 威胁建模
- 安全需求
- 安全设计评审
- 代码审计
- SAST/DAST/SCA/Secret Scan
- CI/CD 安全卡点
- 漏洞分级、派单、复测、闭环
- 研发安全培训
- 组件和 SDK 治理

现有总纲提到了 SDL，但课程占比不够，需要成为独立训练模块。

补强方式：

- 第 13-16 周增加 AppSec/SDL 工程化模块。
- 阶段作品增加 `mobile-sdl-playbook.md` 和 `ci-security-gates.md`。
- 项目必须包含一个自动化扫描或检查脚本，不只靠人工报告。

### 缺口 3：移动端背后的 API/业务安全不够

真实 App 风险往往不止在客户端：

- 登录态和 token 生命周期
- JWT/OAuth/OIDC 使用问题
- 设备绑定
- 重放攻击
- 越权访问
- 参数篡改
- 业务流程绕过
- WebView/H5 与 Native 权限混用

如果只讲本地存储、Hook、反调试，面试官会追问：

> 你绕过客户端判断后，服务端应该怎么设计才安全？

补强方式：

- 第 9-12 周加入移动 API 安全。
- Demo 增加一个本地 mock backend 或可控测试 API。
- 审计报告必须包含“客户端风险是否能转化为服务端业务风险”的判断。

### 缺口 4：真实目标迁移能力不足

自建 Demo 很适合教学，但面试官可能认为“这是你自己设计的问题，不代表你能审真实 App”。

补强方式：

- 第 17-20 周必须审一个陌生授权目标，例如 DVIA-v2、iGoat、OWASP MAS Crackmes 或开源 App。
- 最终报告必须包含“未知代码阅读、攻击面发现、误报排除、复测”的证据。

### 缺口 5：隐私合规需要从经验变成技术项目

用户已有隐私经验，这是差异化优势，但必须工程化：

- SDK 清单
- Privacy Manifest
- 权限声明和实际调用一致性
- 敏感 API 使用点
- 网络域名和数据出境线索
- 隐私政策与实际采集行为差异
- 用户同意、撤回、删除、最小必要

补强方式：

- `Mobile App Inspector` 必须输出隐私风险线索。
- 第 13-16 周增加 `privacy-data-flow-map.md`。
- 最终作品必须体现“安全 + 隐私 + 工具化”，而不是只写合规理解。

## 25K 面试达标线

半年训练营出班时，用户至少要能通过这些追问：

1. 给你一个 IPA/APK，你 30 分钟内如何建立攻击面地图？
2. 本地 token 泄露如何证明有业务影响？服务端怎么设计？
3. Keychain/Keystore 使用了就安全吗？你看哪些配置？
4. 证书绑定如何验证？它的边界是什么？
5. Frida Hook 证明了什么？不能证明什么？
6. 如何判断 URL Scheme/Deep Link 是真实风险，不是理论问题？
7. WebView JSBridge 怎么安全设计？
8. SDK 隐私风险怎么发现？怎么推动整改？
9. 你如何把人工移动安全审计做成 CI 检查？
10. 一个漏洞从发现到修复闭环，你怎么分级、派单、复测？
11. 你会 Android 吗？至少能审哪些问题？
12. 你做过的项目有什么不是 toy demo？
13. 给一个首次接触的 APK/IPA，你如何选择分析入口、验证静态假设，并说明分析结论的边界？

如果回答不了这些，说明训练营不够深。

## 修改结论

原总纲方向正确，但不够保险。要达到面试标准，必须把训练营升级为：

```text
iOS 深度主线
  + Android 安全分析与逆向硬实力线
  + Mobile API/业务安全
  + AppSec/SDL 工程化
  + 隐私合规工具化
  + 陌生授权目标审计
```

2026-07-22 复核新增结论：旧版把实质逆向延后到第 5 周，不符合用户已有 iOS 开发和 Web 渗透经验，也不利于尽早发现逆向能力是否能建立。新版把第一份可验收的陌生 iOS 样本成果提前到第 4 周；如果届时仍只能依赖题解或改返回值，应立即补课或调整求职定位，而不是到半年末才发现深度不足。

更新后的训练营不再只产出 `iOS Security Lab` 和单一平台扫描器，而是产出：

- `iOS Security Lab`
- `Android Mini Lab`
- `Reverse Engineering Evidence Pack`
- `Unknown Sample Analysis Playbook`
- `Mobile App Inspector`
- `Mobile API Security Lab`
- `Mobile SDL Playbook`
- `Privacy Data Flow Map`
- `Real Target Audit Report`
- `Interview Q&A Bank`
- `Resume Portfolio`
