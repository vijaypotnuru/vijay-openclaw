# Google Stitch Workflow Skill

**Version:** v1.4.2
**Author:** luischarro
**License:** MIT-0

## Overview

This skill provides a disciplined MCP-first workflow for Google Stitch, a design exploration and screen-iteration system. It covers project inspection, controlled screen generation and editing, variants exploration, and export/code translation workflows.

## Installation

Since the `skill` plugin is excluded from `plugins.allow`, this skill is installed manually:

```bash
mkdir -p ~/.openclaw/workspace/skills/google-stitch-workflow
cp SKILL.md ~/.openclaw/workspace/skills/google-stitch-workflow/
cp README.md ~/.openclaw/workspace/skills/google-stitch-workflow/
```

## What is Google Stitch?

Google Stitch is a design exploration and screen-iteration system that:

- Generates screens from text prompts
- Edits existing screens with controlled changes
- Creates variants for design exploration
- Exports to code (React, HTML, etc.)
- Integrates with AI Studio, Figma, and MCP

## Key Capabilities

1. **Design Exploration** — Generate screens from prompts with style keywords
2. **Controlled Editing** — Edit specific elements while preserving others
3. **Variants** — Explore multiple design directions
4. **Export** — Translate designs to production code
5. **MCP Integration** — Bidirectional sync with coding agents

## Workflow Summary

1. **Empathy** → Who is the user? What should they feel?
2. **Creative Direction** → Concrete vocabulary and metaphors
3. **Prompt** → Describe the site and its feeling
4. **Design System** → Colors, fonts, spacing
5. **Layout** → Structure and components
6. **Copywriting** → Real content matching the brief
7. **Iterate** → One screen at a time
8. **Export** → Only after direction is accepted

## Style Keywords

- `minimal`, `clean` — Whitespace, restrained palette
- `editorial`, `magazine-style` — Large typography
- `brutalist`, `neobrutalist` — Thick borders, clashing colors
- `glassmorphism` — Frosted cards, blur effects
- `dark mode` — Dark backgrounds
- `premium`, `luxury` — Serif fonts, generous spacing
- `playful`, `consumer` — Rounded shapes, bright colors
- `vintage` — Texture, paper grain
- `retro` — 80s neon, pixel art

## Important Notes

- Work one screen at a time
- Define what must NOT change in edits
- Use hub-first pattern for multi-screen projects
- Review visuals before each major step
- Move to code only after design is accepted
- Use Pro + Thinking for complex layouts and wireframes

## Security Assessment

This is a documentation/instruction-only skill that provides step-by-step operational guidance. It contains no code, no install scripts, and requests no credentials. The skill assumes the agent environment already has access to a Stitch/MCP connector.

## Source

- ClawHub: https://clawhub.ai/luischarro/google-stitch-workflow
- Stars: 2
- Downloads: 322
- Versions: 7
- Updated: 7h ago
