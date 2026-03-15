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

## UpdatedAt: 2026-03-15
