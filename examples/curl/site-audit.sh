#!/usr/bin/env bash
# POST /api/v1/site-audit — kick off an async crawl (returns a job_id immediately)
set -euo pipefail

: "${SIGNALSUMO_API_KEY:?Set SIGNALSUMO_API_KEY to your ss_live_... key first}"
URL="${1:-https://example.com}"
MAX_PAGES="${2:-50}"

RESPONSE=$(curl -s -X POST \
     -H "Authorization: Bearer ${SIGNALSUMO_API_KEY}" \
     -H "Content-Type: application/json" \
     -d "{\"url\":\"${URL}\",\"max_pages\":${MAX_PAGES}}" \
     "https://signalsumo.com/api/v1/site-audit")

echo "$RESPONSE" | python3 -m json.tool

JOB_ID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('job_id', ''))")
if [ -n "$JOB_ID" ]; then
  echo ""
  echo "Job submitted. Poll status with:"
  echo "  ./jobs.sh ${JOB_ID}"
fi
