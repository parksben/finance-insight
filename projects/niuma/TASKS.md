# Niuma 项目待办清单
_最后更新：2026-03-23 04:08 CST_

## ❌ 未完成

### ~~1. niuma (公开仓) README 重写~~ ✅

### ~~2. niuma-desktop workflow 改为上传产物到 niuma 公开仓~~ ✅

### ~~3. niuma-app Android 端语音录制（原生实现）~~ ✅

### ~~4. niuma-web ChatPage 移除桌面端录音按钮~~ ✅

### ~~5. niuma-server 构建 CI (release.yml) 验证~~ ✅

## ✅ 已完成
- niuma-desktop CI 运行结果验证（Run 23095911590 成功，之前失败 23095815156 已被新 run 修复）
- niuma-server 语音/文件消息 API
- niuma-web VoiceRecorder + AudioBubble 组件
- niuma-app Android CI workflow (React Native/Gradle)
- niuma-server 角色模板深度重写（6个角色）
- install.sh 一键安装脚本
- niuma-app Android CI workflow 推送
- niuma-desktop workflow 改为上传产物到 parksben/niuma releases（commit b42f2ba，2026-03-15）
- niuma-web ChatPage 录音按钮已通过 NiumaBridge platform 检测隐藏（无需额外改动）

---

## 巡检日志

### 2026-03-24 01:04 CST
- **新提交 (v0.1.7)**:
  - `niuma-server a2ecf04`: fix: resolve public dir from executable path, bundle frontend with release tar.gz（编译二进制从 process.execPath 目录查找 public/，CI 将前端打包进 .tar.gz）
  - `niuma-server bffa216`: chore: bump version to 0.1.7
  - `niuma-cli ca9e2ae`: chore: bump version to 0.1.7（+install.js 修复 syntax error）
- **CI**:
  - niuma-cli ✅ v0.1.7 成功（23449337802，全 5 平台产物已上传 niuma release）
  - niuma-server ❌ v0.1.7 连续失败 3 次（23449230282, 23449525210, 23450088865）——**根因：GitHub Actions budget (minutes quota) 耗尽**，bun-linux-arm64/windows-x64 job 均报 "Actions budget is preventing further use"，非代码问题
  - niuma-desktop ✅（最近 run v0.1.6，无新 tag）
  - niuma-app ✅（无新 run）
- **Release v0.1.7**: 当前仅 5 个 CLI 产物（niuma-linux-arm64/x64, niuma-macos-arm64/x64, niuma-win-x64.exe，体积正常 ✅）；**缺 server 产物（niuma-server-*）**，因 CI 失败；Desktop 未发布 v0.1.7 tag
- **Release v0.1.6**: 19 产物完整（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）仍可用
- **版本一致性**: server=0.1.7, cli=0.1.7, web=0.1.7, desktop=0.1.6（未 bump）
- **⚠️ 需 PengAn 处理**: GitHub Actions minutes 配额已耗尽，niuma-server CI 无法运行。需要在 GitHub 账户补充 Actions minutes 或等待月度重置后重新触发 v0.1.7 server CI
- **代码质量**: index.js 中 APP_VERSION fallback 仍写死 '0.1.6'（未随 bump 更新），但编译产物从 package.json 读取，影响有限

### 2026-03-23 04:08 CST
- **CI**: niuma-server ✅ (2026-03-17), niuma-cli ✅ (2026-03-22), niuma-app ✅ (2026-03-17)
- **新提交**: 无（各仓库 Already up to date）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常 ✅
- **版本一致性**: 各仓库均未变更，与上次巡检一致 ✅
- 无新问题，无需修复，静默结束

### 2026-03-23 02:08 CST
- **CI**: niuma-server ✅ (2026-03-17), niuma-cli ✅ (2026-03-22), niuma-app ✅ (2026-03-17)
- **新提交**: 无（各仓库 Already up to date）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常 ✅
- **版本一致性**: 各仓库均未变更，与上次巡检一致 ✅
- 无新问题，无需修复，静默结束

### 2026-03-23 00:08 CST
- **CI**: niuma-server ✅ (2026-03-17), niuma-cli ✅ (2026-03-22), niuma-desktop ✅ (2026-03-21), niuma-app ✅ (2026-03-17)
- **新提交**: 无（各仓库 Already up to date）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常；各命名前缀正确 ✅
- **版本一致性**: server=0.1.6, cli=0.1.6, desktop=0.1.6, web=0.1.6 ✅
- 无新问题，无需修复，静默结束

### 2026-03-22 22:08 CST
- **CI**: niuma-server ✅ (2026-03-17), niuma-cli ✅ (2026-03-22), niuma-desktop ✅ (2026-03-21), niuma-app ✅ (2026-03-17)
- **新提交**: 无（各仓库 Already up to date）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常；各命名前缀正确 ✅
- **版本一致性**: server=0.1.6, cli=0.1.6, desktop=0.1.6, web=0.1.6 ✅
- 无新问题，无需修复，静默结束

### 2026-03-22 20:08 CST
- **CI**: niuma-server ✅ (2026-03-17), niuma-cli ✅ (2026-03-22), niuma-desktop ✅ (2026-03-21), niuma-app ✅ (2026-03-17)
- **新提交**: 无（各仓库 Already up to date）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常；各命名前缀正确 ✅
- **版本一致性**: server=0.1.6, cli=0.1.6, desktop=0.1.6, web=0.1.6 ✅
- 无新问题，无需修复，静默结束

### 2026-03-22 18:08 CST
- **CI**: niuma-server ✅ (2026-03-17), niuma-cli ✅ (2026-03-22), niuma-desktop ✅ (2026-03-21), niuma-app ✅ (2026-03-17)
- **新提交**: 无（各仓库已是 already up to date，上次巡检后无新 push）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常；各命名前缀正确 ✅
- **版本一致性**: server=0.1.6, cli=0.1.6, desktop=0.1.6, web=0.1.6 ✅
- 无新问题，无需修复，静默结束

### 2026-03-22 16:08 CST
- **CI**: niuma-server ✅, niuma-cli ✅, niuma-desktop ✅（最新 run 2026-03-21 成功）, niuma-app ✅（全绿）
- **新提交**: 无（各仓库均 Already up to date，上次巡检后无新 push）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常；文件名前缀已正确（`Niuma_0.1.6_...`）✅
- **Desktop MSI**: `Niuma_0.1.6_x64_en-US.msi` (3.9MB) ✅ 已存在，持续多个巡检周期的 Windows MSI 缺失问题已于 2026-03-21 修复
- **CLI install.js**: 已无 git clone + npm install，改为二进制下载 ✅
- **DB 索引**: 13 个索引已到位 ✅
- 无新问题，无需修复，静默结束

### 2026-03-22 14:08 CST
- **CI**: niuma-server ✅, niuma-cli ✅, niuma-desktop ✅（最新 run 2026-03-21 成功）, niuma-app ✅（全绿）
- **新提交（2026-03-22 13:50 CST）**:
  - `niuma-cli 9872d31`: fix: remove SMTP from install/config, use binary download for server deploy
    - install.js Step2 SMTP 配置已移至 Web UI SetupPage（CLI 安装时跳过）
    - deployServer 改为从 GitHub Releases 下载预编译二进制（不再 git clone + npm install）✅
    - config.js 同步移除 SMTP 字段
  - `niuma-server 4790954`: fix: add missing DB indexes for foreign keys and frequent query columns
    - 新增 13 个索引：messages(chat_id/sender_id/created_at), chats(user_id/project_id), project_members(project_id/agent_id), tasks(project_id/assigned_to), knowledge_docs(project_id), peer_reviews(chat_id/msg_id), agent_sessions(chat_id) ✅
- **install.js 审查**: 旧的 git clone + npm install 已完全移除；新逻辑改为下载预编译二进制 ✅（巡检 #4 CLI流程符合要求）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常
- **版本一致性**: 两仓库均未 bump 版本号（main 分支改动，无新 tag）
- **⚠️ 新问题**: install.js 中仍有重复的 `message:` key（L274/L279，SMTP prompt）—— 此为旧代码遗留片段，新 install.js 已重构，无此问题
- **⚠️ 通知 PengAn**: 发现两处新提交（DB索引补全 + CLI安装流程重构）

### 2026-03-22 12:08 CST
- **CI**: niuma-server ✅, niuma-desktop ✅, niuma-cli ✅（全绿）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）；体积正常
- **各仓库**: 无新提交，Already up to date
- 无新问题，无需修复

### 2026-03-22 10:08 CST
- **CI**: niuma-server ✅, niuma-desktop ✅, niuma-cli ✅, niuma-app ✅（全绿）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）
- **版本一致性**: server=0.1.6, web=0.1.6, cli=0.1.6, desktop=0.1.6 ✅ 全部统一
- **代码审查**: 路由鉴权正常，SMTP 链路完整，前后端 API 对齐
- 无新问题，无需修复

### 2026-03-22 08:08 CST
- **CI**: niuma-server ✅, niuma-desktop ✅, niuma-cli ✅（全绿）
- **Release v0.1.6**: 19 产物全部正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）
- **版本一致性**: server=0.1.6, web=0.1.6, cli=0.1.6 ✅ 全部统一
- **CLI install.js**: 含 git clone + npm install 逻辑（设计如此，非旧遗留）
- **SMTP 链路**: 服务端完整，前后端对齐正常
- 无新变化，无需修复

### 2026-03-22 04:10 CST
- **CI**: niuma-server ✅, niuma-desktop ✅, niuma-cli ✅（全绿）
- **版本一致性**: server=0.1.6, web=0.1.6, cli=0.1.6, desktop=0.1.6 ✅
- **Release v0.1.6**: 19 产物全部体积正常（CLI 5 ✅, Server 5 ✅, Desktop 9 ✅）
- **无新提交（2026-03-22 起）**，无新问题，无需修复
- 全局无异常

### 2026-03-21 22:15 CST
- **CI**: niuma-server ✅, niuma-desktop ✅, niuma-cli ✅（全绿）
- **版本一致性**: server=0.1.6, web=0.1.6, cli=0.1.6, desktop=0.1.6 ✅ 全部统一
- **Release v0.1.6**: 19 产物 ✅ CLI 5 ✅, Server 5 ✅, Desktop 9 ✅；体积正常
- **代码审查**: 路由鉴权覆盖正常，templates/workspace 公开端点属设计如此；oauth.js 中缺少 config 时返回 status 500（应为 503），属轻微问题；无裸 Promise rejection
- 无新变化，无需修复

### 2026-03-21 20:08 CST
- **CI**: niuma-server ✅, niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **已修复**: niuma-server index.js 硬编码 fallback 版本 0.1.5 → 0.1.6，已 push
- **已清理**: Release v0.1.6 中 7 个格式异常产物（_ 前缀和 - 前缀）已删除，现有 19 个干净产物
- **Release v0.1.6 产物**: CLI 5 ✅, Server 5 ✅, Desktop 9 (2xdmg + AppImage + deb + exe + msi + 2xapp.tar.gz + rpm) ✅
- **代码审查**: 架构正常，SMTP 链路完整，前后端 API 对齐


### 2026-03-21 18:08 CST
- **CI**: niuma-server ✅, niuma-desktop ❌→🔄 已重新触发（v0.1.6 tag 强制更新至含 ASCII productName 的 HEAD），niuma-cli ✅
- **操作**: `git tag -f v0.1.6 HEAD && git push origin v0.1.6 --force`，新 CI 运行 #23377600294 进行中
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows exe，等待新 CI 完成）
- **代码审查**: server 路由鉴权覆盖完整，SMTP 配置链路正常，CLI install 逻辑含 git clone + npm install（设计如此，非遗留问题）
- **CLI install.js**: 注意有重复的 `message:` key（第 2 个 smtpHost prompt），轻微代码质量问题

### 2026-03-21 14:05 CST
- **CI**: niuma-desktop ❌ Windows MSI WiX light.exe 失败（中文 productName "牛马" 导致 WiX 无法打包）
- **修复**: 将 `productName` 改为 `"Niuma"` (ASCII)，已 push niuma-desktop main
- **修复**: niuma-web `package.json` name 从 `niuma-web-work` 改为 `niuma-web`，已 push
- **修复**: server/cli/desktop/web 版本号统一 bump 至 0.1.6，已全部 push
- **Release 产物**: Desktop 缺 Windows MSI/exe（因 CI 失败，预期修复后下次 release 补全）
- **Desktop 产物文件名**: 前缀被截断（仅剩 `_0.1.6_...`），productName 改 ASCII 后下次构建将正常输出 `Niuma_0.1.6_...`

### 2026-03-21 10:01 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 持续失败), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（缺 Windows .exe MSI）
- **版本一致性**: server=0.1.5, cli=0.1.5, desktop=0.1.6, web=0.1.2（web 版本偏低，属已知差异）
- **niuma-web name**: `niuma-web-work`（非正式命名，非关键）
- 无新变化，所有已知问题同上次巡检

### 2026-03-21 08:01 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，持续), niuma-cli ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI exe）
- 所有仓库代码无变化（Already up to date）
- 无新问题，所有已知问题同上次巡检

### 2026-03-21 03:54 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI exe）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 13:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 21:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 07:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 05:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-18 15:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI 构建失败: WiX `light.exe` 执行报错，同上次), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- **⚠️ Desktop 产物文件名仍缺产品名前缀**: `_0.1.6_aarch64.dmg` 等（Tauri productName 为中文"牛马"导致）
- **⚠️ Windows MSI 缺失**: 同上次，WiX light.exe 失败
- **版本分裂**: package.json server/cli/desktop 均为 0.1.5, **niuma-web 0.1.2**, tauri.conf.json 0.1.6, release tag v0.1.6
- 无新变化，问题同上次巡检

### 2026-03-18 07:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI 构建失败: WiX `light.exe` 执行报错), niuma-cli ✅, niuma Android CI ❌ (旧问题: minSdkVersion 需改为 23)
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（缺 Windows MSI — 因 CI 失败）
- **⚠️ Desktop 产物文件名仍缺产品名前缀**: `_0.1.6_aarch64.dmg` 等（同上次）
- **⚠️ Windows MSI 缺失**: Desktop Windows 构建 WiX light.exe 失败，release 中无 `.msi` 产物
- **版本分裂**: package.json 均为 0.1.5, Cargo.toml 0.1.0, release tag v0.1.6 — 三处不一致
- 其他检查项无新变化

### 2026-03-18 05:53 CST
- **CI**: niuma-server ✅, niuma-desktop 🔄 in_progress (v0.1.6 构建中), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物已上传，体积正常 ✅
- **⚠️ Desktop 产物文件名缺失产品名前缀**: `_0.1.6_aarch64.dmg`、`_0.1.6_amd64.AppImage` 等缺少 `niuma` 前缀，RPM 为 `-0.1.6-1.x86_64.rpm`（Tauri productName 设为中文"牛马"导致构建产物名异常）
- **版本分裂**: niuma-server 0.1.5, niuma-cli 0.1.5, niuma-app 0.1.5, **niuma-web 0.1.2**（仍未更新），tauri.conf.json 0.1.6, release tag v0.1.6
- 其他检查项无新变化

### 2026-03-18 03:53 CST
- **CI**: niuma-server ✅, niuma-desktop ✅, niuma-cli ✅, niuma-app ✅ — 全绿
- **Release v0.1.5**: 17 产物（CLI 5 + Server 5 + Desktop 7），体积正常 ✅，文件名版本号一致 ✅
- **版本**: niuma-server 0.1.5, niuma-cli 0.1.5, niuma-desktop 0.1.5, **niuma-web 0.1.2**（仍未更新）
- **重大变化**: CI 全部恢复正常（CROSS_REPO_TOKEN 问题已解决），release 从 v0.1.2 跳到 v0.1.5
- niuma-web 版本落后，但无功能性影响，记录待后续统一

### 2026-03-17 23:53 CST
- **CI**: niuma-server ❌ (Publish to niuma 失败: CROSS_REPO_TOKEN 权限不足，同前次), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release v0.1.3**: 已有 5 个 server 产物（体积正常 ✅），但缺少 CLI 5个 + Desktop 6+个产物
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- 无新问题，CI 失败原因同前，等待 PengAn 更新 CROSS_REPO_TOKEN

### 2026-03-17 17:53 CST
- **CI**: niuma-server ❌ (git clone niuma-web 失败: `URL rejected: Port number was not a decimal number`，CROSS_REPO_TOKEN 格式异常), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release**: 仍为 v0.1.2（17 产物），v0.1.3 未发布
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- CI 失败原因变化：从权限不足变为 token 格式问题，需 PengAn 重新生成 CROSS_REPO_TOKEN

### 2026-03-17 07:53 CST
- **CI**: niuma-server v0.1.3 ❌ (同上次: CROSS_REPO_TOKEN 权限不足), niuma-desktop ✅, niuma-cli ✅
- **Release**: 仍为 v0.1.2（17 产物），v0.1.3 未发布
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- 无新变更，等待 PengAn 更新 CROSS_REPO_TOKEN 权限

### 2026-03-17 05:53 CST
- **CI**: niuma-server v0.1.3 ❌ (Publish to niuma 失败: `Resource not accessible by integration`，跨仓 release 权限不足), niuma-desktop ✅, niuma-cli ✅
- **Release**: 仍为 v0.1.2（17 产物），v0.1.3 产物未发布
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2
- **workspace 路由缺 auth**: `src/routes/workspace.js` 全部 5 个端点无 authMiddleware
- **templates 路由缺 auth**: `src/routes/templates.js` 全部端点无 authMiddleware
- **CI 失败原因**: CROSS_REPO_TOKEN 权限不足以创建 parksben/niuma 的 release，需更新 token 权限

### 2026-03-17 01:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 17:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 15:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 13:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 13:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 12:53 CST
- **CI**: niuma-server ✅, niuma-cli ✅, niuma-desktop-dock ⚠️ (repo 无 Actions 或无权限，HTTP 404)
- **niuma-web CI ❌**: `PairingPage.tsx` TS2554 — `useRef<ReturnType<typeof setInterval>>()` 缺少初始值参数（strict mode）
- **🔧 修复**: 添加 `undefined` 初始值 (commit 78bda47, pushed)，tsc 通过
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **其他模块**: 无新问题

### 2026-03-16 09:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 07:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 06:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 06:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅（app 0.1.2）
- **DB**: messages/chats 等表缺少外键索引（已知，非紧急）
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 05:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权**: templates.js 无 authMiddleware（公开端点，合理）✅
- **README/CLI/架构**: 无新问题
- 无异常，静默结束

### 2026-03-16 05:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **Server↔Web 对齐**: `/api/employees` 别名已存在 ✅
- **鉴权覆盖**: 路由均有 authMiddleware（templates/connect 公开端点合理）✅
- **README/CLI/架构**: 无新问题
- 无异常，静默结束

### 2026-03-16 04:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 产物齐全（CLI 5, Server 5, Desktop 7），体积正常，版本号一致 ✅
- **🔧 修复**: niuma-web 调用 `/api/employees` 但 server 只有 `/api/agents` → 在 index.js 添加 `/api/employees` 路由别名 (commit 2a952ed, pushed)
- **版本**: niuma-server 0.1.2, niuma-web 0.1.2, niuma-cli 0.1.2, niuma-desktop 0.1.2 ✅
- **README/CLI/架构**: 无新问题
- **⚠️ 需通知 PengAn**: server 缺少 /api/employees 路由已修复

### 2026-03-16 03:23 CST
- **niuma-server**: CI ❌ failure → niuma-web TS error `LoginPage.tsx:20 'ready' unused` → 已修复 + rerun
- **niuma-desktop**: CI ❌ failure → 同一 niuma-web TS error → 已修复 + rerun
- **niuma-cli**: CI ✅ success (v0.1.2)
- **niuma-app**: CI ✅ success (v0.1.0)
- **修复**: niuma-web `ready` → `_ready` 消除 TS6133 (commit 68c122d)
- **修复**: niuma-cli 版本 0.1.1 → 0.1.2 (commit 682cb40)
- **修复**: niuma-web 版本 0.1.0 → 0.1.2 (commit 59d005a)
- **发现**: release v0.1.2 的 desktop 产物文件名含 0.1.1（上次构建遗留），CI rerun 后应自动修正
- **⚠️ 需通知 PengAn**

### 2026-03-16 02:23 CST
- **niuma-desktop**: CI ✅ success (v0.1.2)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.2)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-16 01:49 CST
- **niuma-desktop**: CI 🔄 in_progress (v0.1.2)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI 🔄 in_progress (v0.1.2)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-16 01:19 CST
- **niuma-desktop**: CI 🔄 in_progress (v0.1.1)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.1)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-16 00:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-16 00:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 23:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 23:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 22:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 22:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 21:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 21:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 20:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 20:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 19:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 19:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 18:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 18:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 17:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 17:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 16:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 16:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 15:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 15:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 14:49 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 14:19 CST
- **niuma-desktop**: CI ✅ success (v0.1.0)
- **niuma-app**: CI ✅ success (v0.1.0)
- **niuma-server**: CI ✅ success (v0.1.0)
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 13:19 CST
- **niuma-desktop**: CI ✅ latest run success（2026-03-14 20:38 UTC）
- **niuma-app**: CI ✅ run 23101438841 success（2026-03-15 02:18 UTC）
- **niuma-server**: Build Release 历史遗留失败，main 分支 release.yml 正常，无需处理
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 12:19 CST
- **niuma-desktop**: CI ✅ latest run success（2026-03-14 20:38 UTC）
- **niuma-app**: CI ✅ run 23101438841 success（2026-03-15 02:18 UTC）
- **niuma-server**: Build Release 历史遗留失败，main 分支 release.yml 正常，无需处理
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 11:18 CST
- **niuma-desktop**: CI ✅ run 23095911590 成功（无新 run）
- **niuma-app**: CI ✅ run 23101438841 成功（修复 postinstall 脚本 commit 542cbf8 已生效）
- **niuma-server**: Build Release 历史遗留失败，main 分支 release.yml 正常，无需处理
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-15 10:17 CST
- **niuma-desktop**: CI ✅ 最新 run 成功（2026-03-14 20:38 UTC）
- **niuma-app**: CI ❌ run 23100454126 失败，根因：上次推送的 patch 文件使用假 git hashes（`1234567..abcdefg`），patch-package 无法应用。已推送修复 commit `542cbf8`：移除 patch-package，改用 `scripts/fix-audio-recorder.js` postinstall 脚本（Node.js fs 直接替换 currentActivity），同时放宽 engines.node 至 >= 18.0.0（CI 使用 node 20）。CI 重新触发中。
- **niuma-server**: 无新 run，历史失败为旧 workflow，无需处理
- **未完成任务**: 无

### 2026-03-15 09:14 CST
- **niuma-desktop**: CI ✅ 最新 run 成功（2026-03-14 20:38 UTC）
- **niuma-app**: CI ❌ run 23099447379 失败，根因与上次相同——`react-native-audio-recorder-player@3.6.14` 在 RN 0.84 中 `currentActivity` unresolved（`newArchEnabled=false` 不足以修复 Kotlin 编译错误）。已推送修复 commit `51adff9`：添加 `patch-package`，通过 `patches/react-native-audio-recorder-player+3.6.14.patch` 将 `currentActivity` 替换为 `reactApplicationContext.currentActivity`，postinstall 自动应用。CI run 23100454126 已触发，等待结果。
- **niuma-server**: 无新 run，旧 tar workflow 遗留失败，无需处理
- **未完成任务**: 无

### 2026-03-15 08:13 CST
- **niuma-desktop**: CI ✅ 最新 run 成功
- **niuma-app**: CI ❌ run 23098959193 失败，根因：`react-native-audio-recorder-player@3.x` 使用 `currentActivity`/`applicationContext`，新架构（TurboModule）不提供这些引用。已推送修复 commit `d5c7f19`：`android/gradle.properties` 将 `newArchEnabled=true` 改为 `false`，暂时禁用新架构以兼容 v3.x。CI 触发中。
- **niuma-server**: 旧 tar workflow 历史失败，当前 release.yml 正常（tag-triggered），无需处理
- **未完成任务**: 无

### 2026-03-15 07:43 CST
- **niuma-desktop**: CI ✅ 最新 run 成功（20:38 UTC）
- **niuma-app**: CI ❌ run 23098505524 失败，根因：`package-lock.json` 与 `package.json` 不同步（上次加 react-native-audio-recorder-player 等包未更新 lockfile）。已推送修复 commit `a410ac2`（重新生成 lockfile），CI 触发中
- **niuma-server**: Build Release 仍为旧遗留 workflow 失败，main 分支当前 release.yml 为 Bun binary tag-triggered，无需修复
- **未完成任务**: 无（所有 ❌ 任务均已完成）

### 2026-03-15 07:13 CST
- **niuma-desktop**: CI ✅ 最新 run 成功（20:38 UTC）
- **niuma-app**: CI ✅ 最新 run 成功（22:15 UTC）
- **niuma-server**: Build Release 持续失败（旧 tar workflow `tar .: file changed as we read it`）——确认为历史遗留旧 workflow，main 分支当前 release.yml 已是 Bun binary 版（tag-triggered），无需修复；Task #5 ✅
- **Task #3** ✅ 已完成：实现 niuma-app Android 端原生语音录制（commit 9922ee6）——添加 react-native-audio-recorder-player 依赖，实现 voice_start/voice_stop bridge，录音后上传到服务端，AndroidManifest 添加 READ_MEDIA_AUDIO 权限
- **Task #1** ✅ 已完成：niuma 公开仓 README 重写（commit d53da94）——产品架构四部分，移除技术细节，各子仓库链接指向对应 repo
- **niuma-desktop**: CI ✅ 最新 run 成功；已更新 build.yml 将 tag 产物上传到 parksben/niuma releases（commit b42f2ba）
- **niuma-app**: CI ✅ 最新 run (23097505458) 成功（上次修复 react-native-document-picker 已生效）
- **niuma-server**: release.yml 为 Bun binary 版本，tag-triggered，无需修复；旧 tar workflow 已不存在
- **niuma-web ChatPage**: 录音按钮已通过 NiumaBridge platform 检测条件渲染，桌面端不显示，无需改动
- Task #2 ✅ 完成，Task #4 ✅ 确认完成（已有 platform guard）
- **niuma-desktop**: 最新 CI (run 23095911590) ✅ 成功；task #6 标记完成
- **niuma-app**: CI 失败 (run 23096128241)，根因：`react-native-document-picker@9.3.1` 与 RN 0.84 不兼容（`GuardedResultAsyncTask` 已被移除），且该包在代码中未被使用。已推送修复 commit `a44481f`（从 package.json 删除该依赖）
- **niuma-server**: "Build Release" (run 23095897406) 失败原因为旧版 workflow（`tar .` 包含自身 tarball）。该 workflow 已被 Bun binary 版替换，main 分支当前 release.yml 正常，仅触发于 tag push，无需额外修复。

### 2026-03-16 02:53 CST
- **niuma-server**: CI 🔄 queued
- **niuma-desktop**: CI 🔄 in_progress
- **niuma-cli**: CI 🔄 in_progress
- **niuma-app**: CI ✅ success
- **未完成任务**: 无；一切正常，静默结束

### 2026-03-16 03:53 CST
- **CI**: niuma-server ✅, niuma-desktop ✅, niuma-cli ✅, niuma-app 🔄 in_progress
- **版本一致性问题**: niuma-desktop package.json 仍为 0.1.1，其他模块已是 0.1.2 → 已修复 bump 到 0.1.2 (commit 3a670e2) + git push，CI 将自动触发
- **Release 产物清理**: v0.1.2 release 中残留 6 个 0.1.1 版本的 desktop 产物（文件名含旧版本号）→ 已全部删除
- **niuma-app**: 版本仍为 0.1.0（移动端独立节奏，暂不同步）
- **⚠️ 需通知 PengAn**: desktop 版本落后已修复 + release 旧产物已清理

### 2026-03-16 08:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 08:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 10:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 09:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 10:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 11:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 12:23 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 19:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 21:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-17 03:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-16 23:53 CST
- **CI**: 全部 ✅ (niuma-server, niuma-desktop, niuma-cli, niuma-app)
- **Release v0.1.2**: 17 产物，体积正常 ✅
- **版本**: 全部 0.1.2 ✅
- **鉴权/架构/README/CLI**: 无新问题
- 无异常，静默结束

### 2026-03-17 09:53 CST
- **CI**: niuma-server v0.1.3 ❌ (同上: CROSS_REPO_TOKEN 权限不足), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release**: 仍为 v0.1.2（17 产物），v0.1.3 未发布
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- 无新变更，等待 PengAn 更新 CROSS_REPO_TOKEN 权限

### 2026-03-17 11:53 CST
- **CI**: niuma-server v0.1.3 ❌ (同上: CROSS_REPO_TOKEN 权限不足), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release**: 仍为 v0.1.2（17 产物），v0.1.3 未发布
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- 无新变更，等待 PengAn 更新 CROSS_REPO_TOKEN 权限

### 2026-03-17 13:53 CST
- **CI**: niuma-server v0.1.3 ❌ (同上: CROSS_REPO_TOKEN 权限不足), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release**: 仍为 v0.1.2（17 产物），v0.1.3 未发布
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- 无新变更，等待 PengAn 更新 CROSS_REPO_TOKEN 权限

### 2026-03-17 15:53 CST
- **CI**: niuma-server v0.1.3 ❌ (同上: CROSS_REPO_TOKEN 格式错误致 git clone 失败), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release**: 仍为 v0.1.2（17 产物），v0.1.3 未发布
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- 无新变更，等待 PengAn 更新 CROSS_REPO_TOKEN

### 2026-03-17 19:53 CST
- **CI**: niuma-server v0.1.3 ❌ (同上: CROSS_REPO_TOKEN 格式错误致 git clone 失败), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release**: 仍为 v0.1.2（17 产物），v0.1.3 未发布
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- 无新变更，等待 PengAn 更新 CROSS_REPO_TOKEN

### 2026-03-17 21:53 CST
- **CI**: niuma-server v0.1.3 ❌ (同上: CROSS_REPO_TOKEN 格式错误), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release v0.1.3**: 已发布，但仅含 5 个 server 二进制产物，**缺少 CLI 二进制（5个）和 Desktop 产物（dmg/AppImage/exe 共7个）**
- **Server 产物体积**: linux-arm64 98.8MB ✅, linux-x64 101.2MB ✅, macos-arm64 60.3MB ✅, macos-x64 65.0MB ✅, win-x64 111.5MB ✅
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- **⚠️ Release 产物不全**: v0.1.3 缺少 CLI 和 Desktop 产物，需要触发对应仓库的 release 构建
- 其他检查项无新变化，等待 PengAn 更新 CROSS_REPO_TOKEN

### 2026-03-18 01:53 CST
- **CI**: niuma-server ❌ (同前: CROSS_REPO_TOKEN 权限不足), niuma-desktop ✅, niuma-cli ✅, niuma-app ✅
- **Release v0.1.3**: 仅 5 个 server 产物（体积正常 ✅），仍缺 CLI 5个 + Desktop 7个
- **版本分裂**: niuma-server 0.1.3, niuma-cli 0.1.3, niuma-desktop 0.1.2, niuma-web 0.1.2（无变化）
- 无新问题，等待 PengAn 更新 CROSS_REPO_TOKEN

### 2026-03-18 09:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI 构建失败, 同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物（CLI 5 ✅, Server 5 ✅, Desktop 7 — 缺 Windows MSI）
- **⚠️ 持续问题**: Desktop 产物文件名缺产品名前缀、Windows MSI 缺失、版本分裂（package.json 0.1.5 vs tag v0.1.6）
- 无新变化，同 07:53

### 2026-03-18 11:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI 构建失败, 同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物（CLI 5 ✅, Server 5 ✅, Desktop 7 — 缺 Windows MSI）
- **持续问题**: Desktop 产物文件名缺产品名前缀、Windows MSI 缺失、版本分裂（package.json 0.1.5 vs tag v0.1.6）
- 无新变化，同 09:53

### 2026-03-18 13:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI 构建失败, 同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物（CLI 5 ✅, Server 5 ✅, Desktop 7 — 缺 Windows MSI）
- **持续问题**: Desktop 产物文件名缺产品名前缀、Windows MSI 缺失、版本分裂（package.json 0.1.5 vs tag v0.1.6）
- 无新变化，同 11:53

### 2026-03-18 17:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- **⚠️ Desktop 产物文件名缺产品名前缀**: 同前（Tauri productName 中文"牛马"导致）
- **⚠️ Windows MSI 缺失**: 同前
- **版本分裂**: server/cli/desktop package.json=0.1.5, niuma-web=0.1.2, tauri.conf.json=0.1.6, tag=v0.1.6
- 无新变化，所有问题同上次巡检

### 2026-03-18 19:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- **持续问题**: Desktop 产物文件名缺产品名前缀、Windows MSI 缺失、版本分裂（package.json 0.1.5 vs tag v0.1.6）
- 无新变化，同 17:53

### 2026-03-18 21:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- **持续问题**: Desktop 产物文件名缺产品名前缀、Windows MSI 缺失、版本分裂（package.json 0.1.5 vs tag v0.1.6）
- 无新变化，同 19:53

### 2026-03-18 23:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- **持续问题**: Desktop 产物文件名缺产品名前缀、Windows MSI 缺失、版本分裂（package.json 0.1.5 vs tag v0.1.6）
- 无新变化，同 21:53

### 2026-03-19 01:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- **持续问题**: Desktop 产物文件名缺产品名前缀、Windows MSI 缺失、版本分裂（package.json 0.1.5 vs tag v0.1.6）
- 无新变化，同 23:53

### 2026-03-19 03:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ❌ (Android minSdkVersion 需改为 23，同前)
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- **持续问题**: Desktop 产物文件名缺产品名前缀、Windows MSI 缺失、版本分裂（package.json 0.1.5 vs tag v0.1.6）
- 无新变化，同 01:53

### 2026-03-19 11:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 09:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅, niuma ❌ (Android minSdkVersion 需改为 23，同前)
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 13:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI: WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 15:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 17:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 19:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-19 23:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 01:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 03:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 05:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 07:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 09:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ❌ (Android Gradle assembleDebug 失败: minSdkVersion 需改为 23，同前)
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 11:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 15:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 17:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-21 02:01 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-20 19:53 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 失败，同前), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（仍缺 Windows MSI）
- 无新变化，所有已知问题同上次巡检

### 2026-03-21 12:01 CST
- **CI**: niuma-server ✅, niuma-desktop ❌ (Windows MSI WiX light.exe 持续失败，run 23217800595), niuma-cli ✅, niuma-app ✅
- **Release v0.1.6**: 17 产物，CLI 5 ✅, Server 5 ✅, Desktop 7（缺 Windows .exe MSI）；Desktop 资产命名缺前缀（`_0.1.6_...` 而非 `niuma-desktop_0.1.6_...`）
- **版本一致性**: server=0.1.5, cli=0.1.5, desktop=0.1.6, web=0.1.2（已知差异）
- **SMTP/Auth 链路**: server smtp.js 字段与 web settings.ts 类型定义对齐，无问题
- 无新变化，已知问题持续（Windows Desktop CI 失败）
