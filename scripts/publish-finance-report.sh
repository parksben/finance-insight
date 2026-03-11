#!/bin/bash
# publish-finance-report.sh
# 将 finance-insight 项目的每日报告发布到 GitHub Pages 仓库
# Usage: publish-finance-report.sh <date YYYYMMDD>
# Example: publish-finance-report.sh 20260310
#
# 发布后轮询 GitHub Actions 构建状态；失败时自动诊断并重试一次

set -e

DATE="${1:-$(date +%Y%m%d)}"
DATE_FMT="${DATE:0:4}-${DATE:4:2}-${DATE:6:2}"
FINANCE_PROJECT="/root/.openclaw/workspace/projects/finance-insight"
KNOWLEDGE_DIR="$FINANCE_PROJECT/knowledge"
TRADING_DIR="$FINANCE_PROJECT/trading"
REPORTS_DIR="$FINANCE_PROJECT/reports"
REPO="parksben/finance-insight"
PAGES_BASE="https://fin.parksben.xyz"
SITE_REPO_DIR="/tmp/finance-site-publish"

# ── 工具函数 ──────────────────────────────────────────────

setup_repo() {
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
}

find_report() {
  local role="$1"
  declare -A ROLE_DIRS=(
    ["research"]="$KNOWLEDGE_DIR"
    ["strategist"]="$KNOWLEDGE_DIR"
    ["riskguard"]="$TRADING_DIR"
    ["challenger"]="$KNOWLEDGE_DIR"
    ["arbiter"]="$KNOWLEDGE_DIR"
    ["learn"]="$KNOWLEDGE_DIR"
  )
  local dir="${ROLE_DIRS[$role]:-$KNOWLEDGE_DIR}"
  local f=$(find "$dir" -maxdepth 1 \( -name "*${DATE}*${role}*" -o -name "*${role}*${DATE}*" \) 2>/dev/null | head -1)
  [ -z "$f" ] && f=$(find "$dir" -maxdepth 1 \( -name "*${DATE_FMT}*${role}*" -o -name "*${role}*${DATE_FMT}*" \) 2>/dev/null | head -1)
  echo "$f"
}

poll_actions() {
  # 轮询最新 run 状态，最多等 $1 秒，返回 run_id 到 stdout，exit 0=成功 1=失败 2=超时
  local max_wait="${1:-300}"
  local interval=15
  local elapsed=0
  local run_id=""

  while [ $elapsed -lt $max_wait ]; do
    sleep $interval
    elapsed=$((elapsed + interval))

    local info
    info=$(gh run list --repo "$REPO" --limit 1 --json databaseId,status,conclusion 2>/dev/null \
      | python3 -c "import sys,json; r=json.load(sys.stdin)[0]; print(str(r['databaseId'])+'|'+r['status']+'|'+str(r['conclusion']))" 2>/dev/null || echo "0|unknown|null")

    run_id="${info%%|*}"
    local rest="${info#*|}"
    local status="${rest%%|*}"
    local conclusion="${rest##*|}"

    echo "  ⏳ [${elapsed}s] Actions: $status / $conclusion (run $run_id)" >&2

    if [ "$status" = "completed" ]; then
      echo "$run_id"
      [ "$conclusion" = "success" ] && return 0 || return 1
    fi
  done

  echo "$run_id"
  return 2
}

diagnose_and_fix() {
  local run_id="$1"
  echo ""
  echo "🔍 构建失败，正在拉取日志诊断..."

  local log
  log=$(gh run view "$run_id" --repo "$REPO" --log-failed 2>&1 | tail -50)
  echo "$log"

  # 诊断常见问题并自动修复
  cd "$SITE_REPO_DIR"

  local fixed=0

  # 问题1: package-lock.json 缺失
  if echo "$log" | grep -q "Dependencies lock file is not found"; then
    echo "🔧 修复：生成 package-lock.json..."
    npm install --package-lock-only 2>&1 | tail -3
    git add package-lock.json
    fixed=1
  fi

  # 问题2: node_modules 缓存导致版本冲突
  if echo "$log" | grep -q "ERESOLVE\|peer dep\|version.*not supported"; then
    echo "🔧 修复：重新锁定依赖版本..."
    rm -f package-lock.json
    npm install --package-lock-only 2>&1 | tail -3
    git add package-lock.json
    fixed=1
  fi

  # 问题3: Markdown 语法错误（vitepress build 报 error）
  if echo "$log" | grep -qE "error.*\.md|SyntaxError.*\.md|failed to parse"; then
    local bad_file
    bad_file=$(echo "$log" | grep -oE "docs/[^ ]+\.md" | head -1)
    if [ -n "$bad_file" ] && [ -f "$bad_file" ]; then
      echo "🔧 修复：清理 $bad_file 中的非法字符..."
      # 移除可能导致 VitePress 解析错误的原始 HTML 标签
      sed -i 's/<[^>]*>//g' "$bad_file" 2>/dev/null || true
      git add "$bad_file"
      fixed=1
    fi
  fi

  # 问题4: config.mts 编译错误
  if echo "$log" | grep -qE "config.*error|Cannot find module|SyntaxError.*config"; then
    echo "🔧 修复：重置 VitePress 配置..."
    # 从 workspace 备份恢复（如果有）
    local backup="/root/.openclaw/workspace/finance-site-config.mts.bak"
    [ -f "$backup" ] && cp "$backup" docs/.vitepress/config.mts && git add docs/.vitepress/config.mts && fixed=1
  fi

  if [ $fixed -eq 1 ]; then
    if ! git diff --cached --quiet; then
      git commit -m "fix: auto-fix build error (run $run_id)"
      git push origin main
      echo "🔧 修复已推送，等待重新构建..."
      return 0
    fi
  fi

  echo "⚠️  未能自动修复，需要人工介入"
  echo "查看完整日志：gh run view $run_id --repo $REPO --log-failed"
  return 1
}

cleanup_local() {
  echo ""
  echo "🧹 清理本地已发布文件..."
  for role in research strategist riskguard challenger arbiter learn; do
    local src
    src=$(find_report "$role")
    if [ -n "$src" ] && [ -f "$src" ]; then
      rm -f "$src"
      echo "  🗑️  已删除: $src"
    fi
  done
  for f in "$REPORTS_DIR"/weekly-${DATE}.md "$REPORTS_DIR"/monthly-${DATE:0:6}.md; do
    [ -f "$f" ] && rm -f "$f" && echo "  🗑️  已删除: $f"
  done
  rm -rf "$SITE_REPO_DIR"
  echo "  🗑️  已清理发布缓存: $SITE_REPO_DIR"
}

# ── 主流程 ────────────────────────────────────────────────

echo "📦 开始发布 $DATE_FMT 报告..."

setup_repo
cd "$SITE_REPO_DIR"

DAILY_DIR="docs/daily/$DATE"
mkdir -p "$DAILY_DIR"

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
  [ -f "$DAILY_DIR/${role}.md" ] && echo "- [${TITLE_MAP[$role]:-$role}](./${role})" >> "$DAILY_DIR/index.md"
done

cat >> "$DAILY_DIR/index.md" << 'EOF'

---

> 免责声明：本站内容仅供参考，不构成任何投资建议。
EOF

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

# ── 第一次构建 ────────────────────────────────────────────
run_id=$(poll_actions 300)
poll_exit=$?

if [ $poll_exit -eq 0 ]; then
  # 构建成功
  cleanup_local
  echo "✅ 构建成功，本地文件已清理！"
  echo "PAGE_URL=${PAGES_BASE}/daily/${DATE}/"
  exit 0
fi

if [ $poll_exit -eq 2 ]; then
  echo "⏰ 超时（300s），构建仍在进行，本地文件保留"
  echo "PAGE_URL=${PAGES_BASE}/daily/${DATE}/"
  exit 0
fi

# ── 构建失败：诊断 + 自动修复 + 重试一次 ─────────────────
if diagnose_and_fix "$run_id"; then
  echo "🔄 等待修复后重新构建..."
  run_id2=$(poll_actions 300)
  retry_exit=$?

  if [ $retry_exit -eq 0 ]; then
    cleanup_local
    echo "✅ 修复后构建成功，本地文件已清理！"
    echo "PAGE_URL=${PAGES_BASE}/daily/${DATE}/"
    exit 0
  else
    echo "❌ 重试构建仍然失败（run $run_id2），本地文件保留，请人工排查"
    echo "gh run view $run_id2 --repo $REPO --log-failed"
    exit 2
  fi
else
  echo "❌ 无法自动修复，本地文件保留，请人工排查"
  echo "gh run view $run_id --repo $REPO --log-failed"
  exit 2
fi
