# Google Stitch Workflow

Use when working with Google Stitch through a disciplined MCP-first workflow. Prefer this skill for project inspection, controlled screen generation and editing, variants exploration, and export/code translation workflows.

## Purpose

This skill separates three concerns that are often conflated:

- Verified MCP capabilities in the current environment
- Browser-only Stitch product features
- Optional local workflow conventions that improve traceability

## When to Use This Skill

Use this skill when the task involves one or more of:

- Inspecting Stitch projects and screens before making changes
- Generating a new screen from a text prompt
- Refining an existing generated screen with small, controlled edits
- Organizing a multi-screen redesign effort without losing revision history
- Converting vague design requests into structured prompts

## When Not to Use This Skill

Do not use Stitch as the primary path when the real task is:

- Implementing production UI code directly
- Making deterministic pixel-perfect edits to an existing coded screen
- Redesigning an app without reliable reference screens or screenshots
- Planning an entire product in one step without screen-level iteration
- Evaluating engineering feasibility without a prior visual direction

## Quick Operating Rules

- **Rewrite before acting** — before any `generate`, `edit`, or `variants` call, rewrite the user request into a stronger design prompt or a tighter edit intent
- **Inspect before editing** — always inspect the project and target screen first; verify whether the screen is actually generated content (if `htmlCode` exists, it's more likely editable)
- **Pick the operation class first** — decide whether this pass is `generate`, `edit`, or `variants`; do not blur exploration, refinement, and branching in one move
- **Work one screen at a time** — one short generation followed by controlled edits; keep one screen as the unit of iteration
- **Keep prompts short, explicit, and preservation-oriented** — start with the smallest prompt that can produce a useful screen
- **Review the visual result before the next major step** — review screenshots or visual artifacts immediately after each generate/edit; ask the user to choose using a human description, not an opaque screen ID
- **Move to code only after one direction is clearly accepted** — confirm the visually reviewed canonical screen before export or translation
- **Stop repeating failing payloads** — do not brute-force retries with the same parameters
- **Act as creative director** — Stitch is the designer, you provide the direction
- **Define what must NOT change** — the single most important iteration rule: tell Stitch what to keep, not just what to change
- **Hub-first for multi-screen projects** — generate a hub screen first, derive all other screens via edit, never fresh generate siblings
- **Report state after every pass** — after each generate/edit/variants step, report the project id, screen id, artifact location if any, a short design judgment, and the next recommended move

## Complete Process Order

1. **Empathy** → Who is the user? What should they feel?
2. **Creative direction** → Concrete vocabulary, metaphors, not abstract words
3. **Prompt with direction** → Describe what the site is and how it feels
4. **Design system** → Set color hierarchy, font hierarchy, corner radius in DESIGN.md
5. **Layout** → Use variants (Explore level) with scoped layout prompts
6. **Copywriting** → Generate real copy matching the creative brief
7. **Iterate** → One screen at a time, scoped refinements
8. **Export/code** → Only after the direction is clearly accepted

## Creative Direction Framework

### 1. Start with empathy

Before touching color, typography, or layout, answer two questions:

- Who is the user?
- What should they feel when they arrive?

### 2. Replace abstract words with concrete vocabulary

Bad: "make it look high-end", "patriotic", "sporty"
Good: "architectural limestone", "neoclassical", "ink on paper"

### 3. Use metaphors to find layouts

When stuck on layout, ask: "If my site were a physical object, what would it be?"

## Color Hierarchy

| Role | Usage | Visual weight |
|------|-------|---------------|
| Neutral | 80-90% of the canvas — the background | Lightest |
| Primary | Headings, body text, core content | Dark, high contrast |
| Secondary | Subdued support text | Softer than primary |
| Tertiary | Accent, CTAs, hover states | Loudest, but used the least |

## Font Hierarchy

Stitch sets up three font slots: headline, body, and label.

- Choose fonts that match your creative direction
- Space Grotesk is great for labels and timestamps (not headlines)
- Public Sans works for both headline and body when you want official-but-approachable

## Prompt Structure Template

Every good Stitch prompt has four layers:

1. **Context** — who and what: industry, audience, app reference
2. **Structure** — layout and components: sidebar navigation, card grid, hero section
3. **Aesthetic** — visual tone using precise keywords (minimal, editorial, brutalist, glassmorphism, dark mode, premium, playful, vintage, retro)
4. **Constraints** — device, format, what must NOT change

## Style Keywords

| Keyword | What Stitch generates |
|---------|----------------------|
| `minimal`/`clean` | Lots of whitespace, restrained palette, simple geometry |
| `editorial`/`magazine-style` | Large typography, dramatic whitespace |
| `brutalist`/`neobrutalist` | Thick black borders, clashing colors, hard shadows |
| `glassmorphism` | Frosted translucent cards, blur effects |
| `dark mode` | Dark backgrounds with light text |
| `premium`/`luxury` | Restrained palette, serif typography |
| `playful`/`consumer` | Rounded shapes, bright colors |
| `vintage` | Texture, paper grain, serif type |
| `retro` | 80s synthwave, pixel art, neon |

## Model Selection

| Mode | When to use |
|------|-------------|
| Gemini Flash (`GEMINI_3_FLASH`) | Fast exploratory passes |
| Gemini Pro (`GEMINI_3_PRO`) | Complex multi-screen dashboards |
| Redesign | You have a screenshot or existing site |
| ID8 | Vague problem statement; Stitch helps construct a plan |
| Live | Real-time conversational editing |

## Iteration & Refinement

### Variants Creativity Levels

| Level | Behavior | When to use |
|-------|----------|-------------|
| Refine | Small tweaks, close to original | Polishing an accepted direction |
| Explore | Balanced creativity — the sweet spot | Finding layout and imagery options |
| Reimagine | Wild reinterpretation | Breaking out of a rut |

### Multi-screen Hub-first Pattern

For multi-screen projects:

1. Generate the hub screen → review carefully
2. All further screens → `edit` from the hub (never fresh generate siblings)
3. Max 1-2 changes per edit prompt

## MCP API Reference

### Verified Capabilities

- `list_projects`
- `get_project`
- `list_screens`
- `get_screen`
- `create_project`
- `generate_screen_from_text`
- `edit_screens`

### Parameter Discipline

- `deviceType`: Use uppercase enum values: `"MOBILE"`, `"DESKTOP"`
- `modelId`: Verified values: `"GEMINI_3_FLASH"`, `"GEMINI_3_PRO"`
- `selectedScreenIds`: Pass bare screen IDs (not full resource names)

### Example Edit Call

```json
{
  "projectId": "15190935684505273965",
  "selectedScreenIds": ["69b3228b6c5f4b9f9efceea4b6a30168"],
  "deviceType": "MOBILE",
  "prompt": "Make the primary button darker and add a small secondary text link below it."
}
```

## Export Paths

| Export path | Direction | Best for |
|-------------|-----------|----------|
| Google AI Studio | One-way push | Simple apps (1-2 pages) |
| MCP connection | Bidirectional | Ongoing projects, multi-page apps |
| Download zip | One-time | Offline work, custom build pipelines |
| Copy code | One-time | Quick paste into existing project |
| Figma | One-time | Design handoff to designers |

## Important Notes

- Use Pro + Thinking for wireframe/sketch uploads — Flash produces weaker results
- Use full-page screenshots for redesign, not section-by-section
- Export 5+ complex pages to AI Studio one at a time, not all at once
- Review visual results before each major step
- Move to code only after design direction is accepted
- Replace hardcoded demo content with real data before production

## References

- Prompt reference: `references/prompt-structuring.md`
- Visual review: `references/visual-review-and-artifacts.md`
- Redesign patterns: `references/redesign-prompt-patterns.md`
- Local workflow conventions: `references/local-workflow-conventions.md`
