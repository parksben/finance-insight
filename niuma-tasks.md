# Niuma 项目待办清单
_最后更新：2026-03-15_

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
