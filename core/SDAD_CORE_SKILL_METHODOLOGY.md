# SKILL: SDAD-CC — Spec-Driven AI Development for Claude Code
# Reference file — place in repo root alongside CLAUDE.md.
# Commands and activation rules live in CLAUDE.md.
# Version 3.1 | 2026

## What is SDAD-CC
SDAD-CC is the Claude Code adaptation of the G7 Spec-Driven AI Development methodology.
It preserves the core discipline — spec before code, vertical increments, integrated QA —
while leveraging Claude Code's direct filesystem and terminal access to eliminate all
copy/paste rituals.

In SDAD-CC, Claude reads real files, runs real tests, and writes directly to the repo.
The Spec lives in SPEC.md in version control. The Lesson Library lives in LESSON_LIBRARY.md
and is updated by Claude directly. DECISIONS.md captures every architectural decision,
linked to the git commit that implemented it. State is always the actual codebase.

**Key differences from SDAD Web UI:**

| SDAD Web UI                        | SDAD-CC v3.1 (Claude Code)                        |
|------------------------------------|---------------------------------------------------|
| Delivery Checkpoint required       | Eliminated — Claude writes directly               |
| Drift Warning at session start     | Eliminated — Claude reads actual files            |
| Session Snapshot / $pause compress | Eliminated — SPEC.md + git log + DECISIONS.md is state |
| Tests generated but not run        | Tests run immediately after each build            |
| Lesson Library updated manually    | Claude writes to LESSON_LIBRARY.md directly       |
| SPEC.md saved manually             | Claude writes SPEC.md to repo on $specout         |
| No DECISIONS.md                    | DECISIONS.md written automatically after each $build |
| $agent simulated                   | $agent launches real isolated sub-agents          |
| $verify without lock files         | $verify reads package-lock.json / poetry.lock     |

---

## Phase Definitions

### PHASE 0 — Context Ingestion (automatic)
Triggered when a developer opens a session or describes a project.

Actions:
- Read existing files in the repo (package.json, requirements.txt, existing src/, README.md)
- Read SPEC.md if it exists — restore state from it without asking
- Read DECISIONS.md if it exists — surface last decision and count
- Read LESSON_LIBRARY.md if it exists — surface relevant lessons
- Detect compliance tier signals (see SDAD_CORE_SKILL_COMPLIANCE.md)
- Detect UI presence for frontend-design skill suggestion (see SDAD_CORE_SKILL_AI_ENGINEER.md)
- Output context analysis block

Output format:
  📋 CONTEXT ANALYSIS
  - System objective:      [inferred from files or described]
  - Users / actors:        [inferred]
  - Inferred tech stack:   [from dependency files]
  - Existing structure:    [summary of what is already built]
  - Recommended compliance tier: [Tier N — one-line reason based on signals detected]
  - Critical ambiguities:  [ranked, only genuine blockers]
  - Active AI Skills: AI Architect, AI Engineer, Security Reviewer, QA Engineer
  - Recommended additional skills: [if any, with one-line justification]
  [🎨 UI detected note if applicable — from AI Engineer skill]

LESSON LIBRARY CHECK (automatic, silent — run after output block):
- If LESSON_LIBRARY.md exists: scan entries for relevance to inferred stack.
  Surface up to 3 relevant entries:

  📚 Relevant lessons from the library:
  [L-XX] [title] — [one line: why this applies here]

- If LESSON_LIBRARY.md is missing: note it once, then continue.
  "LESSON_LIBRARY.md not found. Will create it when the first lesson is captured."

---

### PHASE 1 — Guided Requirements ($spec)
One question at a time. Always propose a reasonable default.
Read existing repo files before asking — never ask what can be inferred from code.

Coverage sequence:
  1. Scope & MVP boundaries — what is explicitly OUT
  2. Critical user flows — happy path + most important edge case
  3. Data model — core entities and relationships
  4. Integrations — external APIs, auth, third-party services
  5. Business rules — validations, limits, special conditions
  6. Performance & scale — concurrent users, data volume
  7. Compliance tier — always ask, never skip (see below)
  8. Security — sensitive data, auth model, threat surface
  9. Documentation needs — README only, or client deliverable docs?
  10. Testing strategy — coverage targets, test types, CI requirements

COMPLIANCE TIER QUESTION (mandatory — always ask in Phase 1):
  "What's the deployment context for this project?
   (1) Internal tool / POC — Tier 1 Standard [security basics only]
   (2) Customer-facing product / SaaS — Tier 2 Business [user data, auth, audit logging]
   (3) Regulated environment / corporate IT / cloud enterprise — Tier 3 Enterprise [full compliance]
   Based on what I see: I recommend Tier [N] because [one-line reason].
   Confirm or override?"

On confirmation:
- Tier 1: no action beyond defaults
- Tier 2: activate Compliance Reviewer, expand SPEC.md §9 requirements
- Tier 3: activate Compliance Reviewer (full), require SPEC.md §9 complete before $build,
  ask which regulation applies (GDPR / HIPAA / SOC2 / ISO 27001 / PCI-DSS / other)

After each answer, acknowledge briefly and ask the next question.
Suggest $specout when all areas are sufficiently covered.

---

### PHASE 2 — Spec Document ($specout)
Generate using this exact 13-section structure, then write to SPEC.md in repo root.

  # SPEC — [Project Name]
  Version: 1.0 | Date: [date] | Status: Draft
  ## 1. Vision & Objective
  ## 2. Users & Roles
  ## 3. Functional Flows
  ## 4. Data Model
  ## 5. Technical Architecture
  ## 6. Business Rules
  ## 7. Integrations & APIs
  ## 8. Testing Strategy
  ## 9. Security & Compliance
  ## 10. Definition of Done
  ## 11. Out of Scope (Explicit)
  ## 12. Open Decisions
  ## 13. AI Authorship Log
      | Increment | Feature | Model Used | Date | Notes |
      Updated automatically by Claude after each $build increment.

For Tier 2/3: §9 Security & Compliance is mandatory and must be complete before approval.
For Tier 3: §9 must be complete and approved before $build is allowed.

After writing SPEC.md:
"SPEC.md written to repo. Please review.
You can: (1) approve to proceed to $build,
(2) refine a section with '$spec [section name]',
(3) ask me to adjust anything."

The Spec is a living document — Claude updates it in place when sections change.

---

### PHASE 3 — Guided Development ($build)

WHEN SPEC.md not found: read the repo, then offer $spec or $docfinal — do not proceed to build.
WHEN no test command found (no package.json test script / Makefile / pyproject.toml): flag before writing code.

Develop in VERTICAL increments — complete feature with tests, not horizontal layers.

Before each increment, announce:
  🔨 INCREMENT [N]: [feature name]
  Files: [list of files to create or modify]
  Tests: [unit / integration / E2E — will run immediately after]
  Docs: [README update / API doc / inline comments required]
  Dependencies: [what must be done first]
  ──────────────────────────────────────
  [Wait for approval, then execute]

After writing code:
1. Detect test command from repo config (package.json scripts, Makefile, pyproject.toml).
2. Run tests. Report: X passed, Y failed, Z errors.
3. If failures: fix before proceeding. Never hand off broken tests to $qa.
4. Update README and inline docs as part of the increment — not as a separate step.
5. Update SPEC.md §13 (AI Authorship Log) with increment entry.
6. Append one entry to DECISIONS.md (see DECISIONS LOG below).
7. Trigger $qa auto for the increment.

DECISIONS LOG (automatic after each completed increment):
Append to DECISIONS.md:

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
  # Generated and maintained automatically by SDAD-CC.

Entry numbering: D-001, D-002... sequential across project lifetime.
Read existing DECISIONS.md before writing — never reset numbering.
Before session end or $pause: resolve any entries with Commit: "pending commit" using git log.

Deviation rule: if implementation requires departing from SPEC.md, flag first:
"⚠️ This would deviate from SPEC.md at §[N]. Update Spec first or proceed?"

---

### PHASE 4 — QA & Review ($qa / $QA)

**$qa auto (default):**
- Run all 6 layers.
- Security (P0/P1/P2), Compliance (Tier 2/3), Spec deviation findings → surface for human approval. Never auto-fix.
- All other must-fix and should-improve findings → apply directly, show unified diff, ask single confirmation.
- Style suggestions → apply directly, no diff shown unless requested.
- After auto-fixes: "Applied N fixes. Confirm? (yes / revert all)"
- Then run Lesson Capture.

**$qa review — full manual mode:**
- Report all findings, number H-01, H-02... reading DECISIONS.md and prior QA logs
  to continue from last used number across sessions.
- No fix applied without explicit per-finding approval.
- Close with: "Which fixes would you like me to apply?"
- Then run Lesson Capture.

**$qa full — full project audit, SDAD-Aware mode:**
- Covers entire project, not just current increment.
- Always manual review — never auto-applies.
- Use before PRs, after large refactors, or at sprint end.

**$QA — from User Preferences:**
- SDAD-Aware mode if SPEC.md exists, Standalone mode if not.
- Works in any Claude session, not just inside an SDAD project.
- Always manual review — never auto-applies.

QA Six Layers (ALL TIERS):
  🔐 Security (P0/P1/P2) — hardcoded keys, unprotected endpoints, PII exposure
  🏗️ Structure — separation of concerns, error handling, AI integration contract
  ⚡ Efficiency — token waste, redundant calls, unbounded loops, missing caching
  ✅ Definition of Done — all DoD criteria from SPEC.md §10 met?
  📄 Documentation — README updated? API docs present? Inline comments adequate?
  🧪 Functional Coverage — tests cover happy path, edge cases, error paths,
     boundary conditions, and every business rule in SPEC.md §6.
     Regression risk: could this increment break completed increments?

TIER 2 ADDITIONS:
  🔒 Compliance (Business) — PII handled? Audit logging present? Auth reviewed?
     Error messages safe (no stack traces exposed to users)?

TIER 3 ADDITIONS:
  🔒 Compliance (Enterprise) — all Tier 2 checks plus:
     Regulatory controls per SPEC.md §9 met for this increment?
     Data residency respected? Access control model followed?
     Encryption at rest/in transit implemented where required?

Mark P0 findings with 🚨 — surface first regardless of layer.
Mark compliance violations with 🔒 — surface immediately after P0 findings.
Distinguish clearly: "must fix" / "should improve" / "style suggestion".

---

## $lesson — Lesson Library Management

When the user approves a lesson candidate, Claude writes the full entry directly
to LESSON_LIBRARY.md. No manual paste required.
If LESSON_LIBRARY.md does not exist, Claude creates it first.

Lesson numbering: L-01, L-02, L-03... globally, assigned in creation order.
Check existing entries in LESSON_LIBRARY.md to assign the next number.

Trigger conditions — only propose when a finding involved:
- a non-obvious root cause that took more than one attempt to identify
- an environment, compliance, or platform-specific behavior not in the Spec
- a wrong assumption about external data, API, or regulatory requirement
- an architectural or prompt pattern that significantly simplified the solution

Entry quality rules:
- Title describes the PATTERN, not the symptom.
  Bad:  "Promise.all failed"
  Good: "Serialize async calls instead of Promise.all in restricted runtimes"
- Signal is specific enough for developer self-identification.
  Bad:  "when using Node.js"
  Good: "when your async initialization silently fails on module load in a restricted runtime"
- Transferable principle generalizes beyond the specific stack.

If nothing is lesson-worthy: skip silently — never mention it.

---

## $pause — Session State

In Claude Code, $pause reads actual state rather than reconstructing from memory.

Actions:
1. Read SPEC.md — extract version, status, compliance tier.
2. Run git log --oneline -10 — show recent commits as increment history.
3. Read DECISIONS.md — count entries, surface last entry title and date.
4. Check for open H-XX findings in conversation not yet resolved.
5. List defined flows in .sdad/flows/.
6. Output:

  ## SDAD-CC Session State
  Project:          [name from SPEC.md or repo root]
  Spec:             [version + status from SPEC.md]
  Compliance Tier:  [Tier N — Standard / Business / Enterprise]
  Context Budget:   [% estimate]
  Last increment:   [from git log or AI Authorship Log]
  Open QA findings: [H-XX list or "none"]
  Open Decisions:   [from SPEC.md §12]
  Decisions log:    [N entries — last entry title and date]
  Active Skills:    [AI Architect, AI Engineer, Security Reviewer, QA Engineer + any extras]
  Flows defined:    [N — list names]
  Lesson Library:   [N entries total / N added this session]
  Next step:        [one clear recommendation based on actual state]

No Session Snapshot needed — SPEC.md + git log + DECISIONS.md IS the persistent state.

---

## $docfinal — Retroactive Documentation

For projects built without SDAD. Generates complete documentation retroactively
from existing code. No Spec, no prior process, no increments required.

### When to use
- Taking over a legacy project or codebase
- Onboarding to an existing project before starting SDAD
- Creating documentation for a project that shipped without it
- Preparing a project for a compliance review or client handoff

### Difference from $doc
$doc generates documentation for a project already following SDAD — it reads
SPEC.md and the codebase together. $docfinal has no SPEC.md to read — it
infers everything from code alone and creates SPEC_RETROACTIVE.md.
Never use $docfinal if SPEC.md already exists — use $doc instead.

### Step sequence

**Step 1 — Retroactive Spec**
- Read the full codebase: all source files, package.json/requirements.txt,
  README if present, config files, DB schemas, migration files
- Run git log --oneline to understand project history
- Generate SPEC_RETROACTIVE.md with these sections only:
  §1 Vision & Objective, §2 Users & Roles, §3 Functional Flows, §4 Data Model,
  §5 Technical Architecture, §9 Security & Compliance, §11 Out of Scope, §12 Open Decisions
  Skip §6, §7, §8, §10.
- Write SPEC_RETROACTIVE.md to repo root — never overwrite SPEC.md.
- Every inferred statement cites its source: "inferred from [filename/pattern]"
- Uncertain inferences marked: "⚠️ unconfirmed — verify with team"

**Step 2 — AI Authorship Log**
- Identify major modules and features from the codebase structure
- Run git log --follow on key files to find most recent commit date
- Generate §13 table: one row per detected module/feature (not per file)
  Model Used: "Pre-SDAD / unknown" | Date: from git log | Notes: visible tech debt
- Append to SPEC_RETROACTIVE.md under ## 13. AI Authorship Log

**Step 3 — QA Standalone Audit**
- Run full $QA in Standalone mode
- Run all 6 layers: Security (P0/P1/P2), Structure, Efficiency, DoD, Documentation, Functional Coverage
- Number findings H-01, H-02... globally
- Mark P0 findings with 🚨 — surface first
- DO NOT apply any fixes — report only
- Close with: "Which fixes would you like me to apply? (H-XX, 'all', or 'none')"
- Proceed to Step 4 regardless of fix decision

**Step 4 — Lesson Candidates**
- Evaluate QA findings and full codebase patterns
- Propose up to 3 lesson candidates (larger surface area than single increment)
- Standard format per candidate:
  📚 LESSON CANDIDATE — [short title]
  Category: [LLM Design | Architecture | Data & Debugging | Environment | Workflow]
  Signal: [one line — how would another dev recognize this applies to them?]
  Principle: [one sentence transferable insight]
  Add to Lesson Library? (yes / skip / edit)
- If approved: write entry directly to LESSON_LIBRARY.md
- If nothing lesson-worthy: state "No lesson candidates identified." — never force

**Completion summary:**
  📋 $docfinal complete — [Project Name]
  - SPEC_RETROACTIVE.md written ([N sections generated])
  - AI Authorship Log: [N features documented]
  - QA findings: [N total — X critical, Y improvements, Z suggestions]
  - Lessons captured: [N added to LESSON_LIBRARY.md / "none"]
  Next: run '$spec' to begin a forward-looking Spec, or '$qa' to work through fixes.

---

## Definition of Done — All Tiers

- Code implements feature exactly as described in approved SPEC.md
- Tests pass locally (Claude ran them and confirmed)
- Unit tests cover core logic at minimum coverage defined in Phase 1
- Integration tests cover contracts between this module and dependencies
- No open $qa findings at "must fix" severity
- No hardcoded secrets, API keys, or environment-specific values in source
- Error states handled explicitly — no unhandled rejections or uncaught exceptions
- Feature works when AI/external API is unavailable (fallback tested)
- README updated to reflect any changes to setup, usage, or architecture
- New public functions and API endpoints documented with docstrings or JSDoc
- New environment variables added to .env.example
- SPEC.md updated if implementation required a deviation
- SPEC.md §13 AI Authorship Log entry added
- DECISIONS.md entry added with decision, alternatives, and commit reference

### Tier 2 additions
- PII fields documented in SPEC.md §9 data classification table
- Auth flow reviewed in QA compliance layer — no open findings
- Error responses sanitized — no internal detail exposed to users
- Audit log entry present for every user-affecting action in this increment

### Tier 3 additions (all Tier 2 items, plus)
- Threat model present in SPEC.md §9 (required before first $build)
- Data flow diagram present in SPEC.md §9 (required before first $build)
- Control matrix present in SPEC.md §9 (required before first $build)
- All Tier 3 QA compliance checks pass with no open findings
- $doc compliance generated before project delivery

---

## AI Skills Catalog

### Always Active (built-in)
| Skill | Active By Default | Best For |
|-------|-------------------|----------|
| AI Solutions Architect | ✅ Yes — Phase 0+ | Architecture decisions, LLM integration patterns, cost modeling, red flags |
| AI Engineer | ✅ Yes — All phases | Implementation quality, tooling, CI/CD, DX, UI detection, docs standards |
| Security Reviewer | ✅ Yes — Phase 3-4 | API key exposure, injection, PII handling, auth vulnerabilities |
| QA Engineer | ✅ Yes — Phase 4 | Test coverage, DoD compliance, acceptance criteria, regression risk |

### Auto-activated by compliance tier
| Skill | Activated when | Best For |
|-------|---------------|----------|
| Compliance Reviewer | Tier 2 or Tier 3 confirmed | PII handling, audit logging, regulatory controls, $doc compliance |

### Available to activate manually
| Skill | Best For |
|-------|----------|
| Performance Architect | Load modeling, bottlenecks, caching, async patterns |
| Prompt Engineer | LLM prompt quality, token efficiency, output reliability |

### External Skills (install via npx skills or /plugin)
| Skill | Source | Install when |
|-------|--------|--------------|
| api-design-principles | wshobson/agents | Designing or reviewing REST/GraphQL APIs |
| frontend-design | anthropics/skills | Any project with a user interface |
| skill-creator | anthropics/skills | Extending SDAD-CC or evaluating custom skills |
| mcp-builder | anthropics/skills | Project needs external service integration |
| python-performance-optimization | wshobson/agents | Python stack with performance requirements |
| systematic-debugging | obra/superpowers | Complex bugs requiring structured root cause analysis |
| test-driven-development | obra/superpowers | Teams adopting strict TDD from Phase 3 |
| context-engineering-advisor | deanpeters/Product-Manager-Skills | LLM-intensive context management |
| prioritization-advisor | deanpeters/Product-Manager-Skills | Formal MVP scope prioritization in Phase 1 |
| technical-writing | supercent-io/skills-template | Tier 2/3 formal client deliverables |
| webapp-testing | anthropics/skills | Tier 2/3 end-to-end web testing |
