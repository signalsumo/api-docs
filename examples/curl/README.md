# curl Examples

Runnable shell scripts for each endpoint, matching the examples in the main [README](../../README.md).

## Setup

```bash
export SIGNALSUMO_API_KEY="ss_live_your_key_here"
```

## Usage

```bash
./usage.sh
./backlinks.sh example.com 10
./keyword-research.sh "seo audit tool"
./site-audit.sh https://example.com 50
./jobs.sh <job_id>          # job_id printed by site-audit.sh
```

All scripts pretty-print the JSON response via `python3 -m json.tool`. If you don't have Python 3 available, drop the trailing `| python3 -m json.tool` from any script to see the raw response.
