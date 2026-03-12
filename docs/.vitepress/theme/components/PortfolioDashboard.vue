<template>
  <div class="portfolio-dashboard">
    <!-- 账户概览 -->
    <div class="summary-grid">
      <div class="summary-card" v-for="item in summaryItems" :key="item.label">
        <div class="card-label">{{ item.label }}</div>
        <div class="card-value" :class="item.colorClass">{{ item.value }}</div>
      </div>
    </div>

    <!-- 净值走势 -->
    <div class="chart-section">
      <h2>净值走势</h2>
      <div ref="navChartEl" class="chart-box"></div>
    </div>

    <!-- 持仓分布 & 每日盈亏 -->
    <div class="chart-row">
      <div class="chart-section half">
        <h2>持仓分布</h2>
        <div ref="pieChartEl" class="chart-box"></div>
      </div>
      <div class="chart-section half">
        <h2>每日盈亏</h2>
        <div ref="pnlChartEl" class="chart-box"></div>
      </div>
    </div>

    <!-- 当前持仓 -->
    <div class="table-section">
      <h2>当前持仓</h2>
      <div v-if="positions.length" class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>标的</th><th>方向</th><th>仓位</th>
              <th>成本价</th><th>现价</th><th>盈亏</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="p in positions" :key="p.name">
              <td>{{ p.name }}</td>
              <td>{{ p.direction }}</td>
              <td>{{ (p.weight * 100).toFixed(1) }}%</td>
              <td>{{ p.cost }}</td>
              <td>{{ p.price }}</td>
              <td :class="pnlClass(p.pnl)">{{ p.pnl }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <p v-else class="empty-hint">当前空仓持币</p>
    </div>

    <!-- 交易记录 -->
    <div class="table-section">
      <h2>交易记录</h2>
      <div v-if="transactions.length" class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>日期</th><th>标的</th><th>操作</th>
              <th>数量</th><th>价格</th><th>理由</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="t in [...transactions].reverse()" :key="t.date + t.asset">
              <td>{{ t.date }}</td>
              <td>{{ t.asset }}</td>
              <td :class="t.action === '买入' ? 'text-green' : 'text-red'">{{ t.action }}</td>
              <td>{{ t.shares }}</td>
              <td>{{ t.price }}</td>
              <td class="reason-cell">{{ t.reason }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <p v-else class="empty-hint">暂无交易记录</p>
    </div>

    <p class="update-hint">数据每日 21:20 由 Arbiter Agent 自动更新 · 最后更新：{{ summary.updatedAt }}</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'

// 直接 import JSON（VitePress 支持）
import data from '@data/portfolio.json'

const summary = data.summary || {}
const positions = data.positions || []
const transactions = data.transactions || []
const history = data.history || []

const navChartEl = ref(null)
const pieChartEl = ref(null)
const pnlChartEl = ref(null)
const charts = []

const summaryItems = computed(() => [
  { label: '总资产', value: summary.totalAssets ? '¥' + Number(summary.totalAssets).toLocaleString() : '--' },
  { label: '累计收益', value: summary.totalReturn || '--', colorClass: colorClass(summary.totalReturn) },
  { label: '本周收益', value: summary.weekReturn || '--', colorClass: colorClass(summary.weekReturn) },
  { label: '最大回撤', value: summary.maxDrawdown || '--', colorClass: 'text-red' },
  { label: '胜率', value: summary.winRate || '--' },
  { label: 'vs 沪深300', value: summary.vsCSI300 || '--', colorClass: colorClass(summary.vsCSI300) },
])

function colorClass(val) {
  if (val === null || val === undefined || val === '' || val === '--' || val === 'N/A') return ''
  const s = String(val)
  return s.startsWith('-') ? 'text-red' : 'text-green'
}
function pnlClass(val) {
  if (val === null || val === undefined || val === '') return ''
  const s = String(val)
  return s.startsWith('-') ? 'text-red' : 'text-green'
}

onMounted(async () => {
  const echarts = await import('echarts')

  // 净值曲线
  if (navChartEl.value && history.length) {
    const c = echarts.init(navChartEl.value)
    charts.push(c)
    c.setOption({
      tooltip: { trigger: 'axis' },
      legend: { data: ['组合净值', '沪深300'], bottom: 0 },
      grid: { left: 50, right: 20, top: 20, bottom: 40 },
      xAxis: { type: 'category', data: history.map(d => d.date), axisLabel: { fontSize: 11 } },
      yAxis: { type: 'value', min: v => (v.min * 0.998).toFixed(4), axisLabel: { fontSize: 11 } },
      series: [
        {
          name: '组合净值', type: 'line', smooth: true,
          data: history.map(d => d.nav),
          areaStyle: { opacity: 0.1 },
          lineStyle: { width: 2 }, itemStyle: { color: '#3b82f6' }
        },
        {
          name: '沪深300', type: 'line', smooth: true,
          data: history.map(d => d.csi300),
          lineStyle: { width: 1.5, type: 'dashed' }, itemStyle: { color: '#94a3b8' }
        }
      ]
    })
  }

  // 持仓饼图
  if (pieChartEl.value) {
    const c = echarts.init(pieChartEl.value)
    charts.push(c)
    const used = positions.filter(p => p.weight > 0).reduce((s, p) => s + p.weight, 0)
    const pieData = [
      ...positions.filter(p => p.weight > 0).map(p => ({ name: p.name, value: +(p.weight * 100).toFixed(1) })),
      { name: '现金', value: +((1 - used) * 100).toFixed(1) }
    ]
    c.setOption({
      tooltip: { trigger: 'item', formatter: '{b}: {c}%' },
      legend: { bottom: 0, type: 'scroll', textStyle: { fontSize: 11 } },
      series: [{
        type: 'pie', radius: ['38%', '65%'],
        data: pieData,
        label: { fontSize: 11, formatter: '{b}\n{c}%' }
      }]
    })
  }

  // 每日盈亏柱图
  if (pnlChartEl.value && history.length > 1) {
    const c = echarts.init(pnlChartEl.value)
    charts.push(c)
    const pnlData = history.map((d, i) => {
      if (i === 0) return 0
      return +((d.nav - history[i - 1].nav) / history[i - 1].nav * 100).toFixed(2)
    })
    c.setOption({
      tooltip: { trigger: 'axis', formatter: p => `${p[0].name}<br/>日收益: ${p[0].value}%` },
      grid: { left: 50, right: 20, top: 10, bottom: 40 },
      xAxis: { type: 'category', data: history.map(d => d.date), axisLabel: { fontSize: 10 } },
      yAxis: { type: 'value', axisLabel: { fontSize: 10, formatter: v => v + '%' } },
      series: [{
        type: 'bar',
        data: pnlData.map(v => ({ value: v, itemStyle: { color: v >= 0 ? '#22c55e' : '#ef4444' } }))
      }]
    })
  }

  const resize = () => charts.forEach(c => c.resize())
  window.addEventListener('resize', resize)
  onBeforeUnmount(() => window.removeEventListener('resize', resize))
})
</script>

<style scoped>
.portfolio-dashboard {
  max-width: 900px;
  margin: 0 auto;
  padding: 0 0 48px;
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  margin-bottom: 32px;
}

@media (max-width: 640px) {
  .summary-grid { grid-template-columns: repeat(2, 1fr); }
}

.summary-card {
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  padding: 14px 16px;
  text-align: center;
}
.card-label {
  font-size: 12px;
  color: var(--vp-c-text-2);
  margin-bottom: 6px;
}
.card-value {
  font-size: 18px;
  font-weight: 600;
}

.chart-section { margin-bottom: 32px; }
.chart-section h2 {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 12px;
  border-bottom: 1px solid var(--vp-c-divider);
  padding-bottom: 6px;
}
.chart-box {
  width: 100%;
  height: 260px;
}

.chart-row {
  display: flex;
  gap: 20px;
  margin-bottom: 32px;
}
.chart-row .half { flex: 1; min-width: 0; margin-bottom: 0; }

@media (max-width: 640px) {
  .chart-row { flex-direction: column; }
}

.table-section { margin-bottom: 32px; }
.table-section h2 {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 12px;
  border-bottom: 1px solid var(--vp-c-divider);
  padding-bottom: 6px;
}
.table-wrap { overflow-x: auto; }
.table-wrap table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}
.table-wrap th, .table-wrap td {
  padding: 8px 12px;
  text-align: left;
  border-bottom: 1px solid var(--vp-c-divider);
  white-space: nowrap;
}
.table-wrap th { font-weight: 600; color: var(--vp-c-text-2); }
.reason-cell { white-space: normal; max-width: 200px; }

.empty-hint {
  color: var(--vp-c-text-2);
  font-size: 14px;
  padding: 16px 0;
}

.text-green { color: #22c55e; }
.text-red { color: #ef4444; }

.update-hint {
  font-size: 12px;
  color: var(--vp-c-text-3);
  text-align: center;
  margin-top: 24px;
}
</style>
