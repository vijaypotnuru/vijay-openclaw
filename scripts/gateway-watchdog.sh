#!/usr/bin/env bash
# Gateway restart notifier — sends Telegram message and email when gateway comes back online

TOKEN="7908695181:AAERUwDBqTdJrZ0hckRVKHFdFpj0LIPNTfM"
LOG_FILE="/tmp/openclaw-gateway-watchdog.log"
CHAT_ID="797087757"
FLAG_FILE="/tmp/openclaw-gateway-notified"
HEARTBEAT_FLAG="/tmp/openclaw-heartbeat-sent"

# Email recipient
EMAIL_RECIPIENT="prasadveera369@gmail.com"

# Check if gateway is running
exec >> "$LOG_FILE" 2>&1
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Watchdog check started"

if systemctl --user is-active --quiet openclaw-gateway 2>/dev/null; then
    if [ ! -f "$FLAG_FILE" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Gateway is active, sending notifications..."
        
        # Telegram notification
        RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
            -H "Content-Type: application/json" \
            -d "{\"chat_id\":\"${CHAT_ID}\",\"text\":\"🟢 Gateway is back online. I'm ready!\",\"disable_notification\":false}" 2>&1)
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Telegram API response: $RESPONSE"
        
        # Email notification
        EMAIL_SUBJECT="OpenClaw Gateway Back Online"
        EMAIL_BODY="Gateway is back online at $(date '+%Y-%m-%d %H:%M:%S %Z')."
        
        # Try multiple mail methods
        if command -v mail >/dev/null 2>&1; then
            echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" "$EMAIL_RECIPIENT"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Email sent via mail command."
        elif command -v sendmail >/dev/null 2>&1; then
            {
                echo "Subject: $EMAIL_SUBJECT"
                echo "To: $EMAIL_RECIPIENT"
                echo "Content-Type: text/plain; charset=UTF-8"
                echo ""
                echo "$EMAIL_BODY"
            } | sendmail "$EMAIL_RECIPIENT"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Email sent via sendmail."
        elif command -v msmtp >/dev/null 2>&1; then
            echo "$EMAIL_BODY" | msmtp -t "$EMAIL_RECIPIENT" --subject="$EMAIL_SUBJECT"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Email sent via msmtp."
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: No mail command found (mail/sendmail/msmtp). Email not sent."
        fi
        
        touch "$FLAG_FILE"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Gateway active, already notified."
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Gateway is NOT active."
    rm -f "$FLAG_FILE"
fi