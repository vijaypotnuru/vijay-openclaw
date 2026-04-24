---
name: mission-control
description: "Manage your OpenClaw agent fleet, send email campaigns, and monitor employees from Mission Control."
---

# Mission Control Skill

Use the `mission_control_*` tools to manage your OpenClaw fleet.

## Fleet Status

Check which agents are online/offline:
```
Use tool: mission_control_status
Parameters: { "filter": "online" }
```

## Email Campaigns

Send bulk outreach emails:
```
Use tool: mission_control_campaign_send
Parameters: {
  "subject": "Follow up from our meeting",
  "body": "Hi {name}, ...",
  "recipients": ["john@example.com", "jane@example.com"],
  "fromName": "Vijay"
}
```

## Employee Management

List all employees:
```
Use tool: mission_control_employee_list
Parameters: { "includeOffline": true }
```

## Dashboard

Open the Mission Control dashboard at the configured URL (default: http://localhost:3000).
