# 澜投研多 Agent 协作框架

## 设计理念
用「投资委员会」机制替代单一视角——多角色分工、对抗性验证、裁决者综合拍板。
目标：收益最大化 + 系统性风险控制 + 方法论持续优化。

## Agent 角色定义

### 🔍 Researcher（研究员）
- **职责：** 信息采集、行业调研、宏观数据、博主方法论提炼
- **偏向：** 客观中立，只呈现事实，不做判断
- **输出格式：** `[Researcher] 今日情报简报`

### 📈 Strategist（策略师）
- **职责：** 基于 Researcher 情报生成投资信号，提出建仓/平仓/加减仓方案
- **偏向：** 进攻型，追求 alpha，敢于押注
- **输出格式：** `[Strategist] 投资信号 #N`

### 🛡️ RiskGuard（风控官）
- **职责：** 审查策略师方案，评估风险敞口，设计止损/仓位上限/压力测试
- **偏向：** 保守型，以避免大亏为第一优先
- **输出格式：** `[RiskGuard] 风险评估`

### 🔴 Challenger（质疑者）
- **职责：** 专门寻找策略师逻辑漏洞，提出反向论据，防止群体迷思
- **偏向：** 反向思维，假设"如果我们错了，错在哪里"
- **输出格式：** `[Challenger] 反驳意见`

### ⚖️ Arbiter（裁决者/小小澜本体）
- **职责：** 综合所有角色意见，给出最终决策，记录分歧点
- **偏向：** 综合型，以长期期望值最大化为目标
- **输出格式：** `[Arbiter] 最终裁决`

---

## 标准协作流程

### 场景 A：每日投资决策（晚间播报触发）
```
Researcher → Strategist → [RiskGuard + Challenger 并行] → Arbiter
```
1. **Researcher** 产出今日情报简报（事件+数据，不含观点）
2. **Strategist** 基于情报给出信号（标的+方向+逻辑）
3. **RiskGuard** 和 **Challenger** 并行审查（各自独立，不看对方意见）
4. **Arbiter** 综合裁决，记录分歧，给出最终操作建议

### 场景 B：重大事件快速响应
```
Researcher → [Strategist + RiskGuard 并行] → Arbiter（快速通道）
```
省略 Challenger，追求响应速度，但裁决者需标注"快速通道，未经质疑验证"

### 场景 C：周报 & 方法论迭代
```
所有角色各自复盘 → Arbiter 综合 → 更新 methodology.md
```

---

## 分歧记录机制
- 每次 Strategist vs Challenger 存在实质分歧时，记录到 `trading/disputes.md`
- 事后验证：哪一方更接近实际结果？胜率统计反哺方法论

## 性能优化原则
- Researcher + Strategist + RiskGuard + Challenger：可并行执行（subagent）
- Arbiter 必须串行（依赖所有输入）
- 轻量决策（加减仓<5%）：仅 Strategist + RiskGuard，跳过 Challenger
- 重大决策（新建仓/清仓）：全流程强制走完
