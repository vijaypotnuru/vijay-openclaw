# OpenClaw Employee Deployment Guide

## Complete step-by-step setup for each employee laptop

---

## Prerequisites (before you start)

- Windows 10 (Build 19041+) or Windows 11
- Admin rights on the laptop
- Internet connection
- Employee has an **Ollama Cloud account** (create at https://ollama.com)
- You have created a **Telegram bot** for this employee (via @BotFather)
- Laptop has BIOS virtualization enabled (Intel VT-x / AMD-V)

---

## Step 1: Download & Extract Setup Package

1. Open this link in the browser: **https://drive.google.com/file/d/1Hk-iI_9xwi0Ua_6ZYKKCvv4cIj0-L2S-/view**
2. Download the ZIP file
3. Right-click the ZIP → **Extract All**
4. Open the extracted folder `openclaw-employee-setup`

---

## Step 2: Run Employee Setup (PowerShell Admin)

1. **Right-click `openclaw-setup.bat`** → **Run as Administrator**
2. Wait for it to complete all 8 steps

**If the laptop needs a restart (first time WSL2 install):**
1. Restart the laptop
2. After restart, open **Ubuntu** from Start Menu
3. Create a Linux username and password (remember this!)
4. Run the setup again: Right-click `openclaw-setup.bat` → Run as Administrator

**Wait for:** `Setup Complete!` with the laptop IP address

---

## Step 3: Run Post-Setup (inside Ubuntu)

1. Open **Ubuntu** from Start Menu
2. Run these commands:

```bash
cd /mnt/c/Users/<WINDOWS_USERNAME>/Downloads/openclaw-employee-setup/openclaw-setup
bash openclaw-employee-postsetup.sh
```

> Replace `<WINDOWS_USERNAME>` with the actual Windows username. If unsure, run `ls /mnt/c/Users/` to find it.

**This installs:**
- Ollama + embedding model (for memory)
- Chromium browser (for web browsing)
- Memory features (LanceDB, Active Memory, Wiki)
- Browser plugin
- Gateway service

**Wait for:** `✅ Post-Setup Complete!`

---

## Step 4: Set Employee Password

In Ubuntu, run:

```bash
sudo chpasswd <<< "<LINUX_USERNAME>:<PASSWORD>"
```

Example:
```bash
sudo chpasswd <<< "rahul_kumar:SecurePass123"
```

---

## Step 5: Install Tailscale (for remote management)

**In PowerShell as Admin, run:**

```powershell
winget install Tailscale.Tailscale
```

- Type **Y** for license agreement
- After install, open **Tailscale** from Start Menu
- Log in with: **vijaypotnuru123@gmail.com**
- Wait for it to show "Connected"

---

## Step 6: Enable SSH Remote Access

**In Ubuntu, run:**

```bash
mkdir -p ~/.ssh && echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlvq6YKGtN5zTDw8dRxwGqqCs+y9Nf0vonWDEIAZRjY openclaw-admin" >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
```

**In PowerShell as Admin, run:**

```powershell
Add-Content -Path "C:\ProgramData\ssh\sshd_config" -Value "PubkeyAuthentication yes"; Restart-Service sshd; echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlvq6YKGtN5zTDw8dRxwGqqCs+y9Nf0vonWDEIAZRjY openclaw-admin" | Out-File -FilePath "C:\ProgramData\ssh\administrators_authorized_keys" -Encoding ASCII -Append; icacls "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "SYSTEM:(R)" /grant "Administrators:(R)"
```

---

## Step 7: Connect Employee's Ollama Account

Each employee uses their **own** Ollama Cloud account (not shared).

**In Ubuntu, run:**

```bash
ollama login
```

Enter the employee's Ollama Cloud API key when prompted.

**Verify it works:**

```bash
ollama list
```

Should show available models.

---

## Step 8: Connect Telegram Bot

**Create a bot** (if not already done):
1. Open Telegram → message **@BotFather**
2. Send `/newbot`
3. Pick a name (e.g. "Rahul AI Assistant")
4. Pick a username (e.g. `rahul_openclaw_bot`)
5. Copy the bot token BotFather gives you

**In Ubuntu, run:**

```bash
openclaw config set channels.telegram.botToken '<TELEGRAM_BOT_TOKEN>'
openclaw config set channels.telegram.enabled true
openclaw config set channels.telegram.dmPolicy open
openclaw gateway restart
```

> Replace `<TELEGRAM_BOT_TOKEN>` with the actual token from @BotFather.
> The `dmPolicy open` setting allows anyone to chat without pairing codes.

**Verify:** Open Telegram, find the bot, send `/start` then a message. AI should respond!

---

## Step 9: Verify Everything Works

**In Ubuntu, run:**

```bash
openclaw health
```

Should show:
- Agents: main (default)
- Heartbeat interval: 30m

**In Telegram:** Send a message to the bot → AI should respond.

**Dashboard:** Open `http://127.0.0.1:18789/` in the laptop's Windows browser.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| WSL2 install fails | Make sure BIOS virtualization is enabled (Intel VT-x / AMD-V) |
| Laptop restarts during setup | Run the setup again after restart — it'll skip WSL2 |
| Gateway not running | Run `openclaw gateway install && openclaw gateway start` |
| AI doesn't respond | Check Ollama account: `ollama list` — must show models |
| AI still doesn't respond | Make sure employee ran `ollama login` with their API key |
| Telegram bot silent | Check token: `openclaw config get channels.telegram.botToken` |
| Telegram bot says "access not configured" | Run `openclaw config set channels.telegram.dmPolicy open && openclaw gateway restart` |
| SSH access fails | Make sure both Ubuntu AND PowerShell SSH key commands were run |
| `zstd` error during install | Run `sudo apt-get install -y zstd` first |
| `chpasswd` fails | Use exact format: `sudo chpasswd <<< "username:password"` |
| Dashboard not opening | Open `http://127.0.0.1:18789/` in Windows browser (not Ubuntu) |
| Tailscale not connecting | Open Tailscale app and log in with vijaypotnuru123@gmail.com |
| Bot token "Unauthorized" | Token is wrong — copy exact token from @BotFather again |
| Memory not working | Needs Ollama + nomic-embed-text: `ollama pull nomic-embed-text` |

---

## Quick Reference Commands (run inside Ubuntu)

```bash
# Check OpenClaw status
openclaw health

# Check gateway
openclaw gateway status

# Restart gateway
openclaw gateway restart

# Check Ollama
ollama list

# Change password
sudo chpasswd <<< "username:newpassword"

# Set Telegram bot token
openclaw config set channels.telegram.botToken 'TOKEN_HERE'

# Set Telegram to open access (no pairing)
openclaw config set channels.telegram.dmPolicy open

# Dashboard URL (open in Windows browser)
# http://127.0.0.1:18789/
```

---

## Per-Employee Checklist

Copy this for each employee and mark as done:

| Step | Description | Status |
|------|-------------|--------|
| 1 | Download & extract ZIP | ☐ |
| 2 | Run `openclaw-setup.bat` as Admin | ☐ |
| 3 | Restart + re-run (if WSL2 was new) | ☐ |
| 4 | Run `openclaw-employee-postsetup.sh` in Ubuntu | ☐ |
| 5 | Set employee password | ☐ |
| 6 | Install Tailscale + login | ☐ |
| 7 | SSH keys (Ubuntu + PowerShell) | ☐ |
| 8 | Employee's Ollama account (`ollama login`) | ☐ |
| 9 | Telegram bot token + dmPolicy open | ☐ |
| 10 | Verify AI responds on Telegram | ☐ |

---

## Employee Tracker

| Employee | Laptop | Tailscale IP | Bot Username | Ollama Account | All Steps Done |
|----------|--------|-------------|-------------|----------------|----------------|
| Shiva | LAPTOP-THETEFCG | 100.117.69.13 | @shiva_vakiti_openclaw_bot | ⏳ Pending | 9/10 |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
