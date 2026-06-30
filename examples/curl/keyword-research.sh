#!/usr/bin/env bash
# POST /api/v1/keyword-research — search volume, CPC, competition, related keywords
set -euo pipefail

: "${SIGNALSUMO_API_KEY:?Set SIGNALSUMO_API_KEY to your ss_live_... key first}"
KEYWORD="${1:-seo audit tool}"

curl -s -X POST \
     -H "Authorization: Bearer ${SIGNALSUMO_API_KEY}" \
     -H "Content-Type: application/json" \
     -d "{\"keyword\":\"${KEYWORD}\",\"limit\":5}" \
     "https://signalsumo.com/api/v1/keyword-research" | python3 -m json.tool
