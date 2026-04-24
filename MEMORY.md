# MEMORY.md — Long-Term Memory

## About Vijay
- **Name:** Vijay Potnuru
- **Email:** vijaypotnuru123@gmail.com
- **X (Twitter):** @VijayPotnuru005
- **Location:** Hyderabad, India (Uppal/Kapra area)
- **Bank:** IDFC FIRST Bank (credit card ending XX4629)
- **Phone:** Samsung M35 ("Vijay's M35") — paired via OpenClaw Android app

## Career & Projects
- Job hunting — scanning 80+ companies for software engineering roles
- Top targets: ElevenLabs (Full-Stack), Vercel AI SDK (dream role), Glean (Bangalore)
- 278 job offers found across 13 API-connected companies
- Need to contribute to AI SDK / Next.js OSS before Vercel applications
- Job scan pipeline set up with portals.yml and search queries

## Setup & Tools
- **OS:** WSL2 (Ubuntu 24.04) on Windows laptop (LAPTOP-J8K1OV21)
- **Tailscale:** laptop-j8k1ov21-1.tailf8bf9d.ts.net
- **Gmail:** Connected via **Gog CLI** (v0.12.0) — NOT openclaw-google-workspace (removed)
  - GOG_KEYRING_PASSWORD=openclaw (in .bashrc)
  - GOG_ACCOUNT=vijaypotnuru123@gmail.com (in .bashrc)
  - Skills: gmail, calendar, drive, contacts, sheets, docs
- **Telegram:** Paired — bot @VijayJarvisbot, user ID 797087757
- **Browser:** Playwright v1.59.1 installed with Chromium (headless)
- **Android Node:** Vijay's M35 — camera, location, notifications, contacts, calendar all working
- **OpenClaw version:** 2026.4.15

## Lessons Learned
- `tools.profile: "coding"` with restrictive `tools.allow` blocked all core tools (exec, browser, etc.) — fixed by expanding allow list
- Google OAuth requires **Desktop app** credential type (not Web) for CLI flows like gog
- Gog needs GOG_KEYRING_PASSWORD env var in non-TTY environments (WSL)
- `plugins.allow` entries without matching installed plugins cause warnings — clean them up

## Preferences
- Prefers Gog over openclaw-google-workspace for Google integration
- Wants hands-on help — prefers I do things rather than give instructions
- Likes quick, direct responses
