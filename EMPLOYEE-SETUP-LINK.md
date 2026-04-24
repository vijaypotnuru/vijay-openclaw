# 🦞 OpenClaw Employee Setup — 5 Minutes

## What You'll Get
Your own AI assistant on Telegram that can:
- Answer questions, write code, research anything
- Read your calendar & emails
- Browse the web for you
- Manage your files and tasks

## Setup Steps

### 1. Install WSL2 (one-time)
Open **PowerShell as Admin** and run:
```powershell
wsl --install -d Ubuntu
```
Restart your laptop when asked. After restart, open **Ubuntu** from Start Menu and create a username + password.

### 2. Install OpenClaw
Inside Ubuntu, run:
```bash
npm install -g openclaw
```

### 3. Quick Setup
```bash
openclaw onboard --install-daemon
```
Follow the prompts. When asked for model, select: `ollama/glm-5.1:cloud`

### 4. Connect Telegram
1. Open Telegram, message [@BotFather](https://t.me/BotFather)
2. Send `/newbot` → name it `[YourName] Assistant`
3. Copy the bot token
4. Run:
```bash
openclaw config set channels.telegram.token "YOUR_BOT_TOKEN"
openclaw config set channels.telegram.dmPolicy open
openclaw gateway restart
```

### 5. Done! ✅
Message your bot on Telegram. It should reply!

## Need Help?
Ask Vijay or message the admin bot.

## Quick Commands
| What | Command |
|---|---|
| Check status | `openclaw status` |
| Restart | `openclaw gateway restart` |
| View logs | `openclaw logs` |
| Update | `npm update -g openclaw` |
