# SKILL.md — finance-insight

## 用途
澜投研投资分析技能。适用于：信息采集、方法论提炼、模拟交易决策、投资复盘、市场播报。

## 知识库路径
- 方法论模型：`/root/.openclaw/workspace/projects/finance-insight/knowledge/methodology.md`
- 每日学习记录：`/root/.openclaw/workspace/projects/finance-insight/knowledge/daily-YYYYMMDD.md`
- 持仓快照：`/root/.openclaw/workspace/projects/finance-insight/trading/portfolio.md`
- 交易流水：`/root/.openclaw/workspace/projects/finance-insight/trading/transactions.md`
- 复盘日志：`/root/.openclaw/workspace/projects/finance-insight/trading/review.md`
- 周报归档：`/root/.openclaw/workspace/projects/finance-insight/reports/`

## 信息源（按优先级）
参见 `references/sources.md`

## 标准工作流

### A. 每日信息采集 & 方法论提炼
1. 从信息源列表抓取当日内容（web_search + web_fetch）
2. 提炼方法论要点，分类归入 methodology.md 对应章节
3. 保存当日摘要为 `knowledge/daily-YYYYMMDD.md`
4. 如有重大方法论更新，在群里简短播报

### B. 市场事件 → 投资判断
1. 搜索当日重大事件（政策/数据/行业动态）
2. 对照 methodology.md 中的框架逐项分析
3. 输出：事件摘要 + 影响评估 + 建议操作方向 + 置信度
4. 置信度低于60%时，注明"观望，待验证"

### C. 模拟交易决策
1. 读取 portfolio.md 确认当前仓位和可用现金
2. 基于方法论给出明确的建仓/平仓/加仓/减仓信号
3. 每笔交易必须包含：标的、方向、价格、数量、逻辑摘要
4. 写入 transactions.md，更新 portfolio.md
5. 仓位管理：单标的不超过20%，总仓位不超过80%

### D. 复盘 & 方法论迭代
1. 平仓后必须写复盘，追加到 review.md
2. 每月统计胜率、盈亏比、最大回撤
3. 发现系统性偏差时，更新 methodology.md 并标注版本

## 输出格式规范
- 市场播报：以 `🌊 今日市场播报` 开头，简洁有据
- 交易信号：以 `📌 模拟建仓/平仓` 开头，含完整逻辑
- 周报：以 `📊 澜投研周报` 开头，结构化输出
- 方法论更新：以 `🧠 方法论更新` 开头，注明版本日期
