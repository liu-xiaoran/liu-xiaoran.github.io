---
title: Claude Code 2.1.160：安全加固、ultracode 与后台会话修复
date: 2026-06-02 11:50:00
tags:
  - Claude Code
  - AI 编程
  - 更新日志
  - Anthropic
categories:
  - AI工具
---

2.1.160 距离上一版只隔了 23 小时，但这次并不是走过场。

这一版最核心的动作，是给几类可能被拿来执行恶意代码的路径补上确认提示：shell 启动文件、构建工具配置、git 配置。另一处用户能直接感知的变化，是 dynamic workflow 的触发词从 `workflow` 改成了 `ultracode`，输入框里会以紫色高亮显示。

后台会话也修了一批稳定性问题，prompt tokens 则从约 11.6 万降到约 5.8 万，几乎砍半。表面看是一次常规迭代，但安全加固、后台可靠性和提示词瘦身，都是 Claude Code 这种工具越往深处走越绕不开的苦活。

![文章首图](/images/2026/06/claude-code-2-1-160/cover.jpg)

![Claude Code 2.1.160 原文配图](/images/2026/06/claude-code-2-1-160/orig-cover.jpg)

## 三道安全防线：先把门锁上

2.1.160 最值得认真看的，是安全部分。

这次不是修某一个已经暴露的具体漏洞，而是提前给高风险写入路径加确认。它堵的是同一类攻击模式：通过修改配置文件，把恶意命令持久化到用户环境里。

第一道防线，是 shell 启动文件。

`.zshenv`、`.zlogin`、`.bash_login`，以及 `~/.config/git/` 这类路径，在终端启动或 git 操作时可能自动加载。如果某个 MCP server、skill，或者被污染的自动化流程，往这些地方塞进一行命令，下次打开终端或执行 git 时就可能直接跑起来。

从 2.1.160 开始，Claude Code 写这些文件前会先弹确认。换句话说，不是不让写，而是把“静默写入高危启动项”变成“你想清楚了再让它写”。

第二道防线，是构建工具配置。

在 `acceptEdits` 模式下，Claude Code 现在写入 `.npmrc`、`.yarnrc*`、`bunfig.toml`、`.bazelrc`、`.pre-commit-config.yaml`、`.devcontainer/` 等文件前，也会提示确认。

这些文件的危险点在于，它们经常和依赖安装、构建、提交、容器启动绑定。`.npmrc` 可能影响 install 行为，pre-commit 可以直接跑 shell，devcontainer 则可能在打开项目时触发一整套初始化动作。对于自动接受改动的模式来说，这类路径原本就应该被单独拎出来。

这次加固的意义就在这里：它不是等攻击发生后补洞，而是提前把攻击面降下来。

## `workflow` 改成 `ultracode`：避免误触，也是在腾位置

另一个很明显的变化，是 dynamic workflow 的触发关键词从 `workflow` 改成了 `ultracode`。

这个改名看着小，其实很合理。

`workflow` 是一个太常见的自然语言词。用户说 “show me the workflow”，或者问“这个 workflow 怎么设计”，都有可能不小心触发 dynamic workflow。2.1.157 刚引入 dynamic workflow 时，Anthropic 还专门做过「Workflow keyword trigger」开关，让不想误触的人关掉。现在直接换成 `ultracode`，问题就简单多了：这个词几乎不会自然出现在日常句子里。

更重要的是，它还能和 `/effort ultracode` 保持同一套命名。至于用自然语言描述来触发 workflow 的能力并没有消失，你说“帮我用多个 agent 一起处理这个任务”，仍然可以进入 dynamic workflow 流程。

我更倾向于把这次改名理解为两层意思：一层是减少误触；另一层是给未来的 workflow 编排能力让路。毕竟 workflow 在 MCP、插件和自动化生态里都是常用概念，继续拿它当硬触发词，迟早会撞名。

## grep 之后不用再 Read：小改动，但很顺手

这版还有一个体验改进很实用：单文件 `grep` / `egrep` / `fgrep` 现在可以满足 read-before-edit 校验。

以前的流程经常是这样：先用 `grep "某函数" src/file.ts` 看到了目标位置，准备修改时，Claude Code 又提示“你还没读这个文件”，于是还得再 `Read` 一遍。现在单文件 grep 结果可以算作已经看过文件，省掉一步。

这个改动只对单文件生效，多文件 grep 仍然不算。逻辑也说得通：单文件 grep 至少能确认上下文来自哪个文件；多文件搜索通常只是定位线索，还需要进一步明确要改哪一份。

## 后台会话：修的都是日常会踩的坑

后台会话这次修复不少，而且每一个都直接影响使用体验。

最严重的是恢复已完成会话时，对话历史可能丢失，并重新执行原始 prompt。你从 `claude agents` 里打开一个已经跑完的后台任务，本来只是想看结果，结果它忘了前面的对话，又从头跑一遍，这基本等于白做。

类似的问题还包括隔夜后的后台 session 重新 attach 时丢对话、重新执行原 prompt。对于让 agent 跑长任务的人来说，这种 bug 的杀伤力很大：任务不是不能跑，而是跑完之后结果不可靠。

这次还修了 `claude --bg` 在高负载机器冷启动 daemon 时偶发 `socket missing` 的问题；修了 Windows 上 `claude rm` 后后台 daemon 没退出导致目录删不掉的问题；也修了后台 agent 恢复工作后被错误列在 Completed 下，以及退出 agents 列表时因自动更新检查导致界面冻结的问题。

这些都不是炫技功能，但它们决定后台 agent 到底能不能成为日常工作流的一部分。

## Windows 和输入修复：中文用户也能感到变化

Windows 端这次也补了几处痛点。

WSL 下选中复制不再依赖 OSC 52，而是改用 PowerShell interop 写入 Windows 剪贴板。对于 MobaXterm 这类不支持 OSC 52 的终端来说，这个修复很关键。

高 CPU 负载下，附着到后台 session 或在 agent 视图里 Esc、方向键、输入无响应的问题也修了。这个大概率和事件循环被重任务堵住有关，Windows 用户跑大项目时很容易遇到。

还有一个对中文用户很直接的修复：CJK 输入法候选窗不再跑到屏幕左下角，而是回到输入光标附近。候选窗位置不对，看似小 bug，实际会让中文输入几乎不可用。

## prompt tokens 砍半：官方没强调，但很值钱

这版最意外的数据，是 marckrenn 统计到的 prompt 变化：prompt tokens 从约 115,652 降到约 58,309，减少 57,343，降幅 49.6%。prompt 文件数也从 81 个降到 42 个，少了 39 个文件，降幅 48.1%。

这个幅度不太像小修小补，更像做了一轮系统提示词合并、去重和压缩。

Token 分布也有变化：tools 占比从 86.1% 升到 87.9%，system-reminder 从 8.2% 降到 7.2%，system 从 3.2% 降到 1.0%，system-data 从 1.1% 升到 2.3%。也就是说，真正被砍掉的主要是系统级指令和重复提示，工具定义本身并没有大幅减少。

这件事 Anthropic 官方 changelog 没有重点提，但对 API 付费用户很实际。每次请求少掉约 58k tokens，用得频繁时就是直接省钱。原文按 Opus 4.8 估算，单次 request 大约能省 0.87 美元。对每天几十上百次调用的人来说，这比加一个小功能更有体感。

## 这一版的方向

2.1.160 不是那种让人一眼“哇”的版本，但每条改动都落在关键位置。

安全防护走的是预防性路线。现在未必已经有公开案例利用 shell 启动文件或构建配置攻击 Claude Code 用户，但先给这些路径加确认，总比等事后补丁强。上一次 Claude Code 比较密集地做安全加固，是 2.1.101 那次命令注入修复；那次更像修漏洞，这次更像压攻击面。

后台会话的修复量也说明 Anthropic 在认真推进后台 agent 模式。它修的不只是 crash，还有目录锁、列表分类、会话恢复、界面冻结这些细节。只有这些细节稳定下来，多 agent、长任务、隔夜任务才有可能真正成为默认用法。

至于 `workflow` 改名 `ultracode`，我不觉得只是换个触发词。它更像是在给后续的 workflow 编排能力留下语义空间：workflow 这个词应该属于更通用的流程系统，而不是一个容易误触的关键词。

从 2.1.157 到 2.1.160 这几版连着看，节奏其实很清楚：插件体系铺底，云平台 auto mode 扩展，内部管线优化，然后补安全和可靠性。每版只做一两件事，但都在把 Claude Code 从“能用”往“可长期托付”推。

升级方式也很简单：Native 安装一般会自动后台更新；如果想立刻应用，可以执行 `claude update`。Homebrew 用户则是 `brew upgrade claude-code`。
