# Multica Self-Hosted Setup

## Status: ✅ Running

**Setup Date:** 2026-04-22
**Location:** /tmp/multica

## Access URLs

| Service | URL | Port |
|---------|-----|------|
| Frontend | http://localhost:13000 | 13000 |
| Backend API | http://localhost:18080 | 18080 |
| WebSocket | ws://localhost:18080/ws | 18080 |

## Database

- **Host:** Windows PostgreSQL via WSL2 gateway (172.20.48.1)
- **Port:** 5432
- **Database:** multica
- **User:** multica
- **Password:** multica

## Environment

- `APP_ENV=development` (enables master code 888888 for login)
- `JWT_SECRET` auto-generated
- `ALLOW_SIGNUP=true`

## Login

1. Open http://localhost:13000
2. Enter any email address
3. Use verification code: **888888**

## Services Running

```bash
# Backend (Go)
cd /tmp/multica/server && go run ./cmd/server

# Frontend (Next.js)
cd /tmp/multica && pnpm dev:web
```

## Stop Services

```bash
# Find and kill processes
kill $(lsof -ti:18080)
kill $(lsof -ti:13000)
```

## Next Steps

1. Open http://localhost:13000 in your browser
2. Log in with any email + code 888888
3. Install the CLI: `brew install multica-ai/tap/multica` (on macOS) or build from source
4. Run: `multica setup self-host --server-url ws://localhost:18080/ws --app-url http://localhost:13000`
5. Create agents and assign tasks

## Notes

- No Docker required - running natively on WSL2
- PostgreSQL is the Windows installation (shared with WSL2)
- Email service (Resend) not configured - codes print to logs
- S3/cloud storage not configured - using local file storage
