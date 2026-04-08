# G7 SDAD — Install Guide (Web UI Edition)
# Spec-Driven AI Development for Claude Web
# Version 3.1 | 2026

---

## What is SDAD Web

SDAD Web is the G7 Spec-Driven AI Development methodology edition designed
for the Claude web interface (claude.ai). It requires no terminal, no software
installation, and no paid Claude subscription.

Designed for:
- Functional users and analysts getting started with AI-assisted development
- Junior developers on the G7 team
- Anyone working with Claude in the browser

---

## Requirements

- A claude.ai account (free or paid — both work)
- Access to **Claude Projects** (available on the free plan)
- No terminal. No npm. No git. No installation.

---

## Kit Structure

The SDAD Web v3.1 kit has 5 files:

| File | Role | Where it goes |
|------|------|---------------|
| `SDAD_WEB_PROJECT_INSTRUCTIONS.md` | Methodology core | Project Instructions |
| `SDAD_WEB_SHORTCUTS.md` | Command reference and usage guide | Project Knowledge |
| `SDAD_WEB_INSTALL_GUIDE.md` | This guide | Project Knowledge |
| `SDAD_USER_PREFERENCES_SNIPPET.md` | $SM and $QA shortcuts | User Preferences |
| `SDAD_LESSON_LIBRARY_v3_0.md` | Lesson library | Project Knowledge |

---

## Setup in 4 Steps

### Step 1 — Create the Claude Project

1. Open [claude.ai](https://claude.ai)
2. In the sidebar, click **"Projects"**
3. Click **"New Project"**
4. Give it a descriptive name: `[Client] — [Project Name]`

> One Project per product. Don't mix different projects in the same Claude Project.

---

### Step 2 — Set up Project Instructions

1. Inside the Project, click **"Project Instructions"**
2. Copy the full content of `SDAD_WEB_PROJECT_INSTRUCTIONS.md`
3. Paste into the instructions field
4. Save

> If you already had instructions there, replace them completely with the v3.1 content.

---

### Step 3 — Load files into Project Knowledge

**Kit files that go here:**
1. `SDAD_WEB_SHORTCUTS.md`
2. `SDAD_WEB_INSTALL_GUIDE.md`
3. `SDAD_LESSON_LIBRARY_v3_0.md`

**Project files you add over time:**
4. `SPEC.md` — generated with $specout, updated each sprint
5. Flows defined with $flow (added as you create them)
6. Technical documents generated with $doc

**How to upload:**
1. Inside the Project, click **"Add content"** or the file icon
2. Choose **"Upload files"**
3. Upload files one by one

---

### Step 4 — Configure User Preferences

User Preferences are global — they apply to all Claude conversations, not just this Project.
This enables the `$SM` and `$QA` power shortcuts everywhere.

1. Click your avatar in the top-right corner
2. Go to **Settings → Profile**
3. Find the **User preferences** field
4. Copy the content of `SDAD_USER_PREFERENCES_SNIPPET.md`
5. Paste at the **end** of the field (append — do not replace existing content)
6. Save

> If you already have $SM and $QA from a previous SDAD version: replace that block
> with the v3.1 snippet. The $QA command now has a Documentation layer (6 layers total)
> and $SM now includes a confirmation loop after delivering the prompt.

---

## Verify the Setup

After completing all four steps:

1. Open a new conversation inside your Project
2. Type `$sdad` and send
3. Claude should respond with the methodology overview and command list

If you see the expected response, you're ready to build.

---

## Differences from SDAD-CC (Claude Code)

| Capability | SDAD-CC | SDAD Web |
|------------|---------|---------|
| Filesystem access | ✅ Direct | ❌ — everything via copy-paste |
| Test execution | ✅ Real | ❌ — Claude describes expected results |
| Sub-agents ($agent) | ✅ Real (isolated context) | 🔄 Simulated (isolated analysis in session) |
| $verify with lock files | ✅ Reads package.json/poetry.lock | 🔄 Training lag warning + changelog link |
| $flow | ✅ Filesystem (.sdad/flows/) | 🔄 Copy-paste blocks → Project Knowledge |
| DECISIONS.md | ✅ Written automatically per increment | ❌ Not applicable — no filesystem |
| cc-status-line | ✅ Real-time status bar | ❌ — threshold messages instead |
| Context Budget visibility | ✅ cc-status-line | ✅ Messages at 50% and 65% |
| Compliance Tiers | ✅ Full | ✅ Full |
| $qa auto/review | ✅ Applies fixes directly | ✅ Proposes fixes (copy-paste) |
| Lesson Capture | ✅ Writes directly to repo | ✅ Generates copy-paste block |
| $doc / $docfinal | ✅ Writes to repo | ✅ Generates copy-paste blocks |
| Session Snapshot | ✅ $pause compress | ✅ $pause compress |

---

## How to Update SDAD Web

**To update from v3.0 to v3.1:**
1. In Project Instructions: replace content with `SDAD_WEB_PROJECT_INSTRUCTIONS.md`
2. In Project Knowledge: replace `SDAD_WEB_SHORTCUTS_v3_0.md` with `SDAD_WEB_SHORTCUTS.md`
3. In Project Knowledge: replace this Install Guide with `SDAD_WEB_INSTALL_GUIDE.md`
4. In User Preferences: replace the $SM/$QA block with `SDAD_USER_PREFERENCES_SNIPPET.md`
5. Keep your project files as-is (SPEC.md, LESSON_LIBRARY.md — no changes needed)

Key changes in v3.1:
- $build guardrails: explicit handling when SPEC.md is missing
- $QA now has 6 layers — Documentation layer added (was 5)
- $qa full vs $QA distinction now clearly documented
- $SM Phase 6 feedback loop added
- $agent commands marked as simulated in Web UI throughout
- Lesson Capture correctly documented as copy-paste block (not direct write)
- $pause output format aligned with SDAD-CC

---

## Frequently Asked Questions

**Can I use SDAD Web with Claude's free plan?**
Yes. All SDAD Web v3.1 functionality works with free Claude.
The only limitation is the free plan's daily message limit.

**What if the session ends before I run $pause compress?**
Start the session with $pause — Claude reconstructs state from SPEC.md in Project Knowledge.

**Can I use SDAD Web and SDAD-CC on the same project?**
Yes. They are compatible — SPEC.md is shared between both. Use SDAD-CC when you
have terminal access, SDAD Web when working from the browser.

**Do I need to fully replace my previous SDAD Web version?**
Yes. Replace Project Instructions and the kit files in Project Knowledge.
Your project files (SPEC.md, LESSON_LIBRARY.md) are kept as-is.

**How do I share the kit with another team member?**
Share the 5 kit files. Each person does their own setup on their Claude account.

---

G7 AI Development Methodology | SDAD Web Install Guide | v3.1
Spec-Driven AI Development — Web UI Edition
