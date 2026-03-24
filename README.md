# G7 SDAD-CC v2.0
## Spec-Driven AI Development for Claude Code

SDAD-CC is a development methodology for teams using Claude Code as their primary
AI development tool. It brings spec-first discipline, vertical increments, integrated
QA, compliance tiers, and a shared Lesson Library to AI-assisted development.

---

## Install in 30 seconds

### Mac / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash
```

### Windows (PowerShell as Administrator)
```powershell
irm https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1 | iex
```

The installer will:
- Check and install Node.js 18+ if missing
- Check and install Claude Code if missing
- Check or initialize a git repository
- Copy all SDAD-CC files to your repo root
- Guide you through the Claude User Preferences step
- Print the external skills commands ready to copy

---

## What gets installed

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Core instructions — Claude Code reads this automatically |
| `SKILL_SDAD_METHODOLOGY.md` | Full phase logic, QA rules, compliance tiers |
| `SKILL_AI_ARCHITECT.md` | Architecture decisions, LLM integration patterns |
| `SKILL_AI_ENGINEER.md` | Implementation quality, tooling, UI detection, docs |
| `SKILL_COMPLIANCE.md` | 3-tier compliance system (Standard / Business / Enterprise) |
| `LESSON_LIBRARY.md` | Team knowledge file — grows automatically with use |

---

## Requirements

- Node.js 18+ (installer handles this)
- Claude Code CLI (installer handles this)
- Claude Pro, Max, Team, or Enterprise account
- A git repository (installer can initialize one)

---

## How it works

SDAD-CC adds structure to Claude Code sessions through a CLAUDE.md file that
Claude reads automatically. Every session follows five phases:

```
Phase 0 — Context Ingestion    Claude reads your repo before asking anything
Phase 1 — Requirements         $spec — one question at a time, compliance tier detected
Phase 2 — Spec Document        $specout — writes SPEC.md to your repo
Phase 3 — Guided Development   $build — vertical increments, tests run after each
Phase 4 — QA & Review          $qa — auto-fixes safe issues, surfaces security for human review
```

Plus: `$doc` for documentation generation, `$lesson` for the Lesson Library,
`$pause` for session state, `$skills` for skill management.

---

## Compliance Tiers

SDAD-CC detects the appropriate compliance level in Phase 0 and confirms it in Phase 1:

| Tier | For | Auto-activates |
|------|-----|---------------|
| Tier 1 — Standard | Internal tools, POCs | — |
| Tier 2 — Business | SaaS, customer-facing products | Compliance Reviewer |
| Tier 3 — Enterprise | Regulated environments, corporate IT | Compliance Reviewer (full) |

---

## External Skills

Install these inside a Claude Code session for specialized capabilities:

```bash
# Always relevant
/plugin install example-skills@anthropic-agent-skills   # frontend-design, skill-creator, mcp-builder

# REST/GraphQL API projects
npx skills add https://github.com/wshobson/agents --skill api-design-principles

# Python performance
npx skills add https://github.com/wshobson/agents --skill python-performance-optimization

# TDD + structured debugging
/plugin marketplace add obra/superpowers

# LLM-intensive projects
npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill context-engineering-advisor
```

---

## Documentation

| File | Contents |
|------|----------|
| `SDAD_CC_INSTALL_GUIDE_v2_0.md` | Full installation guide including manual steps |
| `SDAD_CC_USAGE_AND_SHORTCUTS_v2_0.md` | All commands, phases, and best practices |
| `SDAD_CC_TRAINING_AND_PODCAST_v2_0.md` | Training material + NotebookLM prompts |

---

## Repo structure

```
sdad-cc/
├── install.sh                          # Mac/Linux installer
├── install.ps1                         # Windows installer
├── README.md                           # This file
└── kit/                                # SDAD-CC v2.0 files
    ├── SDAD_CC_CLAUDE_MD_v2_0.md
    ├── SDAD_CC_SKILL_SDAD_METHODOLOGY_v2_0.md
    ├── SDAD_CC_SKILL_AI_ARCHITECT_v2_0.md
    ├── SDAD_CC_SKILL_AI_ENGINEER_v2_0.md
    ├── SDAD_CC_SKILL_COMPLIANCE_v2_0.md
    ├── SDAD_CC_LESSON_LIBRARY_v2_0.md
    ├── SDAD_CC_INSTALL_GUIDE_v2_0.md
    ├── SDAD_CC_USAGE_AND_SHORTCUTS_v2_0.md
    └── SDAD_CC_TRAINING_AND_PODCAST_v2_0.md
```

---

## Verification

After installing, start a Claude Code session and run:

| Command | Expected |
|---------|----------|
| `$sdad` | All 5 phases + active skills |
| `$skills` | 4 skills active by default |
| `$spec` | First requirements question |
| `$pause` | Session state from SPEC.md + git log |
| `$SM hello` | ⚡ SIMPLE MODE response |

---

## License

G7 AI Development Methodology — v2.0
