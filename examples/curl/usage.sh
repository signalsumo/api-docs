#!/usr/bin/env bash
# GET /api/v1/usage — check your current month's API call usage
set -euo pipefail

: "${SIGNALSUMO_API_KEY:?Set SIGNALSUMO_API_KEY to your ss_live_... key first}"

curl -s -H "Authorization: Bearer ${SIGNALSUMO_API_KEY}" \
     "https://signalsumo.com/api/v1/usage" | python3 -m json.tool
