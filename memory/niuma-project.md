# 牛马（Niuma）项目 — 完整记忆

> PengAn 的核心项目，最高优先级。

## 一、项目概览

- **名称：** 牛马（Niuma）
- **定位：** AI 驱动的多 Agent 协作平台 —— 类飞书 IM 体验，用户是老板，AI Agent 是员工
- **底层引擎：** OpenClaw Gateway（WebSocket RPC + sessions API + cron）
- **创建日期：** 2026-03-10
- **当前版本：** v0.1.2（2026-03-15/16 发布）
- **License：** MIT
- **Logo：** 折纸风格萌牛头，橙色 #FF6B35，SVG 源文件在 niuma-desktop，公开 URL: https://assets.parksben.xyz/images/518f8caf7736874b.png

---

## 二、仓库清单

| 仓库 | 技术栈 | 可见性 | 本地路径 |
|------|--------|--------|---------|
| [parksben/niuma](https://github.com/parksben/niuma) | README + Release 聚合 | 🟢 Public | /root/.openclaw/projects/niuma |
| [parksben/niuma-server](https://github.com/parksben/niuma-server) | Node.js + Express + SQLite | 🔒 Private | /root/.openclaw/projects/niuma-server |
| [parksben/niuma-web](https://github.com/parksben/niuma-web) | Vite + React + TS + Tailwind | 🔒 Private | (需 clone) |
| [parksben/niuma-cli](https://github.com/parksben/niuma-cli) | Commander.js, Bun 编译 | 🟢 Public | /root/.openclaw/projects/niuma-cli |
| [parksben/niuma-desktop](https://github.com/parksben/niuma-desktop) | Tauri (Rust + WebView) | 🔒 Private | (需 clone) |
| [parksben/niuma-app](https://github.com/parksben/niuma-app) | React Native + WebView | 🔒 Private | (需 clone) |

> 所有平台产物统一发布到 `parksben/niuma` releases，用 CROSS_REPO_TOKEN 跨仓库上传。

---

## 三、架构

```
客户端（Android App / iOS / Desktop macOS+Win+Linux）
  │  React Native 薄壳 + WebView / Tauri + WebView
  │  JSBridge: window.NiumaBridge (voice/file/push/auth)
  ↓
niuma-web（Vite + React + TS + Tailwind）
  │  WebSocket (实时消息) + HTTP REST
  ↓
niuma-server（Express.js + SQLite）
  ├── 用户认证（邮箱 OTP + JWT，自动生成 JWT_SECRET）
  ├── Agent 管理（7 个角色模板 + 自定义创建）
  ├── 项目管理 + 成员管理
  ├── 群聊消息编排（GroupOrchestrator: @解析 → 递归 → 速率限制）
  ├── 知识库文档（Agent 可自动写入）
  ├── 任务看板（todo/doing/review/done/blocked）
  ├── 凭证管理（OAuth 一键绑定 + 手动配置）
  ├── 文件上传 + 语音消息 + 转写
  ├── 项目生命周期（running/paused/stopped）
  ├── Workspace 文件系统（JSONL 消息 + git 产物管理）
  ├── SSE 事件总线
  └── settings API (Gateway URL/Token + SMTP)
  ↓ WebSocket RPC + CLI execSync
OpenClaw Gateway（Agent 运行时）
```

---

## 四、数据库表（SQLite）

users / agents / projects / project_members / chats / chat_agents / messages / otps / knowledge_docs / tasks / credentials(新)

messages 表支持: type(text/voice/file), file_url, file_name, file_size, duration, thinking, status(done/streaming)

---

## 五、Agent 角色模板（7 个，在 src/skills/templates.json）

| 角色 | 模型 | Thinking |
|------|------|---------|
| PM（产品经理）| claude-sonnet-4.6 | low |
| 项目经理 | claude-haiku-4.5 | off |
| 前端工程师 | claude-opus-4.6 | low |
| 后端工程师 | claude-opus-4.6 | low |
| UI/UX 设计师 | claude-haiku-4.5 | off |
| 数据分析师 | claude-sonnet-4.6 | medium |
| 测试工程师 | claude-haiku-4.5 | off |

命名规范：预置 `niuma-planner` 等，用户自建 `niuma-{roleType}-{nanoid6}`

---

## 六、核心业务逻辑

### Planner-Executor 模式
1. 用户发消息 → 保存 DB → 立即返回 201
2. 异步：planner 先回复 → 其 reply 作为 context → executor 并发回复
3. 30% 概率 follow-up（最多 2 轮）
4. Agent 回复通过 `openclaw agent` CLI 调用，失败 fallback 到 mock 模板
5. 回复 chunk 流式推送（SSE: message_chunk）

### GroupOrchestrator（新架构）
- parseMentions 解析 @mentions → 并行触发多 Agent
- 递归处理 Agent 回复中的 @mentions（depth 上限 8）
- 单群 1 分钟 Agent 发言上限 30 条
- broadcastTyping 广播打字状态

### 同伴互评系统
- 任务完成信号触发，最多邀请 2 个 Agent 打分

---

## 七、CI/CD

- 所有仓库 tag push → GitHub Actions → Bun 编译（server/cli）/ Flutter/RN/Tauri 构建
- 产物统一上传到 parksben/niuma releases
- niuma-web build 产出注入 niuma-server/public/（SPA fallback）

---

## 八、版本历史

| 版本 | 日期 | 关键变更 |
|------|------|---------|
| v0.1.0 | 03-15/16 | 首发：全平台构建，release 资产齐全 |
| v0.1.1 | 03-16 | 修复 niuma-web TS 错误，私有仓库 clone 认证 |
| v0.1.2 | 03-16 | 登录改邮箱 OTP，主题色改橙 #FF6B35，安全修复(JWT/settings auth/port)，路由对齐 |

---

## 九、开发历程关键节点

- **03-10**: 项目启动，niuma-cli 初始化
- **03-11**: niuma-cli 5 步安装向导实现，5 个 OpenClaw Agent 创建
- **03-12**: niuma-server 部署(port 3002)，知识库功能，App ServerConnectScreen，所有仓库 public/private 确定，大量 bug 修复（SMTP/路由对齐/server 0.0.0.0 监听）
- **03-15 凌晨**: 架构大重写（GatewayClient WS 长连 + GroupOrchestrator + LifecycleService + WorkspaceService），新建 niuma-web 和 niuma-desktop 仓库
- **03-15 早上**: Logo 定稿，7 角色模板深度重写，语音消息完整链路，Bun 编译方案，install.sh 重写
- **03-15 下午~03-16**: v0.1.0/v0.1.1/v0.1.2 连续发布，CI 修复，安全加固，SMTP 配置链路打通
- **03-17 凌晨**: install.sh macOS 0B bug 修复（GitHub API fallback）

---

## 十、已知问题 & 待办

### Bug
- [x] install.sh macOS 0B 下载（commit c1eb7fe 已修复）
- [ ] niuma install 仍走 git clone niuma-server + npm install（应改用预编译二进制）
- [ ] niuma config 还问 SMTP（应在 Web UI SetupPage 配置）
- [ ] DB 缺外键索引

### 待实现（Phase 2+）
- [ ] iOS 客户端（需 Apple Developer $99/年）
- [ ] 凭证管理系统落地（OAuth: GitHub/Twitter/Facebook/Instagram，手动: TikTok/小红书/LinkedIn）
- [ ] 群聊共享记忆（PengAn 03-17 提出的产品需求）
- [ ] Agent 模板自动注册到 OpenClaw（bootstrapAgentTemplates）

### 历史已完成但被取消的 cron
- niuma-patrol（30min 技术巡检）— PengAn 取消
- niuma-report（2h 进展推送）— PengAn 取消

---

## 十一、TASKS.md 位置

完整任务拆解：`/root/.openclaw/workspace/projects/niuma/TASKS.md`
- Phase 1: TASK-001~010（基础骨架，大部分 review 状态）
- Phase 1.5: TASK-014~016（凭证管理，review 状态）
- Phase 2: TASK-011~012（移动端/桌面端，todo）
- Phase 3: TASK-013（CLI 完善，todo）

---

## 十二、niuma-patrol-prompt 位置

巡检 prompt 备份：`/root/.openclaw/workspace/niuma-patrol-prompt.md`
包含技术巡检（6 维度）和产品需求发现（5 维度）两套 prompt。
