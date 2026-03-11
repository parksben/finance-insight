#!/bin/bash
# publish-finance-report.sh
# 将 finance-insight 项目的每日报告发布到 GitHub Pages 仓库
# Usage: publish-finance-report.sh <date YYYYMMDD>
# Example: publish-finance-report.sh 20260310
#
# 发布后轮询 GitHub Actions 构建状态，完成后输出 PAGE_URL=...

set -e

DATE="${1:-$(date +%Y%m%d)}"
DATE_FMT="${DATE:0:4}-${DATE:4:2}-${DATE:6:2}"
FINANCE_PROJECT="/root/.openclaw/workspace/projects/finance-insight"
KNOWLEDGE_DIR="$FINANCE_PROJECT/knowledge"
TRADING_DIR="$FINANCE_PROJECT/trading"
REPORTS_DIR="$FINANCE_PROJECT/reports"
REPO="parksben/finance-insight"
PAGES_BASE="https://parksben.github.io/finance-insight"
SITE_REPO_DIR="/tmp/finance-site-publish"

echo "📦 开始发布 $DATE_FMT 报告..."

# 克隆或更新仓库
if [ -d "$SITE_REPO_DIR/.git" ]; then
  cd "$SITE_REPO_DIR"
  git config user.name "finance-bot" 2>/dev/null || true
  git config user.email "finance-bot@openclaw" 2>/dev/null || true
  git pull origin main --rebase 2>&1 | tail -2
else
  git clone "https://github.com/$REPO.git" "$SITE_REPO_DIR"
  cd "$SITE_REPO_DIR"
  git config user.name "finance-bot"
  git config user.email "finance-bot@openclaw"
fi

DAILY_DIR="docs/daily/$DATE"
mkdir -p "$DAILY_DIR"

# 角色文件映射：目标名 -> 搜索目录列表
declare -A ROLE_DIRS=(
  ["research"]="$KNOWLEDGE_DIR"
  ["strategist"]="$KNOWLEDGE_DIR"
  ["riskguard"]="$TRADING_DIR"
  ["challenger"]="$KNOWLEDGE_DIR"
  ["arbiter"]="$KNOWLEDGE_DIR"
  ["learn"]="$KNOWLEDGE_DIR"
)

find_report() {
  local role="$1"
  local dir="${ROLE_DIRS[$role]:-$KNOWLEDGE_DIR}"
  # 尝试 YYYYMMDD 格式
  local f=$(find "$dir" -maxdepth 1 \( -name "*${DATE}*${role}*" -o -name "*${role}*${DATE}*" \) 2>/dev/null | head -1)
  # 尝试 YYYY-MM-DD 格式
  [ -z "$f" ] && f=$(find "$dir" -maxdepth 1 \( -name "*${DATE_FMT}*${role}*" -o -name "*${role}*${DATE_FMT}*" \) 2>/dev/null | head -1)
  echo "$f"
}

PUBLISHED=0
PUBLISHED_ROLES=()

for role in research strategist riskguard challenger arbiter learn; do
  src=$(find_report "$role")
  if [ -n "$src" ] && [ -f "$src" ]; then
    cp "$src" "$DAILY_DIR/${role}.md"
    echo "  ✅ $role → $DAILY_DIR/${role}.md"
    PUBLISHED=$((PUBLISHED + 1))
    PUBLISHED_ROLES+=("$role")
  fi
done

# 周报/月报也发布
for f in "$REPORTS_DIR"/weekly-${DATE}.md "$REPORTS_DIR"/monthly-${DATE:0:6}.md; do
  [ -f "$f" ] && cp "$f" "$DAILY_DIR/$(basename $f)" && echo "  ✅ report → $(basename $f)" && PUBLISHED=$((PUBLISHED + 1))
done

if [ $PUBLISHED -eq 0 ]; then
  echo "❌ 没有找到任何报告文件，退出"
  exit 1
fi

# 生成 index.md
cat > "$DAILY_DIR/index.md" << MDEOF
# $DATE_FMT 日报

> 由澜投研多 Agent 框架自动生成 · $(date '+%Y-%m-%d %H:%M %Z')

## 今日报告

MDEOF

declare -A TITLE_MAP=(
  ["research"]="🔍 Researcher 情报简报"
  ["strategist"]="📈 Strategist 投资信号"
  ["riskguard"]="🛡️ RiskGuard 风险评估"
  ["challenger"]="🔴 Challenger 质疑意见"
  ["arbiter"]="⚖️ Arbiter 最终裁决"
  ["learn"]="📚 今日学习摘要"
)

for role in research strategist riskguard challenger arbiter learn; do
  if [ -f "$DAILY_DIR/${role}.md" ]; then
    echo "- [${TITLE_MAP[$role]:-$role}](./${role})" >> "$DAILY_DIR/index.md"
  fi
done

echo "" >> "$DAILY_DIR/index.md"
echo "---" >> "$DAILY_DIR/index.md"
echo "" >> "$DAILY_DIR/index.md"
echo "> 免责声明：本站内容仅供参考，不构成任何投资建议。" >> "$DAILY_DIR/index.md"

echo "  ✅ index.md 生成完成（$PUBLISHED 个报告）"

# Commit & push
git add -A
if git diff --cached --quiet; then
  echo "⚠️  没有新内容需要提交"
  echo "PAGE_URL=${PAGES_BASE}/daily/${DATE}/"
  exit 0
fi

git commit -m "report: $DATE_FMT 日报 (${PUBLISHED_ROLES[*]})"
git push origin main

echo "🚀 已推送到 GitHub，等待 Actions 构建..."

# 轮询 Actions 状态（最多等 5 分钟）
MAX_WAIT=300
ELAPSED=0
INTERVAL=15

BUILD_OK=0
while [ $ELAPSED -lt $MAX_WAIT ]; do
  sleep $INTERVAL
  ELAPSED=$((ELAPSED + INTERVAL))

  STATUS=$(gh run list --repo "$REPO" --limit 1 --json status,conclusion 2>/dev/null \
    | python3 -c "import sys,json; runs=json.load(sys.stdin); print(runs[0]['status']+'|'+str(runs[0]['conclusion'])) if runs else print('unknown|null')" 2>/dev/null || echo "unknown|null")

  RUN_STATUS="${STATUS%%|*}"
  RUN_CONCLUSION="${STATUS##*|}"

  echo "  ⏳ [${ELAPSED}s] Actions: $RUN_STATUS / $RUN_CONCLUSION"

  if [ "$RUN_STATUS" = "completed" ]; then
    if [ "$RUN_CONCLUSION" = "success" ]; then
      BUILD_OK=1
      break
    else
      echo "❌ 构建失败: $RUN_CONCLUSION"
      exit 2
    fi
  fi
done

# 构建成功后清理本地已发布的报告文件
if [ $BUILD_OK -eq 1 ]; then
  echo ""
  echo "🧹 清理本地已发布文件..."
  for role in research strategist riskguard challenger arbiter learn; do
    src=$(find_report "$role")
    if [ -n "$src" ] && [ -f "$src" ]; then
      rm -f "$src"
      echo "  🗑️  已删除: $src"
    fi
  done
  # 清理周报/月报
  for f in "$REPORTS_DIR"/weekly-${DATE}.md "$REPORTS_DIR"/monthly-${DATE:0:6}.md; do
    if [ -f "$f" ]; then
      rm -f "$f"
      echo "  🗑️  已删除: $f"
    fi
  done
  # 清理 /tmp 中的发布缓存目录（避免长期占用磁盘）
  rm -rf "$SITE_REPO_DIR"
  echo "  🗑️  已清理发布缓存: $SITE_REPO_DIR"

  echo ""
  echo "✅ 构建成功，本地文件已清理！"
  echo "PAGE_URL=${PAGES_BASE}/daily/${DATE}/"
  exit 0
fi

echo "⏰ 超时（${MAX_WAIT}s），构建可能仍在进行中（本地文件保留）"
echo "PAGE_URL=${PAGES_BASE}/daily/${DATE}/"
exit 0
