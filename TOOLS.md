# TOOLS.md - Local Setup Notes

> 详细操作文档 → `memory/tools-detail.md`（按需读取）

## 核心规则

- **文件分享**：必须用 `upload-artifact` 上传，返回公开 URL，禁止直接给本地路径
- **截图**：先设 viewport width=1920，再截图，再上传
- **定时任务**：必须用 `openclaw cron`，禁止 subagent+sleep
- **Cron 时区**：直接写北京时间（CST），tz=Asia/Shanghai，无需换算 UTC

## 关键工具

| 工具 | 命令 |
|------|------|
| 文件上传 | `/usr/local/bin/upload-artifact <file> [name]` → `https://assets.parksben.xyz/...` |
| 联网搜索 | `searxng-search "词" [n]` 或 `http://localhost:8080/search?q=...&format=json` |
| 手动备份 | `openclaw-backup-run` |

## 环境信息

- **SearXNG**: `http://localhost:8080`（podman，systemd: `searxng.service`）
- **备份仓库**: https://github.com/parksben/parksben-openclaw（每天 00:00 CST 自动）
- **CJK 字体**: `/usr/share/fonts/google-noto-cjk/`（Noto Sans CJK）
- **Mac 音乐**: 通过 osascript 控制网易云，需辅助功能权限
