# 🦞 Mission Control — OpenClaw Plugin

Multi-agent management dashboard plugin for OpenClaw. Manage employees, send email campaigns, and monitor your OpenClaw fleet from one place.

## Features

- **Fleet Status** — Check which agents are online/offline across your Tailscale network
- **Email Campaigns** — Send bulk outreach emails (SalesHandy-equivalent inside OpenClaw)
- **Employee Management** — List, filter, and manage your team members
- **Dashboard** — Web UI at the configured Mission Control URL

## Tools

| Tool | Description |
|---|---|
| `mission_control_status` | Get fleet status (online/offline agents) |
| `mission_control_campaign_send` | Send email campaigns to recipients |
| `mission_control_employee_list` | List all employees/agents |

## Install

```bash
openclaw plugins install @vijaypotnuru/openclaw-mission-control
```

## Config

Add to your `openclaw.json`:

```json
{
  "plugins": {
    "entries": {
      "mission-control": {
        "config": {
          "dashboardUrl": "http://localhost:3000",
          "defaultFromEmail": "outreach@company.com"
        }
      }
    }
  }
}
```

## Author

**Vijay Potnuru** — [@VijayPotnuru005](https://x.com/VijayPotnuru005)

## License

MIT
