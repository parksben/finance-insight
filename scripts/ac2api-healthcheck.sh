#!/bin/bash
# AIClient2API 免费模型可用性监控
# 每10分钟运行一次，检测所有免费模型是否可用
# 全部不可用时通知 PengAn

API_BASE="http://127.0.0.1:3001/v1"
API_KEY="sk-19763297d0b71b0bf88dd0e42dcefe41"
TIMEOUT=30
MODELS=("gemini-2.5-pro" "gemini-2.5-flash" "gemini-3.1-pro-preview" "gemini-2.5-flash-lite" "gemini-3-pro-preview" "gemini-3-flash-preview")
STATUS_FILE="/tmp/ac2api-health-status.json"

available=()
failed=()

for model in "${MODELS[@]}"; do
  response=$(curl -s --max-time $TIMEOUT -w "\n%{http_code}" \
    "$API_BASE/chat/completions" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}],\"max_tokens\":5}" 2>&1)
  
  http_code=$(echo "$response" | tail -1)
  body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "200" ]; then
    available+=("$model")
  else
    failed+=("$model (HTTP $http_code)")
  fi
done

timestamp=$(date '+%Y-%m-%d %H:%M:%S')
available_count=${#available[@]}
failed_count=${#failed[@]}
total=${#MODELS[@]}

# Write status file
cat > "$STATUS_FILE" << EOF
{
  "timestamp": "$timestamp",
  "total": $total,
  "available": $available_count,
  "failed": $failed_count,
  "available_models": [$(printf '"%s",' "${available[@]}" | sed 's/,$//')]  ,
  "failed_models": [$(printf '"%s",' "${failed[@]}" | sed 's/,$//')]
}
EOF

echo "[$timestamp] Available: $available_count/$total | Failed: $failed_count"
echo "  Available: ${available[*]:-none}"
echo "  Failed: ${failed[*]:-none}"

# Output result for cron agent to interpret
if [ $available_count -eq 0 ]; then
  echo ""
  echo "🚨 ALERT: ALL free models are DOWN! Currently falling back to GitHub Copilot (paid)."
  echo "Please notify PengAn immediately."
  echo "NOTIFY_PENGAN=true"
elif [ $failed_count -gt 0 ]; then
  echo ""
  echo "⚠️ WARNING: $failed_count/$total models unavailable, but $available_count still working."
  echo "NOTIFY_PENGAN=false"
else
  echo ""
  echo "✅ All $total free models healthy."
  echo "NOTIFY_PENGAN=false"
fi
