#!/bin/bash
# AIClient2API 免费模型可用性监控（按 provider 路径精确测试）
API_BASE="http://127.0.0.1:3001"
API_KEY="sk-19763297d0b71b0bf88dd0e42dcefe41"
TIMEOUT=20
STATUS_FILE="/tmp/ac2api-health-status.json"

declare -A PROVIDERS
PROVIDERS["ac2api-qwen/qwen3-coder-plus"]="openai-qwen-oauth/v1|qwen3-coder-plus"
PROVIDERS["ac2api-qwen/qwen3-coder-flash"]="openai-qwen-oauth/v1|qwen3-coder-flash"
PROVIDERS["ac2api-gemini/gemini-2.5-flash"]="gemini-antigravity/v1|gemini-2.5-flash"
PROVIDERS["ac2api-gemini/gemini-2.5-pro"]="gemini-cli-oauth/v1|gemini-2.5-pro"

available=()
failed=()

for name in "${!PROVIDERS[@]}"; do
  IFS='|' read -r path model <<< "${PROVIDERS[$name]}"
  response=$(curl -s --max-time $TIMEOUT -w "\n%{http_code}" \
    "$API_BASE/$path/chat/completions" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}],\"max_tokens\":5}" 2>&1)
  
  http_code=$(echo "$response" | tail -1)
  body=$(echo "$response" | sed '$d')
  
  if echo "$body" | grep -q '"choices"'; then
    available+=("$name")
  else
    err=$(echo "$body" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('error',{}).get('message','?')[:60])" 2>/dev/null || echo "timeout/error")
    failed+=("$name ($err)")
  fi
done

timestamp=$(date '+%Y-%m-%d %H:%M:%S')
available_count=${#available[@]}
failed_count=${#failed[@]}
total=${#PROVIDERS[@]}

cat > "$STATUS_FILE" << EOF
{
  "timestamp": "$timestamp",
  "total": $total,
  "available": $available_count,
  "failed": $failed_count
}
EOF

echo "[$timestamp] Available: $available_count/$total | Failed: $failed_count"
for m in "${available[@]}"; do echo "  ✅ $m"; done
for m in "${failed[@]}"; do echo "  ❌ $m"; done

if [ $available_count -eq 0 ]; then
  echo ""
  echo "🚨 ALERT: ALL free models are DOWN!"
  echo "NOTIFY_PENGAN=true"
elif [ $failed_count -gt 0 ]; then
  echo ""
  echo "⚠️ WARNING: $failed_count/$total unavailable, $available_count still working."
  echo "NOTIFY_PENGAN=false"
else
  echo ""
  echo "✅ All $total free models healthy."
  echo "NOTIFY_PENGAN=false"
fi
