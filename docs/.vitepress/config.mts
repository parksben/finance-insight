import { defineConfig } from 'vitepress'
import { readdirSync, existsSync } from 'fs'
import { join } from 'path'

// 自动生成每日报告侧边栏
function getDailySidebar() {
  const dailyDir = join(__dirname, '../daily')
  if (!existsSync(dailyDir)) return []

  const dates = readdirSync(dailyDir)
    .filter(f => f.match(/^\d{8}$/))
    .sort()
    .reverse() // 最新日期在前

  return dates.map(date => {
    const yyyy = date.slice(0, 4)
    const mm = date.slice(4, 6)
    const dd = date.slice(6, 8)
    const label = `${yyyy}-${mm}-${dd}`

    const dayDir = join(dailyDir, date)
    const files = existsSync(dayDir)
      ? readdirSync(dayDir).filter(f => f.endsWith('.md'))
      : []

    const pageOrder = ['index', 'research', 'strategist', 'riskguard', 'challenger', 'arbiter']

    const items = files
      .sort((a, b) => {
        const ai = pageOrder.indexOf(a.replace('.md', ''))
        const bi = pageOrder.indexOf(b.replace('.md', ''))
        return (ai === -1 ? 99 : ai) - (bi === -1 ? 99 : bi)
      })
      .map(f => {
        const name = f.replace('.md', '')
        const titleMap = {
          index: '📋 日报概要',
          research: '🔍 Researcher 情报',
          strategist: '📈 Strategist 信号',
          riskguard: '🛡️ RiskGuard 风控',
          challenger: '🔴 Challenger 反驳',
          arbiter: '⚖️ Arbiter 裁决',
        }
        return {
          text: titleMap[name] || name,
          link: `/daily/${date}/${name}`,
        }
      })

    return {
      text: label,
      collapsed: dates.indexOf(date) > 0, // 只展开最新一天
      items,
    }
  })
}

export default defineConfig({
  base: '/',
  title: '澜投研',
  description: '每日投资分析报告 · 多 Agent 协作框架',
  lang: 'zh-CN',

  head: [
    ['meta', { name: 'theme-color', content: '#1a1a2e' }],
  ],

  themeConfig: {
    logo: '🌊',
    siteTitle: '澜投研',

    nav: [
      { text: '首页', link: '/' },
      { text: '每日报告', link: '/daily/' },
    ],

    sidebar: {
      '/daily/': getDailySidebar(),
    },

    search: {
      provider: 'local',
    },

    outline: {
      label: '本页目录',
      level: [2, 3],
    },

    docFooter: {
      prev: '上一篇',
      next: '下一篇',
    },

    darkModeSwitchLabel: '主题',
    lightModeSwitchTitle: '切换到浅色模式',
    darkModeSwitchTitle: '切换到深色模式',
    sidebarMenuLabel: '菜单',
    returnToTopLabel: '回到顶部',

    footer: {
      message: '澜投研 · 仅供参考，不构成投资建议',
    },
  },

  markdown: {
    theme: {
      light: 'github-light',
      dark: 'github-dark',
    },
    lineNumbers: false,
  },
})
