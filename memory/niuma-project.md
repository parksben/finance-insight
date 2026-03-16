# 牛马（Niuma）项目记录

> PengAn 的重要项目，优先级高。

## 项目概览

- **名称：** 牛马（Niuma）
- **定位：** AI 驱动的多 Agent 协作平台 —— 让你的产品团队随时在线
- **创建日期：** 2026-03-10
- **最新版本：** v0.1.2（2026-03-15 发布）
- **License：** MIT

## 仓库

| 仓库 | 用途 | URL |
|------|------|-----|
| parksben/niuma | 主仓库（README + release 资产托管） | https://github.com/parksben/niuma |
| parksben/niuma-cli | CLI 安装工具（源码） | https://github.com/parksben/niuma-cli |
| parksben/niuma-server | 服务端（被 install.sh 克隆部署） | https://github.com/parksben/niuma-server |

> 注：niuma 主仓库只有 README.md，实际代码产物从 niuma-cli 的 CI 交叉发布到 niuma 的 releases。
> niuma-server 是独立仓库，install 时 git clone 到用户机器。

## 产品描述

基于 OpenClaw 的多 Agent 协作系统。用户在 App 或桌面端创建「产品项目」，拉入不同角色的 AI 员工（规划师、工程师、设计师、分析师、文案），让他们在群聊里协作完成任务。

## 架构

```
用户端（Android App / Desktop Win+Mac+Linux）
  ↓ HTTP / SSE
牛马服务端 niuma-server（用户认证 · 项目管理 · Agent 路由 · 消息持久化 · SMTP 邮件）
  ↓ OpenClaw Gateway API (默认 ws://localhost:18789)
OpenClaw（多 Agent 运行时 · 工具调用 · 记忆 · 定时任务）
```

## niuma-cli 源码结构

```
niuma-cli/
├── install.sh                    # 一键安装脚本（下载 CLI + Server 二进制到 ~/.niuma/bin/）
├── package.json                  # v0.1.2, type=module, 依赖: commander/inquirer/chalk/ora/nodemailer
├── src/
│   ├── index.js                  # 入口，注册所有 subcommand
│   ├── commands/
│   │   ├── install.js            # 交互式安装向导（5 步）
│   │   ├── server.js             # niuma server start/stop/restart/status/logs
│   │   ├── agents.js             # niuma agents list / install
│   │   └── config.js             # niuma config（交互式修改 SMTP/端口等）
│   └── lib/
│       ├── config.js             # ~/.niuma/config.json 读写
│       ├── openclaw.js           # OpenClaw 检测/Gateway 通信/Agent API
│       ├── systemd.js            # 服务管理（自动检测 systemd vs 直接进程）
│       └── systemd-install.js    # 写入 /etc/systemd/system/niuma-server.service
└── .github/workflows/
    ├── release.yml               # Bun 编译多平台二进制 → 发布到 parksben/niuma releases
    └── validate.yml              # CI 语法检查
```

## install.sh 详解

安装脚本从 `parksben/niuma` 的 GitHub releases 下载两个二进制：
- `niuma-{platform}` → `~/.niuma/bin/niuma`
- `niuma-server-{platform}` → `~/.niuma/bin/niuma-server`

支持平台：linux-x64, linux-arm64, macos-x64, macos-arm64, win-x64

下载特性：
- 分片并发下载（8 chunks）提速
- 带进度条和百分比显示
- 下载后可选安装桌面客户端（dmg/AppImage/exe）
- 写入 PATH（~/.bashrc, ~/.zshrc, ~/.profile）

### macOS 0B bug（2026-03-17）

**现象：** 文件大小显示 `共 0B (CLI 0B + Server 0B)`

**根因：** `get_file_size` 函数通过 `curl -fsSI -r 0-0` 取 `content-range`，GitHub release 302 重定向到 S3 后，macOS curl 拿不到 content-range 和 content-length，size=0。size=0 时分片逻辑 `chunk_size = total / CHUNKS = 0`，下载失败。

**修复方案：**
1. 优先方案：从 GitHub API 直接获取 asset size（最可靠）
2. 备选：size=0 时跳过分片，走普通单线程下载

## niuma install 安装向导（5 步）

1. **Step 1: 检测 OpenClaw** — 自动扫描常见路径（~/.openclaw, /root/.openclaw 等），验证 Gateway 连通性
2. **Step 2: 配置邮箱 SMTP** — 交互输入邮箱/SMTP 授权码/服务器/端口，可选发送测试邮件
3. **Step 3: 创建 Agent 套件** — 在 OpenClaw 上创建 5 个预设 Agent（见下方）
4. **Step 4: 部署 niuma-server** — git clone niuma-server 仓库（优先 ghproxy 镜像），npm install，写 .env，配置 systemd，健康检查
5. **Step 4.5: HTTPS 配置（可选）** — 检测 DNS，配置 Caddy 反代，验证 HTTPS
6. **Step 5: 完成** — 保存配置，显示汇总信息，确认服务运行

## Agent 套件（5 个预设角色）

| ID | 名称 | Emoji | 角色类型 | 职责 |
|----|------|-------|---------|------|
| niuma-planner | 规划师 | 📋 | planner | 需求分析、PRD、任务拆解、团队协调 |
| niuma-coder | 工程师 | 💻 | coder | 全栈开发、技术方案、编码实现 |
| niuma-designer | 设计师 | 🎨 | designer | UI/UX 设计、视觉规范、交互方案 |
| niuma-analyst | 分析师 | 📊 | analyst | 数据分析、市场研究、决策支持 |
| niuma-writer | 文案 | ✍️ | writer | 内容创作、文案撰写、品牌传播 |

安装套餐选项：
- 基础套餐：规划师 + 工程师 + 分析师
- 全套团队：全部 5 个角色
- 自定义选择

每个 Agent 创建时：
1. 创建 workspace 目录 `~/.openclaw/workspaces/{agent-id}/`
2. 写入 SOUL.md（含角色 prompt + 工作规范）
3. 写入 IDENTITY.md
4. 调用 `openclaw agents add` 注册
5. 调用 `openclaw agents set-identity` 设置名称和 emoji

## 工作规范（所有 Agent 共享）

1. 接单即响应
2. 先读文档（项目知识库）
3. 产出即文档（主动更新知识库）
4. 协作优先（阻塞时标注 blocked）
5. 自驱自结（主动扫描、执行、汇报）
6. 简洁汇报（200 字以内，详细写知识库）

## 服务管理

支持两种模式（自动检测）：
- **Linux（有 systemd）：** systemctl start/stop/restart niuma-server + journalctl 日志
- **macOS/其他（无 systemd）：** 直接 spawn 进程，PID 文件 `~/.niuma/server.pid`，日志 `~/.niuma/server.log`

## CI/CD

- **release.yml：** tag push 触发 → Bun 编译 5 个平台二进制 → upload 到 parksben/niuma releases（使用 CROSS_REPO_TOKEN 跨仓库发布）
- **validate.yml：** main push / PR 触发 → node --check 语法检查

## 配置文件

- `~/.niuma/config.json` — CLI 配置（OpenClaw 路径、邮箱 SMTP、服务器端口/路径/URL、已安装 agents 列表）
- `~/.niuma/bin/` — niuma CLI + niuma-server 二进制
- `~/niuma-server/.env` — 服务端环境变量（PORT、SMTP_*、JWT_SECRET）

## Release 资产（v0.1.2）

### 桌面客户端
- macOS: `niuma-desktop_0.1.2_aarch64.dmg` (4.6MB)
- Windows: `niuma-desktop_0.1.2_x64-setup.exe` (2.6MB), `.msi` (3.9MB)
- Linux: `niuma-desktop_0.1.2_amd64.AppImage` (81.8MB), `.deb` (4.4MB), `.rpm` (4.4MB)

### CLI 二进制
- macos-arm64 (62.8MB), macos-x64 (67.8MB)
- linux-x64 (105.8MB), linux-arm64 (103.2MB)
- win-x64 (116.6MB)

### Server 二进制
- macos-arm64 (63.1MB), macos-x64 (68.1MB)
- linux-x64 (106.1MB), linux-arm64 (103.6MB)
- win-x64 (116.9MB)

## 版本历史

- v0.1.0 — 2026-03-15 首发
- v0.1.1 — 2026-03-15 修复
- v0.1.2 — 2026-03-15 最新稳定版（Latest）

## 待办/已知问题

- [ ] install.sh macOS 下载 0B bug（get_file_size 问题）
- [ ] iOS 版客户端开发中
- [ ] niuma-server 源码未读（需单独 clone parksben/niuma-server 分析）
- [ ] 桌面客户端源码未读（可能在 niuma 主仓库的其他分支或私有仓库）
