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
- Status: todo
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
- Owner: builder
- Status: todo
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
- Owner: builder
- Status: todo
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
- Owner: builder
- Status: todo
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
- Owner: builder
- Status: todo
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
- Owner: builder
- Status: todo
- Repo: niuma-web
- Description: |
    - Vite + React + TypeScript 初始化
    - React Router：/login, /chat, /chat/:id, /workspace, /employees, /profile
    - Tailwind CSS
    - 响应式布局：移动端底部 Tab，PC 端左侧 Sidebar 自动切换（breakpoint: 768px）
    - NiumaBridge 接口定义（window.NiumaBridge mock 实现，供开发调试）

### TASK-007
- Title: niuma-web — 聊天列表页 & 单聊页面
- Owner: builder
- Status: todo
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
- Owner: builder
- Status: todo
- Repo: niuma-web
- Depends: TASK-006
- Description: |
    - 员工列表：头像（首字 + 颜色）、角色、状态（在线/暂停）
    - 创建员工：选择 Agent 模板 → 填写名字 → 确认创建
    - Agent 模板库展示（内置模板：PM、项目经理、前端、后端、设计师）
    - 员工详情：基本信息、技能标签、单聊入口

### TASK-009
- Title: niuma-web — 项目群管理 & 生命周期控制
- Owner: builder
- Status: todo
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
- Owner: builder
- Status: todo
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

### TASK-014
- Title: 凭证管理系统 — Server 端
- Owner: builder
- Status: todo
- Repo: niuma-server
- Depends: TASK-002
- Priority: P1
- Description: |
    实现员工凭证（Token/API Key）统一管理后端：

    **数据模型 credentials 表：**
    - id, userId, label（显示名，如「我的 GitHub」）
    - provider（平台标识，见下方枚举）
    - tokenEncrypted（AES-256-GCM 加密存储）
    - scopes[]（权限范围，如 ["repo","workflow"]）
    - tags[]（用途标签，如 ["代码管理","CI/CD"]）
    - expiresAt（过期时间，可选）
    - createdAt, updatedAt

    **支持的 provider 枚举（首批）：**
    - github — Personal Access Token (Fine-grained)
      · 接入方式：用户在 GitHub Settings > Developer Settings 生成 Fine-grained PAT
      · 可控权限粒度：按仓库 + 按权限类型（Contents/Issues/Actions 等）
      · Token 格式：github_pat_xxx
      · 适用角色：程序员员工

    - twitter — X/Twitter API OAuth 2.0
      · 接入方式：developer.x.com 创建 App，获取 API Key + API Secret + Access Token + Access Token Secret + Bearer Token（共 5 个凭证）
      · 权限分 3 档：Read / Read+Write / Read+Write+DM
      · 存储为 JSON 对象：{ apiKey, apiSecret, accessToken, accessSecret, bearerToken }
      · 适用角色：运营员工

    - facebook — Meta Graph API
      · 接入方式：developers.facebook.com 创建 App，OAuth 授权获取 Page Access Token
      · Token 分类：User Token（短期2h）/ Page Token（长期）/ App Token
      · 实际使用 Long-lived Page Token（60天有效，可续期）
      · 权限通过 scope 控制：pages_manage_posts, pages_read_engagement 等
      · 适用角色：运营员工

    - instagram — Instagram Graph API（通过 Meta 平台）
      · 接入方式：同 Facebook，需要 Instagram Business 账号绑定 Facebook Page
      · 使用 Page Access Token + instagram_basic, instagram_content_publish scope
      · 适用角色：运营员工

    - xiaohongshu — 小红书开放平台
      · 接入方式：open.xiaohongshu.com 注册开发者，创建应用获取 AppKey + AppSecret
      · 授权流程：OAuth 2.0 授权码模式，获取 access_token + refresh_token
      · Token 有效期短（需定期刷新），需实现自动续期逻辑
      · 适用角色：运营员工

    - custom — 自定义凭证（通用 Key-Value）
      · 用户自行填写名称和凭证内容
      · 适用任意第三方服务

    **API 设计：**
    - POST /api/credentials — 创建凭证
    - GET /api/credentials — 列表（返回脱敏值，如 ghp_****xxxx）
    - GET /api/credentials/:id — 详情（脱敏）
    - PUT /api/credentials/:id — 更新
    - DELETE /api/credentials/:id — 删除
    - POST /api/credentials/:id/verify — 验证凭证有效性（调平台 API 测试）

    **安全策略：**
    - 加密：AES-256-GCM + 随机 IV，密钥从环境变量 CREDENTIAL_ENCRYPTION_KEY 读取
    - API 响应永远不返回明文 Token，只返回脱敏值
    - 操作审计日志：记录谁在何时创建/使用/删除了哪个凭证
    - Agent 调用凭证时通过内部 API 获取解密值，不经过前端

### TASK-015
- Title: 凭证管理系统 — Web 前端
- Owner: builder
- Status: todo
- Repo: niuma-web
- Depends: TASK-014, TASK-006
- Priority: P1
- Description: |
    在个人页面（/profile）中添加「凭证管理」模块：

    **凭证列表：**
    - 卡片式展示，每张卡片：平台图标 + 名称 + 标签 + 脱敏值 + 过期状态
    - 过期/即将过期的凭证红色/黄色提示
    - 支持按平台/标签筛选

    **添加凭证流程：**
    - Step 1: 选择平台（GitHub / Twitter / Facebook / Instagram / 小红书 / 自定义）
    - Step 2: 显示该平台的接入引导（如何获取 Token 的简要说明 + 跳转链接）
    - Step 3: 填写凭证信息（Token/Key，标签，备注）
    - Step 4: 自动验证 → 保存

    **凭证详情：**
    - 基本信息（平台、创建时间、过期时间）
    - 权限范围展示
    - 标签管理（增删标签）
    - 使用记录（哪些员工调用过）
    - 删除按钮（二次确认）

    **UI 要求：**
    - 明文 Token 只在输入时可见，保存后不可再查看
    - 复制脱敏值按钮（方便确认是哪个 Token）
    - 各平台有对应品牌色图标

### TASK-016
- Title: 凭证管理系统 — Agent 凭证注入
- Owner: builder
- Status: todo
- Repo: niuma-server
- Depends: TASK-014, TASK-010
- Priority: P1
- Description: |
    让 AI 员工能根据角色自动获取所需凭证：

    - Agent 模板新增 requiredCredentials[] 字段，如：
      frontend-dev.json: ["github"]
      运营模板: ["twitter", "facebook", "xiaohongshu"]
    - AgentService.spawnEmployee 时，检查所需凭证是否已配置
    - 未配置时提示用户去个人页面配置
    - 已配置时，通过环境变量或 context 注入解密后的凭证
    - 凭证注入走内部 API，不经过 WebSocket 明文传输

---

## UpdatedAt: 2026-03-16
