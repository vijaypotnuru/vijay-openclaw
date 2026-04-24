# OpenClaw Employee Setup Guide (Windows)

## Prerequisites

- Windows 10/11
- Admin access on the laptop
- Internet connection

---

## Step 1: Install Node.js

1. Download Node.js from https://nodejs.org (LTS version)
2. Run the installer, keep all defaults
3. Verify: open PowerShell and run:
```powershell
node --version
npm --version
```

## Step 2: Install OpenClaw

Open PowerShell as Administrator:
```powershell
npm install -g openclaw
```

Verify:
```powershell
openclaw --version
```

## Step 3: Initial Setup

```powershell
openclaw setup
```

This will walk you through:
- Creating the workspace directory
- Setting up the gateway

## Step 4: Configure Model

```powershell
openclaw configure
```

Select the Ollama Cloud model you've set up for employees.

Or set it directly:
```powershell
openclaw config set model ollama/glm-5.1:cloud
```

## Step 5: Create Telegram Bot (for each employee)

1. Open Telegram, search @BotFather
2. Send `/newbot`
3. Give it a name (e.g., "Employee1 Assistant")
4. Give it a username (e.g., "emp1_assistant_bot")
5. Copy the bot token you receive

## Step 6: Connect Telegram

```powershell
openclaw channels login --channel telegram
```

Enter the bot token from Step 5.

## Step 7: Start the Gateway

```powershell
openclaw gateway start
```

This starts the OpenClaw gateway as a background service.

## Step 8: Verify Everything Works

```powershell
openclaw status
openclaw health
```

Then send a message to the employee's Telegram bot to confirm it responds.

## Step 9: Enable Auto-Start (so it runs after reboot)

```powershell
openclaw gateway start --install
```

This installs the gateway as a Windows service that starts automatically.

---

## Post-Setup: What the Employee Gets

- **Telegram bot** — their personal AI assistant
- **Local file access** — can read/write files on their laptop
- **Chrome access** — can browse and interact with websites
- **Full OpenClaw features** — calendar, email, reminders, research

## Post-Setup: What You (Admin) Keep

- **SSH access** — you can remote into the laptop for updates
- **Model billing** — all 8 use your Ollama Cloud subscription
- **Config files** — you set up SOUL.md, permissions, channels
- **Telegram group** — create a group with all 8 bots for monitoring

---

## Quick Reference for Employees

| Task | Command |
|------|---------|
| Check status | `openclaw status` |
| Restart gateway | `openclaw gateway restart` |
| View logs | `openclaw logs` |
| Update OpenClaw | `npm update -g openclaw` |

---

## Notes

- Repeat Steps 1-9 on each of the 8 Windows laptops
- Create a separate Telegram bot for each employee (8 bots total)
- Use the same Ollama Cloud account/API key on all machines
- SOUL.md customization can be done later per employee role
