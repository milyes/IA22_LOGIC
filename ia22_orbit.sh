#!/usr/bin/env bash
PROMPT="$1"
RESPONSE=$(curl -s -X POST http://127.0.0.1:8777/scribe \
  -H "X-API-Key: demo-api-key-h3" \
  -H "Content-Type: application/json" \
  -d "{\"prompt\":\"$PROMPT\", \"voix\":\"architecte\"}")

echo "$RESPONSE" | tee -a ~/IA22_LOGIC/audit_orbit.log
SEAL=$(echo "$RESPONSE" | grep -o '"seal":"[^"]*"' | cut -d'"' -f4)
echo "SEAL: $SEAL"
