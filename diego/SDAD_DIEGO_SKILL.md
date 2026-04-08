# SKILL: SDAD-Diego — Spec-Driven AI Development (Personal Edition)
# Reference file — consulted by Claude when deeper phase detail is needed.
# Commands and activation rules live in Project Instructions.
# Version 3.1 | 2026

## What is SDAD-Diego

SDAD-Diego is a personal development methodology for Diego's projects.
It wraps SDAD-CC v3.1 with Diego's infrastructure context — secrets management,
Python environment, QBO auth, and project registry — so every project starts
with full context and closes with updated documentation.

SDAD-Diego applies to any type of project: Python scripts, automations, web apps,
data analysis, APIs, or anything else. SDAD-CC v3.1 phases (1–4) are always available
and activate automatically when development begins.

Core principle: Claude knows Diego's infrastructure from day one.
Diego never explains it twice.

---

## Compliance Tiers

SDAD-Diego uses three compliance tiers. Detected in Phase 0, confirmed in Phase 1.

TIER 1 — STANDARD
  For: internal tools, POCs, personal automations, learning projects
  Additional skills: none
  DoD additions: none

TIER 2 — BUSINESS
  For: customer-facing products, SaaS, apps handling user data
  Additional skills: Compliance Reviewer (auto-activated)
  DoD additions: audit logging present, PII handling documented, auth reviewed,
                 sanitized error messages (no stack traces exposed to users)

TIER 3 — ENTERPRISE / REGULATED
  For: regulated environments, corporate IT, healthcare, finance, government
  Additional skills: Compliance Reviewer (full profile)
  DoD additions: threat model documented, data flow diagram present,
                 control matrix in SPEC.md
  $build is blocked until SPEC.md §9 is complete and approved.

TIER DETECTION (Phase 0, automatic):
- Payment integration, health data, government → recommend Tier 3
- User accounts, external data, client deployment → recommend Tier 2
- Internal script, no user data, no external exposure → recommend Tier 1
Always confirm with Diego in Phase 1 before locking tier.

---

## Phase Definitions

### PHASE 0 — Context Ingestion (automatic)

Triggered when user describes a project or shares documents.

Output block format:
  📋 CONTEXT ANALYSIS
  - System objective:      [what it does and for whom]
  - Users / actors:        [who interacts with it]
  - Inferred tech stack:   [languages, frameworks, services]
  - Critical ambiguities:  [ranked list of blocking unknowns]
  - Recommended AI Skills: [list with one-line justification]
  - Recommended compliance tier: Tier N — [one-line reason]
  🎨 UI detected: recommend activating frontend-design skill [if applicable]

LESSON LIBRARY CHECK (automatic, silent — run after CONTEXT ANALYSIS block):
- If LESSON_LIBRARY_DIEGO.md or LESSON_LIBRARY.md is present: scan for relevance
  to the inferred stack. Surface up to 3 entries after the CONTEXT ANALYSIS block.
  Format: [L-XX] [title] — [why this applies here]
- If neither is present: skip silently.

Phase 0 immediately triggers Phase 0.5 automatically.

---

### PHASE 0.5 — Infra Declaration (automatic, silent — runs after Phase 0)

Triggered automatically after Phase 0. No user action required.
Claude reads all infra docs present in project knowledge and emits:

  🏗️ INFRA DECLARATION
  Stack detected:       [Python local / QBO / web / DB / other — based on infra docs present]
  Credentials ready:    [list of secrets in infra_SECRETS.md usable for this project]
  Credentials needed:   [new secrets this project will likely require]
  Infra docs loaded:    [list of infra_*.md files found in knowledge]
  Registry entry:       [automation name if found in automatizaciones_registry.md, or "new project"]
  Context budget:       [cc-status-line active? yes / not detected]
  ─────────────────────────────────────────────────────────
  Ready. Describe what you want to build or run $spec to start requirements.

Rules:
- Never ask Diego questions during Phase 0.5 — infer everything from the docs.
- If an infra doc is missing that the stack clearly needs, flag it with:
  "⚠️ infra_XXXXX.md not found — will proceed without it."
- If automatizaciones_registry.md is present, check if a similar automation already exists
  and surface it: "Similar project found: [name] — review before building."

---

### PHASE 1 — Guided Requirements ($spec)

One question at a time with proposed defaults.
Coverage: scope → user flows → data model → integrations → business rules →
          performance → compliance tier → security → testing.
Before asking, read existing SPEC.md — infer what is already defined.
Compliance tier question is mandatory — never skip.
Suggest $specout when all areas are covered.

COMPLIANCE QUESTION (always ask, never skip):
  "What's the deployment context for this project?
   (1) Internal tool / POC — Tier 1 Standard
   (2) Customer-facing product / SaaS — Tier 2 Business
   (3) Regulated environment / corporate IT — Tier 3 Enterprise
   Based on what I see, I recommend: [Tier N — one-line reason]"
  Lock the tier on confirmation. Activate tier-specific skills and DoD immediately.

---

### PHASE 2 — Spec Document ($specout)

13-section structure including AI Authorship Log.
Output as copy-paste block ready to save as SPEC.md.
For Tier 2/3: §9 Security & Compliance is mandatory and must be complete before approval.
For Tier 3: §9 must be complete and approved before $build is allowed.
Ask for approval before allowing $build.

---

### PHASE 3 — Guided Development ($build)

CONTEXT BUDGET (active in all sessions):
- At 50%: ⚠️ soft warning — inform Diego, continue normally.
- At 65%: 🔴 hard warning — finish current increment, block $build, prompt new session.

WHEN SPEC.md not found: ask what is available, offer $spec or $docfinal — do not proceed to build.

INFRA INTEGRATION (automatic during $build):
- All new scripts must use secrets_helper.py for credentials. Never hardcode.
- New scripts follow the folder structure in infra_PYTHON_LOCAL.md.
- Logging pattern follows the standard defined in infra_PYTHON_LOCAL.md.
- If a new credential is needed: announce it in the increment block before writing code.
- $verify runs automatically when $build introduces a new dependency.

INCREMENT block format:
  🔨 INCREMENT [N]: [feature name]
  Files: [list]
  Tests: [unit / integration / E2E]
  Docs: [README update / inline comments required]
  Dependencies: [what must be done first]
  New credentials needed: [list or "none"]
  ──────────────────────────────────────
  [waits for approval before writing code]

SPEC DEVIATION FLAG:
"⚠️ This would deviate from SPEC.md at [section]. Update the Spec first or proceed?"

DIRECT WRITE in SDAD-Diego: always "no" for local Windows projects.
Diego runs the code on his machine — Claude delivers files as copy-paste blocks.
Delivery Checkpoint is mandatory after every $build session.

DRIFT WARNING: at session start when the project already has history, emit:
  ⚠  Drift check: do the files on your machine reflect all changes from the last session?

---

### PHASE 4 — QA & Review ($qa / $QA)

Three modes:
  $qa        → auto mode (default)
  $qa review → manual mode — full report, per-finding approval
  $qa full   → full project audit in SDAD-Aware mode

AUTO MODE behavior:
- Security findings (P0/P1/P2): always surface for explicit approval. Never auto-apply.
- Compliance findings (Tier 2/3): always surface for explicit approval. Never auto-apply.
- Spec deviation findings: always surface for explicit approval. Never auto-apply.
- Structure / Efficiency / Best Practices / DoD / Docs "must fix" or "should improve":
  propose fix with clear diff, ask for single confirmation.
- Style suggestions: apply directly showing the change.
- After fixes: "Applied N changes. Confirm? (yes / revert all)"

Both modes: number findings H-01, H-02... reading DECISIONS.md and prior QA logs
to continue from last used number.

QA LAYERS — ALL TIERS:
  🔐 Security (P0/P1/P2)
  Diego Security additions:
    - All credentials via secrets_helper.py? (no hardcoded values)
    - Token files (.json) excluded from version control?
    - .env excluded from version control?
    - New secrets added to the catalog in secrets_manager.py?
  🏗️ Structure — consistent with SPEC.md architecture?
  ⚡ Efficiency — token waste, unnecessary API calls, latency?
  ✅ Definition of Done — all DoD criteria from SPEC.md met?
  📄 Documentation — README / RUNBOOK updated? Inline comments adequate?
  🧪 Functional Coverage — happy path / edge cases / error paths / regression risk?

QA LAYERS — TIER 2 ADDITIONS:
  🔒 Compliance (Business) — PII handled? Audit logging? Auth reviewed? Safe errors?

QA LAYERS — TIER 3 ADDITIONS:
  🔒 Compliance (Enterprise) — all Tier 2 plus regulatory controls, encryption, access control.

Lesson Capture: automatic after each $qa — propose ONE entry if lesson-worthy.
Skip silently if nothing is worth capturing.

---

### PHASE 5 — Project Close ($close) ← Diego-specific

Triggered when user writes $close.
Generates all updated documentation so Diego can overwrite files on his machine.

$close runs a guided checklist in this order:

STEP 1 — Code QA confirmation
  "Has $qa been run on the final code? (yes / run it now)"
  If not run: trigger $qa before continuing.

STEP 2 — Updated infra docs
  Generate updated versions of every infra doc that changed during this project:
  - infra_SECRETS.md — add new credentials to the "Usada en" table and catálogo
  - infra_PYTHON_LOCAL.md — add this project to "Usada en", update anything new
  - infra_QBO_AUTH.md — only if QBO was used; add lessons learned
  - Any new infra_XXXXX.md if a new integration was built

  For each file, output:
    📄 [filename] — updated
    [full file content ready to overwrite]

STEP 3 — Registry entry
  Generate the complete block for automatizaciones_registry.md.
  Output:
    📄 automatizaciones_registry.md — new entry
    [block ready to paste]

STEP 4 — secrets_manager.py update
  If new credentials were added: output the updated SECRETS_CATALOG dict.
  Output:
    🔑 secrets_manager.py — SECRETS_CATALOG update
    [updated dict block ready to paste]

STEP 5 — Lesson Library
  Evaluate all findings from this project's $qa sessions.
  Propose up to 2 lesson entries (most valuable only).
  Same format as standard Lesson Capture.

STEP 6 — Close summary
  Output:
    ✅ PROJECT CLOSE — [project name] — [date]
    Files to overwrite on your machine:
      - [file 1] → [path on machine]
      - [file 2] → [path on machine]
    New secrets to add in secrets_manager.py: [list or "none"]
    Lessons proposed: [count or "none"]
    Re-upload to this Claude project: [list of files that changed]

---

## $docfinal — Retroactive Documentation

Triggered when user writes $docfinal. For projects built without SDAD.
No Spec required. Infers everything from code shared in the conversation.

  $docfinal         → run all 4 steps in sequence (default)
  $docfinal spec    → Step 1 only
  $docfinal log     → Step 2 only
  $docfinal qa      → Step 3 only
  $docfinal lessons → Step 4 only

STEP 1 — RETROACTIVE SPEC:
Generate SPEC_RETROACTIVE.md. Include only sections reliably inferable:
  §1, §2, §3, §4, §5, §9, §11, §12. Skip §6, §7, §8, §10.

STEP 2 — AI AUTHORSHIP LOG:
Generate §13 table — one row per detected module or feature. Append to SPEC_RETROACTIVE.md.

STEP 3 — QA STANDALONE AUDIT:
Full audit. All layers including Diego-specific security checks.
Mark P0 with 🚨. Number H-01, H-02... Do NOT apply any fixes.
Close: "Which fixes would you like me to apply? (H-XX or 'all' or 'none')"
Proceed to Step 4 regardless of fix decision.

STEP 4 — LESSON CANDIDATES:
Propose up to 3 lesson candidates.
If approved: generate copy-paste block for LESSON_LIBRARY_DIEGO.md.

RULES:
- Never overwrites SPEC.md — output file is always SPEC_RETROACTIVE.md.
- QA step never applies fixes — report only.
- Proposes up to 3 lesson candidates (vs 1 in standard $qa).

---

## $infra — Infra Status

Shows current infra state based on docs in project knowledge:

  🏗️ INFRA STATUS
  Secrets catalog:    [N secrets — list keys]
  Python env:         [OS, base path, libraries used in this project]
  QBO:                [connected / not used — app name, company ID if connected]
  Automations:        [N registered — list names and status]
  Infra docs loaded:  [list]
  Last updated:       [date from each doc's "Usada en" table]

---

## $nuevo — Project Start

Triggered when user writes $nuevo, OR automatically when a new conversation
starts in a SDAD-Diego project and the user describes a project.

Actions (all silent, no questions):
1. Run Phase 0 (Context Ingestion) — including UI detection and Lesson Library check
2. Run Phase 0.5 (Infra Declaration)
3. Output both blocks
4. Wait for user to describe what they want to build or run $spec

$nuevo never asks setup questions. It infers everything from the knowledge files.

---

## $pause compress — Session Snapshot

Generated when user runs $pause compress.
Compact state block for pasting at the start of the next conversation.

Includes:
- Current phase
- Spec status per section
- Compliance tier
- Completed increments summary
- Open QA findings (H-XX)
- Open decisions
- AI Authorship Log summary
- Lesson Library summary (N new entries — titles)
- Active skills
- Context budget %
- Flows defined
- Exact next step

When a Session Snapshot is detected at conversation start: acknowledge it and restore
all state without asking Diego to re-explain anything.

---

## Command Summary

| Command | Origin | Phase | What it does |
|---------|--------|-------|--------------|
| $nuevo | Diego | 0+0.5 | Silent project start — context + infra declaration |
| $infra | Diego | Any | Show current infra status |
| $close | Diego | 5 | Guided project close — generates all updated docs |
| $spec | SDAD-CC | 1 | Guided requirements — one question at a time |
| $specout | SDAD-CC | 2 | Generate 13-section Spec Document |
| $build | SDAD-CC | 3 | Vertical increment development (blocked at 65% context) |
| $verify | SDAD-CC | 3 | Check dependency documentation currency |
| $qa | SDAD-CC | 4 | Incremental QA review (auto mode) + Lesson Capture |
| $qa review | SDAD-CC | 4 | Manual QA — per-finding approval |
| $qa full | SDAD-CC | Any | Full project audit in SDAD-Aware mode |
| $QA | SDAD-CC | Any | Full project audit — SDAD-Aware or Standalone (User Preferences) |
| $docfinal | SDAD-CC | Any | Retroactive documentation for pre-SDAD projects |
| $agent review | SDAD-CC | Any | Architectural review via sub-agent |
| $agent test | SDAD-CC | Any | Test suite generation via sub-agent |
| $agent audit | SDAD-CC | Any | Security audit via sub-agent |
| $doc | SDAD-CC | Any | Generate documentation from SPEC.md + codebase |
| $doc compliance | SDAD-CC | Any | Compliance summary (Tier 2/3 only) |
| $flow [name] | SDAD-CC | Any | Define repeatable project sequence |
| $flow list | SDAD-CC | Any | List all flows defined |
| $flow [name] run | SDAD-CC | Any | Execute a saved flow |
| $lesson | SDAD-CC | Any | Lesson Library management |
| $pause | SDAD-CC | Any | Session state + context budget % |
| $pause compress | SDAD-CC | Any | Generate Session Snapshot for next session |
| $skills | SDAD-CC | Any | View and manage AI specialist skills |
| $SM / $S | SDAD-CC | Any | Prompt construction (User Preferences) |

---

## Diego's Infrastructure — Reference

### Base path
C:\Users\diego\Documents\Cowork\

### File ownership defaults (local Windows projects)
ENVIRONMENT:     local Windows
DIRECT WRITE:    no — Claude delivers files as copy-paste blocks, Diego runs them on his machine
SOURCE OF TRUTH: C:\Users\diego\Documents\Cowork\
DEPLOY:          manual — copy files to machine, run from CMD

### Credentials system
All credentials via secrets_helper.py. Never hardcoded.
Service name in Windows Credential Manager: G7_Automatizaciones
Add new credentials: run infra\secrets_manager.py → option 3

### Logging pattern (all Python scripts)
============================================================
  NOMBRE DEL PROCESO
============================================================
[ 1/N ] Descripción del paso...
✓ Éxito  /  ⚠ Advertencia  /  ✗ Error
============================================================
  ✓ PROCESO COMPLETADO
============================================================

### ngrok (OAuth only)
Account: diegomondrik
Fixed domain: nonmultiplicational-tonically-odilia.ngrok-free.dev
Command: ngrok http --url=nonmultiplicational-tonically-odilia.ngrok-free.dev 8080
Only needed for initial auth or re-auth. Not needed for normal script runs.

### Folder structure for new automations
C:\Users\diego\Documents\Cowork\
└── [category_folder]\
    └── [project_name]\
        ├── [main_script].py
        ├── requirements.txt
        └── RUNBOOK.md
