#!/bin/bash
# =============================================================================
# OpenClaw Admin - Remote Management Script
# Run this from your (Vijay's) machine to manage employee laptops
#
# USAGE:
#   ./openclaw-admin-manage.sh <command> <employee-ip> [options]
#
# Commands:
#   status    - Check OpenClaw status on employee laptop
#   memory    - Read employee's memory files
#   soul      - Read/replace employee's SOUL.md
#   config    - Read employee's openclaw.json config
#   sessions  - List employee's conversation sessions
#   skills    - List installed skills
#   plugins   - List installed plugins
#   restart   - Restart gateway on employee laptop
#   update    - Update OpenClaw on employee laptop
#   install   - Install a skill on employee laptop
#   git-sync  - Pull workspace git changes for monitoring
#   help      - Show this help
#
# Example:
#   ./openclaw-admin-manage.sh status 192.168.1.101
#   ./openclaw-admin-manage.sh memory 192.168.1.101
#   ./openclaw-admin-manage.sh install 192.168.1.101 weather
# =============================================================================

set -e

SSH_USER="${SSH_USER:-employee}"
SSH_KEY="${SSH_KEY:-}"

COMMAND="${1:-help}"
EMPLOYEE_IP="${2:-}"
REMOTE="ssh ${SSH_KEY:+-i $SSH_KEY} ${SSH_USER}@${EMPLOYEE_IP}"

usage() {
    cat << EOF
OpenClaw Admin Management

Usage: $0 <command> <employee-ip> [options]

Commands:
  status      Check OpenClaw gateway status
  memory      Read all memory files
  soul        Read SOUL.md personality config
  config      Read openclaw.json config
  sessions    List conversation sessions
  skills      List installed skills
  plugins     List installed plugins
  restart     Restart the gateway
  update      Update OpenClaw to latest version
  install     Install a skill (usage: install <ip> <skill-name>)
  git-sync    Pull workspace changes for monitoring
  logs        Tail recent gateway logs

Examples:
  $0 status 192.168.1.101
  $0 memory 192.168.1.101
  $0 install 192.168.1.101 weather
  $0 soul 192.168.1.102
EOF
}

if [ -z "$EMPLOYEE_IP" ] && [ "$COMMAND" != "help" ]; then
    echo "ERROR: Employee IP required"
    usage
    exit 1
fi

case "$COMMAND" in
    status)
        echo "=== OpenClaw Status on ${EMPLOYEE_IP} ==="
        $REMOTE "openclaw status && openclaw health"
        ;;
    memory)
        echo "=== Memory Files on ${EMPLOYEE_IP} ==="
        $REMOTE "ls -la ~/.openclaw/workspace/memory/ 2>/dev/null; echo '---'; cat ~/.openclaw/workspace/memory/*.md 2>/dev/null || echo 'No memory files yet'; echo '---'; cat ~/.openclaw/workspace/MEMORY.md 2>/dev/null || echo 'No MEMORY.md yet'"
        ;;
    soul)
        echo "=== SOUL.md on ${EMPLOYEE_IP} ==="
        $REMOTE "cat ~/.openclaw/workspace/SOUL.md 2>/dev/null || echo 'No SOUL.md yet'"
        ;;
    config)
        echo "=== Config on ${EMPLOYEE_IP} ==="
        $REMOTE "cat ~/.openclaw/openclaw.json 2>/dev/null || echo 'No config yet'"
        ;;
    sessions)
        echo "=== Sessions on ${EMPLOYEE_IP} ==="
        $REMOTE "openclaw sessions --all-agents --json 2>/dev/null || openclaw sessions 2>/dev/null || echo 'No sessions yet'"
        ;;
    skills)
        echo "=== Skills on ${EMPLOYEE_IP} ==="
        $REMOTE "openclaw skills list 2>/dev/null || echo 'No skills installed'"
        ;;
    plugins)
        echo "=== Plugins on ${EMPLOYEE_IP} ==="
        $REMOTE "ls -la ~/.openclaw/extensions/ 2>/dev/null || echo 'No plugins installed'"
        ;;
    restart)
        echo "=== Restarting gateway on ${EMPLOYEE_IP} ==="
        $REMOTE "openclaw gateway restart"
        echo "✅ Gateway restarted"
        ;;
    update)
        echo "=== Updating OpenClaw on ${EMPLOYEE_IP} ==="
        $REMOTE "sudo npm update -g openclaw && openclaw --version"
        echo "✅ OpenClaw updated"
        ;;
    install)
        SKILL="${3:-}"
        if [ -z "$SKILL" ]; then
            echo "ERROR: Skill name required. Usage: $0 install <ip> <skill-name>"
            exit 1
        fi
        echo "=== Installing skill '$SKILL' on ${EMPLOYEE_IP} ==="
        $REMOTE "openclaw skills install $SKILL"
        echo "✅ Skill '$SKILL' installed"
        ;;
    git-sync)
        echo "=== Pulling workspace changes from ${EMPLOYEE_IP} ==="
        $REMOTE "cd ~/.openclaw/workspace && git add -A && git commit -m 'Auto-sync $(date +%Y-%m-%d)' 2>/dev/null; git push 2>/dev/null || echo 'No remote configured'"
        echo "✅ Workspace synced"
        ;;
    logs)
        echo "=== Recent logs from ${EMPLOYEE_IP} ==="
        $REMOTE "openclaw logs --lines 50"
        ;;
    help|*)
        usage
        ;;
esac
