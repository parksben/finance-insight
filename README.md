# 🌊 澜投研

> 多 Agent 协作投资分析框架 · 每日自动生成报告 · 静态网站展示

**在线访问：** https://parksben.github.io/finance-insight/

---

## 项目简介

澜投研是一套运行在 OpenClaw 上的自动化投资分析系统。每天收盘后，由 5 个扮演不同角色的 AI Agent 协作完成市场分析，最终生成结构化报告并自动发布到本站。

设计理念：用「投资委员会」机制替代单一视角——多角色分工、对抗性验证、裁决者综合拍板，目标是收益最大化 + 系统性风险控制 + 方法论持续迭代。

---

## Agent 角色分工

| 角色 | 职责 | 思维倾向 |
|------|------|--------|
| 🔍 **Researcher** | 客观采集当日市场数据、宏观事件、行业动态，不含主观判断 | 中立 |
| 📈 **Strategist** | 基于情报生成投资信号，给出标的、方向、仓位建议 | 进攻型 |
| 🛡️ **RiskGuard** | 独立审查策略风险，设定止损位和仓位上限 | 保守型 |
| 🔴 **Challenger** | 专门寻找策略逻辑漏洞，提出反向论据，防止群体迷思 | 批判型 |
| ⚖️ **Arbiter** | 综合四方意见，给出最终操作决策，记录核心分歧 | 综合型 |

标准协作流程：

```
Researcher → Strategist → [RiskGuard + Challenger 并行] → Arbiter
```

---

## 自动化流程

### 触发时机

由服务器上的 OpenClaw cron 任务驱动，每日北京时间 21:00 起依次触发：

| 时间 | 任务 |
|------|------|
| 21:00 | Researcher 采集情报 |
| 21:10 | Strategist / RiskGuard / Challenger 并行分析 |
| 21:20 | Arbiter 综合裁决 + 发布报告 |

### 发布流程

```
各 Agent 生成 Markdown 报告
        ↓
Arbiter 调用 publish-finance-report 脚本
        ↓
脚本将报告文件复制到本仓库 docs/daily/<YYYYMMDD>/
        ↓
生成当日 index.md（汇总页）
        ↓
git commit & push → 触发 GitHub Actions
        ↓
VitePress 构建静态网站（约 30 秒）
        ↓
部署到 GitHub Pages
        ↓
脚本返回 PAGE_URL，通过企业微信发送到群组
        ↓
服务器本地报告文件自动删除（磁盘保持干净）
```

### 仓库结构

```
finance-insight/
├── docs/
│   ├── .vitepress/
│   │   └── config.mts          # VitePress 配置（侧边栏自动生成）
│   ├── daily/
│   │   └── YYYYMMDD/
│   │       ├── index.md        # 当日汇总页
│   │       ├── research.md     # Researcher 情报
│   │       ├── strategist.md   # Strategist 信号
│   │       ├── riskguard.md    # RiskGuard 风控
│   │       ├── challenger.md   # Challenger 质疑
│   │       └── arbiter.md      # Arbiter 裁决
│   ├── index.md                # 首页
│   └── about.md                # 框架介绍
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions 自动构建部署
└── package.json                # VitePress 依赖
```

---

## 技术栈

- **静态站生成器：** [VitePress](https://vitepress.dev/)
- **全文搜索：** VitePress 内置 Local Search（无需外部服务）
- **部署：** GitHub Pages（GitHub Actions 自动触发构建）
- **Agent 运行时：** [OpenClaw](https://openclaw.ai)
- **AI 模型：** Claude Sonnet（via GitHub Copilot）

---

## 免责声明

本站所有内容均由 AI 自动生成，仅供学习和参考，**不构成任何投资建议**。投资有风险，入市需谨慎。
