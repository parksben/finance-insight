# 牛马项目任务拆解

## 项目背景

AI 多 Agent 协作平台，类飞书 IM 体验，用户是老板，AI Agent 是员工。
底层引擎：OpenClaw Gateway（WebSocket RPC + sessions API + cron）

## 仓库

- niuma-cli: https://github.com/parksben/niuma-cli （保留，小改）
- niuma-server: https://github.com/parksben/niuma-server （改造）
- niuma-web: https://github.com/parksben/niuma-web （新建）
- niuma-app: https://github.com/parksben/niuma-app （重写）
- niuma-desktop: https://github.com/parksben/niuma-desktop （新建）

---

## Phase 1 — 基础骨架（MVP 核心跑通）

### TASK-001
- Title: niuma-server — Gateway 连接层
- Owner: builder
- Status: review
- Repo: niuma-server
- Description: |
    实现 src/gateway/ 模块：
    - GatewayClient.js：WebSocket 长连接，处理 connect.challenge 握手，断线重连（指数退避），15s 心跳 tick
    - GatewayRpc.js：封装 req/res 模式，send + waitForResponse，30s 超时
    - GatewayEvents.js：监听 event 帧，EventEmitter 分发
    - GatewayHttp.js：封装 POST /tools/invoke HTTP 调用
    配置从环境变量读取：OPENCLAW_GATEWAY_URL, OPENCLAW_GATEWAY_TOKEN

### TASK-002
- Title: niuma-server — AgentService & CronService
- Owner: reviewer
- Status: review
- Repo: niuma-server
- Depends: TASK-001
- Description: |
    - AgentService.js：
      spawnEmployee({ templateId, name, label }) → sessions_spawn → 返回 sessionKey
      sendMessage({ sessionKey, message, context }) → sessions_send
      getHistory({ sessionKey }) → sessions_history
      killEmployee({ sessionKey }) → subagents kill
    - CronService.js：封装 openclaw cron add/rm/list（通过 GatewayHttp）

### TASK-003
- Title: niuma-server — GroupOrchestrator（群消息编排）
- Owner: reviewer
- Status: review
- Repo: niuma-server
- Depends: TASK-002
- Description: |
    实现群聊多 Agent 协作核心逻辑：
    - handleMessage({ groupId, fromType, fromId, content, depth=0 })
    - parseMentions(content) 解析 @mentions
    - buildContext(groupId, content) 构造 Agent 上下文（角色扮演包）
    - 并行触发多个被 @ 的 Agent（Promise.all）
    - 递归处理 Agent 回复中的 @mentions（depth 上限 8）
    - broadcastTyping(groupId, employeeId) 广播打字状态
    防护：单群 1 分钟内 Agent 发言上限 30 条，单次 Agent 调用 60s 超时

### TASK-004
- Title: niuma-server — 项目生命周期控制
- Owner: reviewer
- Status: review
- Repo: niuma-server
- Depends: TASK-003
- Description: |
    - group.status 状态机：running / paused / stopped
    - POST /api/groups/:id/control { action: pause|resume|stop }
    - POST /api/groups/:id/members/:employeeId/control { action: pause|resume }
    - 暂停时：给所有员工 session 发「项目已暂停」系统消息，入库暂停快照
    - 恢复时：给 PM Agent 发恢复消息附暂停摘要
    - 结束时：kill 所有 session，群状态置 stopped（只读归档）

### TASK-005
- Title: niuma-server — 产物文件系统（Workspace）
- Owner: reviewer
- Status: review
- Repo: niuma-server
- Description: |
    实现 WorkspaceService：
    目录结构：/workspace/projects/{groupId}-{name}/docs/ code/ tasks/
    - createGroupWorkspace(groupId, name)
    - writeFile(groupId, path, content)
    - readFile(groupId, path)
    - listFiles(groupId)
    Agent 输出文档/代码时解析特殊标记写入文件系统，数据库只存元数据（路径引用）

### TASK-006
- Title: niuma-web — 项目初始化 & 路由
- Owner: reviewer
- Status: review
- Repo: niuma-web
- Description: |
    - Vite + React + TypeScript 初始化
    - React Router：/login, /chat, /chat/:id, /workspace, /employees, /profile
    - Tailwind CSS
    - 响应式布局：移动端底部 Tab，PC 端左侧 Sidebar 自动切换（breakpoint: 768px）
    - NiumaBridge 接口定义（window.NiumaBridge mock 实现，供开发调试）

### TASK-007
- Title: niuma-web — 聊天列表页 & 单聊页面
- Owner: reviewer
- Status: review
- Repo: niuma-web
- Depends: TASK-006
- Description: |
    - 聊天列表：单聊 + 群聊，展示最后一条消息 + 未读数
    - 单聊页：消息气泡，支持流式打字效果（WebSocket message_chunk 事件）
    - 群聊页：多人消息流，Agent 打字状态（typing indicator），@ 高亮
    - WebSocket 客户端封装（自动重连）
    - 消息输入框：文字 + 语音按钮（调 NiumaBridge.voice）

### TASK-008
- Title: niuma-web — 员工管理页 & 创建员工向导
- Owner: reviewer
- Status: review
- Repo: niuma-web
- Depends: TASK-006
- Description: |
    - 员工列表：头像（首字 + 颜色）、角色、状态（在线/暂停）
    - 创建员工：选择 Agent 模板 → 填写名字 → 确认创建
    - Agent 模板库展示（内置模板：PM、项目经理、前端、后端、设计师）
    - 员工详情：基本信息、技能标签、单聊入口

### TASK-009
- Title: niuma-web — 项目群管理 & 生命周期控制
- Owner: reviewer
- Status: review
- Repo: niuma-web
- Depends: TASK-007
- Description: |
    - 创建项目群：群名、目标描述、选择员工、指定负责人
    - 群设置页：成员管理、群目标
    - 群顶部操作栏：▶继续 / ⏸暂停 / ⏹结束 三个控制按钮
    - 结束确认弹窗（不可恢复提示）
    - 暂停/运行状态在群列表和群页面的视觉区分

### TASK-010
- Title: niuma-server — Agent 模板 Skill 定义（5个内置角色）
- Owner: reviewer
- Status: review
- Repo: niuma-server
- Description: |
    在 src/skills/ 下创建 5 个内置 Agent 模板定义（JSON/YAML）：
    - pm.json：产品经理（主动询问需求、产出 PRD、分配任务、汇报进展）
    - project-manager.json：项目经理（版本规划、任务跟踪、协调资源）
    - frontend-dev.json：前端工程师（UI 实现、组件设计）
    - backend-dev.json：后端工程师（API 设计、数据库、服务端逻辑）
    - designer.json：设计师（UI/UX 方案、设计说明文档）
    每个模板包含：systemPrompt、skills[]、tools[]、personality、defaultBehavior

---

## Phase 2 — 移动端 & 桌面端

### TASK-011
- Title: niuma-app — React Native 薄壳重构
- Owner: builder
- Status: todo
- Repo: niuma-app
- Description: |
    完全重写为 WebView 薄壳架构：
    - WebView 组件加载 niuma-web（开发时走 dev server，生产时走 server URL）
    - JSBridge 实现 window.NiumaBridge：
      voice: { startRecording, stopRecording, getTranscript }（调系统 STT）
      file: { pick, upload }
      push: { register, getToken }
      auth: { getToken, setToken }（本地安全存储 server URL + token）
    - iOS + Android 双端适配
    - server 连接配置页（首次启动填写 server URL）

### TASK-012
- Title: niuma-desktop — Tauri 初始化 & WebView 集成
- Owner: builder
- Status: todo
- Repo: niuma-desktop
- Description: |
    - Tauri 项目初始化，WebView 加载 niuma-web
    - 实现同一套 window.NiumaBridge（Tauri invoke 调 Rust 原生能力）
    - 账号密码 + Token 本地存储登录（不需要扫码）
    - 窗口大小记忆、系统托盘

---

## Phase 3 — CLI 工具完善

### TASK-013
- Title: niuma-cli — 更新安装向导支持新架构
- Owner: builder
- Status: todo
- Repo: niuma-cli
- Description: |
    更新安装向导：
    - 配置 OPENCLAW_GATEWAY_URL 和 OPENCLAW_GATEWAY_TOKEN
    - 自动检测 OpenClaw Gateway 连通性
    - 一键启动 niuma-server（含静态文件服务）
    - 健康检查命令：niuma status

---

## Phase 1.5 — 凭证管理（员工权限配置）

策略：能一键 OAuth 托管的平台走自动化流程，门槛高/API 受限的平台走手动配置兜底。

### TASK-014
- Title: 凭证管理系统 — Server 端（OAuth + 手动双路径）
- Owner: reviewer
- Status: review
- Repo: niuma-server
- Depends: TASK-002
- Priority: P1
- Description: |
    实现员工凭证统一管理后端，支持两种接入模式：

    **一、数据模型 credentials 表：**
    - id, userId, label（显示名）
    - provider（平台标识）
    - authMode: "oauth" | "manual"（接入方式）
    - tokenEncrypted（AES-256-GCM 加密存储）
    - refreshTokenEncrypted（OAuth refresh_token，加密存储）
    - scopes[]（权限范围）
    - tags[]（用途标签，如 ["代码管理","社媒运营"]）
    - expiresAt（过期时间）
    - status: "active" | "expired" | "revoked" | "error"
    - createdAt, updatedAt

    **二、OAuth 一键绑定（完全托管）— 首批支持：**

    🟢 github（GitHub App）
    · 用户点「绑定」→ 跳转 GitHub Install 页面 → 选择仓库授权 → 回调
    · 后端自动获取 installation_id → 按需生成 installation access token
    · Token 自动续期（1小时有效，过期自动刷新）
    · 权限粒度：按仓库 + 按类型（contents/issues/actions/pull_requests）
    · 适用角色：程序员员工

    🟢 twitter（OAuth 2.0 PKCE）
    · 用户点「绑定」→ 跳转 Twitter 授权页 → 同意 → 回调拿 access_token + refresh_token
    · scope: tweet.read tweet.write users.read dm.read dm.write
    · refresh_token 自动续期
    · 适用角色：运营员工

    🟢 facebook（Meta OAuth）
    · 用户点「绑定」→ Meta OAuth 登录 → 授权 Page 权限 → 获取 Long-lived Page Token
    · scope: pages_manage_posts, pages_read_engagement, pages_show_list
    · Page Token 60天有效，后台定时 refresh 续期
    · 适用角色：运营员工

    🟢 instagram（Meta OAuth，同 Facebook 流程）
    · 需 Instagram Business/Creator 账号已绑定 Facebook Page
    · 额外 scope: instagram_basic, instagram_content_publish
    · 适用角色：运营员工

    **三、手动配置（门槛高的平台兜底）：**

    🟡 tiktok
    · Content Posting API 需双重审核（1-2周），先手动配置
    · 后续审核通过后可升级为 OAuth 一键绑定
    · 手动填写：access_token, open_id

    🟡 xiaohongshu
    · 需企业资质，个人发笔记 API 未开放
    · 手动填写：app_key, app_secret, access_token
    · 后台实现 refresh_token 自动续期

    🟡 linkedin
    · Share API 需单独申请 Marketing Developer Platform
    · 手动填写：access_token

    🔵 custom — 自定义凭证（通用 Key-Value）
    · 用户自行填写，适用任意第三方服务

    **四、OAuth 路由：**
    - GET /api/oauth/:provider/authorize → 生成授权 URL，302 重定向
    - GET /api/oauth/:provider/callback → 处理回调，存储 token，跳回前端
    - POST /api/oauth/:provider/refresh → 手动触发 token 续期

    **五、凭证 CRUD API：**
    - POST /api/credentials — 创建（手动模式）
    - GET /api/credentials — 列表（脱敏）
    - PUT /api/credentials/:id — 更新
    - DELETE /api/credentials/:id — 删除
    - POST /api/credentials/:id/verify — 验证有效性

    **六、自动续期服务：**
    - TokenRefreshService：定时扫描即将过期凭证，自动 refresh
    - GitHub: installation token 按需生成（1h有效）
    - Twitter: refresh_token 换新 access_token
    - Facebook/Instagram: Long-lived token 续期
    - 续期失败 → status 置为 "error"，通知用户重新绑定

    **七、安全策略：**
    - AES-256-GCM + 随机 IV 加密存储，密钥从 CREDENTIAL_ENCRYPTION_KEY 读取
    - API 永不返回明文 Token
    - 操作审计日志
    - Agent 通过内部 API 获取解密值，不经前端

### TASK-015
- Title: 凭证管理系统 — Web 前端（一键绑定 + 手动配置）
- Owner: reviewer
- Status: review
- Repo: niuma-web
- Depends: TASK-014, TASK-006
- Priority: P1
- Description: |
    个人页面（/profile）「凭证管理」模块：

    **凭证列表：**
    - 卡片式展示：平台图标 + 名称 + 绑定状态 + 标签 + 过期状态
    - 状态指示：🟢已绑定 / 🟡即将过期 / 🔴已失效
    - 按平台/标签筛选

    **一键绑定流程（GitHub/Twitter/Facebook/Instagram）：**
    - 点击平台卡片上的「一键绑定」按钮
    - 跳转到对应平台授权页（新窗口/重定向）
    - 用户在平台上确认授权
    - 自动回调 → 绑定完成 → 卡片变为已绑定状态
    - 支持「解绑」和「重新绑定」

    **手动配置流程（TikTok/小红书/LinkedIn/自定义）：**
    - 点击「手动添加」
    - 选择平台 → 显示接入引导（如何获取 Token + 跳转链接）
    - 填写凭证 → 自动验证 → 保存

    **凭证详情：**
    - 基本信息、绑定方式（OAuth/手动）、权限范围
    - 标签管理、使用记录
    - 过期倒计时（OAuth 的自动续期状态）
    - 删除（二次确认）

    **UI 要求：**
    - 各平台品牌色图标
    - OAuth 绑定的平台显示「已托管·自动续期」标识
    - 手动配置的平台显示「手动·需定期更新」提示

### TASK-016
- Title: 凭证管理系统 — Agent 凭证注入
- Owner: reviewer
- Status: review
- Repo: niuma-server
- Depends: TASK-014, TASK-010
- Priority: P1
- Description: |
    让 AI 员工根据角色自动获取所需凭证：

    - Agent 模板新增 requiredCredentials[] 字段：
      frontend-dev.json: ["github"]
      backend-dev.json: ["github"]
      social-media-ops.json: ["twitter", "facebook", "instagram", "tiktok", "xiaohongshu"]
    - AgentService.spawnEmployee 时检查所需凭证是否已绑定
    - 未绑定 → 提示用户去个人页面绑定（区分一键/手动）
    - 已绑定 → 通过内部 API 注入解密凭证（不经前端/WebSocket）
    - OAuth 凭证注入时自动检查有效性，过期则先 refresh 再注入

    **前置条件：** 需先在各平台注册开发者应用（一次性操作，由 PengAn 完成）：
    - GitHub: 创建 GitHub App（github.com/settings/apps）
    - Twitter: 创建 App（developer.x.com）
    - Meta: 创建 App（developers.facebook.com）
    - 各 App 的 client_id/secret 存入 server 环境变量

---

## Activity Log
- 2026-03-16 15:00 [builder] TASK-004 implemented & pushed (commit 13dba4d). Status → review.

## UpdatedAt: 2026-03-16
## Activity Log
- 2026-03-16 TASK-015: builder completed credential management UI, pushed to niuma-web main (3af2203), moved to review
