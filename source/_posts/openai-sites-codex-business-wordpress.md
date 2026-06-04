---
title: OpenAI Sites：Codex 开始变成“打工人版 WordPress”
date: 2026-06-04 11:45:00
tags:
  - OpenAI
  - Codex
  - AI Agent
  - 企业AI
  - 无代码
categories:
  - AI观察
cover: /images/2026/06/openai-sites-codex-business-wordpress/cover.png
---

摘要：OpenAI 新推出的 Sites，让 Codex 不再只是写代码的助手，而是开始变成一个企业内部建站与轻应用生成工具。你只要用自然语言描述需求，它就能生成可交互、可托管、可分享的网站。这不是又一个 AI demo，更像是 OpenAI 把 Codex 从开发者工具推向企业基础设施的一次跳步。

![文章首图](/images/2026/06/openai-sites-codex-business-wordpress/cover.png)

昨天刷 X 的时候，看到 OpenAI 发了一条推文：Building apps has never been easier。

配套视频不到 1 分钟，演示的是 Codex 如何把一个想法直接变成一个可以分享的交互式网站。第一眼看，很容易觉得这不就是 Vercel v0 加 Replit 的合体吗？

但把 “Intelligence at Work” 发布会和开发者文档看完以后，事情没那么简单。OpenAI 这步棋，表面是建站，底层瞄准的是企业 AI Agent 的工作流入口。

![Sites 示例](/images/2026/06/openai-sites-codex-business-wordpress/sites-example.png)

## Sites 到底是什么？

先说结论：Sites 是 Codex 的一个插件，能让用户用自然语言描述需求，然后由 Codex 生成一个可交互、可托管、可分享的网站或轻应用。

关键是三个词：交互式、托管、分享。

这和 ChatGPT 帮你写一段 HTML 不在同一个层级。你不用自己找服务器，不用处理部署、域名、SSL，也不用先学 React 或 Tailwind。Codex 生成之后，直接给你一个 URL，扔到工作群里，同事点开就能用。

官方给出的适用场景包括：仪表盘、规划器、评审工作区、项目看板、画廊，以及各种轻量工具。说白了，就是企业内部那些“需要但没人排期做”的小工具。

这个点很关键。每个公司都有类似需求：销售团队想要客户跟进看板，运营团队想要活动进度追踪器，产品团队想要评审页面。过去这些东西永远排在工程资源后面，现在可能只需要描述清楚，就能先跑起来。

OpenAI 官方原话是：With Sites, Codex can turn your work, ideas, and plans into an interactive website or app your team can explore, use, and share with a URL.

这条推文在 X 上拿到约 120 万次浏览、7.9 万点赞和 3.4 千收藏。热度不算炸裂，但评论区的反应很有意思。

Hacker News 上有用户提到，自己非技术背景的妻子已经能用类似工具给销售团队搭出一个很 impressive 的 dashboard，然后感叹：“我有点存在主义危机了，我不再那么特别了。”

也有人把这称作 Codex 对白领工作的一次大更新。另一边，关于模型公司垂直扩张到应用层、“SaaS 末日”和平台依赖的担忧，也随之出现。

![Codex Sites 功能全景](/images/2026/06/openai-sites-codex-business-wordpress/sites-overview.png)

## 技术实现比想象中更深

一开始我也以为 Sites 只是模板建站。但开发者文档里透露出的技术底座，其实更像一个认真面向企业场景的发布系统。

首先是两阶段发布管线。

第一步是保存版本。Codex 会构建可部署站点，并把版本和源代码的 Git commit 关联起来。这一步创建的是可审查的部署候选，不会直接公开。

第二步是部署版本。确认没问题后，才把保存的版本发布出去，拿到生产 URL。

这个设计很软件工程：先审查，再上线，不是一键裸奔。

OpenAI 还在开发者网站上做了 Sites Showcase，展示了 6 个示例项目：Onboarding Hub、Enablement Hub、Pulse Dashboard、Sparkboard、Launch Cal、Event Planning Hub。技术栈覆盖 Next.js、React、Three.js，甚至还有 SwiftUI。

存储方面，Sites 支持两类绑定：结构化数据用 D1，文件和图片等对象存储用 R2。如果只是静态着陆页，可以不接存储；如果是带登录、上传、状态记录的内部工具，就可以同时绑定 D1 和 R2。

运行时也值得注意。Sites 的构建产物是兼容 Cloudflare Worker 的 ES Modules，也就是说它不是随便搭了个自研壳子，而是站在 Cloudflare 边缘计算基础设施上。好处是低延迟、全球分发和弹性伸缩；代价是技术栈和基础设施依赖也更明确。

访问控制则明显是给企业准备的：admins_only、workspace_all、custom 三种模式，分别对应站点所有者、整个工作区，以及指定用户或用户组。

实际使用也很直接，在 Codex 里用 `@Sites` 触发插件，再描述你想要的内部工具。例如让团队成员提交项目请求、查看负责人、更新状态、筛选列表，并要求用工作区账号登录、保存访问数据。只要需求说清楚，Codex 就会尝试把它变成一个可用页面。

## 6 大业务插件：OpenAI 想做角色化 Agent 编队

Sites 并不是孤立功能，它和 OpenAI 这次面向 Business / Enterprise 的 Codex 战略绑在一起。

同时出现的，还有 6 个角色化业务插件：

- 数据分析插件：用自然语言探索数据、解释指标变化、创建报告，集成 Snowflake、Databricks、Hex、Tableau。
- 创意制作插件：帮助营销团队生成广告变体、产品图、电商素材，集成 Figma、Canva、Shutterstock、Picsart。
- 销售插件：识别优先客户、准备会议、更新客户记录，集成 Salesforce、HubSpot、Slack、Outreach。
- 产品设计插件：辅助原型制作、审计用户流程，集成 Figma、Canva。
- 公共股权投资插件：分析财报、对比公司、评估投资论点，接入 Moody’s、FactSet、LSEG、S&P、PitchBook。
- 投资银行插件：辅助推介材料、可比公司分析和尽职调查。

![Codex 业务插件](/images/2026/06/openai-sites-codex-business-wordpress/business-plugins.png)

这套组合透露出的信息很清楚：OpenAI 不只是想让 Codex 写代码，它想把 Codex 做成按岗位分工的 Agent 编队。

每个插件背后，都是一套预置工作流、一组已经对接好的 SaaS 工具，以及针对特定岗位优化过的提示和操作路径。普通用户不用知道这些，只需要说“帮我准备明天和某个客户的会议”，Codex 就可能拉 Salesforce 的客户数据，生成会议准备材料，最后再通过 Sites 做成一个可交互的客户概览页。

所以 Sites 真正的价值，不是“它也能建站”，而是它成了 Agent 工作流的展示层。

过去团队对齐想法，要写文档、做 PPT、开会讲半天。每个人脑子里的理解还不一定一样。Sites 试图把这种“脑补对齐”变成“现场对齐”：直接生成一个能看、能点、能用的东西，让团队在使用中对齐。

## 和 v0、Replit、Cursor 比，差异在哪里？

很多人第一时间会把 Sites 和 Vercel v0、Replit、Cursor 放在一起比较。确实，它们都和“从想法到应用”有关，但面向的人群并不一样。

![AI 建站工具对比](/images/2026/06/openai-sites-codex-business-wordpress/tool-compare.png)

v0 生成 React 组件的能力很强，尤其是 UI 层面。但它输出的是代码，不是企业里马上可分享的成品网站。后续部署、后端、数据和权限，大多还要开发者接着处理。

Replit 更偏全栈，从提示词到部署的链路很顺。但它的核心体验仍然是“用 AI 辅助构建应用”，门槛比 Sites 高一些。

Cursor 则是专业开发者的 AI 编辑器，它增强的是编码过程，而不是把一个业务想法直接变成团队可用的 URL。

Sites 的优势，至少在当前叙事里，是门槛最低。一个不写代码的销售经理，如果能在 5 分钟内把客户跟进看板从想法变成链接，这件事对企业内部效率的冲击会很大。

这也是 Sites 和传统建站工具最大的不同：它不只是帮你“生成页面”，而是试图帮你“完成一段工作”。

## OpenAI 的生态策略：不是筑墙，而是修桥

另一个信号也值得看：OpenAI 并没有把 Sites 做成一个孤立封闭的工具。

它提到的合作伙伴包括 Wix、Base44、Replit、Lovable、Figma、Webflow、Emergent。换句话说，OpenAI 不是只想做一个新的建站产品，而是想让 Sites 变成 Agent 工作流与外部工具之间的桥。

VentureBeat 的分析里有一句话很贴切：相比静态 PPT，Sites 承诺让企业以更易消化的方式持续查看最新指标和重要信息。

这句话背后的意思是：Sites 不只是展示页，而是一个“活页面”。它可以接 Figma 设计、Salesforce 数据、Snowflake 数据仓库，再把这些信息变成团队能直接操作的界面。

这是平台策略，不是单点工具策略。

## 我的判断

好的地方很明显。

从技术上看，Sites 的底座比预期扎实。Cloudflare Workers 运行时、D1/R2 存储绑定、两阶段发布流程、RBAC 访问控制，这些都不是随便做 demo 的配置，而是认真往企业产品靠。

从行业上看，这步棋也聪明。Codex 从 2 月发布以来，周活用户已经超过 500 万，但非开发者只占 20%。Sites 加角色插件，是 OpenAI 把 Codex 往更广泛知识工作者市场推进的钥匙。

但现在我不会给太高分，最多 6 分左右。

第一，它目前主要面向 Business 和 Enterprise。Business 工作区默认开启，Enterprise 还需要管理员在 RBAC 里手动打开。Plus、Pro 和 Free 用户暂时用不上，口碑扩散会受限制。

第二，自定义能力仍有限。站点跑在 OpenAI 和 Cloudflare 的基础设施上，定制空间和开发者掌控感很难和 Vercel v0、Replit 这类工具比。

第三，影子 IT 风险会变大。团队自己生成各种内部应用，效率是提高了，但谁负责维护、谁负责安全审查、谁确认数据权限，都可能变成新的治理问题。

还有使用边界也要注意。Sites 条款里明确禁止处理受 HIPAA 保护的医疗数据、PCI DSS 管辖的支付卡数据，以及资金转移和加密货币交易相关场景。这说明它目前更适合内部工具、原型和轻量工作流，而不是高敏感数据的生产系统。

总体看，Sites 的意义不在于“OpenAI 又做了一个建站工具”，而在于 Codex 正在从写代码走向交付成果。

当年 WordPress 让建站从“写 HTML”变成“选主题”。Sites 想做的事情本质上类似，只是这次用户连主题都不用选，说出来就行。
