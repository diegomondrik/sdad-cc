# G7 SDAD-CC — Usage Guide & Shortcuts Reference
# Spec-Driven AI Development for Claude Code
# Version 2.0 | 2025

---

## What Changed from v1.3 (Web UI)

SDAD-CC is not a rewrite — it is a targeted adaptation. The core methodology is
identical. What changed is the elimination of rituals that existed only to compensate
for the web UI's lack of filesystem access:

| Removed from v1.3 | Why removed in v2.0 |
|-------------------|---------------------|
| Delivery Checkpoint | Claude Code writes directly — no deployment gap |
| Drift Warning | Claude reads actual files — no drift possible |
| Session Snapshot / $pause compress | SPEC.md + git log is the persistent state |
| Manual lesson paste | Claude writes to LESSON_LIBRARY.md directly |
| FILE OWNERSHIP DECLARATION | Always DIRECT WRITE = yes in Claude Code |

**What is new in v1.5:**
- AI Engineer skill (always active) — implementation quality, tooling, UI detection, docs standards
- Compliance Tier system — 3 tiers detected in Phase 0, confirmed in Phase 1, auto-activates skills
- `$doc` command — generates README, API docs, architecture docs, compliance summaries
- `$qa` Documentation layer — README and API docs checked as part of every increment
- External skills catalog expanded — skill-creator, mcp-builder, systematic-debugging, test-driven-development
- `frontend-design` skill recommended automatically when UI is detected in Phase 0
- $qa auto mode — Claude applies safe fixes directly, surfaces security and compliance for human review
- Tests run automatically after every $build increment
- SPEC.md written to repo automatically on $specout
- LESSON_LIBRARY.md updated directly by Claude on lesson approval

---

## The Five Phases

### PHASE 0 — Context Ingestion (automatic)

Triggered when you start a session. Claude reads the repo before asking anything.

What Claude reads:
- `SPEC.md` — restores full project state if it exists
- `LESSON_LIBRARY.md` — surfaces relevant lessons for your stack
- `package.json` / `pyproject.toml` / `requirements.txt` — infers stack and tooling
- `src/` or `app/` — understands what is already built
- `.github/workflows/` — knows if CI exists

What Claude detects automatically:
- **Compliance tier signals** — payment integrations, health data, user accounts, corporate deployment
- **UI presence** — React/Vue/Tailwind/mobile frameworks trigger a frontend-design skill suggestion
- **Missing tooling** — no test command, no linter, no .env.example flagged before Phase 1

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

One targeted question at a time, in order of impact. Claude always proposes a
reasonable default — you can say "accept" or "yes" to move forward.

Because Claude has already read the repo in Phase 0, it skips questions it
can already answer from the code. If you have an existing codebase, Phase 1
is often shorter than on a greenfield project.

Coverage order:
1. Scope & MVP boundaries
2. Critical user flows
3. Data model
4. Integrations
5. Business rules
6. Performance & scale
7. **Compliance tier** — always asked, never skipped (see below)
8. Security
9. Documentation needs
10. Testing strategy

**The compliance tier question** is mandatory in every project. Claude pre-selects
the recommended tier based on Phase 0 signals:
```
What's the deployment context for this project?
(1) Internal tool / POC — Tier 1 Standard
(2) Customer-facing product / SaaS — Tier 2 Business
(3) Regulated environment / corporate IT — Tier 3 Enterprise
Based on what I see: I recommend Tier N because [reason].
Confirm or override?
```
Confirming Tier 2 activates the Compliance Reviewer skill automatically.
Confirming Tier 3 activates it in full profile and requires SPEC.md §9 to be
complete before `$build` is allowed.

Use `$spec [section]` at any time to refine a specific area — before or after
the Spec is generated.

---

### PHASE 2 — Spec Document [$specout]

Generates the complete 13-section Spec and **writes it to `SPEC.md` in your
repo root automatically**. No copy/paste needed.

After writing:
```
SPEC.md written to repo. Please review.
You can: (1) approve to proceed to $build,
(2) refine a section with '$spec [section name]',
(3) ask me to adjust anything.
```

`SPEC.md` is a living document. Every `$build` increment adds a row to the
AI Authorship Log (§13) automatically. Every approved deviation updates the
relevant section. Commit it alongside your code — it is part of the project.

---

### PHASE 3 — Guided Development [$build]

Develops in vertical increments — a complete feature with tests, not horizontal
layers. Each increment follows this sequence:

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

**2. Write** — after approval, Claude writes all files for the increment,
including inline docs and README updates as part of the same step.

**3. Run tests** — Claude detects the test command from your config and runs it:
```
✅ Tests: 24 passed, 0 failed (2.3s)
```
If tests fail, Claude fixes before proceeding. You never inherit broken tests.

**4. Update SPEC.md §13** — Claude adds an AI Authorship Log entry automatically.

**5. Trigger $qa** — runs in auto mode by default.

> Name your increments: `$build auth module` or `$build search feature` helps
> Claude scope the work and write better tests.

---

### PHASE 4 — QA & Review [$qa]

#### $qa (auto mode — default)
The fast path. Designed for Claude Code's direct write capability.

What auto mode does:
- Runs all 5 QA layers.
- **Security findings (P0/P1/P2):** surfaces for your explicit approval. Never auto-fixed.
- **Spec deviation findings:** surfaces for your explicit approval. Never auto-fixed.
- **Must fix / should improve (structure, efficiency, DoD, coverage):** applies directly, shows a unified diff.
- **Style suggestions:** applies silently.
- After fixes: "Applied N changes. Confirm? (yes / revert all)"

This means most QA cycles complete in one turn instead of N turns — one per finding.

#### $qa review
Full manual mode. Use when you want to see everything before anything is touched.
- Complete report, all findings numbered H-01, H-02...
- Nothing applied without your explicit per-finding approval.
- Closes with: "Which fixes would you like me to apply?"

#### $qa full
Alias for `$QA` — full project audit, not just the current increment.
Always manual review mode.

#### When to use which:

| Command | Use when |
|---------|----------|
| `$qa` (auto) | Normal development flow — you trust the increment and want to move fast |
| `$qa review` | Complex increment, architectural changes, or you want to learn from findings |
| `$qa full` | Before a PR/merge, after a large refactor, or at sprint end |
| `$QA` | Full project audit from User Preferences — same as $qa full |

---

## Command Reference

| Command | Phase | What it does |
|---------|-------|--------------|
| `$SM` / `$S` | Any | Socratic-Meta Prompting — all prompt construction from simple to complex |
| `$QA` | Any | Full project audit. SDAD-Aware (5 layers) or Standalone (4 layers). Always manual. |
| `$spec` | 1 | Guided requirements — one question at a time with proposed defaults |
| `$spec [section]` | 1 | Refine a specific Spec section (e.g. `$spec data model`) |
| `$specout` | 2 | Generate full 13-section Spec and write to SPEC.md |
| `$build` | 3 | Start development — requires approved SPEC.md |
| `$build [feature]` | 3 | Start a specific named increment |
| `$qa` | 4 | Auto QA — applies safe fixes, surfaces security and compliance for human review |
| `$qa review` | 4 | Manual QA — full report, per-finding approval |
| `$qa full` | 4 | Full project audit (alias for $QA in SDAD-Aware mode) |
| `$doc` | Any | Generate full documentation set from SPEC.md + codebase |
| `$doc readme` | Any | Update README.md |
| `$doc api` | Any | Generate or update API reference |
| `$doc arch` | Any | Generate architecture document for delivery or onboarding |
| `$doc compliance` | Any | Generate compliance summary (Tier 2/3 only) |
| `$lesson` | Any | Show all library entries grouped by category |
| `$lesson [keyword]` | Any | Filter entries by keyword, category, or stack |
| `$lesson [L-XX]` | Any | Show full entry for that lesson number |
| `$lesson new` | Any | Guided entry creation — writes to LESSON_LIBRARY.md on approval |
| `$pause` | Any | Show current state: reads SPEC.md + git log + compliance tier + open findings |
| `$skills` | Any | View and adjust active AI specialist skills |
| `$sdad` | Any | Show methodology overview and all commands |

---

## AI Skills

### Always Active (cannot be deactivated)

**🏗️ AI Solutions Architect**
Architecture decisions, LLM integration patterns, cost modeling, red flags.
Active in all phases. Adds an Architecture layer to QA.
Watch for: 🏗️ Architect lens: prefix in responses.

**🔧 AI Engineer**
Implementation quality, tooling setup, CI/CD, developer experience, UI detection, docs standards.
Active in all phases. Adds Developer Experience and Documentation layers to QA.
Watch for: 🔧 AI Engineer lens: prefix in responses.
Key behaviors: detects UI presence in Phase 0 and suggests frontend-design skill,
flags missing test commands / linter / .env.example / CI, enforces documentation
per increment (README, JSDoc, .env.example updates).

**🔐 Security Reviewer**
API key exposure, injection vulnerabilities, PII handling, auth weaknesses.
Active in Phases 3-4. Security findings are always P0/P1/P2 classified.
Never auto-fixed — always requires your explicit approval.

**✅ QA Engineer**
Test coverage, DoD compliance, acceptance criteria, regression risk.
Active in Phase 4. Owns the Functional Coverage layer in QA.

### Auto-activated by compliance tier

**🔒 Compliance Reviewer**
Activated automatically when Tier 2 or Tier 3 is confirmed in Phase 1.
Adds a 🔒 Compliance layer to every $qa run.
Tier 2: PII handling, auth, session security, audit logging, error sanitization.
Tier 3: all Tier 2 checks plus regulatory controls (GDPR/HIPAA/SOC2/PCI-DSS),
encryption, access control, data residency, tamper-evident audit trail.
Generates $doc compliance output for client deliverables.
Watch for: 🔒 Compliance lens: prefix in responses.

### Available to activate manually ($skills to enable)

| Skill | Best activated for |
|-------|-------------------|
| Performance Architect | Load modeling, bottlenecks, caching, async patterns (stack-agnostic) |
| Prompt Engineer | LLM prompt quality, token efficiency, output reliability |

### External Skills (install via npx skills or /plugin)

Install once, use across projects. The four groups below mirror the categories in CLAUDE.md.

**Always relevant:**

| Skill | What it does | Install |
|-------|-------------|---------|
| `api-design-principles` | REST + GraphQL design with code examples. Replaces API Contract Designer. | `npx skills add https://github.com/wshobson/agents --skill api-design-principles` |
| `frontend-design` | Production-grade UI quality for any stack. Suggested automatically when UI detected. | `/plugin install example-skills@anthropic-agent-skills` |
| `skill-creator` | Create and evaluate custom SDAD-CC skills. Useful for training and team extension. | `/plugin install example-skills@anthropic-agent-skills` |
| `mcp-builder` | Build MCP servers for external service integrations. | `/plugin install example-skills@anthropic-agent-skills` |

**Conditional on stack:**

| Skill | What it does | Install |
|-------|-------------|---------|
| `python-performance-optimization` | Profiling, NumPy, async I/O, DB optimization for Python projects. | `npx skills add https://github.com/wshobson/agents --skill python-performance-optimization` |
| `systematic-debugging` | Structured root cause analysis for complex bugs in Phase 3-4. | `/plugin marketplace add obra/superpowers` |
| `test-driven-development` | Strict TDD discipline integrated from Phase 3 onwards. | `/plugin marketplace add obra/superpowers` |

**Conditional on project type:**

| Skill | What it does | Install |
|-------|-------------|---------|
| `context-engineering-advisor` | Diagnoses context stuffing vs. engineering for LLM-intensive projects. | `npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill context-engineering-advisor` |
| `prioritization-advisor` | RICE, ICE, Kano frameworks for complex MVP scope decisions in Phase 1. | `npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill prioritization-advisor` |

**Conditional on compliance tier:**

| Skill | What it does | Install |
|-------|-------------|---------|
| `technical-writing` | Formal documentation for client deliverables (Tier 2/3). | `npx skills add https://github.com/supercent-io/skills-template --skill technical-writing` |
| `webapp-testing` | End-to-end web testing for Tier 2/3 projects. | `/plugin install example-skills@anthropic-agent-skills` |

---

## Compliance Tiers

Every SDAD-CC project has a compliance tier. It is detected in Phase 0 and
confirmed by one mandatory question in Phase 1. You can always override the
recommendation.

| Tier | For | Auto-activates | DoD additions |
|------|-----|---------------|---------------|
| **Tier 1 — Standard** | Internal tools, POCs, scripts | Nothing | None |
| **Tier 2 — Business** | SaaS, customer-facing, user data | Compliance Reviewer | PII docs, auth review, audit logging, sanitized errors |
| **Tier 3 — Enterprise** | Regulated environments, corporate IT, cloud with security review | Compliance Reviewer (full) | Threat model, data flow diagram, control matrix — required before $build |

**Tier 3 requires SPEC.md §9 to be complete before `$build` is allowed.**
This is enforced — Claude will not start development without it.

The `$doc compliance` command generates a formal compliance summary for client
delivery, mapping every regulatory control to its implementation in the codebase.

---

## $doc — Technical Documentation

`$doc` generates documentation artifacts from SPEC.md and the live codebase.
All output is written to `/docs/` in the repo.

| Command | What it generates |
|---------|------------------|
| `$doc` | Full documentation set for current project state |
| `$doc readme` | Updates README.md |
| `$doc api` | API reference from code + SPEC.md |
| `$doc arch` | Architecture document for client delivery or team onboarding |
| `$doc compliance` | Compliance summary — data inventory, control matrix, open items (Tier 2/3 only) |

Documentation is also maintained **incrementally during `$build`** — the AI Engineer
skill enforces README updates, JSDoc, and .env.example updates as part of every
increment, not as a separate phase. `$doc` is for formal, standalone deliverables.

---

## The Lesson Library

`LESSON_LIBRARY.md` is a knowledge file that lives in your repo root.
It captures transferable patterns — environment limitations, architectural decisions,
debugging insights — that save future developers (or your future self) from repeating
the same mistakes.

**In SDAD-CC, Claude maintains it directly:**
- After each `$qa`, Claude evaluates whether any finding is lesson-worthy.
- If yes, it proposes a lesson candidate with title, category, signal, and principle.
- If you approve, Claude writes the full entry to `LESSON_LIBRARY.md` immediately.
- No copy/paste. No manual paste reminder. It's just done.

**Entry categories:**

| Category | What it captures |
|----------|-----------------|
| 🧠 LLM Design | Prompt architecture, delegation to LLM vs backend, input structure |
| 🏗️ Architecture | System design decisions with lasting impact |
| 🔍 Data & Debugging | Assumptions about external data, root cause patterns |
| ⚙️ Environment | Runtime limitations, deploy constraints, platform behavior |
| 🔄 Workflow | Patterns for working effectively with Claude |

**Use `$lesson` to search:** `$lesson environment` shows all environment entries.
`$lesson Node.js` finds entries tagged for Node.js. `$lesson L-04` shows entry 4.

---

## The Spec as Living Documentation

`SPEC.md` is not a one-time output. It is the source of truth for the entire project.

- Generated once by `$specout` and written to the repo.
- Updated by Claude whenever a `$build` increment is completed (§13 Authorship Log).
- Updated when you use `$spec [section]` to refine a section mid-development.
- Updated when an approved deviation requires a Spec change.
- Committed to git alongside your code.

**SPEC.md sections:**

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
| 9. Security Considerations | Auth, PII, threat model, compliance |
| 10. Definition of Done | Acceptance criteria per feature |
| 11. Out of Scope (Explicit) | What this version intentionally excludes |
| 12. Open Decisions | Unresolved choices — must close before $build |
| 13. AI Authorship Log | Increment / Feature / Model / Date / Notes |

---

## Best Practices

| Practice | Why it matters |
|----------|---------------|
| Start each session with `$pause` | Claude reads SPEC.md + git log + compliance tier and restores state in seconds |
| Name your `$build` increments | `$build auth module` scopes work better than `$build` alone |
| Confirm compliance tier early | Tier 3 requires threat model before $build — don't discover this at Phase 3 |
| Use `$qa review` for architectural increments | Manual review catches systemic issues auto mode might batch-fix |
| Run `$qa full` before any PR | Even with per-increment QA, a full audit before code review catches cross-increment issues |
| Run `$doc arch` before client delivery | Architecture document from SPEC.md + code takes seconds and saves hours of manual writing |
| Commit SPEC.md, LESSON_LIBRARY.md, and SKILL files | They are infrastructure, not documentation |
| Use `$spec [section]` to update mid-build | Requirements change — update the Spec before deviating, not after |
| Install frontend-design before building any UI | 193k installs — the quality difference is immediate and visible |
| Install systematic-debugging for complex bugs | Structured root cause analysis beats print-debugging in complex Claude Code sessions |
| Share LESSON_LIBRARY.md across team repos | The library gains compound value — lessons from one project prevent bugs in the next |
| Use `$SM` for complex prompts within your app | When your project includes LLM calls, use $SM to build the prompts inside them |

---

## $SM — Socratic-Meta Prompting (Universal Shortcut)

`$SM` works in any Claude session — web UI or Claude Code.
It handles all prompt construction by auto-calibrating depth to what you need.

| Track | When it activates | What it shows |
|-------|------------------|---------------|
| Simple Track | Clear objective, direct request | ⚡ SIMPLE MODE: [one line] then the prompt |
| Complex Track | Ambiguous objective, hidden assumptions | 📊 METHOD + 💡 Reason + 💡 Insight then the prompt |

`$SM` absorbed the old `$P` shortcut. If you used `$P` before, use `$SM` now.

**Useful within SDAD-CC for:** building prompts for LLM features inside your app,
refining requirements questions, and drafting technical documentation.

---

G7 AI Development Methodology | SDAD-CC Usage Guide & Shortcuts Reference | v2.0
Spec-Driven AI Development for Claude Code
