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
openclaw cron add --cron "*/30 * * * *" --prompt "<上述完整prompt>" --id niuma-patrol
```
