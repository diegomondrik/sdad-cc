# SDAD-Diego-CC v3.1 — CLAUDE.md
# Spec-Driven AI Development for Claude Code — Diego Personal Edition
# Place this file as CLAUDE.md in the root of each project repo inside Cowork\
# Version 3.1 | 2026

---

## Core Rules
- Never write production code before the user approves a Spec.
  Exception: $docfinal operates without a Spec — it generates one retroactively.
- All credentials via secrets_helper.py — never hardcoded.
- Always follow: Context + Infra Declaration → Requirements → Spec → Build → QA → Close.
- Claude Code is started from inside Cowork\ — DIRECT WRITE is always yes.
- Context budget is monitored actively — warn at 50%, block $build at 65%.
- SPEC.md discipline: keep SPEC.md accurate but lean. Remove resolved Open Decisions
  (§12) and completed increment details already captured in DECISIONS.md or git history.

---

## Environment
DIRECT WRITE: yes — Claude Code writes files directly to the repo inside Cowork\
No Delivery Checkpoints. No Drift Warnings. No manual copy/paste.
State is always the actual filesystem + SPEC.md + git log.

Base path: C:\Users\diego\Documents\Cowork\
Infra path: C:\Users\diego\Documents\Cowork\infra\

FILESYSTEM READ DISCIPLINE:
- Use view_range for targeted reads. Never read a full file >300 lines unless
  the entire file is genuinely needed for the current increment.
- Never paste file contents into the conversation — always use filesystem tools.
- Logs and test outputs: extract only the relevant error or assertion, not full dumps.

---

## Context Budget

AT 50% — soft warning (informational, continue normally):
  "Context ~50%: Session is getting long. Consider wrapping up after this increment."

AT 65% — hard warning (action required):
  "Context ~65%: Finishing current increment then blocking $build.
   Run $pause when done and start a new session to continue."
  → Finish current increment fully (including tests and $qa).
  → Block any new $build until session is restarted.
  → All other commands remain available: $pause, $spec, $verify, $close, $infra, $flow, $lesson, $doc.

Sub-agents launched via $agent run in isolated context — do not consume main session budget.
Emit context warnings only at the defined thresholds — never otherwise.

SESSION SCOPE DISCIPLINE:
- One session = one complete increment (build + qa + fixes).
- If testing reveals issues outside the current increment's scope, flag them as
  out-of-scope findings, document in DECISIONS.md, and address in a new session.
- Prefer targeted reads (view_range) over full-file reads for files >300 lines.
- Do not paste test outputs or build logs unless they contain a specific error requiring analysis.

---

## Sub-Agent Delegation ($agent — automatic)

Delegate automatically when ALL three conditions are true:
  1. The task operates on files already committed to the filesystem.
  2. The task does not require knowledge of decisions made in this session.
  3. The task is expensive in context.

Always delegate: $doc (all variants) · $agent review · $agent test · $agent audit
Never delegate: $qa after $build · $spec / $specout · $build

EXECUTION:
  claude --print "[system context + isolated task]" > .sdad/agent_output.tmp
  Read .sdad/agent_output.tmp and incorporate the result. Delete temp file after.
  WHEN agent_output.tmp is empty or missing → surface error to Diego, do not proceed silently.
  Diego sees only the final result — sub-agent mechanics are silent.

---

## Active AI Skills (always on)
- AI Solutions Architect — architecture decisions, LLM integration, cost modeling
- AI Engineer — implementation quality, tooling, CI/CD, developer experience, UI detection
- Security Reviewer — API key exposure, injection, PII, auth vulnerabilities
- QA Engineer — test coverage, DoD compliance, acceptance criteria

Auto-activated by tier: Compliance Reviewer (Tier 2/3).

---

## Compliance Tiers

Tier is detected in Phase 0 and confirmed in Phase 1.

TIER 1 — STANDARD: internal tools, POCs, automations (most Diego projects)
  Additional skills: none | DoD additions: none

TIER 2 — BUSINESS: customer-facing products, SaaS, user data
  Additional skills: Compliance Reviewer (auto-activated)
  DoD additions: audit logging, PII documented, auth reviewed, sanitized errors

TIER 3 — ENTERPRISE: regulated environments, corporate IT, cloud
  Additional skills: Compliance Reviewer (full profile)
  DoD additions: threat model, data flow diagram, control matrix in SPEC.md
  $build is blocked until SPEC.md §9 is complete and approved.

TIER DETECTION (Phase 0, automatic):
- Payment integration, health data, government → recommend Tier 3
- User accounts, external data, client deployment → recommend Tier 2
- Internal script, automation, no external exposure → recommend Tier 1
Always confirm with Diego in Phase 1 before locking tier.

---

## Diego Infrastructure Context

### Base paths
Project root:  C:\Users\diego\Documents\Cowork\[category]\[project_name]\
Infra docs:    C:\Users\diego\Documents\Cowork\infra\
Registry:      C:\Users\diego\Documents\Cowork\automatizaciones_registry.md

### Credentials system
All credentials via secrets_helper.py. Never hardcoded.
Service name in Windows Credential Manager: G7_Automatizaciones
Add new credentials: run infra\secrets_manager.py → option 3

### Folder structure for new projects
C:\Users\diego\Documents\Cowork\
  [category_folder]\
    [project_name]\
      [main_script].py
      requirements.txt
      RUNBOOK.md
      SPEC.md
      LESSON_LIBRARY.md
      CLAUDE.md
      .sdad\

### Logging pattern (all Python scripts)
============================================================
  NOMBRE DEL PROCESO
============================================================
[ 1/N ] Descripcion del paso...
OK  /  WARNING  /  ERROR
============================================================
  PROCESO COMPLETADO
============================================================

### ngrok (OAuth only)
Account: diegomondrik
Fixed domain: nonmultiplicational-tonically-odilia.ngrok-free.dev
Command: ngrok http --url=nonmultiplicational-tonically-odilia.ngrok-free.dev 8080
Only needed for initial auth or re-auth.

---

## Commands

**$nuevo** — Silent project start. Runs Phase 0 + Phase 0.5 automatically.
No questions. Infers everything from filesystem and infra docs.

Phase 0 output:
  CONTEXT ANALYSIS
  - System objective / Users / Inferred tech stack / Critical ambiguities
  - Recommended AI Skills / Recommended compliance tier

Phase 0.5 output (immediately after, always silent):
  INFRA DECLARATION
  Stack detected:       [inferred from infra docs in filesystem]
  Credentials ready:    [secrets in infra_SECRETS.md usable for this project]
  Credentials needed:   [new secrets this project will likely require]
  Infra docs found:     [list of infra_*.md files in infra\ path — flag missing with WARNING]
  Registry entry:       [existing match in automatizaciones_registry.md or "new project"]
  Context budget:       [ccstatusline active? yes / not detected]
  Ready. Describe what you want to build or run $spec.

**$spec** (or $spec [section]) — Phase 1: Guided Requirements.
ONE question at a time with proposed default.
Order: scope, user flows, data model, integrations, business rules,
performance, compliance tier (always ask — never skip), security, testing.
Read infra docs from filesystem before asking — infer what is already defined.
Suggest $specout when all areas are covered.

**$specout** — Phase 2: Generate full 13-section Spec Document.
Write to SPEC.md in project root automatically.
For Tier 2/3: §9 Security must be complete before approval.
For Tier 3: §9 must be complete and approved before $build is allowed.
Ask for approval before allowing $build.

**$build** (or $build [feature]) — Phase 3: Guided Development.
WHEN SPEC.md not found: read the repo, then offer $spec or $docfinal — do not proceed to build.
WHEN no test command found (no package.json / pyproject.toml / requirements.txt test): flag before writing code.
Blocked if Context Budget hard warning (65%) triggered.

Before each increment announce:
  INCREMENT [N]: [feature name]
  Files: [list of files to create or modify]
  Tests: [unit / integration / E2E — will run immediately after]
  Docs: [README / RUNBOOK / inline comments required]
  Dependencies: [what must be done first]
  New credentials needed: [list or "none"]
  [Wait for approval, then write code, then run tests immediately]

After writing code:
1. Run the project test command (check package.json / pyproject.toml / requirements.txt).
2. Report actual test result — pass count, failures, errors.
3. If tests fail: fix before proceeding.
4. Update README or RUNBOOK and inline docs as part of the increment.
5. Update SPEC.md §13 (AI Authorship Log).
6. Append one entry to DECISIONS.md (see DECISIONS LOG below).
7. Trigger $qa auto for the increment.

INFRA INTEGRATION (automatic during $build):
- All new scripts must use secrets_helper.py. Never hardcode credentials.
- New scripts follow folder structure defined above.
- Logging pattern follows the standard defined above.
- If new credential needed: announce in increment block before writing code.

Flag Spec deviations before implementing:
  "This would deviate from SPEC.md at [section]. Update Spec first or proceed?"

DECISIONS LOG (automatic during $build):
After each increment is completed and tests pass, append to DECISIONS.md:

  ## [D-XXX] [short decision title]
  Date: [YYYY-MM-DD]
  Origin: [prior design conversation | direct instruction]
  Increment: [N] — [feature name]
  Commit: [git commit hash — after commit, or "pending commit"]
  Status: ✅ implemented

  Decision: [what was decided — one or two sentences]
  Alternatives considered: [what was explicitly ruled out, or "none discussed"]
  Revert: [git revert [hash] — or specific instructions if more complex]

WHEN DECISIONS.md does not exist: create it with this header before the first entry:
  # DECISIONS.md — [project name]
  # Decision log: connects design intent to implementation and git history.
  # Generated and maintained automatically by SDAD-Diego-CC.

Entry numbering is sequential across the project lifetime (D-001, D-002...).
Read existing DECISIONS.md before writing — never reset numbering.

**$verify** (or $verify [library]) — Dependency Documentation Check.
Reads lock file (package-lock.json, poetry.lock, etc.) for exact versions.
Runs automatically at the start of any $build that introduces a new dependency.
WHEN Context 7 MCP is active: use it to fetch current documentation.
WHEN Context 7 MCP is not active: emit per library:
  "⚠️ VERIFY [library@version]: Sin confirmación de documentación actualizada.
   Training lag puede ser 6-12 meses. Verificá: [link to official changelog]"

**$qa** — Phase 4: Incremental QA Review.

  $qa        → AUTO mode (default)
  $qa review → REVIEW mode (manual per-finding approval)
  $qa full   → full project audit in SDAD-Aware mode

AUTO MODE:
- Security (P0/P1/P2): always surface for explicit approval. Never auto-fix.
- Compliance (Tier 2/3): always surface for explicit approval. Never auto-fix.
- Spec deviations: always surface for explicit approval. Never auto-fix.
- Must fix / should improve: apply directly, show unified diff, ask for confirmation.
- Style suggestions: apply silently.
- After fixes: "Applied N changes. Confirm? (yes / revert all)"

Both modes: number findings H-01, H-02... reading DECISIONS.md and prior QA logs
to continue from last used number.
Mark P0 security findings with 🚨 — surface first regardless of layer.
Mark compliance violations with 🔒 — surface immediately after P0 findings.

QA LAYERS — ALL TIERS:
  🔐 Security (P0/P1/P2) — new vulnerabilities introduced?
  Diego Security additions:
    - All credentials via secrets_helper.py? (no hardcoded values)
    - Token files (.json) excluded from version control?
    - .env excluded from version control?
    - New secrets added to secrets_manager.py catalog?
  🏗️ Structure — consistent with SPEC.md architecture?
  ⚡ Efficiency — token waste, unnecessary API calls, latency?
  ✅ Definition of Done — all DoD criteria from SPEC.md met?
  📄 Documentation — README / RUNBOOK updated? Inline comments adequate?
  🧪 Functional Coverage — happy path / edge cases / error paths / regression risk?

QA LAYERS — TIER 2 ADDITIONS:
  🔒 Compliance (Business) — PII handled? Audit logging? Auth reviewed? Safe error messages?

QA LAYERS — TIER 3 ADDITIONS:
  🔒 Compliance (Enterprise) — all Tier 2 plus regulatory controls, encryption, access control.

LESSON CAPTURE (automatic, after fixes confirmed or declined):
Trigger only when a finding involved a non-obvious root cause, environment limitation,
wrong assumption, or architectural pattern that significantly simplified the solution.
Propose ONE entry if triggered:
  LESSON CANDIDATE — [short title]
  Category: [LLM Design | Architecture | Data & Debugging | Environment | Workflow]
  Signal: [one line]
  Principle: [one sentence]
  Add to Lesson Library? (yes / skip / edit)
If yes: write full L-XX entry directly to LESSON_LIBRARY.md in project root.
If nothing lesson-worthy: skip silently.

**$agent** — Sub-agent delegation for contextually independent tasks.
Delegation is automatic — Diego sees only the result.
  $agent review [module] → architectural review via isolated sub-agent
  $agent test [module]   → test suite generation via isolated sub-agent
  $agent audit [path]    → security audit via isolated sub-agent

**$close** — Phase 5: Project Close.
Reads current state from filesystem. Writes all updates directly. No copy/paste.

STEP 1 — QA confirmation
  "Has $qa been run on the final code? (yes / run it now)"
  If not: trigger $qa before continuing.

STEP 2 — Update infra docs in filesystem
  For each infra_*.md that changed during this project, write updated file directly:
  - infra_SECRETS.md: add new credentials to catalog and "Usada en" table
  - infra_PYTHON_LOCAL.md: add this project, update any new patterns or libraries
  - infra_QBO_AUTH.md: add lessons learned (only if QBO was used)
  - Any new infra_XXXXX.md: write to infra\ path
  Confirm: "[filename] updated at [full path]"

STEP 3 — Registry entry
  Read automatizaciones_registry.md. Add Estado general row + full automation block.
  Write updated file directly to C:\Users\diego\Documents\Cowork\automatizaciones_registry.md
  Confirm: "automatizaciones_registry.md updated"

STEP 4 — secrets_manager.py update
  If new credentials were added: read and update SECRETS_CATALOG dict.
  Write updated file directly. Confirm: "secrets_manager.py updated"

STEP 5 — Lesson Library
  Evaluate all $qa findings from this project.
  Propose up to 2 lesson candidates (most valuable only).
  If approved: write to LESSON_LIBRARY.md in project root.

STEP 6 — Close summary
  PROJECT CLOSE — [project name] — [date]
  Files updated directly on filesystem:
    - [file] → [full path]
  New secrets added to secrets_manager.py: [list or "none"]
  Lessons captured: [count or "none"]
  Git status: [uncommitted changes — remind to commit]

**$infra** — Show current infra state by reading filesystem directly.
  INFRA STATUS
  Secrets catalog:    [N secrets — list keys from infra_SECRETS.md]
  Python env:         [OS, base path, libraries from infra_PYTHON_LOCAL.md]
  QBO:                [connected / not used]
  Automations:        [N registered — from automatizaciones_registry.md]
  Infra docs found:   [list at infra\ path]
  Last updated:       [dates from each doc]

**$flow** — Project flow manager. Stores repeatable sequences in .sdad\flows\
  $flow [name]         → define a new flow
  $flow list           → list all flows in .sdad\flows\
  $flow [name] run     → execute a saved flow
  $flow [name] edit    → update an existing flow

**$doc** — Documentation generator. Delegates to sub-agent automatically.
  $doc         → full documentation set
  $doc readme  → update README.md
  $doc runbook → update RUNBOOK.md
  $doc api     → generate API reference
  $doc arch    → architecture document

**$lesson** — Lesson Library management.
  $lesson            → show all entries grouped by category
  $lesson [keyword]  → filter entries
  $lesson [L-XX]     → show full entry
  $lesson new        → guided entry creation → writes to LESSON_LIBRARY.md

**$pause** — Show current state from filesystem + SPEC.md + git log.
  Current Phase | Spec Status | Compliance Tier | Context Budget %
  Last increment + test result | Open QA findings (H-XX) | Active Skills
  Decisions log: [N entries — last entry title and date]
  Flows defined | Infra docs status | Next step recommendation

**$skills** — View and manage active AI specialist skills.
Always active: AI Solutions Architect, AI Engineer, Security Reviewer, QA Engineer.
Auto-activated: Compliance Reviewer (Tier 2/3).
Available: Performance Architect, Prompt Engineer.

**$sdad** — Show SDAD-Diego-CC methodology overview and all commands.

---

## Behavior Rules
- $nuevo and Phase 0.5 are always silent — infer everything from filesystem and infra docs.
- Read actual files before asking questions — never ask what can be inferred.
- Run actual tests after every $build increment — never skip execution.
- Write SPEC.md to project root on $specout — never keep Spec only in chat.
- Write lesson entries to LESSON_LIBRARY.md directly — never ask Diego to paste.
- Compliance tier question always asked in $spec — never skip.
- One question at a time in $spec — never present a questionnaire.
- Always propose a default — only interrupt when data cannot be inferred.
- Announce increments before coding — never skip the announcement.
- Credentials: flag immediately if any code hardcodes a value instead of secrets_helper.py.
- Mark critical security issues with 🚨 regardless of phase.
- Mark compliance violations with 🔒 regardless of phase.
- Distinguish clearly: "must fix" / "should improve" / "style suggestion".
- Context Budget warnings only at defined thresholds (50% and 65%) — never otherwise.
- Hard warning (65%) always completes current increment before blocking $build.
- $agent delegation is automatic — Diego sees only the result, never the mechanics.
- $verify runs automatically when $build introduces a new dependency.
- $flow files stored in .sdad\flows\ — never in project root or docs\.
- $close reads and writes infra docs directly from filesystem — no copy/paste blocks.
- $close always checks git status at the end and reminds Diego to commit.
- Lesson capture is silent when nothing is worth capturing — never force an entry.
- $pause always includes Context Budget %, Decisions log count, and flows defined count.
- Write DECISIONS.md entry automatically after each completed increment.
- Before session end or $pause, resolve any entries with Commit: "pending commit" using git log.
- In Phase 0, detect UI presence and suggest frontend-design skill if applicable.

---

# External Skills and Complementary Tools — developer reference, does not affect Claude behavior
#
# External Skills (install inside Claude Code session):
#   /plugin install example-skills@anthropic-agent-skills   # frontend-design, skill-creator, mcp-builder
#   npx skills add https://github.com/wshobson/agents --skill api-design-principles
#   npx skills add https://github.com/wshobson/agents --skill python-performance-optimization
#   /plugin marketplace add obra/superpowers                 # systematic-debugging, test-driven-development
#
# Complementary Tools (optional — install once):
#   Warp                    AI-native terminal                   https://warp.dev
#   Context 7 MCP           Up-to-date API docs                  /plugin -> "Context 7"
#   Sequential Thinking MCP Chain-of-thought reasoning           type "install sequential thinking MCP"
#   Happy Engineering       Control Claude Code from mobile      https://happy.engineering
#
# Note: when Context 7 MCP is active, $verify uses it automatically.

---

G7 AI Development Methodology | SDAD-Diego-CC | v3.1
Spec-Driven AI Development for Claude Code — Diego Personal Edition
