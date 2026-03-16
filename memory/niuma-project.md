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
| parksben/niuma | 主仓库（服务端+客户端+桌面端） | https://github.com/parksben/niuma |
| parksben/niuma-cli | CLI 安装工具（install.sh + 服务管理） | https://github.com/parksben/niuma-cli |

## 产品描述

基于 OpenClaw 的多 Agent 协作系统，支持创建 AI 员工团队，自动完成产品规划、开发、设计、分析等工作。
用户在 App 或桌面端创建「产品项目」，拉入不同角色的 AI 员工（规划师、工程师、设计师、分析师…），让他们在群聊里协作完成任务。

## 架构

```
用户端（Android App / Desktop Win+Mac+Linux）
  ↓ HTTP / SSE
牛马服务端（用户认证 · 项目管理 · Agent 路由 · 消息持久化）
  ↓ OpenClaw API
OpenClaw（多 Agent 运行时 · 工具调用 · 记忆 · 定时任务）
```

## Release 资产（v0.1.2）

### 客户端
- Android: (待确认，可能 apk 未上传)
- macOS: `niuma-desktop_0.1.2_aarch64.dmg` (4.6MB)
- Windows: `niuma-desktop_0.1.2_x64-setup.exe` (2.6MB), `.msi` (3.9MB)
- Linux: `niuma-desktop_0.1.2_amd64.AppImage` (81.8MB), `.deb` (4.4MB), `.rpm` (4.4MB)

### CLI 二进制
- `niuma-macos-arm64` (62.8MB)
- `niuma-macos-x64` (67.8MB)
- `niuma-linux-x64` (105.8MB)
- `niuma-linux-arm64` (103.2MB)
- `niuma-win-x64.exe` (116.6MB)

### Server 二进制
- `niuma-server-macos-arm64` (63.1MB)
- `niuma-server-macos-x64` (68.1MB)
- `niuma-server-linux-x64` (106.1MB)
- `niuma-server-linux-arm64` (103.6MB)
- `niuma-server-win-x64.exe` (116.9MB)

## CLI 命令

| 命令 | 说明 |
|------|------|
| `niuma install` | 一键部署 niuma-server + OpenClaw + Agent 套餐 |
| `niuma server start/stop/restart/status/logs` | 管理 niuma-server 服务 |
| `niuma agents list` | 查看已安装的 Agent |
| `niuma agents install` | 安装/更新 Agent 套餐 |
| `niuma config` | 修改配置（SMTP、端口等） |
| `niuma update` | 更新 niuma-server 到最新版 |

## 已知问题

### install.sh macOS 下载文件大小为 0（2026-03-17 发现）

**现象：** `curl -fsSL install.sh | bash` 执行后显示 `共 0B (CLI 0B + Server 0B)`

**原因：** `get_file_size` 函数通过 `curl -fsSI -r 0-0` 获取 `content-range`，GitHub Release 下载链接会 302 到 S3/CDN，macOS curl 经过重定向后可能拿不到 content-range 和 content-length，导致 size=0。size=0 后分片下载逻辑 chunk_size=0 也出问题。

**修复方案：** 在 `get_file_size` 中加 GitHub API fallback，直接从 `https://api.github.com/repos/parksben/niuma/releases/latest` 的 assets 字段取 size（最可靠）。或者当 size=0 时跳过分片，走普通下载模式。

## 版本历史

- v0.1.0 — 2026-03-15 首发
- v0.1.1 — 2026-03-15 修复
- v0.1.2 — 2026-03-15 最新稳定版（Latest）

## 备注

- iOS 版正在开发中
- 系统要求：Linux/macOS 服务器 + 已部署 OpenClaw
- 国内用户安装推荐用 ghproxy.net 代理
