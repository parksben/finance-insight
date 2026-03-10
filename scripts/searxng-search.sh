#!/bin/bash
# searxng-search.sh - Query local SearXNG instance and return JSON results
# Usage: searxng-search.sh "<query>" [limit]
# Example: searxng-search.sh "A股今日行情" 5

QUERY="${1}"
LIMIT="${2:-10}"
SEARXNG_URL="http://localhost:8080"

if [ -z "$QUERY" ]; then
  echo "Usage: $0 '<query>' [limit]"
  exit 1
fi

ENCODED=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$QUERY")

curl -s "${SEARXNG_URL}/search?q=${ENCODED}&format=json&language=zh-CN" | python3 -c "
import sys, json
d = json.load(sys.stdin)
results = d.get('results', [])
limit = int('$LIMIT')
print(json.dumps(results[:limit], ensure_ascii=False, indent=2))
"
