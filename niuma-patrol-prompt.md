# Niuma Patrol — 定时巡检任务

## 任务一：技术巡检（每 30 分钟）

### Prompt

```
niuma 技术巡检。执行以下检查：

## 1. CI/CD 状态
检查 parksben/niuma-server, niuma-desktop, niuma-cli, niuma-app 最近一次 CI 状态。失败则分析日志并尝试修复。

## 2. Server 架构审查
- API 路由设计是否 RESTful、命名一致
- 鉴权覆盖：哪些路由需要 auth 但没加
- 错误处理：有无裸 500、未处理的 promise
- DB schema：缺失索引、类型不当
- 环境变量/配置管理是否清晰

## 3. Server ↔ Web/App 对齐
- 前端调用的 API 是否在 server 都实现了
- 请求/响应字段名是否一致（驼峰 vs 下划线）
- 错误处理前后端是否对齐

## 4. CLI 流程
- install 流程有无遗留旧逻辑（不该有的 git clone、npm install）
- 命令帮助信息是否清晰
- 对小白用户的错误提示是否友好

## 5. README
- parksben/niuma README 新用户能否看懂、跟着操作
- 关键步骤是否缺失

## 6. 跨项目一致性
- 版本号是否同步
- 配置格式（config.json 字段名）是否统一
- package.json name/version 是否对齐

发现问题直接修复 + git push，改完汇总报告。仅在有实际改动或发现新问题时通知 PengAn（通过 WeCom），无事不扰。

**重要原则：** 产品处于早期研发阶段，保持功能逻辑最小化，避免冗余实现。不要加别名/兼容层/wrapper，应该统一到一个正确的实现上。

仓库位置：
- /tmp/niuma-repos/niuma-server/
- /tmp/niuma-repos/niuma-web/
- /tmp/niuma-repos/niuma-cli/
- /tmp/niuma-desktop-dock/ (niuma-desktop)
- /tmp/niuma-repos/niuma/ (公开仓)
```

### Cron 命令

```bash
openclaw cron add --cron "*/30 * * * *" --prompt "<上述技术巡检prompt>" --id niuma-tech-patrol
```

---

## 任务二：产品需求发现（每 6 小时）

### Prompt

```
niuma 产品需求发现巡检。

站在产品经理和挑剔用户的双重视角，审视 niuma 全线产品（server / web / desktop / cli / app），主动挖掘改进机会。

## 审视维度

### 用户体验
- 交互流程是否顺畅、有无多余步骤、反馈是否及时
- 新用户引导是否清晰、上手成本高不高
- 错误提示是否友好、能否帮用户自助解决

### 产品体验
- 功能完整度、边界 case 处理
- 功能之间的衔接是否自然
- 有无「差一步就完美」的半成品功能

### 视觉效果
- UI 一致性（间距/配色/字体层级/图标风格）
- 响应式适配、暗色模式
- 动效/过渡是否流畅

### 办公场景价值
- 能否真正解决用户在办公中的痛点
- 有无未覆盖的高频办公场景
- 对比竞品，哪些场景我们做得更好/更差

### 增长与收益
- 能带来用户增长、留存、口碑传播的功能点
- 降低流失的改进（减少摩擦、增加愉悦感）
- 差异化机会：结合 APP 定位，找到别人没做好的点

## 输出要求

如果发现有价值的点子，整理成需求卡片：
- **标题**：一句话概括
- **描述**：要解决什么问题、怎么做
- **预期价值**：对用户/产品/增长的意义
- **优先级建议**：P0-P3

汇总后推送给 PengAn 讨论。没有发现值得提的点就不用打扰。

仓库位置：
- /tmp/niuma-repos/niuma-server/
- /tmp/niuma-repos/niuma-web/
- /tmp/niuma-repos/niuma-cli/
- /tmp/niuma-desktop-dock/ (niuma-desktop)
- /tmp/niuma-repos/niuma/ (公开仓)
```

### Cron 命令

```bash
openclaw cron add --cron "0 */6 * * *" --prompt "<上述产品需求发现prompt>" --id niuma-product-patrol
```
