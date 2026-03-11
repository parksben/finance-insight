import DefaultTheme from 'vitepress/theme'
import PortfolioDashboard from './components/PortfolioDashboard.vue'
import './custom.css'

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('PortfolioDashboard', PortfolioDashboard)
  }
}
