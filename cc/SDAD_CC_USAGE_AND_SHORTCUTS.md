# G7 SDAD-CC — Usage Guide & Shortcuts Reference
# Spec-Driven AI Development for Claude Code
# Version 3.1 | 2026

---

## Before Every Session

```bash
npx ccstatusline@latest   # terminal 1 — shows model, context %, cost, git branch
claude                    # terminal 2 — start Claude Code
```

Always run ccstatusline first. It is your primary context budget indicator.

---

## The Five Phases

### PHASE 0 — Context Ingestion (automatic)

Triggered when you start a session. Claude reads the repo before asking anything.

What Claude reads:
- `SPEC.md` — restores full project state if it exists
- `.sdad/project.md` — reads project registry and session log
- `LESSON_LIBRARY.md` — surfaces relevant lessons for your stack
- `package.json` / `pyproject.toml` / `requirements.txt` — infers stack and tooling
- `src/` or `app/` — understands what is already built
- `.github/workflows/` — knows if CI exists

What Claude detects automatically:
- **Compliance tier signals** — payment integrations, health data, user accounts
- **UI presence** — React/Vue/Tailwind/mobile frameworks trigger a frontend-design skill suggestion
- **Missing tooling** — no test command, no linter, no .env.example → flagged before Phase 1
- **Context Budget baseline** — session starts at 0%, thresholds monitored from here

Output:
```
📋 CONTEXT ANALYSIS
- System objective: ...
- Users / actors: ...
- Inferred tech stack: ...
- Existing structure: ...
- Recommended compliance tier: Tier N — [one-line reason]
- Critical ambiguities: [ranked, only genuine blockers]
- Active AI Skills: AI Architect, AI Engineer, Security Reviewer, QA Engineer
🎨 UI detected: recommend installing frontend-design skill [if applicable]

📚 Relevant lessons from the library:
[L-XX] [title] — [why this applies here]
```

---

### PHASE 1 — Requirements Definition [$spec]

One targeted question at a time. Claude always proposes a reasonable default —
say "accept" or "yes" to move forward. Claude skips questions it can already
answer from the code it read in Phase 0.

Coverage order:
1. Scope & MVP boundaries
2. Critical user flows
3. Data model
4. Integrations
5. Business rules
6. Performance & scale
7. **Compliance tier** — always asked, never skipped
8. Security
9. Documentation needs
10. Testing strategy

**The compliance tier question** is mandatory:
```
What's the deployment context for this project?
(1) Internal tool / POC — Tier 1 Standard
(2) Customer-facing product / SaaS — Tier 2 Business
(3) Regulated environment / corporate IT — Tier 3 Enterprise
Based on what I see: I recommend Tier N because [reason].
Confirm or override?
```

Use `$spec [section]` at any time to refine a specific area.

---

### PHASE 2 — Spec Document [$specout]

Generates the complete 13-section Spec and **writes it to `SPEC.md` automatically**.

After writing:
```
SPEC.md written to repo. Please review.
You can: (1) approve to proceed to $build,
(2) refine a section with '$spec [section name]',
(3) ask me to adjust anything.
```

For Tier 3: §9 Security & Compliance must be complete and approved before `$build` is allowed.

`SPEC.md` is a living document. Commit it alongside your code.

---

### PHASE 3 — Guided Development [$build]

Develops in vertical increments — a complete feature with tests.
Blocked if Context Budget hard warning (65%) was triggered.

WHEN SPEC.md not found: Claude reads the repo, then offers $spec or $docfinal — does not proceed to build.
WHEN no test command found (no package.json test script / Makefile / pyproject.toml): flagged before writing code.

Each increment sequence:

**1. Announce**
```
🔨 INCREMENT [N]: [feature name]
Files: [list]
Tests: [unit / integration / E2E — will run immediately after]
Docs: [README update / API doc / inline comments required]
Dependencies: [what must be done first]
──────────────────────────────────────
[Waiting for your approval]
```

**2. Write** — after approval, Claude writes all files including inline docs.

**3. Run tests** — Claude detects and runs the test command:
```
✅ Tests: 24 passed, 0 failed (2.3s)
```
If tests fail, Claude fixes before proceeding.

**4. Update SPEC.md §13** — AI Authorship Log entry added automatically.

**5. Append DECISIONS.md entry** — one entry per completed increment.

**6. Trigger $qa** — runs in auto mode by default.

> Name your increments: `$build auth module` scopes work better than `$build` alone.

---

### PHASE 4 — QA & Review [$qa]

#### $qa (auto mode — default)
- Runs all QA layers silently.
- **Security (P0/P1/P2), Compliance, Spec deviations:** always surfaces for explicit approval. Never auto-fixed.
- **Must fix / should improve:** applies directly, shows unified diff, single confirmation.
- **Style suggestions:** applies silently.
- After fixes: "Applied N changes. Confirm? (yes / revert all)"
- Then: Lesson Capture evaluation.

#### $qa review
Full manual mode — complete report, nothing applied without per-finding approval.
Use for complex increments, architectural changes, or when you want to learn from findings.

#### $qa full
Full project audit in SDAD-Aware mode. Always manual review.
Use before PRs, after large refactors, or at sprint end.

#### $QA (from User Preferences)
Full project audit — runs in SDAD-Aware mode if a Spec is present, Standalone otherwise.
Works in any Claude session, not just inside an SDAD project.

#### When to use which:

| Command | Use when |
|---------|----------|
| `$qa` (auto) | Normal flow — you trust the increment and want to move fast |
| `$qa review` | Complex increment, architectural change, or want full visibility |
| `$qa full` | Before PR/merge, after large refactor, at sprint end (SDAD-Aware) |
| `$QA` | Full audit from User Preferences — works outside a project too |

---

## Context Budget

| Threshold | Type | What happens |
|-----------|------|-------------|
| **50%** | ⚠️ Soft warning | Informational. Continue normally. Good moment to consider session change after current increment. |
| **65%** | 🔴 Hard warning | Claude finishes the current increment (including tests and $qa), then blocks `$build`. Run `$pause`, start a new session. |

**What stays available after a hard warning:**
`$pause`, `$spec`, `$verify`, `$lesson`, `$doc`, `$flow`, `$skills`, `$sdad` — all work.
Only `$build` is blocked.

**Sub-agents and context budget:**
Tasks delegated via `$agent` run in isolated context windows — they do not consume
the main session budget.

`ccstatusline` shows context % in real time. Use it as your primary indicator.

---

## Sub-Agent Delegation ($agent)

Claude automatically delegates certain tasks to isolated sub-agents.
You see only the result, not the mechanics.

**Automatic delegation:**

| Task | Why it delegates |
|------|-----------------|
| `$doc` (all variants) | Generates from filesystem — doesn't need session state |
| `$agent review [module]` | Architectural review of committed code |
| `$agent test [module]` | Test suite generation for existing module |
| `$agent audit [path]` | Security audit of a file or folder |

**Always in main context:**

| Task | Why it stays |
|------|-------------|
| `$qa` after `$build` | Needs the just-written increment in context |
| `$spec` / `$specout` | Requires conversation history |
| `$build` | Active development requires full context |

Direct triggers:
```
$agent review src/auth/      → architectural review of the auth module
$agent test src/api/users.js → generate test suite for that file
$agent audit src/            → security audit of the full src/ folder
```

---

## $verify — Dependency Documentation Check

Claude's training has a lag of 6-12 months. `$verify` checks whether the libraries
in your project match what Claude knows and flags when documentation may be stale.

```
$verify              → check all dependencies in the project
$verify anthropic    → check the Anthropic SDK version in use
$verify openai@4.x   → check a specific version
```

`$verify` runs **automatically** at the start of any `$build` introducing a new dependency.

If **Context 7 MCP** is installed, `$verify` uses it to fetch current docs.
If not: emits a per-library warning with the official changelog link.

---

## $flow — Project Flow Manager

Flows capture repeatable sequences specific to your project as named commands.
They live in `.sdad/flows/` and are distinct from lessons:

| | Lessons | Flows |
|---|---------|-------|
| Scope | Cross-project transferable insights | This project's repeatable sequences |
| Lives in | `LESSON_LIBRARY.md` | `.sdad/flows/[name].md` |
| Created by | `$lesson new` or auto after `$qa` | `$flow [name]` |
| Executed | Not executable — reference only | `$flow [name] run` |

```
$flow [name]          → define a new flow for this project
$flow list            → list all flows defined in .sdad/flows/
$flow [name] run      → execute a saved flow
$flow [name] edit     → update an existing flow definition
```

---

## Command Reference

| Command | Phase | What it does |
|---------|-------|-------------|
| `$SM` / `$S` | Any | Socratic-Meta Prompting — all prompt construction (User Preferences) |
| `$QA` | Any | Full audit — SDAD-Aware or Standalone (User Preferences) |
| `$spec` | 1 | Guided requirements — one question at a time with defaults |
| `$spec [section]` | 1 | Refine a specific Spec section |
| `$specout` | 2 | Generate full 13-section Spec → writes to SPEC.md |
| `$build` | 3 | Start development — requires approved SPEC.md |
| `$build [feature]` | 3 | Start a specific named increment |
| `$verify` | Any | Check dependency documentation currency |
| `$verify [lib]` | Any | Check a specific library |
| `$qa` | 4 | Auto QA — applies safe fixes, surfaces security/compliance for approval |
| `$qa review` | 4 | Manual QA — full report, per-finding approval |
| `$qa full` | 4 | Full project audit in SDAD-Aware mode |
| `$agent review [module]` | Any | Architectural review via sub-agent |
| `$agent test [module]` | Any | Test suite generation via sub-agent |
| `$agent audit [path]` | Any | Security audit via sub-agent |
| `$doc` | Any | Generate full documentation set |
| `$doc readme` | Any | Update README.md |
| `$doc api` | Any | Generate or update API reference |
| `$doc arch` | Any | Generate architecture document |
| `$doc compliance` | Any | Generate compliance summary (Tier 2/3 only) |
| `$docfinal` | Any | Retroactive documentation for pre-SDAD projects |
| `$docfinal spec` | Any | Step 1 — retroactive Spec |
| `$docfinal log` | Any | Step 2 — AI Authorship Log |
| `$docfinal qa` | Any | Step 3 — QA Standalone audit |
| `$docfinal lessons` | Any | Step 4 — Lesson candidates |
| `$flow [name]` | Any | Define a new project flow |
| `$flow list` | Any | List all flows in .sdad/flows/ |
| `$flow [name] run` | Any | Execute a saved flow |
| `$flow [name] edit` | Any | Update an existing flow |
| `$lesson` | Any | Show all library entries grouped by category |
| `$lesson [keyword]` | Any | Filter entries by keyword, category, or stack |
| `$lesson [L-XX]` | Any | Show full entry for that lesson |
| `$lesson new` | Any | Guided entry creation → writes to LESSON_LIBRARY.md |
| `$pause` | Any | Show current state: phase, Spec, tier, context budget, findings, decisions |
| `$pause compress` | Any | Generate Session Snapshot for next session |
| `$skills` | Any | View and adjust active AI specialist skills |
| `$sdad` | Any | Show methodology overview and all commands |

---

## AI Skills

### Always Active

**🏗️ AI Solutions Architect**
Architecture decisions, LLM integration patterns, cost modeling, red flags.
Active in all phases. Adds an Architecture layer to QA.

**🔧 AI Engineer**
Implementation quality, tooling setup, CI/CD, developer experience, UI detection, docs standards.
Active in all phases. Detects UI in Phase 0, flags missing tooling, enforces docs per increment.

**🔐 Security Reviewer**
API key exposure, injection vulnerabilities, PII handling, auth weaknesses.
Active in Phases 3-4. Always P0/P1/P2 classified. Never auto-fixed.

**✅ QA Engineer**
Test coverage, DoD compliance, acceptance criteria, regression risk.
Active in Phase 4. Owns Functional Coverage layer in QA.

### Auto-activated by compliance tier

**🔒 Compliance Reviewer**
Activated automatically on Tier 2 or Tier 3 confirmation.
Tier 2: PII, auth, session security, audit logging, error sanitization.
Tier 3: all Tier 2 + regulatory controls (GDPR/HIPAA/SOC2/PCI-DSS),
encryption, access control, data residency, tamper-evident audit trail.

### Available to activate manually

| Skill | Best for |
|-------|---------|
| Performance Architect | Load modeling, bottlenecks, caching, async patterns |
| Prompt Engineer | LLM prompt quality, token efficiency, output reliability |

### External Skills

| Skill | Activate when | Install |
|-------|-------------|---------|
| `api-design-principles` | Designing/reviewing REST or GraphQL APIs | `npx skills add https://github.com/wshobson/agents --skill api-design-principles` |
| `frontend-design` | Any project with UI (auto-suggested when detected) | `/plugin install example-skills@anthropic-agent-skills` |
| `skill-creator` | Creating or evaluating custom SDAD skills | `/plugin install example-skills@anthropic-agent-skills` |
| `mcp-builder` | Building MCP servers | `/plugin install example-skills@anthropic-agent-skills` |
| `python-performance-optimization` | Python with performance requirements | `npx skills add https://github.com/wshobson/agents --skill python-performance-optimization` |
| `systematic-debugging` | Complex bugs needing root cause analysis | `/plugin marketplace add obra/superpowers` |
| `test-driven-development` | Strict TDD from Phase 3 | `/plugin marketplace add obra/superpowers` |
| `context-engineering-advisor` | LLM-intensive projects | `npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill context-engineering-advisor` |
| `prioritization-advisor` | MVP scope prioritization in Phase 1 | `npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill prioritization-advisor` |
| `technical-writing` | Tier 2/3 formal documentation | `npx skills add https://github.com/supercent-io/skills-template --skill technical-writing` |
| `webapp-testing` | Tier 2/3 end-to-end web testing | `/plugin install example-skills@anthropic-agent-skills` |

---

## Compliance Tiers

| Tier | For | Auto-activates | DoD additions |
|------|-----|---------------|---------------|
| **Tier 1 — Standard** | Internal tools, POCs, scripts | Nothing | None |
| **Tier 2 — Business** | SaaS, customer-facing, user data | Compliance Reviewer | PII docs, auth review, audit logging, sanitized errors |
| **Tier 3 — Enterprise** | Regulated environments, corporate IT | Compliance Reviewer (full) | Threat model, data flow diagram, control matrix |

**Tier 3: SPEC.md §9 must be complete and approved before `$build` is allowed.**

---

## The Lesson Library

`LESSON_LIBRARY.md` captures transferable patterns across projects.

- After each `$qa`, Claude evaluates whether any finding is lesson-worthy.
- If yes: proposes one candidate (title, category, signal, principle).
- If approved: writes the full entry directly to `LESSON_LIBRARY.md`.
- If nothing is lesson-worthy: skips silently.

| Category | What it captures |
|----------|-----------------|
| 🧠 LLM Design | Prompt architecture, delegation patterns, input structure |
| 🏗️ Architecture | System design decisions with lasting impact |
| 🔍 Data & Debugging | Assumptions about external data, root cause patterns |
| ⚙️ Environment | Runtime limitations, deploy constraints, platform behavior |
| 🔄 Workflow | Patterns for working effectively with Claude |

---

## The Spec as Living Documentation

| Section | Content |
|---------|---------|
| 1. Vision & Objective | What the system does and for whom |
| 2. Users & Roles | Who interacts and what they can do |
| 3. Functional Flows | Happy paths, edge cases, error flows |
| 4. Data Model | Entities, relationships, key attributes |
| 5. Technical Architecture | Stack, components, integration points |
| 6. Business Rules | Validations, limits, special logic |
| 7. Integrations & APIs | External services, contracts, fallbacks |
| 8. Testing Strategy | Unit/integration/E2E scope, coverage targets |
| 9. Security & Compliance | Auth, PII, threat model, regulatory controls |
| 10. Definition of Done | Acceptance criteria per feature |
| 11. Out of Scope (Explicit) | What this version intentionally excludes |
| 12. Open Decisions | Unresolved choices — must close before $build |
| 13. AI Authorship Log | Increment / Feature / Model / Date / Notes |

---

## Best Practices

| Practice | Why it matters |
|----------|---------------|
| Watch ccstatusline during sessions | Real-time context % visibility |
| Start each session with `$pause` | Restores full state from SPEC.md + git log in seconds |
| Watch for the 50% soft warning | Plan your session end before the 65% hard block |
| Use `$agent` commands for module reviews | Isolated context → higher quality output |
| Run `$verify` when adding new dependencies | 6-12 month training lag can mean deprecated APIs |
| Define `$flow` for any sequence you repeat | Two repetitions = worth capturing |
| Name your `$build` increments | `$build auth module` scopes work better than bare `$build` |
| Confirm compliance tier early | Tier 3 requires §9 complete before `$build` |
| Use `$qa review` for architectural increments | Manual review catches systemic issues |
| Run `$qa full` before any PR | Cross-increment issues only surface in full audits |
| Run `$doc arch` before client delivery | Saves hours — takes seconds from SPEC.md + code |
| Commit SPEC.md, LESSON_LIBRARY.md, SKILL files | They are infrastructure, not documentation |
| Share LESSON_LIBRARY.md across team repos | Lessons from one project prevent bugs in the next |
| Install `frontend-design` before any UI work | The quality difference is immediate and visible |
| Use `$SM` for complex prompts in your LLM app | When your project makes LLM calls, use $SM to build those prompts |

---

## $SM — Socratic-Meta Prompting (Universal Shortcut)

`$SM` works in any Claude session — web UI or Claude Code.
Activates from User Preferences. Handles all prompt construction by auto-calibrating
depth to what you need. Closes with a feedback loop for iteration.

| Track | When | What you see |
|-------|------|-------------|
| Simple Track | Clear objective, direct request | ⚡ SIMPLE MODE: [one line] then the prompt |
| Complex Track | Ambiguous objective, hidden assumptions | 📊 METHOD + 💡 Reason + 💡 Insight then the prompt |

After delivering the prompt, always closes with:
  "Does this capture your actual goal, or should I adjust the scope, role, or output format?"

---

G7 AI Development Methodology | SDAD-CC Usage Guide & Shortcuts Reference | v3.1
Spec-Driven AI Development for Claude Code
