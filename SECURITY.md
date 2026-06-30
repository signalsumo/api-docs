# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in the SignalSumo API, please report it privately rather than opening a public issue.

Email **security@signalsumo.com** with:

- A description of the vulnerability and its potential impact
- Steps to reproduce (proof-of-concept code or requests, if applicable)
- Any relevant API endpoint(s) involved

We aim to acknowledge reports within 48 hours and will keep you updated as we investigate and resolve the issue.

## API Key Safety

- Treat API keys (`ss_live_...`) as secrets — never commit them to a public repository, client-side code, or shared documents.
- Keys are shown only once at creation time. If a key is exposed, revoke it immediately at [signalsumo.com/api-keys](https://signalsumo.com/api-keys) and generate a new one.
- Use environment variables or a secrets manager to store keys in your applications.
