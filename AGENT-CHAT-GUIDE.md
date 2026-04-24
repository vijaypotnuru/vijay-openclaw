# Agent Chat User Guide

## Overview
The Agent Chat feature allows you to communicate with all 184 agents individually or in groups, similar to WhatsApp or Slack.

## Access
**URL:** http://localhost:3001/agents-chat

## Features

### 1. Individual Agent Chat
- Click any agent name in the left sidebar
- Type your message and click **Send**
- Agent will respond based on their expertise

### 2. Group Chat
1. Click **👥 Start Group Chat** button
2. Select multiple agents by clicking on them
3. Selected agents show a **✓** checkmark
4. Type message and click **Send**
5. Message goes to all selected agents simultaneously

### 3. Agent List
- All 184 agents are listed in the sidebar
- Shows agent name and role
- Scroll to find specific agents

## Popular Agents for Outreach

| Agent | Purpose |
|-------|---------|
| sales-outreach | Draft sales emails |
| deal-strategist | Optimize deal strategy |
| content-creator | Create marketing content |
| discovery-coach | Prepare discovery calls |
| linkedin-content-creator | LinkedIn posts |
| seo-specialist | SEO optimization |

## Example Workflow

1. **Research Phase:**
   ```
   @outbound-strategist: "Research Surya Digital Solutions"
   ```

2. **Draft Phase:**
   ```
   @sales-outreach: "Draft follow-up email for Prasad Veera"
   ```

3. **Optimize Phase:**
   ```
   @deal-strategist: "Review and optimize this email"
   ```

4. **Group Collaboration:**
   ```
   [Group: sales-outreach, deal-strategist, content-creator]
   "Create complete outreach package for Surya Digital"
   ```

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/agents` | GET | List all agents |
| `/api/agents/{id}/message` | POST | Send message to agent |

## Troubleshooting

**"0 agents available"**
- This is normal on first load
- React will hydrate and load agents from API
- Refresh the page if needed

**Agent not responding**
- Check if agent ID is correct
- Verify server is running: `curl http://localhost:3001/api/agents`

## Architecture

```
┌─────────────────────────────────┐
│         Browser (React)          │
│  ┌──────────┐  ┌──────────────┐ │
│  │ Sidebar  │  │ Chat Window  │ │
│  │ (Agents) │  │ (Messages)   │ │
│  └──────────┘  └──────────────┘ │
└──────────────┬──────────────────┘
               │ fetch('/api/agents')
               ▼
┌─────────────────────────────────┐
│      Next.js API Routes          │
│  ┌──────────┐  ┌──────────────┐ │
│  │ /api/    │  │ /api/agents/ │ │
│  │ agents   │  │ {id}/message │ │
│  └──────────┘  └──────────────┘ │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│      Agent Filesystem            │
│  ~/.openclaw/agency-agents/      │
└─────────────────────────────────┘
```

## Files
- `app/agents-chat/page.js` - Main UI
- `app/agents-chat/layout.js` - Navigation
- `app/api/agents/route.js` - List agents API
- `app/api/agents/[id]/message/route.js` - Message API

## Status
✅ **ONLINE** - Server running on port 3001
