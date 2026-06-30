#!/usr/bin/env bash
# GET /api/v1/jobs/{job_id} — poll an async job (e.g. from site-audit.sh) until complete
set -euo pipefail

: "${SIGNALSUMO_API_KEY:?Set SIGNALSUMO_API_KEY to your ss_live_... key first}"
JOB_ID="${1:?Usage: ./jobs.sh <job_id>}"

curl -s -H "Authorization: Bearer ${SIGNALSUMO_API_KEY}" \
     "https://signalsumo.com/api/v1/jobs/${JOB_ID}" | python3 -m json.tool
