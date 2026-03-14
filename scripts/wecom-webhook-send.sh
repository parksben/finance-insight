#!/bin/bash
# wecom-webhook-send.sh - 发送企业微信群机器人消息（Markdown 格式）
# 用法: wecom-webhook-send.sh "消息内容（Markdown）"
# 或通过管道: echo "消息" | wecom-webhook-send.sh

WEBHOOK_URL="https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=4dd0d70f-f8ef-4b6c-931e-a123fa6f4fc3"

# 读取消息内容（参数或 stdin）
if [ -n "$1" ]; then
  MSG="$1"
else
  MSG=$(cat)
fi

if [ -z "$MSG" ]; then
  echo "Usage: wecom-webhook-send.sh <message>" >&2
  exit 1
fi

# 转义消息内容为 JSON 安全字符串
ESCAPED=$(printf '%s' "$MSG" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read()))")

PAYLOAD="{\"msgtype\":\"markdown\",\"markdown\":{\"content\":$ESCAPED}}"

RESPONSE=$(curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

ERRCODE=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('errcode',0))" 2>/dev/null)

if [ "$ERRCODE" = "0" ]; then
  echo "✅ 消息发送成功"
else
  echo "❌ 发送失败: $RESPONSE" >&2
  exit 1
fi
