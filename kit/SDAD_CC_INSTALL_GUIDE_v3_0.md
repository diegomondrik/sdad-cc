# G7 SDAD-CC — Installation & Setup Guide
# Spec-Driven AI Development for Claude Code
# Version 3.0 | 2026

---

## What is SDAD-CC

SDAD-CC is the Claude Code edition of the G7 Spec-Driven AI Development methodology.
It is designed for developers who use Claude Code (the CLI agent) as their primary
AI development tool. Unlike the web UI version (v1.3), SDAD-CC eliminates all
copy/paste rituals by leveraging Claude Code's direct filesystem and terminal access.

If you are using Claude on the web UI (claude.ai), use SDAD v1.3 instead.
Both kits are maintained in parallel — they share the same methodology core.

---

## Two Installers

SDAD-CC v3.0 ships with two separate installers:

| Installer | Purpose | When to run |
|-----------|---------|-------------|
| `install.sh` / `install.ps1` | Installs the methodology globally | Once per machine |
| `project-init.sh` / `project-init.ps1` | Initializes SDAD in a specific repo | Once per project |

The project initializer checks for the methodology automatically — if it is not
installed, it runs the methodology installer first.

---

## Part 1 — Methodology Installer

### Mac / Linux

Run from inside your project folder:

```bash
curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash
```

### Windows (PowerShell)

**Important — two safe options to avoid Execution Policy blocks:**

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

> **Why two options?** The classic `irm url | iex` pattern is flagged by Windows Defender
> and Execution Policy because it downloads and executes in a single pipeline step.
> Option A reads the script as a string first (no execution flag triggered).
> Option B downloads the file separately so it can be inspected before running.
> Either option works with Windows Defender, Bitdefender, and most corporate antivirus
> without requiring Administrator privileges or policy changes.

### What the installer does

1. Checks Node.js 18+ — installs if missing (via brew / apt / winget / nvm)
2. Checks Claude Code — installs via npm if missing
3. Installs `cc-status-line` — required context budget monitor
4. Checks git — initializes if missing
5. Downloads and copies all SDAD-CC files to your repo root
6. Handles existing CLAUDE.md — appends rather than overwrites
7. Preserves existing LESSON_LIBRARY.md if it has entries
8. Creates `.sdad/` directory structure
9. Updates `.gitignore` to exclude temp files

---

## Part 2 — Project Initializer

Run from inside the repo you want to initialize:

### Mac / Linux

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.sh)
```

### Windows (PowerShell)

**Option A — paste directly:**
```powershell
$init = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.ps1" -UseBasicParsing).Content
Invoke-Expression $init
```

**Option B — download first, then run:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.ps1" -OutFile "project-init.ps1"
powershell -ExecutionPolicy Bypass -File ".\project-init.ps1"
```

### What the project initializer does

1. Verifies SDAD-CC is installed — runs methodology installer automatically if not
2. Asks for: project name (inferred from folder), your name, compliance tier
3. Creates SDAD project structure:

| File / Folder | Purpose |
|--------------|---------|
| `SPEC.md` | Initialized with project metadata — populated by `$specout` |
| `LESSON_LIBRARY.md` | Ready for lesson entries — preserved if already exists |
| `.sdad/project.md` | Project registry with session log |
| `.sdad/flows/` | Folder for project-specific `$flow` commands |
| `.gitignore` update | Excludes `.sdad/agent_output.tmp` |

---

## Prerequisites

The installer handles these automatically, but for reference:

| Requirement | Why | How to check |
|-------------|-----|--------------|
| Node.js 18+ | Required by Claude Code | `node --version` |
| Claude Code CLI | The AI agent | `claude --version` |
| Claude Pro / Max / Team / Enterprise | Required to use Claude Code | claude.ai account |
| git initialized | SDAD-CC files versioned with your code | `git status` |
| cc-status-line | Context budget monitor | `npx cc-status-line@latest` |

---

## Kit File Overview

These files are installed into your repo root by the methodology installer:

| File installed as | Purpose |
|------------------|---------|
| `CLAUDE.md` | Core instructions — Claude reads this automatically |
| `SKILL_SDAD_METHODOLOGY.md` | Full phase logic and QA rules |
| `SKILL_AI_ARCHITECT.md` | Architecture decisions, LLM patterns |
| `SKILL_AI_ENGINEER.md` | Implementation quality, UI detection, docs |
| `SKILL_COMPLIANCE.md` | 3-tier compliance system |
| `LESSON_LIBRARY.md` | Team knowledge file — grows over time |

Human reference files (Install Guide, Usage Guide, Training doc) do not go into
the repo — keep them in your shared drive or team wiki.

---

## Manual Installation (if automated install is not available)

### Step 1 — Verify prerequisites

```bash
node --version      # must be v18 or higher
claude --version    # must be installed
git status          # must be inside a git repo
```

If Node.js is missing: https://nodejs.org
If Claude Code is missing: `npm install -g @anthropic-ai/claude-code`
If not in a git repo: `git init`

### Step 2 — Install cc-status-line

```bash
npm install -g cc-status-line
```

### Step 3 — Copy files to repo root

Download the kit files from https://github.com/diegomondrik/sdad-cc/tree/main/kit
and copy them with the correct names:

```bash
cp SDAD_CC_CLAUDE_MD_v3_0.md              CLAUDE.md
cp SDAD_CC_SKILL_SDAD_METHODOLOGY_v3_0.md SKILL_SDAD_METHODOLOGY.md
cp SDAD_CC_SKILL_AI_ARCHITECT_v3_0.md     SKILL_AI_ARCHITECT.md
cp SDAD_CC_SKILL_AI_ENGINEER_v3_0.md      SKILL_AI_ENGINEER.md
cp SDAD_CC_SKILL_COMPLIANCE_v3_0.md       SKILL_COMPLIANCE.md
cp SDAD_CC_LESSON_LIBRARY_v3_0.md         LESSON_LIBRARY.md
```

If your repo already has a CLAUDE.md, append instead of replacing:
```bash
echo "" >> CLAUDE.md
cat SDAD_CC_CLAUDE_MD_v3_0.md >> CLAUDE.md
```

### Step 4 — Create .sdad/ structure

```bash
mkdir -p .sdad/flows
touch .sdad/.gitkeep
echo ".sdad/agent_output.tmp" >> .gitignore
```

### Step 5 — Install User Preferences ($SM and $QA)

$SM and $QA are universal shortcuts that work in any Claude session.
This step is done once per Claude account.

1. Go to: https://claude.ai/settings/profile
2. Scroll to "Preferences"
3. Copy the entire content of `SDAD_USER_PREFERENCES_SNIPPET.md`
4. Paste into the Preferences field
5. Save

### Step 6 — Initialize your project

Run the project initializer or manually create:

```bash
# SPEC.md
echo "# SPEC — $(basename $PWD)" > SPEC.md
echo "Version: 0.1 | Date: $(date +%Y-%m-%d) | Status: Draft" >> SPEC.md

# LESSON_LIBRARY.md
echo "# LESSON LIBRARY" > LESSON_LIBRARY.md

# Project registry
echo "# SDAD-CC Project Registry" > .sdad/project.md
```

### Step 7 — Verify installation

Navigate to your repo and start Claude Code:

```bash
cd /path/to/your/repo
npx cc-status-line@latest   # in one terminal
claude                       # in another terminal
```

Run these checks inside the Claude Code session:

| Type this | Expected result |
|-----------|-----------------|
| `$sdad` | All 5 phases visible. Active skills listed. |
| `$skills` | 4 skills active, Compliance Reviewer listed as auto-activates on Tier 2/3 |
| `$spec` | First requirements question with a proposed default |
| `$pause` | Session state including Context Budget status |
| `$lesson` | "No entries yet" message |
| `$SM hello` | ⚡ SIMPLE MODE — prompt returned immediately |

---

## External Skills (optional — install inside Claude Code)

Run these commands inside a running `claude` session:

```bash
# Always relevant — frontend design, skill creator, MCP builder
/plugin install example-skills@anthropic-agent-skills

# REST/GraphQL API projects
npx skills add https://github.com/wshobson/agents --skill api-design-principles

# Python projects with performance requirements
npx skills add https://github.com/wshobson/agents --skill python-performance-optimization

# TDD discipline + structured debugging
/plugin marketplace add obra/superpowers

# LLM-intensive projects with complex context management
npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill context-engineering-advisor

# Complex MVP scope prioritization (Phase 1)
npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill prioritization-advisor

# Tier 2/3 — formal technical documentation
npx skills add https://github.com/supercent-io/skills-template --skill technical-writing
```

---

## Multi-Repo Setup

For teams working across multiple repos, each repo gets its own CLAUDE.md,
SPEC.md, and project initializer run. The LESSON_LIBRARY.md can be shared:

**Option A — Per-repo library:** Each repo has its own LESSON_LIBRARY.md.
Lessons are project-specific. Simple, no coordination needed.

**Option B — Shared library (recommended for teams):** Keep one canonical
LESSON_LIBRARY.md in a shared location (team wiki, shared drive, internal repo).
When the project initializer runs, it detects and preserves the existing file.
Sync accumulated lessons back to the shared copy periodically.

**Option C — Git submodule:** Add the shared library repo as a submodule.
Most robust for teams with active lesson accumulation.

---

## Upgrading from SDAD-CC v2.0

Run the methodology installer in the repo root — it detects existing files:
- `CLAUDE.md`: appends new content (with your approval)
- `LESSON_LIBRARY.md`: preserves if it has entries
- `SKILL` files: replaces with v3.0 versions
- `.sdad/`: creates if missing, preserves if already exists

Then run the project initializer for each active project:
- `SPEC.md`: preserved if exists
- `.sdad/project.md`: created if missing

Key changes from v2.0 to v3.0:
- Context Budget monitoring (50% / 65% thresholds) added to all sessions
- `cc-status-line` is now a required install, not optional
- Sub-agent delegation via `$agent` (automatic — no developer action required)
- New commands: `$verify`, `$flow`
- `$pause` now includes Context Budget status and flows count
- `.sdad/` directory structure required for flows and agent temp files

---

## Upgrading from SDAD v1.3 (Web UI)

SDAD-CC v3.0 is a parallel kit — it does not replace v1.3. Keep both.
Use v1.3 for web UI conversations, v3.0 for Claude Code sessions.

To migrate an existing project:
1. Run the methodology installer in the project's repo root
2. Run the project initializer — it will detect existing SPEC.md and preserve it
3. Start a Claude Code session — Phase 0 detects SPEC.md and restores state
4. Run `$pause` to confirm state was loaded correctly

Existing Lesson Libraries from v1.3 are fully compatible.

---

## API / Programmatic Use

For teams using the Anthropic API directly, paste CLAUDE.md content as the
system prompt. Store as a versioned config file in your repo.

```javascript
// system_prompt.js
const fs = require('fs');
const SDAD_SYSTEM = fs.readFileSync('./CLAUDE.md', 'utf-8');

const response = await anthropic.messages.create({
  model: 'claude-sonnet-4-20250514',
  system: SDAD_SYSTEM,
  messages: [{ role: 'user', content: userMessage }]
});
```

Treat CLAUDE.md as infrastructure code. Version it in Git alongside your codebase.

---

## Troubleshooting

**PowerShell blocks script execution**
→ Use Option A or B from the Windows install section above — do not use `irm | iex`
→ Option B lets you inspect the script before running it if your security policy requires it

**Antivirus blocks npm or the download**
→ The installer avoids download+execute in a single step for this reason
→ If the antivirus still blocks: download each kit file manually from
  https://github.com/diegomondrik/sdad-cc/tree/main/kit and copy per the manual steps

**"$sdad not recognized" after installation**
→ Verify CLAUDE.md is in the repo root (not in a subfolder)
→ Verify you started `claude` from inside the repo directory

**Installer fails to download files**
→ Check internet connection
→ Verify the diegomondrik/sdad-cc repo is public
→ Use manual installation steps above

**Node.js installed but not found after installer runs**
→ Restart your terminal / PowerShell session
→ Re-run the installer — it will detect Node.js correctly after restart

**Claude Code installed but `claude` command not found**
→ Run: `npm install -g @anthropic-ai/claude-code`
→ On Mac/Linux: check that npm global bin is in your PATH
→ On Windows: restart PowerShell after installation

**cc-status-line not showing**
→ Make sure you run `npx cc-status-line@latest` before starting `claude`, not after
→ It must run in a separate terminal from the one running Claude Code

**$build blocked after 65% context warning**
→ This is expected behavior — run `$pause`, note your state, start a new session
→ All SDAD commands except $build remain available to wrap up cleanly

---

G7 AI Development Methodology | SDAD-CC Installation Guide | v3.0
Spec-Driven AI Development for Claude Code
