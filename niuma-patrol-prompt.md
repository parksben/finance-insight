# Niuma Patrol — 定时巡检任务描述

## 巡检 Prompt（用于 openclaw cron）

```
niuma 产品全栈巡检。执行以下检查：

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

## 7. 需求发现（产品视角）
主动从产品和用户体验角度发现改进机会，目标：
- **用户体验提升**：交互流程是否顺畅、有无多余步骤、反馈是否及时
- **产品体验优化**：功能完整度、边界 case 处理、新用户引导
- **视觉效果改进**：UI 一致性、间距/配色/字体层级、响应式适配
- **办公场景价值**：能否真正解决用户在办公中的痛点，有无未覆盖的高频场景
- **让用户"用得更爽"**：减少摩擦、增加愉悦感、提升效率
- **收益导向改进**：能带来用户增长、留存、口碑传播的功能点

思考方式：站在一个挑剔用户的角度去审视产品，从 APP 定位出发，结合竞品和行业趋势，寻找差异化机会。

如果发现有价值的需求点子，整理成简短的需求卡片（标题 + 一句话描述 + 预期价值 + 优先级建议），汇总后推送给 PengAn 讨论。

发现问题直接修复 + git push，改完汇总报告。仅在有实际改动或发现新问题时通知 PengAn（通过 WeCom），无事不扰。

仓库位置：
- /tmp/niuma-repos/niuma-server/
- /tmp/niuma-repos/niuma-web/
- /tmp/niuma-repos/niuma-cli/
- /tmp/niuma-desktop-dock/ (niuma-desktop)
- /tmp/niuma-repos/niuma/ (公开仓)
```

## Cron 命令（Gateway 恢复后执行）

```bash
openclaw cron rm d92003da-6e8a-4c6c-a69b-b0a08219754a
openclaw cron add --cron "0 */6 * * *" --prompt "<上述完整prompt>" --id niuma-patrol
```
