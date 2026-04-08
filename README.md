# G7 SDAD-CC v3.1
## Spec-Driven AI Development for Claude Code

SDAD-CC is a development methodology for teams using Claude Code as their primary
AI development tool. It brings spec-first discipline, vertical increments, integrated
QA, compliance tiers, context budget management, and a shared Lesson Library to
AI-assisted development.

---

## Install

### Mac / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash
```

### Windows (PowerShell)

**Option A — paste directly (recommended):**
```powershell
$sdad = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1" -UseBasicParsing).Content
Invoke-Expression $sdad
```

**Option B — download first, then run:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1" -OutFile "install-sdad.ps1"
powershell -ExecutionPolicy Bypass -File ".\install-sdad.ps1"
```

> The classic `irm | iex` pattern is blocked by Windows Defender and Execution Policy.
> Both options above work without Administrator privileges or antivirus exceptions.

The installer will:
- Check and install Node.js 18+ if missing
- Check and install Claude Code if missing
- Install `ccstatusline` (required context budget monitor)
- Check or initialize a git repository
- Copy all SDAD-CC files to your repo root
- Create `.sdad/` directory structure
- Guide you through the Claude User Preferences step

---

## Start a new project

After installing the methodology, initialize each new repo:

### Mac / Linux
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.sh)
```

### Windows (PowerShell)
```powershell
$init = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.ps1" -UseBasicParsing).Content
Invoke-Expression $init
```

The project initializer verifies SDAD-CC is installed (runs the methodology installer
automatically if not), then creates `SPEC.md`, `LESSON_LIBRARY.md`, and `.sdad/`
structure in your repo.

---

## Before every session

```bash
npx ccstatusline@latest   # terminal 1 — shows model, context %, cost, git branch
claude                    # terminal 2 — start Claude Code
```

ccstatusline appears automatically in the status bar once installed.

---

## What gets installed

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Core instructions — Claude Code reads this automatically |
| `SDAD_CORE_SKILL_METHODOLOGY.md` | Full phase logic, QA rules, compliance tiers |
| `SDAD_CORE_SKILL_AI_ARCHITECT.md` | Architecture decisions, LLM integration patterns |
| `SDAD_CORE_SKILL_AI_ENGINEER.md` | Implementation quality, tooling, UI detection, docs |
| `SDAD_CORE_SKILL_COMPLIANCE.md` | 3-tier compliance system (Standard / Business / Enterprise) |
| `LESSON_LIBRARY.md` | Team knowledge file — grows automatically with use |

Project initializer also creates:

| File / Folder | Purpose |
|--------------|---------|
| `SPEC.md` | Initialized with project metadata — populated by `$specout` |
| `.sdad/project.md` | Project registry and session log |
| `.sdad/flows/` | Project-specific repeatable command sequences |

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

### Context Budget

Claude's reasoning degrades as the session context fills. SDAD-CC monitors this:

| Threshold | Action |
|-----------|--------|
| 50% | ⚠️ Soft warning — informational, continue normally |
| 65% | 🔴 Hard warning — finishes current increment, blocks `$build`, prompts session restart |

`ccstatusline` shows context % in real time. Sub-agents (`$agent`) run in isolated
context windows and do not consume the main session budget.

---

## Key commands

| Command | What it does |
|---------|-------------|
| `$spec` | Phase 1 — guided requirements, one question at a time |
| `$specout` | Phase 2 — generate full 13-section Spec → writes SPEC.md |
| `$build [feature]` | Phase 3 — vertical increment with tests |
| `$qa` | Phase 4 — auto QA, surfaces security for approval |
| `$qa review` | Phase 4 — manual QA, per-finding approval |
| `$qa full` | Full project audit in SDAD-Aware mode |
| `$QA` | Full code audit from User Preferences (Standalone or SDAD-Aware) |
| `$verify [lib]` | Check dependency documentation currency before coding |
| `$agent review [module]` | Architectural review via isolated sub-agent |
| `$agent test [module]` | Test suite generation via isolated sub-agent |
| `$flow [name]` | Define a repeatable project-specific sequence |
| `$doc` | Generate documentation from SPEC.md + codebase |
| `$lesson` | View and manage the Lesson Library |
| `$pause` | Show current state — Spec, git log, context budget, findings, decisions |

---

## Compliance Tiers

Detected in Phase 0, confirmed in Phase 1:

| Tier | For | Auto-activates |
|------|-----|---------------|
| Tier 1 — Standard | Internal tools, POCs | — |
| Tier 2 — Business | SaaS, customer-facing products | Compliance Reviewer |
| Tier 3 — Enterprise | Regulated environments, corporate IT | Compliance Reviewer (full) |

Tier 3 requires SPEC.md §9 complete before `$build` is allowed.

---

## External Skills

Install inside a Claude Code session:

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

## Complementary tools (optional)

| Tool | Purpose |
|------|---------|
| [Warp](https://warp.dev) | AI-native terminal with side panel for file visualization |
| Context 7 MCP | Up-to-date API docs inside Claude Code — `/plugin` → "Context 7" |
| Sequential Thinking MCP | Deep chain-of-thought reasoning — type "install sequential thinking MCP" |
| [Happy Engineering](https://happy.engineering) | Control Claude Code terminals from mobile |

---

## Documentation

| File | Contents |
|------|----------|
| `SDAD_CC_INSTALL_GUIDE.md` | Full installation guide including manual steps and antivirus notes |
| `SDAD_CC_USAGE_AND_SHORTCUTS.md` | All commands, phases, context budget, and best practices |

---

## Repo structure

```
sdad-cc/
├── install.sh                            # Mac/Linux methodology installer
├── install.ps1                           # Windows methodology installer
├── project-init.sh                       # Mac/Linux project initializer
├── project-init.ps1                      # Windows project initializer
├── README.md                             # This file
└── kit/                                  # SDAD-CC v3.1 files
    ├── SDAD_CC_CLAUDE_MD.md
    ├── SDAD_CORE_SKILL_METHODOLOGY.md
    ├── SDAD_CORE_SDAD_CORE_SKILL_AI_ARCHITECT.md
    ├── SDAD_CORE_SDAD_CORE_SKILL_AI_ENGINEER.md
    ├── SDAD_CORE_SDAD_CORE_SKILL_COMPLIANCE.md
    ├── SDAD_LESSON_LIBRARY.md
    ├── SDAD_CC_INSTALL_GUIDE.md
    └── SDAD_CC_USAGE_AND_SHORTCUTS.md
```

---

## Verification

After installing, start `claude` and verify:

| Command | Expected |
|---------|----------|
| `$sdad` | All 5 phases + active skills |
| `$skills` | 4 skills active by default |
| `$spec` | First requirements question with proposed default |
| `$pause` | Session state including Context Budget status and Decisions log |
| `$SM hello` | ⚡ SIMPLE MODE response |

---

## License

G7 AI Development Methodology — v3.1
