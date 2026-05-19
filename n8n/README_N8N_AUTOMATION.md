# n8n Automation (VPS)

This folder contains n8n workflow JSON exports you can import in your n8n instance.

## Prereqs
- n8n running on VPS (Docker Compose)
- GitHub credentials configured inside n8n (recommended: PAT with `repo`, `read:org`, `workflow`)
- Google Sheets credentials configured inside n8n (OAuth)
- A Google Sheet target (spreadsheetId)

## VPS Bootstrap (Docker + Caddy)
Files provided:
- `docker-compose.n8n.yml`
- `.env.example` (copy to `.env` on VPS and fill)
- `Caddyfile`

On the VPS:
```bash
mkdir -p /opt/n8n
cd /opt/n8n
# copy docker-compose.n8n.yml, Caddyfile, and .env (filled)
docker compose -f docker-compose.n8n.yml up -d
```

## Import
In n8n UI:
- Workflows -> Import from File

## Required n8n variables / credentials
These workflows use variables to avoid hardcoding secrets:
- `GITHUB_OWNER` (e.g. `CVlad97`)
- `GITHUB_PAT` (GitHub Personal Access Token; recommended scopes: `repo`, `read:org`, `workflow`, and for secret-scanning APIs: `security_events`)
- `SHEET_ID` (Google spreadsheetId)
- `SHEET_NAME` (tab name, default `audit`)
- `SHEET_PAGES_TAB` (tab name, default `pages_monitor`)
- `SHEET_SECRET_TAB` (tab name, default `secret_scanning`)

Set them in n8n:
- Settings -> Variables

## Included Workflows
- `workflow_repo_audit_to_sheets.json`: inventory repos -> Sheets
- `workflow_pages_monitor.json`: monitor GitHub Pages status -> Sheets
- `workflow_github_pages_monitor.json`: monitor Pages status (no Sheets)
- `workflow_secret_scanning_to_sheets.json`: pull GitHub Secret Scanning alerts count -> Sheets (does not store secret literals)

## Notes (Security)
- Do not paste secrets into Google Sheets.
- Prefer GitHub Secret Scanning + repo-level secret rotation over sharing any raw keys.
- If you enable high-risk nodes like `Execute Command`, do it only on your own VPS and lock down access tightly.
