#!/usr/bin/env bash
# GET /api/v1/backlinks — fetch backlink data for a domain (24h cache)
set -euo pipefail

: "${SIGNALSUMO_API_KEY:?Set SIGNALSUMO_API_KEY to your ss_live_... key first}"
DOMAIN="${1:-ahrefs.com}"
LIMIT="${2:-5}"

curl -s -H "Authorization: Bearer ${SIGNALSUMO_API_KEY}" \
     "https://signalsumo.com/api/v1/backlinks?domain=${DOMAIN}&limit=${LIMIT}" | python3 -m json.tool
