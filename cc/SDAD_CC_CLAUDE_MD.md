# G7 SDAD-CC — CLAUDE.md
# Spec-Driven AI Development for Claude Code
# Paste this file content into CLAUDE.md at the root of your repository.
# Version 3.1 | 2026

---

## Core Rules
- Never write production code before the user approves a Spec.
  Exception: $docfinal operates without a Spec — it generates one retroactively.
- Always follow: Context Analysis → Requirements → Spec → Build → QA.
- Claude Code has direct filesystem and terminal access — use it.
  Read actual files. Run actual tests. Write directly to the repo. Never simulate what you can execute.

---

## Environment
DIRECT WRITE: yes — always. Claude Code writes files directly to the repo.
State is always the actual filesystem + SPEC.md + git log.

---

## Context Budget

MONITORING: Estimate context usage after every response, starting from Phase 0.

AT 50% — ⚠️ SOFT WARNING (informational, continue normally):
  "⚠️ CONTEXT ~50%: Sesión extendida. Podés continuar — considerá iniciar
   sesión nueva al completar este incremento."

AT 65% — 🔴 HARD WARNING (action required):
  "🔴 CONTEXT ~65%: Bloqueando $build al terminar el incremento en curso.
   Al finalizar: ejecutá $pause, guardá el estado, e iniciá sesión nueva."
  → Finish the current increment fully (including tests and $qa).
  → Block any new $build until session is restarted.
  → $pause, $spec, $verify, $lesson, $doc, $flow remain available.

RULES:
- Emit context warnings only at the defined thresholds — never otherwise.
- Hard warning never interrupts mid-increment — always finish cleanly.
- Sub-agents launched via $agent run in isolated context — they do not consume the main session budget.

---

## Sub-Agent Delegation ($agent — automatic)

Delegate automatically when ALL three conditions are true:
  1. The task operates on files already committed to the filesystem.
  2. The task does not require knowledge of decisions made in this session.
  3. The task is expensive in context (doc generation, architectural review, test suite generation).

Always delegate:  $doc (all variants) · $agent review · $agent test · $agent audit
Never delegate:   $qa after $build · $spec / $specout · $build

EXECUTION:
  claude --print "[system context + isolated task]" > .sdad/agent_output.tmp
  Read .sdad/agent_output.tmp and incorporate the result. Delete temp file after.
  WHEN agent_output.tmp is empty or missing → surface error to developer, do not proceed silently.
  Developer sees only the final result — sub-agent mechanics are silent.

---

## Active AI Skills

Always active:
- AI Solutions Architect — architecture decisions, LLM integration, cost modeling
- AI Engineer — implementation quality, tooling, CI/CD, developer experience, UI stack detection
- Security Reviewer — API key exposure, injection, PII, auth vulnerabilities
- QA Engineer — test coverage, DoD compliance, acceptance criteria

Auto-activated by tier: Compliance Reviewer (Tier 2/3).
Use $skills to view details or activate additional specialist skills.

---

## Compliance Tiers

Tier is detected in Phase 0 and confirmed in Phase 1.
Claude recommends a tier based on repo context — developer confirms or overrides.

TIER 1 — STANDARD
  For: internal tools, POCs, productivity scripts, personal projects
  Auto-activates: nothing
  DoD additions: none

TIER 2 — BUSINESS
  For: customer-facing products, SaaS, apps handling user data
  Auto-activates: Compliance Reviewer
  DoD additions: audit logging present, PII handling documented, auth reviewed, sanitized errors
  SPEC.md additions: §9 expanded with data classification and retention policy

TIER 3 — ENTERPRISE / REGULATED
  For: cloud deployments to corporate IT, healthcare, finance, government, ISO/SOC2
  Auto-activates: Compliance Reviewer (full profile) + relevant regulation-specific skill
  DoD additions: threat model documented, data flow diagram present, control matrix in SPEC.md
  SPEC.md additions: §9 mandatory full security and compliance section
  External skills: add gdpr-compliance, hipaa-compliance, or soc2-compliance as applicable
  $build is blocked until SPEC.md §9 is complete and approved.

TIER DETECTION (Phase 0, automatic):
- Payment integration, health data, government → recommend Tier 3
- User accounts, external data, client deployment → recommend Tier 2
- Internal script, no user data, no external exposure → recommend Tier 1
Always confirm with developer in Phase 1 before locking tier.

---

## External Skills
# Developer reference — does not affect Claude behavior.
# Install with: npx skills add <source> --skill <skill-name>
#
# Always relevant:
#   api-design-principles     (wshobson/agents)
#   frontend-design           (/plugin install example-skills@anthropic-agent-skills)
#   skill-creator             (/plugin install example-skills@anthropic-agent-skills)
#   mcp-builder               (/plugin install example-skills@anthropic-agent-skills)
#
# Conditional on stack:
#   python-performance-optimization  (wshobson/agents)
#   systematic-debugging             (/plugin marketplace add obra/superpowers)
#   test-driven-development          (/plugin marketplace add obra/superpowers)
#
# Conditional on project type:
#   context-engineering-advisor  (deanpeters/Product-Manager-Skills)
#   prioritization-advisor       (deanpeters/Product-Manager-Skills)
#
# Conditional on compliance tier:
#   technical-writing  (supercent-io/skills-template)
#   webapp-testing     (/plugin install example-skills@anthropic-agent-skills)
#   gdpr-compliance / hipaa-compliance / soc2-compliance  (see INSTALL_GUIDE.md)

---

## Commands

**$sdad** — Show SDAD-CC methodology overview: phases, descriptions, command list.

**$spec** (or $spec [section]) — Phase 1: Guided Requirements.
ONE question at a time with proposed default.
Order: scope, user flows, data model, integrations, business rules,
performance, security, compliance tier, testing.
Before asking, read existing files in the repo — infer what is already defined.
COMPLIANCE QUESTION (always ask, never skip):
  "What's the deployment context?
   (1) Internal tool / POC — Tier 1 Standard
   (2) Customer-facing product / SaaS — Tier 2 Business
   (3) Regulated environment / corporate IT / cloud enterprise — Tier 3 Enterprise
   Based on what I see in this repo, I recommend: [Tier N — reason]"
  Lock the tier on confirmation. Activate tier-specific skills and DoD immediately.
Suggest $specout when all areas are covered.

**$specout** — Phase 2: Generate full 13-section Spec Document.
Sections: Vision & Objective, Users & Roles, Functional Flows, Data Model,
Technical Architecture, Business Rules, Integrations & APIs, Testing Strategy,
Security & Compliance (depth depends on tier), Definition of Done,
Out of Scope, Open Decisions,
AI Authorship Log (Increment / Feature / Model Used / Date / Notes).
After generating, write the Spec to SPEC.md in the repo root automatically.
For Tier 2/3: §9 Security & Compliance is mandatory and must be complete before approval.
For Tier 3: §9 must be complete and approved before $build is allowed.
Ask for approval before allowing $build.

**$build** (or $build [feature]) — Phase 3: Guided Development.
Require approved SPEC.md.
WHEN SPEC.md not found: read the repo, then offer $spec or $docfinal — do not proceed to build.
WHEN no test command found (no package.json test script / Makefile / pyproject.toml): flag before writing code.
Blocked if Context Budget hard warning (65%) was triggered — inform developer.
Before each increment announce:

  🔨 INCREMENT [N]: [feature name]
  Files: [list of files to create or modify]
  Tests: [unit / integration / E2E — will be executed after writing]
  Docs: [README update / API doc / inline comments required]
  Dependencies: [what must be done first]
  ──────────────────────────────────────
  [Wait for approval, then write code, then run tests immediately]

After writing code for an increment:
1. Run the project's test command. Report actual result — pass count, failures, errors.
2. If tests fail: fix before proceeding. Do not trigger $qa on broken tests.
3. Update README and inline API docs as part of the increment — not as a separate step.
4. Update SPEC.md Section 13 (AI Authorship Log) with this increment's entry.
5. Append one entry to DECISIONS.md (see DECISIONS LOG below).
6. Trigger $qa auto for the increment.

Flag any Spec deviation before implementing:
"⚠️ This would deviate from SPEC.md at [section]. Update Spec first or proceed?"

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
  # Format: one entry per increment or significant decision.
  # Generated and maintained automatically by SDAD-CC.

Entry numbering is sequential across the project lifetime (D-001, D-002...).
Read existing DECISIONS.md before writing — never reset numbering.

**$verify** (or $verify [library@version]) — Dependency Documentation Check.
Reads lock file (package-lock.json, poetry.lock, etc.) for exact versions.
Runs automatically at the start of any $build that introduces a new dependency.

  $verify              → check all dependencies in the current project
  $verify [library]    → check a specific library
  $verify [lib@ver]    → check a specific version

WHEN Context 7 MCP is active: use it to fetch current documentation.
WHEN Context 7 MCP is not active: emit per library checked:
  "⚠️ VERIFY [library@version]: Sin confirmación de documentación actualizada.
   Training lag puede ser 6-12 meses. Verificá: [link to official changelog]"
Flag any method or pattern known to be deprecated in the detected version.

**$qa** — Phase 4: Incremental QA Review.

  $qa         → AUTO mode
  $qa review  → REVIEW mode (manual approval per finding)
  $qa full    → alias for $QA (full project audit, SDAD-Aware)

AUTO MODE:
- Run all QA layers for active tier silently.
- Security (P0/P1/P2), Compliance (Tier 2/3), Spec deviations: always surface for explicit human approval. Never auto-fix.
- Structure / Efficiency / Best Practices / DoD / Docs "must fix" or "should improve": apply directly, show unified diff, ask for single confirmation.
- Style suggestions: apply directly without asking.
- After all auto-fixes: "Confirm these changes? (yes / revert all)"
- Then trigger Lesson Capture.

REVIEW MODE:
- Full report, all layers, findings numbered H-01, H-02...
- No fix applied without explicit per-finding approval.
- Close with: "Which fixes would you like me to apply?"
- Then trigger Lesson Capture.

Both modes: number findings H-01, H-02... reading DECISIONS.md and prior QA logs to continue from last used number.
Mark P0 security findings with 🚨 — surface first regardless of layer.
Mark compliance violations with 🔒 — surface immediately after P0 findings.
Distinguish: "must fix" / "should improve" / "style suggestion".

QA LAYERS — ALL TIERS:
  🔐 Security (P0/P1/P2) — new vulnerabilities introduced?
  🏗️ Structure — consistent with SPEC.md architecture?
  ⚡ Efficiency — token waste, unnecessary API calls, latency?
  ✅ Definition of Done — all DoD criteria from SPEC.md met?
  📄 Documentation — README updated? API docs present? Inline comments adequate?
  🧪 Functional Coverage — happy path / edge cases / error paths /
     boundary conditions / Spec business rules. Regression risk?

QA LAYERS — TIER 2 ADDITIONS:
  🔒 Compliance (Business) — PII handled correctly? Audit logging present?
     Auth reviewed? Error messages safe (no stack traces to users)?

QA LAYERS — TIER 3 ADDITIONS:
  🔒 Compliance (Enterprise) — all Tier 2 checks plus:
     Regulatory controls per SPEC.md §9 met for this increment?
     Data residency respected? Access control model followed?
     Encryption at rest/in transit implemented where required?

LESSON CAPTURE (automatic, after fixes are confirmed or declined):
Trigger only when a finding involved:
- a non-obvious root cause that took more than one attempt to identify
- an environment, compliance, or platform-specific behavior not in the Spec
- a wrong assumption about external data, API, or regulatory requirement
- an architectural or prompt pattern that significantly simplified the solution

If triggered, propose ONE entry (most valuable finding only):
  📚 LESSON CANDIDATE — [short title]
  Category: [LLM Design | Architecture | Data & Debugging | Environment | Workflow]
  Signal: [one line — how would another dev recognize this applies to them?]
  Principle: [one transferable sentence]

  Add to Lesson Library? (yes / skip / edit)

If yes: write the full L-XX entry directly to LESSON_LIBRARY.md.
If nothing is lesson-worthy: skip silently — never mention it.

**$agent** — Sub-Agent Delegation. Delegation is automatic per policy above.

  $agent review [module]  → architectural review of a specific module
  $agent test [module]    → generate test suite for an existing module
  $agent audit [path]     → standalone security audit of a file or folder

Output written to .sdad/agent_output.tmp, incorporated silently, then deleted.

**$doc** — Technical Documentation Generator. Delegates to sub-agent automatically.

  $doc            → generate full documentation set
  $doc readme     → update README.md
  $doc api        → generate or update API reference
  $doc arch       → generate architecture document
  $doc compliance → generate compliance summary (Tier 2/3 only — warns if Tier 1)

All $doc outputs written directly to /docs in the repo.

**$docfinal** — Retroactive Documentation. For projects built without SDAD.
No Spec required. Infers everything from the codebase. Runs 4 steps in sequence.

  $docfinal         → run all 4 steps (default)
  $docfinal spec    → Step 1 only
  $docfinal log     → Step 2 only
  $docfinal qa      → Step 3 only
  $docfinal lessons → Step 4 only

STEP 1 — RETROACTIVE SPEC:
Read the entire codebase. Write SPEC_RETROACTIVE.md to repo root (never overwrite SPEC.md).
Include only sections reliably inferred from code:
  §1 Vision & Objective, §2 Users & Roles, §3 Functional Flows, §4 Data Model,
  §5 Technical Architecture, §9 Security & Compliance, §11 Out of Scope, §12 Open Decisions.
Skip §6, §7, §8, §10.

STEP 2 — AI AUTHORSHIP LOG:
Generate §13 table — one row per detected module or feature (not per file).
  Increment / Feature / Model Used: "Pre-SDAD / unknown" / Date (from git log) / Notes
Append to SPEC_RETROACTIVE.md.

STEP 3 — QA STANDALONE AUDIT:
Full $QA Standalone mode. All layers: Security (P0/P1/P2), Structure, Efficiency,
Best Practices, Documentation. Mark P0 findings with 🚨. Number H-01, H-02...
Do NOT apply any fixes — report only.
Close with: "Which fixes would you like me to apply? (H-XX or 'all' or 'none')"
Proceed to Step 4 regardless of fix decision.

STEP 4 — LESSON CANDIDATES:
Evaluate QA findings and full codebase. Propose up to 3 lesson candidates.
For each: title / Category / Signal / Principle / Add to Lesson Library? (yes / skip / edit)
If approved: write entry directly to LESSON_LIBRARY.md.

COMPLETION:
  📋 $docfinal complete
  - SPEC_RETROACTIVE.md written to repo root
  - AI Authorship Log: [N features documented]
  - QA findings: [N total — X critical, Y improvements]
  - Lessons captured: [N added to LESSON_LIBRARY.md]
  Run '$spec' to begin a forward-looking Spec, or '$qa' to start the fix cycle.

**$flow** — Project Flow Manager.

  $flow [name]       → define a new flow for this project
  $flow list         → list all flows in .sdad/flows/
  $flow [name] run   → execute a saved flow
  $flow [name] edit  → update an existing flow

Flow definitions stored as markdown in .sdad/flows/[name].md.
Each file contains: description, steps, expected output, last run date.

**$lesson** — Lesson Library management.
  $lesson            → show all entries grouped by category
  $lesson [keyword]  → filter by keyword, category, or stack
  $lesson [L-XX]     → show full entry
  $lesson new        → guided entry creation — writes to LESSON_LIBRARY.md on approval

**$pause** — Show current state.
  Current Phase | Spec Status | Compliance Tier | Context Budget %
  Last increment + test result | Open QA findings (H-XX) | Active Skills
  Decisions log: [N entries — last entry title and date]
  Flows defined: [N] | Next step recommendation

**$skills** — Show active and available AI specialist skills.
  Always active: AI Solutions Architect, AI Engineer, Security Reviewer, QA Engineer.
  Auto-activated by tier: Compliance Reviewer (Tier 2/3).
  Available manually: Performance Architect, Prompt Engineer.

**$sdad** — Show methodology overview and all commands.

---

## Behavior Rules

- Read actual files before asking questions — never ask what you can infer.
- Run actual tests after every $build increment — never skip execution.
- Write SPEC.md to the repo on $specout — never keep the Spec only in chat.
- Write lesson entries to LESSON_LIBRARY.md directly — never ask user to paste.
- Ask the compliance tier question in Phase 1 — never skip it.
- Activate Compliance Reviewer automatically on Tier 2/3 confirmation.
- Ask one question at a time in $spec — never present a questionnaire.
- Always propose a default — interrupt only when data cannot be inferred.
- Announce increments before coding — never skip the announcement.
- Include docs update in every $build increment announcement.
- Mark critical security issues with 🚨 regardless of current phase.
- Mark compliance violations with 🔒 regardless of current phase.
- Distinguish clearly: "must fix" / "should improve" / "style suggestion".
- Lesson capture is silent when nothing is worth capturing — never force an entry.
- $qa auto never touches security, compliance, or Spec deviations without human approval.
- Update SPEC.md §13 after every completed increment.
- In Phase 0, detect UI presence and suggest frontend-design skill if applicable.
- $agent delegation is automatic — never ask developer which tasks to delegate.
- $verify runs automatically when $build introduces a new dependency.
- $pause always includes Context Budget status, Decisions log count, and flows defined count.
- Write DECISIONS.md entry automatically after each completed increment.
- Before session end or $pause, resolve any entries with Commit: "pending commit" using git log.

---

## Required Environment Tool

cc-status-line provides a real-time status bar: model, context %, session cost, git branch.
Install automatically via the SDAD-CC installer, or run manually:

```bash
npx cc-status-line@latest
```

Use as primary context budget indicator — shows the same 50% / 65% thresholds.

---

## Complementary Tools
# Developer reference — does not affect Claude behavior.
#
# Warp              AI-native terminal                        https://warp.dev
# Context 7 MCP     Up-to-date API docs (eliminates lag)      /plugin → "Context 7"
# Sequential Thinking MCP  Chain-of-thought reasoning         type "please install sequential thinking MCP"
# Happy Engineering  Remote Claude Code control (mobile)      https://happy.engineering
#
# Note: when Context 7 MCP is active, $verify uses it automatically.

---

G7 AI Development Methodology | SDAD-CC CLAUDE.md | v3.1
Spec-Driven AI Development for Claude Code
