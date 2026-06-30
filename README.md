# SignalSumo API Reference — v1

Integrate SignalSumo's SEO data directly into your own tools, dashboards, and workflows.

API access is available on **Professional**, **Agency**, and **Enterprise** plans. Manage your keys and see your current plan at [signalsumo.com/api-keys](https://signalsumo.com/api-keys).

## Table of Contents

- [Overview](#overview)
- [Authentication](#authentication)
- [Rate Limits](#rate-limits)
- [Error Codes](#error-codes)
- [Endpoints](#endpoints)
  - [GET /usage](#get-apiv1usage)
  - [GET /backlinks](#get-apiv1backlinks)
  - [POST /keyword-research](#post-apiv1keyword-research)
  - [POST /site-audit](#post-apiv1site-audit)
  - [GET /jobs/{job_id}](#get-apiv1jobsjob_id)
- [Changelog](#changelog)

## Overview

All endpoints are served under:

```
https://signalsumo.com/api/v1/
```

Requests and responses use **JSON**. Every successful response follows the same envelope:

```json
{
  "success": true,
  "data":    { ... },
  "meta":    { "timestamp": "2026-06-26T10:00:00+00:00" }
}
```

Errors follow the same shape with `success: false` and an `error` object instead of `data`.

## Authentication

Pass your API key in the `Authorization` header on every request:

```
Authorization: Bearer ss_live_your_key_here
```

Alternatively, you may pass it as a query parameter (not recommended for production):

```
GET /api/v1/usage?api_key=ss_live_your_key_here
```

> **Generating a key** — Create and manage your API keys at [signalsumo.com/api-keys](https://signalsumo.com/api-keys). Each key is shown **only once** at creation time (format: `ss_live_` followed by 40 hex characters) — store it securely. Afterward, only a masked prefix is ever displayed again.

## Rate Limits

| Plan | Monthly API calls | Notes |
|---|---|---|
| Mid | 0 | Resets on the 1st of each month |
| Pro | 100 | Resets on the 1st of each month |
| Agency | 500 | — |

When you exceed your limit the API returns `HTTP 429` with a `resets_at` field in the response meta. This is a monthly call-count ceiling, not a per-second/per-minute rate limiter — there is no request-frequency throttling.

## Error Codes

| HTTP | code | Meaning |
|---|---|---|
| 400 | `BAD_REQUEST` | Malformed request syntax |
| 401 | `UNAUTHORIZED` | Missing or invalid API key |
| 403 | `FORBIDDEN` | API access not available on your plan |
| 404 | `NOT_FOUND` | Endpoint or resource not found |
| 422 | `VALIDATION_ERROR` | Required parameter missing or invalid value |
| 429 | `RATE_LIMITED` / `QUOTA_EXCEEDED` | Monthly call limit or feature quota hit |
| 500 | `SERVER_ERROR` | Upstream or internal error — safe to retry |

## Endpoints

### `GET /api/v1/usage`

Returns your API quota usage for the current calendar month.

**Example Request**

```bash
curl -H "Authorization: Bearer ss_live_xxxx" \
     "https://signalsumo.com/api/v1/usage"
```

**Example Response**

```json
{
  "success": true,
  "data": {
    "plan": "mid",
    "api_calls_used": 42,
    "api_calls_limit": 500,
    "unlimited": false,
    "resets_at": "2026-07-01"
  },
  "meta": {
    "timestamp": "2026-06-26T10:00:00+00:00",
    "key_name": "Production App"
  }
}
```

---

### `GET /api/v1/backlinks`

Returns live backlink data for any domain. Results are cached for 24 hours.

**Query Parameters**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `domain` | string | Yes | Root domain, e.g. `example.com` (no `https://`) |
| `page` | integer | No | Page number, default `1` |
| `limit` | integer | No | Results per page, 1–200, default `50` |

**Example Request**

```bash
curl -H "Authorization: Bearer ss_live_xxxx" \
     "https://signalsumo.com/api/v1/backlinks?domain=ahrefs.com&limit=5"
```

**Example Response**

```json
{
  "success": true,
  "data": {
    "domain": "ahrefs.com",
    "total_backlinks": 4821903,
    "referring_domains": 182440,
    "page": 1,
    "limit": 5,
    "backlinks": [
      {
        "url_from": "https://blog.hubspot.com/marketing/seo-tools",
        "url_to": "https://ahrefs.com/",
        "domain_from": "hubspot.com",
        "anchor": "Ahrefs",
        "dofollow": true,
        "rank": 97,
        "first_seen": "2021-03-10",
        "last_seen": "2026-06-20"
      }
    ]
  },
  "meta": { "timestamp": "2026-06-26T10:00:00+00:00", "cached": false }
}
```

---

### `POST /api/v1/keyword-research`

Returns search volume, CPC, competition, and related keywords for a seed keyword. Synchronous — responds immediately.

**Request Body (JSON)**

| Field | Type | Required | Description |
|---|---|---|---|
| `keyword` | string | Yes | Seed keyword, max 200 chars |
| `location_code` | integer | No | DataForSEO location code, default `2840` (US) |
| `language_code` | string | No | Language code, default `en` |
| `limit` | integer | No | Max related keywords returned, 1–100, default `10` |

**Example Request**

```bash
curl -X POST \
     -H "Authorization: Bearer ss_live_xxxx" \
     -H "Content-Type: application/json" \
     -d '{"keyword":"seo audit tool","limit":5}' \
     "https://signalsumo.com/api/v1/keyword-research"
```

**Example Response**

```json
{
  "success": true,
  "data": {
    "keyword": "seo audit tool",
    "location_code": 2840,
    "language_code": "en",
    "overview": {
      "search_volume": 5400,
      "cpc": 4.20,
      "competition": 0.72,
      "competition_level": "HIGH"
    },
    "related_keywords": [
      { "keyword": "free seo audit tool",   "search_volume": 2900, "cpc": 3.10, "competition": 0.68 },
      { "keyword": "website seo checker",   "search_volume": 1900, "cpc": 2.85, "competition": 0.65 },
      { "keyword": "technical seo audit",   "search_volume": 1600, "cpc": 5.20, "competition": 0.75 },
      { "keyword": "seo site audit online", "search_volume": 1200, "cpc": 2.50, "competition": 0.60 },
      { "keyword": "on page seo checker",   "search_volume": 880,  "cpc": 2.10, "competition": 0.55 }
    ]
  },
  "meta": { "timestamp": "2026-06-26T10:00:00+00:00" }
}
```

---

### `POST /api/v1/site-audit`

> ⏱ Site audits are **asynchronous**. This endpoint returns a `job_id` immediately. Poll `GET /api/v1/jobs/{job_id}` for results. Typical crawl time: 1–5 minutes.

**Request Body (JSON)**

| Field | Type | Required | Description |
|---|---|---|---|
| `url` | string | Yes | Full URL to crawl, e.g. `https://example.com` |
| `max_pages` | integer | No | Max pages to crawl, capped by plan limit (default `100`) |
| `depth` | integer | No | Crawl depth, 1–5, default `3` |

**Example Request**

```bash
curl -X POST \
     -H "Authorization: Bearer ss_live_xxxx" \
     -H "Content-Type: application/json" \
     -d '{"url":"https://example.com","max_pages":50}' \
     "https://signalsumo.com/api/v1/site-audit"
```

**Response (202 Accepted)**

```json
{
  "success": true,
  "job_id": "a3f9b2c1d4e5f6a7b8c9d0e1f2a3b4c5",
  "status": "queued",
  "poll": "https://signalsumo.com/api/v1/jobs/a3f9b2c1d4e5f6a7b8c9d0e1f2a3b4c5",
  "meta": { "timestamp": "2026-06-26T10:00:00+00:00" }
}
```

---

### `GET /api/v1/jobs/{job_id}`

Poll the status of an async job. Poll every 10–15 seconds until `status` is `complete` or `failed`.

**Status Values**

| Status | Meaning |
|---|---|
| `queued` | Job accepted, not yet started |
| `running` | Crawl in progress — check `progress` (0–100) |
| `complete` | Done — `data` field contains results |
| `failed` | Crawl failed — `error` field has the reason |

**Example Request**

```bash
curl -H "Authorization: Bearer ss_live_xxxx" \
     "https://signalsumo.com/api/v1/jobs/a3f9b2c1d4e5f6a7b8c9d0e1f2a3b4c5"
```

**Response — Running**

```json
{
  "success": true,
  "data": {
    "job_id": "a3f9b2c1d4e5f6a7b8c9d0e1f2a3b4c5",
    "endpoint": "site-audit",
    "status": "running",
    "progress": 42,
    "created_at": "2026-06-26 10:00:00",
    "updated_at": "2026-06-26 10:01:30",
    "completed_at": null
  },
  "meta": { "timestamp": "2026-06-26T10:01:30+00:00" }
}
```

**Response — Complete**

```json
{
  "success": true,
  "data": {
    "job_id": "a3f9b2c1d4e5f6a7b8c9d0e1f2a3b4c5",
    "endpoint": "site-audit",
    "status": "complete",
    "progress": 100,
    "created_at": "2026-06-26 10:00:00",
    "updated_at": "2026-06-26 10:03:18",
    "completed_at": "2026-06-26 10:03:18",
    "data": {
      "audit_id": "AUDIT-A1B2C3-4567",
      "domain": "https://example.com",
      "pages_crawled": 47,
      "total_score": 78,
      "report_url": "https://signalsumo.com/report?audit=AUDIT-A1B2C3-4567"
    }
  },
  "meta": { "timestamp": "2026-06-26T10:03:18+00:00" }
}
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## Support

Questions? Email [hello@signalsumo.com](mailto:hello@signalsumo.com), or open an issue in this repository.

Manage your API keys: [signalsumo.com/api-keys](https://signalsumo.com/api-keys) · Compare plans: [signalsumo.com/pricing](https://signalsumo.com/pricing)
