# G7 SDAD-CC v3.0
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

## Update an existing install

When a new version of SDAD-CC is released, users can update without reinstalling:

### Mac / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash -s -- --update
```

### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -File ".\install-sdad.ps1" --update
```

The `--update` flag compares your local `.sdad/version.json` against the remote `version.json`. If a newer version exists it re-downloads `CLAUDE.md` and updates your local version file. If already up to date it exits cleanly.

---

## Start a new project

After installing the methodology, initialize each new repo:

### Mac / Linux
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/kit/project-init.sh)
```

### Windows (PowerShell)
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/kit/project-init.ps1" -OutFile "project-init.ps1"
powershell -ExecutionPolicy Bypass -File ".\project-init.ps1"
```

The project initializer verifies SDAD-CC is installed (runs the methodology installer
automatically if not), then creates `SPEC.md`, `LESSON_LIBRARY.md`, and `.sdad/`
structure in your repo.

---

## Before every session

```bash
npx ccstatusline@latest   # terminal 1 — shows model, context %, cost, git branch
claude                       # terminal 2
```

---

## What gets installed

`install.sh` / `install.ps1` creates:

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Core instructions — Claude Code reads this automatically. All skills are embedded here. |
| `.sdad/version.json` | Tracks the installed SDAD-CC version for future `--update` checks |

`project-init.sh` / `project-init.ps1` also creates:

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
| `$verify [lib]` | Check dependency documentation currency before coding |
| `$agent review [module]` | Architectural review via isolated sub-agent |
| `$agent test [module]` | Test suite generation via isolated sub-agent |
| `$flow [name]` | Define a repeatable project-specific sequence |
| `$doc` | Generate documentation from SPEC.md + codebase |
| `$lesson` | View and manage the Lesson Library |
| `$pause` | Show current state — Spec, git log, context budget, open findings |

---

## Compliance Tiers

Detected in Phase 0, confirmed in Phase 1:

| Tier | For | Auto-activates |
|------|-----|---------------|
| Tier 1 — Standard | Internal tools, POCs | — |
| Tier 2 — Business | SaaS, customer-facing products | Compliance Reviewer |
| Tier 3 — Enterprise | Regulated environments, corporate IT | Compliance Reviewer (full) |

---

## External Skills

Install inside a Claude Code session for specialized capabilities:

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
| `SDAD_CC_INSTALL_GUIDE_v3_0.md` | Full installation guide including manual steps and antivirus notes |
| `SDAD_CC_USAGE_AND_SHORTCUTS_v3_0.md` | All commands, phases, context budget, and best practices |
| `SDAD_CC_TRAINING_AND_PODCAST_v2_0.md` | Training material + NotebookLM prompts |

---

## Repo structure

```
sdad-cc/
├── install.sh                            # Mac/Linux methodology installer
├── install.ps1                           # Windows methodology installer
├── version.json                          # Current methodology version (bump on every release)
├── README.md                             # This file
└── kit/                                  # SDAD-CC v3.0 files (served via raw GitHub URLs)
    ├── project-init.sh                   # Mac/Linux project initializer
    ├── project-init.ps1                  # Windows project initializer
    ├── SDAD_CC_CLAUDE_MD_v3_0.md         # Core methodology — all skills embedded
    ├── SDAD_CC_INSTALL_GUIDE_v3_0.md
    ├── SDAD_CC_USAGE_AND_SHORTCUTS_v3_0.md
    ├── SDAD_CC_README_v3_0.md
    └── SDAD_CC_TRAINING_AND_PODCAST_v2_0.md
```

---

## Maintainer release workflow

When releasing a new version of SDAD-CC:

1. **Update kit files** — edit `kit/SDAD_CC_CLAUDE_MD_v3_0.md` (and any other files)
2. **Bump `version.json`** in the repo root:
```json
{
  "version": "3.1.0",
  "released": "YYYY-MM-DD"
}
```
3. **Push to GitHub** — that's it. No build step needed.
4. Users run the update command and get the new files automatically:
```bash
# Mac/Linux
curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash -s -- --update

# Windows
powershell -ExecutionPolicy Bypass -File ".\install-sdad.ps1" --update
```

---

## Verification

After installing, run `npx ccstatusline@latest` in one terminal, start `claude`
in another, then verify inside Claude Code:

| Command | Expected |
|---------|----------|
| `$sdad` | All 5 phases + active skills |
| `$skills` | 4 skills active by default |
| `$spec` | First requirements question with proposed default |
| `$pause` | Session state including Context Budget status |
| `$SM hello` | ⚡ SIMPLE MODE response |

---

## License

G7 AI Development Methodology — v3.0
