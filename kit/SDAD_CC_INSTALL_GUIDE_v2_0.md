# G7 SDAD-CC — Installation & Setup Guide
# Spec-Driven AI Development for Claude Code
# Version 2.0 | 2025

---

## What is SDAD-CC

SDAD-CC is the Claude Code edition of the G7 Spec-Driven AI Development methodology.
It is designed for developers who use Claude Code (the CLI agent) as their primary
AI development tool. Unlike the web UI version (v1.3), SDAD-CC eliminates all
copy/paste rituals by leveraging Claude Code's direct filesystem and terminal access.

If you are using Claude on the web UI (claude.ai), use SDAD v1.3 instead.
Both kits are maintained in parallel — they share the same methodology core.

---

## Quick Install (recommended)

The installer handles all prerequisites and file setup automatically.

### Mac / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash
```

### Windows (PowerShell — run as Administrator)
```powershell
irm https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1 | iex
```

**What the installer does:**
1. Checks Node.js 18+ — installs if missing (via brew / apt / winget / nvm)
2. Checks Claude Code — installs via npm if missing
3. Checks git — initializes if missing
4. Downloads and copies all SDAD-CC files to your repo root
5. Handles existing CLAUDE.md — appends rather than overwrites
6. Preserves existing LESSON_LIBRARY.md if it has entries
7. Opens Claude settings and copies User Preferences snippet to clipboard
8. Prints external skill commands ready to copy

**Run from inside your project folder:**
```bash
cd my-project/
curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash
```

---

## Prerequisites

The installer handles these automatically, but for reference:

| Requirement | Why | How to check |
|-------------|-----|--------------|
| Node.js 18+ | Required by Claude Code | `node --version` |
| Claude Code CLI | The AI agent | `claude --version` |
| Claude Pro / Max / Team / Enterprise | Required to use Claude Code | claude.ai account |
| git initialized | SDAD-CC files are versioned with your code | `git status` |

---

## Kit File Overview

These files are installed into your repo root by the installer:

| File installed as | Source file | Purpose |
|------------------|-------------|---------|
| `CLAUDE.md` | `SDAD_CC_CLAUDE_MD_v2_0.md` | Core instructions — Claude reads this automatically |
| `SKILL_SDAD_METHODOLOGY.md` | `SDAD_CC_SKILL_SDAD_METHODOLOGY_v2_0.md` | Full phase logic and QA rules |
| `SKILL_AI_ARCHITECT.md` | `SDAD_CC_SKILL_AI_ARCHITECT_v2_0.md` | Architecture decisions, LLM patterns |
| `SKILL_AI_ENGINEER.md` | `SDAD_CC_SKILL_AI_ENGINEER_v2_0.md` | Implementation quality, UI detection, docs |
| `SKILL_COMPLIANCE.md` | `SDAD_CC_SKILL_COMPLIANCE_v2_0.md` | 3-tier compliance system |
| `LESSON_LIBRARY.md` | `SDAD_CC_LESSON_LIBRARY_v2_0.md` | Team knowledge file — grows over time |

Human reference files (Install Guide, Usage Guide, Training doc) do not go into
the repo — keep them in your shared drive or team wiki.

---

## Manual Installation (if automated install is not available)

Follow these steps if you cannot run the installer script.

### Step 1 — Verify prerequisites

```bash
node --version      # must be v18 or higher
claude --version    # must be installed
git status          # must be inside a git repo
```

If Node.js is missing: https://nodejs.org
If Claude Code is missing: `npm install -g @anthropic-ai/claude-code`
If not in a git repo: `git init`

### Step 2 — Copy files to repo root

Download the kit files from https://github.com/diegomondrik/sdad-cc/tree/main/kit
and copy them with the correct names:

```bash
cp SDAD_CC_CLAUDE_MD_v2_0.md          CLAUDE.md
cp SDAD_CC_SKILL_SDAD_METHODOLOGY_v2_0.md  SKILL_SDAD_METHODOLOGY.md
cp SDAD_CC_SKILL_AI_ARCHITECT_v2_0.md      SKILL_AI_ARCHITECT.md
cp SDAD_CC_SKILL_AI_ENGINEER_v2_0.md       SKILL_AI_ENGINEER.md
cp SDAD_CC_SKILL_COMPLIANCE_v2_0.md        SKILL_COMPLIANCE.md
cp SDAD_CC_LESSON_LIBRARY_v2_0.md          LESSON_LIBRARY.md
```

If your repo already has a CLAUDE.md, append instead of replacing:
```bash
echo "" >> CLAUDE.md
cat SDAD_CC_CLAUDE_MD_v2_0.md >> CLAUDE.md
```

### Step 3 — Install User Preferences ($SM and $QA)

$SM and $QA are universal shortcuts that work in any Claude session.
This step is done once per Claude account.

1. Go to: https://claude.ai/settings/profile
2. Scroll to "Preferences"
3. Copy the entire content of `SDAD_USER_PREFERENCES_SNIPPET_v1_3.md`
4. Paste into the Preferences field
5. Save

These preferences apply globally — they work in the web UI, Claude Code,
and any other Claude interface on your account.

### Step 4 — Verify installation

Navigate to your repo and start Claude Code:

```bash
cd /path/to/your/repo
claude
```

Run these checks inside the Claude Code session:

| Type this | Expected result |
|-----------|-----------------|
| `$sdad` | All 5 phases visible. Active skills: AI Architect, AI Engineer, Security Reviewer, QA Engineer |
| `$skills` | 4 skills active by default, Compliance Reviewer listed as auto-activates on Tier 2/3 |
| `$spec` | First requirements question with a proposed default |
| `$pause` | Session state: reads SPEC.md if exists, shows git log summary |
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

For teams working across multiple repos, each repo gets its own CLAUDE.md and
SPEC.md. The LESSON_LIBRARY.md can be shared:

**Option A — Per-repo library:** Each repo has its own LESSON_LIBRARY.md.
Lessons are project-specific. Simple, no coordination needed.

**Option B — Shared library (recommended for teams):** Keep one canonical
LESSON_LIBRARY.md in a shared location (team wiki, shared drive, internal repo).
When a new project starts, the installer detects and preserves the existing file.
Sync accumulated lessons back to the shared copy periodically.

**Option C — Git submodule:** Add the shared library repo as a submodule.
Most robust for teams with active lesson accumulation.

---

## Upgrading from SDAD v1.3 (Web UI)

SDAD-CC v2.0 is a parallel kit — it does not replace v1.3. Keep both.
Use v1.3 for web UI conversations, v2.0 for Claude Code sessions.

To migrate an existing project:
1. Run the installer in the project's repo root
2. Copy SPEC.md to the repo root if not already there
3. Start a Claude Code session — Phase 0 detects SPEC.md and restores state
4. Run `$pause` to confirm state was loaded correctly

Existing Lesson Libraries from v1.3 are fully compatible — the installer
preserves them automatically if they have content.

---

## Upgrading from SDAD-CC v1.x

Run the installer in the repo root — it detects existing files and handles
the upgrade correctly:
- CLAUDE.md: appends new content (with your approval)
- LESSON_LIBRARY.md: preserves if it has entries
- SKILL files: replaces with v2.0 versions

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

**CLAUDE.md exists but $sdad commands don't respond**
→ Open CLAUDE.md and verify the SDAD-CC content was appended correctly
→ If it's only your original content, run `cat SDAD_CC_CLAUDE_MD_v2_0.md >> CLAUDE.md`

---

G7 AI Development Methodology | SDAD-CC Installation Guide | v2.0
Spec-Driven AI Development for Claude Code
