# G7 SDAD — Shortcuts Reference & Usage Guide (Web UI Edition)
# Spec-Driven AI Development for Claude Web
# Version 3.1 | 2026

---

## The Five Phases

### PHASE 0 — Context Ingestion (automatic)

Triggered at session start. Claude reads everything available before asking anything.

What Claude reads:
- `SPEC.md` in Project Knowledge — restores full project state if it exists
- `LESSON_LIBRARY.md` in Project Knowledge — surfaces relevant lessons for your stack
- Any code or doc files shared in the conversation
- Session Snapshot if pasted at session start

What Claude detects automatically:
- **Compliance tier signals** — payment integrations, health data, user accounts
- **UI presence** — mentions of React/Vue/Tailwind/mobile trigger a frontend-design skill suggestion
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
🎨 UI detected: recommend activating frontend-design skill [if applicable]

📚 Relevant lessons from the library:
[L-XX] [title] — [why this applies here]
```

---

### PHASE 1 — Requirements Definition [$spec]

One targeted question at a time. Claude always proposes a reasonable default —
say "accept" or "yes" to move forward.

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

**The compliance tier question** (mandatory, never skipped):
```
What's the deployment context for this project?
(1) Internal tool / POC — Tier 1 Standard
(2) Customer-facing product / SaaS — Tier 2 Business
(3) Regulated environment / corporate IT — Tier 3 Enterprise
Based on what I see, I recommend Tier N because [reason].
Confirm or override?
```

Use `$spec [section]` at any time to refine a specific area.

---

### PHASE 2 — Spec Document [$specout]

Generates the complete 13-section Spec as a **copy-paste block ready to save as SPEC.md**.

After generating:
```
SPEC.md ready to copy. Please review.
You can: (1) approve to proceed to $build,
(2) refine a section with '$spec [section name]',
(3) ask me to adjust anything.
```

For Tier 3: §9 Security & Compliance must be complete before approving.

`SPEC.md` is a living document. Save it in Project Knowledge and update it alongside code.

---

### PHASE 3 — Guided Development [$build]

Develops in vertical increments — one complete feature with tests per increment.
Blocked if Context Budget hard warning (65%) was triggered.

Each increment sequence:

**1. Announce**
```
🔨 INCREMENT [N]: [feature name]
Files: [list]
Tests: [description of proposed coverage]
Docs: [what documentation is updated]
Dependencies: [what must be done first]
──────────────────────────────────────
[Waiting for your approval]
```

**2. Write** — after approval, Claude delivers all files as labeled copy-paste blocks.

**3. Tests** — Claude delivers test cases as ready-to-run code with expected results documented.
(Tests cannot be executed in Web UI.)

**4. Update SPEC.md §13** — AI Authorship Log entry delivered as a copy-paste block.

**5. Trigger $qa** — runs in auto mode by default.

**6. Delivery Checkpoint** — summary of all files delivered in the increment.

> Name your increments: `$build auth module` scopes work better than `$build` alone.

---

### PHASE 4 — QA & Review [$qa]

#### $qa (auto mode — default)
- Runs all QA layers silently.
- **Security (P0/P1/P2), Compliance, Spec deviations:** always surfaces for explicit approval. Never auto-applies.
- **Must fix / should improve:** proposes fix with clear diff, asks for single confirmation.
- **Style suggestions:** applies directly showing the change.
- After fixes: "Applied N changes. Confirm? (yes / revert all)"
- Then: evaluates for Lesson Capture.

#### $qa review
Full manual mode — complete report, nothing applied without per-finding approval.
Use for complex increments, architectural changes, or when you want full visibility.

#### $qa full
Alias for `$QA` in SDAD-Aware mode — full project audit, not just the current increment.
Always manual review mode. Use before client deliveries, after large refactors, or at sprint end.

#### When to use which:

| Command | Use when |
|---------|----------|
| `$qa` (auto) | Normal flow — you trust the increment and want to move fast |
| `$qa review` | Complex increment, architectural change, or want full visibility |
| `$qa full` | Before client delivery, after large refactor, at sprint end |
| `$QA` | Full code audit from User Preferences — works outside a project too |

---

## Context Budget

```
SOFT ⚠️ 50% → Informational — continue, consider closing session after current increment
HARD 🔴 65% → $build blocked — finish current increment, run $pause compress, start new session
```

**Signs that context is running low:**
- Responses are shorter than expected
- Claude asks questions you already answered
- Generated code omits details it previously included

**What to do at 65%:**
1. Finish the current increment (including $qa).
2. Run `$pause compress` to generate the Session Snapshot.
3. Copy the full Snapshot.
4. Start a new conversation.
5. Paste the Snapshot as the first message.

---

## Full Command Reference

| Command | Phase | What it does |
|---------|-------|-------------|
| `$sdad` | Any | SDAD methodology overview and command list |
| `$spec` | 1 | Guided requirements — one question at a time with default |
| `$spec [section]` | 1 | Refine a specific section of the Spec |
| `$specout` | 2 | Generate full 13-section Spec → copy-paste block |
| `$build` | 3 | Guided vertical increment development |
| `$build [feature]` | 3 | Scoped increment development |
| `$verify` | Any | Training lag warning + link to changelog (no lock file access in Web UI) |
| `$verify [library]` | Any | Check a specific library |
| `$qa` | 4 | Auto QA — applies safe fixes, surfaces security/compliance for approval |
| `$qa review` | 4 | Manual QA — full report, per-finding approval |
| `$qa full` | 4 | Full project audit in SDAD-Aware mode (alias for $QA with Spec) |
| `$agent review [module]` | Any | Isolated architectural review of a module (simulated in Web UI) |
| `$agent test [module]` | Any | Test suite generation for an existing module (simulated in Web UI) |
| `$agent audit [file]` | Any | Standalone security audit (simulated in Web UI) |
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
| `$flow list` | Any | List all defined flows |
| `$flow [name] run` | Any | Execute a saved flow |
| `$flow [name] edit` | Any | Update an existing flow definition |
| `$lesson` | Any | Show all library entries grouped by category |
| `$lesson [keyword]` | Any | Filter entries by keyword, category, or stack |
| `$lesson [L-XX]` | Any | Show full entry for that lesson |
| `$lesson new` | Any | Guided entry creation → copy-paste block for Lesson Library |
| `$pause` | Any | Show current state: phase, Spec, tier, skills, context budget, findings, next step |
| `$pause compress` | Any | Generate Session Snapshot for next session |
| `$skills` | Any | View and adjust active AI specialist skills |
| `$SM` / `$S` | Any | Prompt construction and optimization (User Preferences) |
| `$QA` | Any | Full code audit — standalone or SDAD-Aware (User Preferences) |

> **Web UI note:** `$agent` commands run as simulated isolated analysis — same reasoning quality, no real sub-processes. `$verify` works without lock file access. `$doc` outputs are delivered as copy-paste blocks, not written to disk.

---

## AI Skills

### Always Active

**🏗️ AI Solutions Architect**
Architecture decisions, LLM integration patterns, cost modeling, red flags.
Active in all phases. Adds an Architecture layer to QA.

**🔧 AI Engineer**
Implementation quality, tooling setup, developer experience, UI detection, docs standards.
Active in all phases. Detects UI in Phase 0, flags missing tooling, enforces docs per increment.

**🔐 Security Reviewer**
API key exposure, injection vulnerabilities, PII handling, auth weaknesses.
Active in Phases 3–4. Always P0/P1/P2 classified. Never auto-applied.

**✅ QA Engineer**
Test coverage, DoD compliance, acceptance criteria, regression risk.
Active in Phase 4. Owns the Functional Coverage layer in QA.

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

### External Skills (reference)

| Skill | Activate when |
|-------|-------------|
| `api-design-principles` | Designing or reviewing REST/GraphQL APIs |
| `frontend-design` | Any project with a user interface (auto-suggested when UI detected) |
| `skill-creator` | Creating or evaluating custom SDAD skills |
| `mcp-builder` | Building MCP servers for external integrations |
| `python-performance-optimization` | Python stack with performance requirements |
| `systematic-debugging` | Complex bugs requiring structured root cause analysis |
| `test-driven-development` | Teams adopting strict TDD from Phase 3 |
| `context-engineering-advisor` | LLM-intensive projects with complex context management |
| `prioritization-advisor` | Phase 1 when MVP scope requires formal prioritization |
| `technical-writing` | Tier 2/3 or client deliverable requiring formal documentation |
| `webapp-testing` | Tier 2/3 web projects needing end-to-end test coverage |

---

## Compliance Tiers

| Tier | For | Auto-activates | DoD additions |
|------|-----|----------------|---------------|
| **Tier 1 — Standard** | Internal tools, POCs, scripts | Nothing | None |
| **Tier 2 — Business** | SaaS, customer-facing, user data | Compliance Reviewer | PII docs, auth review, audit logging, sanitized errors |
| **Tier 3 — Enterprise** | Regulated environments, corporate IT | Compliance Reviewer (full) | Threat model, data flow diagram, control matrix |

**Tier 3: SPEC.md §9 must be complete and approved before `$build` is allowed.**

---

## The Lesson Library

`LESSON_LIBRARY.md` captures transferable patterns across projects.

- After each `$qa`, Claude evaluates whether any finding is lesson-worthy.
- If yes: proposes one candidate (title, category, signal, principle).
- If approved: Claude generates the full entry as a **copy-paste block** for LESSON_LIBRARY.md.
- If nothing is lesson-worthy: skips silently — never mentions it.

| Category | What it captures |
|----------|-----------------|
| 🧠 LLM Design | Prompt architecture, delegation patterns, input structure |
| 🏗️ Architecture | System design decisions with lasting impact |
| 🔍 Data & Debugging | Assumptions about external data, root cause patterns |
| ⚙️ Environment | Runtime limitations, deploy constraints, platform behavior |
| 🔄 Workflow | Patterns for working effectively with Claude |

`$lesson [keyword]` to filter. `$lesson L-04` to read a specific entry.

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

## State Management in Web UI

Project state lives in two complementary places:

**Project Knowledge (permanent project state):**
- `SPEC.md` — the living project document
- `LESSON_LIBRARY.md` — accumulated lesson library
- Defined flows (markdown blocks generated with $flow)
- Technical docs generated with $doc

**Session Snapshot (current session state):**
- Generated with `$pause compress` at the end of each session
- Pasted as the first message in the next session
- Contains: phase, tier, skills, increments, open findings, open decisions, next step

**When to update each:**
| Event | Project Knowledge | Session Snapshot |
|-------|------------------|-----------------|
| $specout complete | Update SPEC.md | — |
| $build complete | Update SPEC.md §13 | — |
| $lesson approved | Update LESSON_LIBRARY.md | — |
| $flow created | Add flow to PK | — |
| Session end | — | Generate with $pause compress |
| New session start | — | Paste Snapshot |

---

## Before Every Session

1. Open your project's Claude Project.
2. If you have a Session Snapshot from the previous session, paste it as the first message.
3. If you don't have a Snapshot, share the current SPEC.md if there have been changes.
4. Type `$pause` to restore full session state.

You don't need to re-explain the project context if you have the Snapshot or SPEC.md loaded.

---

## Best Practices

| Practice | Why it matters |
|----------|---------------|
| Start every session with $pause or pasting the Snapshot | Restores full state without re-explaining anything |
| Update SPEC.md in Project Knowledge after each sprint | It is your source of truth between sessions |
| Watch the Context Budget at 50% | Plan session close before the 65% block hits |
| One session = one complete increment | Starting new work before closing the current increment mixes context and degrades quality |
| Never paste full file contents in chat — update Project Knowledge instead | Pasting code inflates context; PK files load cleanly each session |
| Use `$qa review` for architectural increments | Manual review catches systemic issues that auto mode batches |
| Run `$qa full` before any client delivery | Cross-increment issues only surface in full audits |
| Name your increments | `$build auth module` scopes work better than bare `$build` |
| Confirm compliance tier early | Tier 3 requires §9 complete before $build |
| Save flows in Project Knowledge | Two repetitions of any sequence = worth capturing |
| Use $SM for complex prompts in your LLM app | When your project makes LLM calls, use $SM to build those prompts |
| Share LESSON_LIBRARY.md across team projects | Lessons from one project prevent bugs in the next |

---

## $SM — Socratic-Meta Prompting (Universal Shortcut)

`$SM` works in any Claude session — Web UI or Claude Code.
Handles all prompt construction by auto-calibrating depth to what you need.

| Track | When | What you see |
|-------|------|-------------|
| Simple Track | Clear objective, direct request | ⚡ SIMPLE MODE: [one line] then the prompt |
| Complex Track | Ambiguous objective, hidden assumptions | 📊 METHOD + 💡 Reason + 💡 Insight then the prompt |

---

G7 AI Development Methodology | SDAD Web Shortcuts Reference | v3.1
Spec-Driven AI Development — Web UI Edition
