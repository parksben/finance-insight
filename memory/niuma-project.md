# 牛马（Niuma）项目记录

> PengAn 的重要项目，优先级高。

## 项目概览

- **名称：** 牛马（Niuma）
- **定位：** AI 驱动的多 Agent 协作平台 —— 让你的产品团队随时在线
- **创建日期：** 2026-03-10
- **最新版本：** v0.1.2（2026-03-15 发布）
- **License：** MIT
- **Skill：** `niuma-codebase`（读代码用）

## 仓库 & 本地路径

| 仓库 | 用途 | GitHub | 本地路径 |
|------|------|--------|---------|
| niuma | Monorepo（Flutter App + 桌面端 + README） | parksben/niuma | /root/.openclaw/projects/niuma |
| niuma-server | Express.js 后端 | parksben/niuma-server | /root/.openclaw/projects/niuma-server |
| niuma-cli | CLI 安装工具 | parksben/niuma-cli | /root/.openclaw/projects/niuma-cli |

> CI 交叉发布：niuma-cli 的 release.yml 用 Bun 编译多平台二进制 → 发布到 parksben/niuma 的 releases

## 架构

```
Flutter App (Android/iOS/Desktop)
  ↓ HTTP REST + SSE (实时消息流)
niuma-server (Express.js + SQLite)
  ├── 用户认证（邮箱 OTP + JWT）
  ├── 项目管理（CRUD + 成员管理）
  ├── Agent 管理（创建/删除/列表）
  ├── 群聊消息（发送 → 触发 Agent 回复）
  ├── 知识库文档（CRUD + Agent 自动写入）
  ├── 任务管理（看板：todo/doing/review/done/blocked）
  ├── 概览仪表盘（聚合统计）
  ├── 文件上传（multer, 50MB 限制）
  └── SSE 事件总线（message/message_chunk/message_update）
  ↓ execSync(`openclaw agent --agent <id> --message <text> --json`)
OpenClaw（Agent 运行时）
```

## 数据库表结构（SQLite）

| 表 | 主要字段 | 说明 |
|----|---------|------|
| users | id, email, created_at | 邮箱 OTP 注册，无密码 |
| agents | id, name, role_type, bio, avatar_url, system_prompt | 5 个预设 + 支持自定义创建 |
| projects | id, name, description, owner_id | 用户创建的产品项目 |
| project_members | id, project_id, agent_id, nickname, duties, level | Agent 加入项目 |
| chats | id, type(group/direct), project_id, user_id, title | 群聊或 1v1 |
| chat_agents | chat_id, agent_id | 群聊中的 Agent |
| messages | id, chat_id, sender_type, sender_id, content, thinking, status, type, file_url | 消息（支持流式） |
| otps | email, code, expires_at | 邮箱验证码 |
| knowledge_docs | id, project_id, title, content, author_type/id/name | 知识库文档 |
| tasks | id, project_id, title, description, status, priority, assigned_to, due_at | 任务看板 |

## Planner-Executor 模式（核心协作逻辑）

1. 用户发消息 → 保存到 DB → 立即返回 201
2. 异步触发 `runPlannerExecutor()`
3. 如果群里有 planner：planner 先回复 → 其 reply 作为 context 传给其他 agent → executor 并发回复
4. 如果没有 planner：agent 顺序回复
5. 30% 概率 follow-up（最多 2 轮）
6. Agent 回复通过 `openclaw agent` CLI 调用，失败则 fallback 到 mock 模板
7. 回复分 chunk 流式推送（SSE: message_chunk 事件）
8. Agent 可通过 `<!-- create_doc:{"title":"xxx"} -->` 自动写入知识库

## niuma-server API 路由

| 路由 | 说明 |
|------|------|
| POST /auth/send-otp | 发送邮箱验证码 |
| POST /auth/verify-otp | 验证码登录，自动创建用户+1v1聊天 |
| GET/POST /agents | Agent 列表/创建（含 OpenClaw 注册） |
| DELETE /agents/:id | 删除 Agent |
| GET/POST /projects | 项目列表/创建 |
| GET /projects/:id | 项目详情+成员 |
| POST /projects/:id/members | 添加 Agent 到项目 |
| GET/POST /projects/:id/docs | 知识库文档 |
| GET/POST /projects/:id/tasks | 任务管理 |
| GET/POST /chats | 聊天列表/创建群聊 |
| GET /chats/:id/messages | 消息历史（游标分页） |
| POST /chats/:id/messages | 发消息（触发 Agent 回复） |
| GET /chats/:id/stream | SSE 实时流 |
| POST /api/upload | 文件上传 |
| GET /api/overview | 仪表盘概览统计 |
| GET /api/agents/:id/tasks | 跨项目 Agent 待办任务 |

## Flutter Mobile App 结构

```
apps/mobile/lib/
├── main.dart                    # 入口
├── app.dart                     # App 根组件
├── core/
│   ├── api.dart                 # HTTP 客户端
│   ├── sse.dart                 # SSE 实时消息
│   └── storage.dart             # 本地存储
├── models/                      # 数据模型
│   ├── agent.dart, chat.dart, message.dart
│   ├── project.dart, task.dart, user.dart
│   ├── knowledge_doc.dart, overview.dart
├── providers/                   # 状态管理
│   ├── auth_provider.dart, agents_provider.dart
│   ├── chats_provider.dart, projects_provider.dart
│   ├── tasks_provider.dart, knowledge_provider.dart
│   └── overview_provider.dart
├── screens/                     # 页面
│   ├── splash_screen.dart, login_screen.dart
│   ├── main_screen.dart, server_connect_screen.dart
│   ├── chat_screen.dart, chats_list_screen.dart
│   ├── projects_screen.dart, project_detail_screen.dart
│   ├── agents_screen.dart, create_agent_screen.dart
│   ├── tasks_screen.dart, overview_screen.dart
│   ├── knowledge_base_screen.dart, doc_detail/edit_screen.dart
│   ├── language_select_screen.dart, profile_screen.dart
└── widgets/
    ├── agent_avatar.dart, agent_profile_sheet.dart
    ├── create_group_sheet.dart, message_bubble.dart
```

## niuma-cli 源码结构

```
src/
├── index.js                     # 入口（commander 注册子命令）
├── commands/
│   ├── install.js               # 5 步安装向导
│   ├── server.js                # 服务管理（start/stop/status/logs）
│   ├── agents.js                # Agent 套餐安装
│   └── config.js                # 交互式配置修改
└── lib/
    ├── config.js                # ~/.niuma/config.json 读写
    ├── openclaw.js              # Gateway 检测 + Agent API
    ├── systemd.js               # 双模式服务管理（systemd / 直接进程）
    └── systemd-install.js       # 写入 systemd service 文件
```

## Agent 套件（5 个预设角色）

| ID | 名称 | Emoji | 角色 | 职责 |
|----|------|-------|------|------|
| niuma-planner | 规划师 | 📋 | planner | PRD、任务拆解、团队协调 |
| niuma-coder | 工程师 | 💻 | coder | 全栈开发、技术方案 |
| niuma-designer | 设计师 | 🎨 | designer | UI/UX、视觉规范 |
| niuma-analyst | 分析师 | 📊 | analyst | 数据分析、市场研究 |
| niuma-writer | 文案 | ✍️ | writer | 内容创作、品牌传播 |

seed.js 中还有 5 个默认 agent（agent-planner/coder/designer/analyst/writer），用英文 prompt。

## 已知问题 & 待办

- [ ] install.sh macOS 下载 0B bug（get_file_size curl range 问题）
- [ ] iOS 版客户端开发中
- [ ] niuma-server 运行在 /root/niuma-server（生产）和 /root/.openclaw/projects/niuma-server（开发）
- [ ] 数据库在 /root/.openclaw/projects/niuma-server/data/niuma.db 和 /root/.openclaw/workspace/data/niuma.db

## 版本历史

- v0.1.0 — 2026-03-15 首发
- v0.1.1 — 2026-03-15 修复
- v0.1.2 — 2026-03-15 最新稳定版
