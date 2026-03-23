# Tools Detail (on-demand reference)

## Backup & Persistence

- 备份脚本：`/root/openclaw-backup/scripts/backup.sh`（入口：`openclaw-backup-run`）
- 备份仓库：https://github.com/parksben/parksben-openclaw（private）
- 定时任务：每天 00:00 CST（cron: `nightly-openclaw-backup`）
- 备份内容：整个 `/root/.openclaw/`、Caddy 配置、工具脚本
- workspace 有本地 git，重要变更需 `git commit`

## upload-artifact

`/usr/local/bin/upload-artifact <file-path> [original-name]`

- 自动分类（images/documents/videos/audios/archives/others）
- SHA256 重命名，上传至 GitHub repo: parksben/openclaw-artifect
- 上传后自动删除本地文件
- 返回 URL: `https://assets.parksben.xyz/{category}/{hash}.{ext}`

## Screenshot Protocol

1. viewport width=1920 before screenshot
2. `browser act kind=resize width=1920 height=1080`
3. `loadState=networkidle` after navigate
4. Upload via `upload-artifact`

## Scheduled Tasks / Cron

```bash
openclaw cron list
openclaw cron add --once "2026-03-10 10:30" --prompt "..."
openclaw cron add --cron "30 10 * * 1" --prompt "..."
openclaw cron runs
openclaw cron rm <job-id>
```

## Mac 音乐控制（网易云音乐）

需辅助功能权限（系统设置 → 隐私与安全性 → 辅助功能）

```bash
# 播放/暂停
osascript -e 'tell application "NeteaseMusic" to activate' && sleep 0.3 && osascript -e 'tell application "System Events" to keystroke space'
# 下一首
osascript -e 'tell application "NeteaseMusic" to activate' && sleep 0.3 && osascript -e 'tell application "System Events" to key code 124 using {command down}'
# 调节音量(+20)
osascript -e 'set v to output volume of (get volume settings)' -e 'set volume output volume (v + 20)'
```

## SearXNG 联网搜索

- 地址：`http://localhost:8080`
- podman 容器，systemd: `searxng.service`
- 配置：`/root/.openclaw/workspace/searxng/settings.yml`

```bash
searxng-search "搜索词" [数量]
curl -s "http://localhost:8080/search?q=<query>&format=json&language=zh-CN"
```

## System Fonts

CJK: `google-noto-sans-cjk-ttc-fonts` @ `/usr/share/fonts/google-noto-cjk/`
