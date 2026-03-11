---
title: 模拟盘实况
layout: page
---

<script setup>
import { onMounted, ref } from 'vue'
import * as echarts from 'echarts'
import portfolioData from '../data/portfolio.json'

const netValueChart = ref(null)
const allocationChart = ref(null)
const pnlChart = ref(null)

onMounted(() => {
  // 净值曲线
  if (netValueChart.value && portfolioData.history?.length) {
    const chart = echarts.init(netValueChart.value)
    chart.setOption({
      tooltip: { trigger: 'axis' },
      xAxis: { type: 'category', data: portfolioData.history.map(d => d.date) },
      yAxis: { type: 'value', name: '净值', min: 'dataMin' },
      series: [{
        name: '组合净值',
        type: 'line',
        data: portfolioData.history.map(d => d.nav),
        smooth: true,
        areaStyle: { opacity: 0.15 },
        lineStyle: { width: 2 },
        itemStyle: { color: '#3b82f6' }
      }, {
        name: '沪深300',
        type: 'line',
        data: portfolioData.history.map(d => d.csi300),
        smooth: true,
        lineStyle: { width: 1.5, type: 'dashed' },
        itemStyle: { color: '#94a3b8' }
      }]
    })
    window.addEventListener('resize', () => chart.resize())
  }

  // 持仓分布
  if (allocationChart.value && portfolioData.positions?.length) {
    const chart = echarts.init(allocationChart.value)
    const positions = portfolioData.positions.filter(p => p.weight > 0)
    const cashWeight = 1 - positions.reduce((s, p) => s + p.weight, 0)
    const pieData = [
      ...positions.map(p => ({ name: p.name, value: (p.weight * 100).toFixed(1) })),
      { name: '现金', value: (cashWeight * 100).toFixed(1) }
    ]
    chart.setOption({
      tooltip: { trigger: 'item', formatter: '{b}: {c}%' },
      legend: { bottom: 0, type: 'scroll' },
      series: [{
        type: 'pie',
        radius: ['40%', '70%'],
        data: pieData,
        label: { formatter: '{b}\n{c}%' }
      }]
    })
    window.addEventListener('resize', () => chart.resize())
  }

  // 每日盈亏
  if (pnlChart.value && portfolioData.history?.length) {
    const chart = echarts.init(pnlChart.value)
    const pnlData = portfolioData.history.map((d, i) => {
      if (i === 0) return 0
      const prev = portfolioData.history[i-1].nav
      return +((d.nav - prev) / prev * 100).toFixed(2)
    })
    chart.setOption({
      tooltip: { trigger: 'axis', formatter: params => `${params[0].name}<br/>日收益: ${params[0].value}%` },
      xAxis: { type: 'category', data: portfolioData.history.map(d => d.date) },
      yAxis: { type: 'value', name: '日收益%' },
      series: [{
        type: 'bar',
        data: pnlData.map(v => ({ value: v, itemStyle: { color: v >= 0 ? '#22c55e' : '#ef4444' } }))
      }]
    })
    window.addEventListener('resize', () => chart.resize())
  }
})
</script>

# 📊 模拟盘实况

> 初始资金 100万，纯模拟演练，不构成投资建议

## 账户概览

<div v-if="portfolioData.summary" class="portfolio-summary">

| 指标 | 数值 |
|------|------|
| 总资产 | {{ portfolioData.summary.totalAssets?.toLocaleString('zh-CN', {style:'currency',currency:'CNY'}) }} |
| 累计收益 | {{ portfolioData.summary.totalReturn }} |
| 本周收益 | {{ portfolioData.summary.weekReturn }} |
| 最大回撤 | {{ portfolioData.summary.maxDrawdown }} |
| 胜率 | {{ portfolioData.summary.winRate }} |
| 对比沪深300 | {{ portfolioData.summary.vsCSI300 }} |

</div>

## 净值走势

<div ref="netValueChart" class="chart-container" style="height:300px"></div>

## 持仓分布

<div ref="allocationChart" class="chart-container" style="height:300px"></div>

## 每日盈亏

<div ref="pnlChart" class="chart-container" style="height:200px"></div>

## 当前持仓

<div v-if="portfolioData.positions?.length">

| 标的 | 方向 | 仓位 | 成本 | 现价 | 盈亏% |
|------|------|------|------|------|-------|
<template v-for="p in portfolioData.positions.filter(p => p.shares > 0)">
| {{ p.name }} | {{ p.direction }} | {{ (p.weight*100).toFixed(1) }}% | {{ p.cost }} | {{ p.price }} | {{ p.pnl }} |
</template>

</div>
<div v-else>

> 当前空仓持币

</div>

## 交易记录

<div v-if="portfolioData.transactions?.length">

| 日期 | 标的 | 操作 | 数量 | 价格 | 理由 |
|------|------|------|------|------|------|
<template v-for="t in portfolioData.transactions.slice().reverse()">
| {{ t.date }} | {{ t.asset }} | {{ t.action }} | {{ t.shares }} | {{ t.price }} | {{ t.reason }} |
</template>

</div>
<div v-else>

> 暂无交易记录

</div>
