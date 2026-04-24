# 🎯 Agent Management Guide

## Quick Reference

### Spawn an Agent
```bash
# Basic spawn
openclaw sessions spawn --agent-id sales-outreach

# With task description
openclaw sessions spawn --agent-id sales-outreach --task "Draft a cold email for Prasad Veera"

# Interactive mode
openclaw sessions spawn --agent-id frontend-developer --interactive
```

### List Active Sessions
```bash
openclaw sessions list
```

### Send Message to Agent Session
```bash
openclaw sessions send --session-key <session-id> --message "Your message here"
```

### Kill/Stop Agent Session
```bash
openclaw sessions kill --session-key <session-id>
```

## 🏗️ Organizing Agents by Function

### Lead Generation
- outbound-strategist
- sales-outreach
- sales-engineer

### Content & Marketing
- content-creator
- linkedin-content-creator
- seo-specialist
- social-media-strategist

### Technical
- frontend-developer
- backend-architect
- devops-automator
- security-engineer

### Business Operations
- product-manager
- project-shepherd
- deal-strategist
- account-strategist

## 🔥 Pro Tips

1. **Use agents in sequence** for complex workflows:
   ```
   Step 1: outbound-strategist → Find leads
   Step 2: sales-outreach → Write emails
   Step 3: deal-strategist → Close deals
   ```

2. **Check agent capabilities** before spawning:
   ```bash
   cat ~/.openclaw/agency-agents/<agent-name>/AGENTS.md
   ```

3. **Monitor active sessions** to avoid conflicts:
   ```bash
   openclaw sessions list --active
   ```

4. **Use descriptive tasks** for better results:
   ```bash
   # Good
   openclaw sessions spawn --agent-id sales-outreach --task "Write a follow-up email for Prasad Veera at Surya Digital Solutions about white-label partnership, referencing our previous conversation about pricing"
   
   # Bad
   openclaw sessions spawn --agent-id sales-outreach --task "Write email"
   ```
