# Multica Best Practices — Vijay's Guide

## 🎯 Core Value
Multica turns your AI assistants into **real teammates** that can:
- Execute tasks autonomously
- Work 24/7 without breaks
- Scale across multiple machines
- Learn and improve over time

---

## 🚀 Top 5 Use Cases

### 1. **Autonomous Job Hunting Pipeline**
- Create agents for: resume tailoring, company research, application tracking
- Set up autopilots to scan job boards daily
- Use Career-Ops integration for 80+ company pipeline
- Ironman (or similar) can: scan, filter, draft applications, track responses

**Setup:**
```
Agent: job-hunter
Skills: web-search, github, gog (email)
Autopilot: Daily at 09:00 IST → scan + filter + notify
```

### 2. **Code Review & PR Management**
- Assign agents to review pull requests
- Auto-tag issues based on content
- Run tests on every commit
- Generate changelogs from merged PRs

**Setup:**
```
Agent: code-reviewer
Skills: github, gh-issues
Autopilot: On PR creation → review + comment
```

### 3. **System Health Monitoring**
- Check server status, disk usage, memory
- Monitor Tailscale network health
- Alert on issues via Telegram/Email
- Auto-restart services when down

**Setup:**
```
Agent: sysmon
Skills: exec, browser
Autopilot: Every 30 min → health check → alert if issues
```

### 4. **Content & Social Media**
- Draft tweets/LinkedIn posts
- Schedule via Postiz integration
- Monitor engagement
- Auto-respond to mentions

**Setup:**
```
Agent: social-manager
Skills: browser, openclaw-web-search
Autopilot: Daily → draft content → schedule → report
```

### 5. **Documentation Maintenance**
- Keep READMEs updated
- Generate API docs from code
- Update changelogs
- Maintain knowledge bases

**Setup:**
```
Agent: docs-keeper
Skills: github, exec
Autopilot: On push → check docs → update if stale
```

---

## 🛠️ Setup Strategies

### Multi-Agent Workforce
| Agent | Role | Runtime | Skills |
|-------|------|---------|--------|
| ironman | General tasks | OpenClaw | exec, browser |
| job-hunter | Job search | OpenClaw | web-search, gog |
| sysmon | Monitoring | Hermes | exec |
| reviewer | Code review | OpenClaw | github |

### Autopilot Triggers
1. **Schedule** — Run at specific times (cron-like)
2. **Event** — React to GitHub webhooks, PRs, issues
3. **Manual** — Trigger on demand via CLI or UI

### Skill Assignment Tips
- Assign **minimal skills** per agent (security)
- Group related skills (e.g., `github` + `gh-issues`)
- Use `exec` sparingly — it has full system access
- For email tasks, use `gog` skill (safer than raw SMTP)

---

## 💡 Pro Tips

1. **Start small** — One agent, one task. Scale gradually.
2. **Use autopilots** — Set and forget. Agents work while you sleep.
3. **Monitor via UI** — Check http://localhost:3000 for status
4. **Review logs** — `multica daemon logs` for debugging
5. **Archive unused** — Keep workspace clean
6. **Version control** — Export configs to Git for backup

---

## 🔗 Integrations to Explore

| Integration | Use Case | Status |
|-------------|----------|--------|
| GitHub | PR reviews, issue mgmt | ✅ Ready |
| Gmail (Gog) | Email automation | ✅ Ready |
| Postiz | Social scheduling | 🔄 In progress |
| Tailscale | Network health | ✅ Manual |
| Bitbucket | Code hosting | 🔄 In progress |
| Career-Ops | Job pipeline | ✅ Ready |

---

## 🎬 Quick Start: Job Hunting Agent

```bash
# 1. Create agent
multica agent create --name job-hunter --runtime openclaw

# 2. Assign skills
multica agent skills set job-hunter --skills web-search,gog

# 3. Create autopilot
multica autopilot create \
  --name "Daily Job Scan" \
  --agent job-hunter \
  --schedule "0 9 * * *" \
  --task "Scan Career-Ops for new jobs, filter by AI/ML, email summary"

# 4. Watch it work
multica autopilot logs --follow
```

---

*Last updated: 2026-04-22*
