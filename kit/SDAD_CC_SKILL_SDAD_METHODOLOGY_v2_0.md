# SKILL: SDAD-CC — Spec-Driven AI Development for Claude Code
# Reference file — place in repo root alongside CLAUDE.md.
# Commands and activation rules live in CLAUDE.md.
# Version 2.0 | Claude Code Edition

## What is SDAD-CC
SDAD-CC is the Claude Code adaptation of the G7 Spec-Driven AI Development methodology.
It preserves the core discipline — spec before code, vertical increments, integrated QA —
while eliminating the web UI workarounds that existed only to compensate for the lack
of filesystem and terminal access.

In SDAD-CC, Claude reads real files, runs real tests, and writes directly to the repo.
The Spec lives in SPEC.md in version control, not in chat history.
The Lesson Library lives in LESSON_LIBRARY.md and is updated by Claude directly.
State is always the actual codebase — not a session snapshot.

**Core difference from SDAD v1.3 (web UI):**

| SDAD v1.3 (Web UI)               | SDAD-CC v2.0 (Claude Code)                        |
|----------------------------------|---------------------------------------------------|
| Delivery Checkpoint required     | Eliminated — Claude writes directly               |
| Drift Warning at session start   | Eliminated — Claude reads actual files            |
| Session Snapshot / $pause compress | Eliminated — SPEC.md + git log is state         |
| Tests generated but not run      | Tests run immediately after each build            |
| Lesson Library updated manually  | Claude writes to LESSON_LIBRARY.md directly       |
| SPEC.md saved manually           | Claude writes SPEC.md to repo on $specout         |
| $qa waits for per-finding approval | $qa auto applies safe fixes, surfaces security  |
| No compliance tiers              | 3-tier compliance system detected in Phase 0      |
| No documentation command         | $doc generates /docs artifacts from SPEC.md + code |
| UI skills not suggested          | AI Engineer detects UI and suggests frontend-design |

---

## Phase Definitions

### PHASE 0 — Context Ingestion (automatic)
Triggered when a developer opens a session or describes a project.

Actions:
- Read existing files in the repo (package.json, requirements.txt, existing src/, README.md)
- Read SPEC.md if it exists — restore state from it without asking
- Read LESSON_LIBRARY.md if it exists — surface relevant lessons
- Detect compliance tier signals (see Compliance Tier System in SKILL_COMPLIANCE.md)
- Detect UI presence for frontend-design skill suggestion (see SKILL_AI_ENGINEER.md)
- Output context analysis block

Output format:
  📋 CONTEXT ANALYSIS
  - System objective: [inferred from files or described]
  - Users / actors: [inferred]
  - Inferred tech stack: [from dependency files]
  - Existing structure: [summary of what is already built]
  - Recommended compliance tier: [Tier N — one-line reason based on signals detected]
  - Critical ambiguities: [ranked, only genuine blockers]
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
Present the three options with the recommended tier pre-selected based on Phase 0 signals:
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
  ## 9. Security Considerations
  ## 10. Definition of Done
  ## 11. Out of Scope (Explicit)
  ## 12. Open Decisions
  ## 13. AI Authorship Log
      | Increment | Feature | Model Used | Date | Notes |
      Updated after each $build increment automatically by Claude.

After writing SPEC.md:
"SPEC.md written to repo. Please review.
You can: (1) approve to proceed to $build,
(2) refine a section with '$spec [section name]',
(3) ask me to adjust anything."

The Spec is a living document — Claude updates it in place when sections change.

---

### PHASE 3 — Guided Development ($build)
Require SPEC.md approved. If not found: read the repo, then ask.
Develop in VERTICAL increments — complete feature with tests, not horizontal layers.

Before each increment, announce:
  🔨 INCREMENT [N]: [feature name]
  Files: [list]
  Tests: [unit / integration / E2E — will run immediately after]
  Dependencies: [what must be done first]
  ──────────────────────────────────────
  [Wait for approval, then execute]

After writing code:
1. Detect test command from repo config (package.json scripts, Makefile, pytest.ini).
2. Run tests. Report: X passed, Y failed, Z errors.
3. If failures: fix before proceeding. Never hand off broken tests to $qa.
4. Update SPEC.md §13 (AI Authorship Log) with increment entry.
5. Trigger $qa (auto mode by default).

Deviation rule: if implementation requires departing from SPEC.md, flag first:
"⚠️ This would deviate from SPEC.md at §[N]. Update Spec first or proceed?"

---

### PHASE 4 — QA & Review ($qa / $QA)

**$qa auto (default)** — fast path, designed for Claude Code's direct write capability:
- Run all 5 layers.
- P0/P1/P2 security findings and Spec deviation findings → surface for human approval.
- All other must-fix and should-improve findings → apply directly, show unified diff.
- Style suggestions → apply directly, no diff shown unless requested.
- After auto-fixes: "Applied N fixes. Confirm? (yes / revert all)"
- Then run Lesson Capture.

**$qa review** — full manual mode:
- Report all findings, number H-01, H-02...
- No fix applied without explicit approval.
- "Which fixes would you like me to apply?"
- Then run Lesson Capture.

**$QA** — full project audit (from User Preferences):
- SDAD-Aware mode if SPEC.md exists, Standalone mode if not.
- Same 5 layers, P0/P1/P2 classification.
- Always manual review — never auto-applies.

QA Five Layers:
  🔐 Security (P0/P1/P2) — hardcoded keys, unprotected endpoints, PII exposure
  🏗️ Structure — separation of concerns, error handling, AI integration contract
  ⚡ Efficiency — token waste, redundant calls, unbounded loops, missing caching
  ✅ Definition of Done — all DoD criteria from SPEC.md §10 met?
  🧪 Functional Coverage — tests cover happy path, edge cases, error paths,
     boundary conditions, and every business rule in SPEC.md §6.
     Regression risk: could this increment break completed increments?

---

## $lesson — Lesson Library Management

Full command behavior defined in CLAUDE.md.
This section covers numbering, quality rules, and the write behavior.

Write behavior (Claude Code only):
When the user approves a lesson candidate, Claude writes the full entry directly
to LESSON_LIBRARY.md using the format below. No manual paste required.
If LESSON_LIBRARY.md does not exist, Claude creates it first.

Lesson numbering: L-01, L-02, L-03... globally, assigned in creation order.
Check existing entries in LESSON_LIBRARY.md to assign the next number.

Entry quality rules:
- Title describes the PATTERN, not the symptom.
  Bad: "Promise.all failed"
  Good: "Serialize async calls instead of Promise.all in restricted runtimes"
- Signal is specific enough for developer self-identification.
  Bad: "when using Node.js"
  Good: "when your async initialization silently fails on module load in a restricted runtime"
- Transferable principle generalizes beyond the specific stack.

---

## $pause — Session State

In Claude Code, $pause reads actual state rather than reconstructing from memory.
Actions:
1. Read SPEC.md — extract version, status, compliance tier, last modified section.
2. Run git log --oneline -10 — show recent commits as increment history.
3. Check for open findings in conversation (H-XX not yet resolved).
4. Output:

  ## SDAD-CC Session State
  Project: [name from SPEC.md or repo root]
  Spec: [version + status from SPEC.md]
  Compliance Tier: [Tier N — Standard / Business / Enterprise]
  Last increment: [from git log or AI Authorship Log]
  Open QA findings: [list or "none"]
  Open Decisions: [from SPEC.md §12]
  Active Skills: AI Architect, AI Engineer, Security Reviewer, QA Engineer [+ any extras]
  Lesson Library: [N entries total / N added this session]
  Next step: [one clear recommendation based on actual state]

No Session Snapshot needed — SPEC.md + git log IS the persistent state.

---

## Definition of Done (default — customize in SPEC.md §10)

### All Tiers
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
- AI Authorship Log entry added to SPEC.md §13

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
| Skill | Active By Default | Best For |
|-------|-------------------|----------|
| Performance Architect | No | Load modeling, bottlenecks, caching, async patterns (stack-agnostic) |
| Prompt Engineer | No | LLM prompt quality, token efficiency, output reliability |

### External Skills (install via npx skills or /plugin)
| Skill | Source | Replaces / Complements | Install when |
|-------|--------|----------------------|--------------|
| api-design-principles | wshobson/agents | Replaces API Contract Designer | Designing or reviewing REST/GraphQL APIs |
| frontend-design | anthropics/skills | Adds production UI quality | Any project with a user interface |
| skill-creator | anthropics/skills | Meta — create/evaluate custom skills | Extending SDAD-CC or training teams |
| mcp-builder | anthropics/skills | Builds MCP server integrations | Project needs external service integration |
| python-performance-optimization | wshobson/agents | Complements Performance Architect | Python stack with performance requirements |
| systematic-debugging | obra/superpowers | Structured root cause analysis | Complex bugs in Phase 3-4 |
| test-driven-development | obra/superpowers | Strict TDD from Phase 3 | Teams adopting TDD discipline |
| context-engineering-advisor | deanpeters/Product-Manager-Skills | Complements AI Architect | LLM-intensive context management |
| prioritization-advisor | deanpeters/Product-Manager-Skills | Complements $spec Phase 1 | Formal MVP scope prioritization |
| technical-writing | supercent-io/skills-template | Formal documentation | Tier 2/3 client deliverables |
| webapp-testing | anthropics/skills | End-to-end web testing | Tier 2/3 web projects |
