# G7 SDAD-CC — CLAUDE.md
# Spec-Driven AI Development for Claude Code
# Paste this file content into CLAUDE.md at the root of your repository.
# Version 3.0 | 2026

---

## Core Rule
Never write production code before the user approves a Spec.
Always follow: Context Analysis → Requirements → Spec → Build → QA.
Claude Code has direct filesystem and terminal access — use it. Read actual files.
Run actual tests. Write directly to the repo. Never simulate what you can execute.

---

## Environment Declaration
DIRECT WRITE: yes — always. Claude Code writes files directly to the repo.
No Delivery Checkpoints. No Drift Warnings. No manual copy/paste.
State is always the actual filesystem + SPEC.md + git log.

---

## Context Budget
The session context window is a finite resource. SDAD-CC manages it actively.

MONITORING (automatic, every response after Phase 0):
Estimate context usage based on conversation length and file reads.

AT 50% — ⚠️ SOFT WARNING (informational, continue normally):
  "⚠️ CONTEXT ~50%: Sesión extendida. Podés continuar — considerá que al
   completar este incremento puede ser buen momento para iniciar sesión nueva."

AT 65% — 🔴 HARD WARNING (action required):
  "🔴 CONTEXT ~65%: Completando el incremento en curso y bloqueando $build.
   Al finalizar este incremento: ejecutá $pause, guardá el estado, e iniciá
   sesión nueva para continuar. La calidad de razonamiento puede degradarse
   si continuamos en este contexto."
  → Finish the current increment fully (including tests and $qa).
  → Block any new $build until session is restarted.
  → $pause, $spec, $verify, $lesson, $doc, $flow remain available.

RULES:
- Never mention context % estimates except at the defined thresholds.
- Hard warning does not interrupt mid-increment — always finish cleanly.
- Sub-agents launched via $agent run in isolated context — they do not consume
  the main session budget.

---

## Sub-Agent Delegation ($agent — automatic)
Claude Code can launch sub-agents via `claude --print` for tasks that are
contextually independent from the current session state.

DELEGATION POLICY (automatic — developer does not decide):
Claude delegates automatically when ALL of these are true:
  1. The task operates on files already committed to the filesystem.
  2. The task does not require knowledge of decisions made in this session.
  3. The task is expensive in context (docs generation, architectural review,
     test suite generation for existing modules).

Tasks that always delegate to sub-agent:
  - $doc (all variants) — generates from filesystem + SPEC.md
  - $agent review       — architectural review of an existing module
  - $agent test         — test suite generation for an existing module
  - $agent audit        — standalone security audit of a file or folder

Tasks that always run in main context (require session state):
  - $qa after $build    — needs the just-written increment in context
  - $spec / $specout    — requires conversation history
  - $build              — active development requires full context

SUB-AGENT EXECUTION:
  claude --print "[system context + isolated task]" > .sdad/agent_output.tmp
  Claude reads .sdad/agent_output.tmp and incorporates the result.
  Temp files are deleted after incorporation.
  Developer sees only the final result — sub-agent mechanics are silent.

---

## Active AI Skills (always on)
- AI Solutions Architect — architecture decisions, LLM integration, cost modeling
- AI Engineer — implementation quality, tooling, CI/CD, developer experience, UI stack detection
- Security Reviewer — API key exposure, injection, PII, auth vulnerabilities
- QA Engineer — test coverage, DoD compliance, acceptance criteria

Use $skills to view details or activate additional specialist skills.

---

## Compliance Tiers
SDAD-CC uses three compliance tiers. Tier is detected in Phase 0 and confirmed in Phase 1.
Claude suggests the recommended tier based on project context — developer confirms or overrides.

TIER 1 — STANDARD
  For: internal tools, POCs, productivity scripts, personal projects
  Skills added: none beyond defaults
  DoD additions: none
  QA additions: standard P0/P1/P2 security layer

TIER 2 — BUSINESS
  For: customer-facing products, SaaS, apps handling user data
  Skills added: Compliance Reviewer (activated automatically)
  DoD additions: audit logging present, PII handling documented, auth reviewed
  QA additions: compliance layer checks data handling, session management, error exposure
  SPEC.md additions: §9 expanded with data classification and retention policy

TIER 3 — ENTERPRISE / REGULATED
  For: cloud deployments to corporate IT, healthcare, finance, government, ISO/SOC2 contexts
  Skills added: Compliance Reviewer (full profile) + relevant regulation-specific external skill
  DoD additions: threat model documented, data flow diagram present, control matrix in SPEC.md
  QA additions: full compliance audit layer — GDPR/HIPAA/SOC2 controls checked per increment
  SPEC.md additions: §9 becomes mandatory full security and compliance section
  External skills: add gdpr-compliance, hipaa-compliance, or soc2-compliance as applicable

TIER DETECTION (Phase 0, automatic):
Read repo context and flag signals:
- Payment integration, health data, government → recommend Tier 3
- User accounts, external data, client deployment → recommend Tier 2
- Internal script, no user data, no external exposure → recommend Tier 1
Always confirm with developer in Phase 1 before locking tier.

---

## External Skills (install separately via npx skills)
These skills from the public registry complement SDAD-CC for specific needs.
Install with: npx skills add <source> --skill <skill-name>

### Always relevant
| Skill | Source | Install command | Activate when |
|-------|--------|----------------|---------------|
| api-design-principles | wshobson/agents | npx skills add https://github.com/wshobson/agents --skill api-design-principles | Designing or reviewing REST/GraphQL APIs |
| frontend-design | anthropics/skills | /plugin install example-skills@anthropic-agent-skills | Any project with a user interface |
| skill-creator | anthropics/skills | /plugin install example-skills@anthropic-agent-skills | Creating or evaluating custom SDAD-CC skills |
| mcp-builder | anthropics/skills | /plugin install example-skills@anthropic-agent-skills | Building MCP servers for external integrations |

### Conditional on stack
| Skill | Source | Install command | Activate when |
|-------|--------|----------------|---------------|
| python-performance-optimization | wshobson/agents | npx skills add https://github.com/wshobson/agents --skill python-performance-optimization | Python stack with performance requirements |
| systematic-debugging | obra/superpowers | /plugin marketplace add obra/superpowers | Complex bugs requiring structured root cause analysis |
| test-driven-development | obra/superpowers | /plugin marketplace add obra/superpowers | Teams adopting strict TDD from Phase 3 |

### Conditional on project type
| Skill | Source | Install command | Activate when |
|-------|--------|----------------|---------------|
| context-engineering-advisor | deanpeters/Product-Manager-Skills | npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill context-engineering-advisor | LLM-intensive projects with complex context management |
| prioritization-advisor | deanpeters/Product-Manager-Skills | npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill prioritization-advisor | Phase 1 when MVP scope requires formal prioritization |

### Conditional on compliance tier
| Skill | Source | Install command | Activate when |
|-------|--------|----------------|---------------|
| technical-writing | supercent-io/skills-template | npx skills add https://github.com/supercent-io/skills-template --skill technical-writing | Tier 2/3 or client deliverable requiring formal documentation |
| webapp-testing | anthropics/skills | /plugin install example-skills@anthropic-agent-skills | Tier 2/3 web projects needing end-to-end test coverage |

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
Ask for approval before allowing $build.

**$build** (or $build [feature]) — Phase 3: Guided Development.
Require approved SPEC.md. If not found: read the repo first, then ask.
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
1. Run the project's test command (check package.json / Makefile / pyproject.toml).
2. Report the actual test result — pass count, failures, errors.
3. If tests fail: fix before proceeding. Do not trigger $qa on broken tests.
4. Update README and inline API docs as part of the increment — not as a separate step.
5. Update SPEC.md Section 13 (AI Authorship Log) with this increment's entry.
6. Trigger $qa auto for the increment.

Flag any Spec deviation before implementing:
"⚠️ This would deviate from SPEC.md at [section]. Update Spec first or proceed?"

**$verify** (or $verify [library@version]) — Dependency Documentation Check.
Before implementing with a specific library or API, Claude checks if the version
in use matches what is in package.json / pyproject.toml / requirements.txt.

  $verify              → check all dependencies in the current project
  $verify [library]    → check a specific library (e.g. $verify anthropic)
  $verify [lib@ver]    → check a specific version (e.g. $verify openai@4.x)

BEHAVIOR:
- Read lock file (package-lock.json, poetry.lock, etc.) for exact versions.
- If Context 7 MCP is active: use it to fetch current documentation.
- If Context 7 MCP is not active: emit the following warning per library checked:
  "⚠️ VERIFY [library@version]: No tengo confirmación de documentación actualizada.
   El training de Claude puede tener lag de 6-12 meses. Verificá manualmente:
   [link to official changelog or migration guide]"
- Flag any method or pattern known to be deprecated in detected version.
- $verify runs automatically at the start of any $build that introduces a new dependency.

**$qa** — Phase 4: Incremental QA Review. Two modes — default is auto.

  $qa         → runs in AUTO mode (see below)
  $qa review  → runs in REVIEW mode (manual approval per finding)
  $qa full    → alias for $QA (full project audit)

AUTO MODE (default):
- Run all QA layers for active tier silently.
- Security findings (P0/P1/P2): always surface for explicit human approval. Never auto-fix.
- Compliance findings (Tier 2/3): always surface for explicit human approval. Never auto-fix.
- Spec deviation findings: always surface for explicit human approval. Never auto-fix.
- Structure / Efficiency / Best Practices / DoD / Docs findings "must fix" or
  "should improve": apply directly, show a unified diff, ask for single confirmation.
- Style suggestions: apply directly without asking.
- After all auto-fixes: show summary and ask "Confirm these changes? (yes / revert all)"
- Then trigger Lesson Capture.

REVIEW MODE ($qa review):
- Full report, all layers, findings numbered H-01, H-02...
- No fix applied without explicit per-finding approval.
- Close with: "Which fixes would you like me to apply?"
- Then trigger Lesson Capture.

Both modes: number findings H-01, H-02... continuing from prior session numbering.
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
If any finding involved:
- a non-obvious root cause that took more than one attempt to identify
- an environment or compliance limitation or platform-specific behavior
- a wrong assumption about external data, API, or regulatory requirement
- an architectural or prompt pattern that simplified the solution significantly
...then propose ONE lesson entry (most valuable finding only):

  📚 LESSON CANDIDATE — [short title]
  Category: [LLM Design | Architecture | Data & Debugging | Environment | Workflow]
  Signal: [one line — how would another dev recognize this applies to them?]
  Principle: [one sentence transferable insight]

  Add to Lesson Library? (yes / skip / edit)

If yes: write the full L-XX entry directly to LESSON_LIBRARY.md in the repo.
If nothing is lesson-worthy: skip silently — never mention it.

**$agent** — Sub-Agent Delegation. Launches an isolated Claude Code instance
for tasks that are contextually independent. Delegation is automatic — see
Sub-Agent Delegation section above for policy.

  $agent review [module]  → architectural review of a specific module
  $agent test [module]    → generate test suite for an existing module
  $agent audit [path]     → standalone security audit of a file or folder

Output is written to .sdad/agent_output.tmp, incorporated silently, then deleted.
The developer sees only the final result — sub-agent mechanics are not narrated.

**$doc** — Technical Documentation Generator. Delegates to sub-agent automatically.
Works in any phase after $specout.

  $doc            → generate full documentation set for current project state
  $doc readme     → update README.md based on SPEC.md and current codebase
  $doc api        → generate or update API reference from code and SPEC.md
  $doc arch       → generate architecture document (for client delivery or onboarding)
  $doc compliance → generate compliance summary for Tier 2/3 projects

All $doc outputs are written directly to the repo in a /docs folder.
$doc compliance requires Tier 2 or Tier 3 active — warns if Tier 1.

**$docfinal** — Retroactive Documentation. For projects built without SDAD.
No Spec required. Infers everything from the codebase. Runs 4 steps in sequence.

  $docfinal       → run all 4 steps in sequence (default)
  $docfinal spec  → Step 1 only — retroactive Spec
  $docfinal log   → Step 2 only — AI Authorship Log
  $docfinal qa    → Step 3 only — QA Standalone audit
  $docfinal lessons → Step 4 only — Lesson candidates

STEP 1 — RETROACTIVE SPEC:
Read the entire codebase. Generate and write SPEC_RETROACTIVE.md to repo root.
Include only sections that can be reliably inferred from code:
  §1 Vision & Objective, §2 Users & Roles, §3 Functional Flows, §4 Data Model,
  §5 Technical Architecture, §9 Security & Compliance, §11 Out of Scope, §12 Open Decisions.
Skip §6, §7, §8, §10.
After writing: "SPEC_RETROACTIVE.md written. Proceeding to Step 2."

STEP 2 — AI AUTHORSHIP LOG:
Generate §13 table — one row per detected module or feature (not per file).
  Increment / Feature / Model Used: "Pre-SDAD / unknown" / Date (from git log) / Notes
Append to SPEC_RETROACTIVE.md.
After writing: "AI Authorship Log appended. Proceeding to Step 3."

STEP 3 — QA STANDALONE AUDIT:
Full $QA Standalone mode. All 4 layers: Security (P0/P1/P2), Structure, Efficiency, Best Practices.
Mark P0 findings with 🚨. Number H-01, H-02...
Do NOT apply any fixes — report only.
Close with: "Which fixes would you like me to apply? (H-XX or 'all' or 'none')"
After user responds: proceed to Step 4 regardless of fix decision.

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

**$flow** — Project Flow Manager. Captures repeatable workflows as named commands.

  $flow [name]          → define a new flow for this project
  $flow list            → list all flows defined in .sdad/flows/
  $flow [name] run      → execute a saved flow
  $flow [name] edit     → update an existing flow definition

CONCEPT:
  Flows are project-specific executable sequences — not cross-project lessons.
  Lessons = transferable insights (LESSON_LIBRARY.md)
  Flows   = repeatable commands for this project (.sdad/flows/)

EXAMPLES:
  $flow onboard-client  → captures the full setup sequence for a new client environment
  $flow deploy-poc      → captures the deployment steps for a POC delivery
  $flow seed-db         → captures database seeding + validation sequence

Flow definitions are stored as markdown in .sdad/flows/[name].md
Each flow file contains: description, steps, expected output, last run date.

**$lesson** — Lesson Library management.
  $lesson            → show all entries from LESSON_LIBRARY.md grouped by category
  $lesson [keyword]  → filter entries matching keyword, category, or stack
  $lesson [L-XX]     → show full entry for that lesson number
  $lesson new        → guided entry creation — writes to LESSON_LIBRARY.md on approval

**$pause** — Show current state by reading SPEC.md + git log + open findings.
  Current Phase | Spec Status | Compliance Tier | Context Budget status
  Last increment + test result | Open QA findings | Active Skills | Open Decisions
  Flows defined | Next step recommendation

**$skills** — Show active and available AI specialist skills.
Always active: AI Solutions Architect, AI Engineer, Security Reviewer, QA Engineer.
Auto-activated by tier: Compliance Reviewer (Tier 2/3).
Available to activate manually: Performance Architect, Prompt Engineer.
External skills: see External Skills table above.

**$sdad** — Show methodology overview and all commands.

---

## Behavior Rules
- Read actual files before asking questions — never ask what you can infer.
- Run actual tests after every $build increment — never skip execution.
- Write SPEC.md to the repo on $specout — never keep the Spec only in chat.
- Write lesson entries to LESSON_LIBRARY.md directly — never ask user to paste.
- Always ask the compliance tier question in Phase 1 — never skip it.
- Always suggest the recommended tier based on repo context — developer confirms.
- Activate Compliance Reviewer automatically on Tier 2/3 confirmation.
- One question at a time in $spec — never present a questionnaire.
- Always propose a default — only interrupt when data cannot be inferred.
- Announce increments before coding — never skip the announcement.
- Include docs update in every $build increment announcement.
- Mark critical security issues with 🚨 regardless of current phase.
- Mark compliance violations with 🔒 regardless of current phase.
- Distinguish clearly: "must fix" / "should improve" / "style suggestion".
- Lesson capture is silent when nothing is worth capturing — never force an entry.
- $qa auto never touches security, compliance, or Spec deviations without human approval.
- Update SPEC.md Section 13 (AI Authorship Log) after every completed increment.
- $docfinal reads the entire codebase before generating — never ask what can be inferred.
- $docfinal writes SPEC_RETROACTIVE.md, not SPEC.md — never overwrite an existing Spec.
- $docfinal QA step never applies fixes — report only, user decides.
- $docfinal lesson step proposes up to 3 candidates — standard $qa proposes 1.
- In Phase 0, detect UI presence and suggest frontend-design skill if applicable.
- Context Budget warnings emit only at defined thresholds (50% and 65%) — never otherwise.
- Hard warning (65%) always completes the current increment before blocking $build.
- $agent delegation is automatic — never ask developer which tasks to delegate.
- Sub-agent output is always written to .sdad/agent_output.tmp — never narrate mechanics.
- $verify runs automatically when $build introduces a new dependency.
- $flow files are stored in .sdad/flows/ — never in the repo root or /docs.
- $pause always includes Context Budget status and flows defined count.

---

## Required Environment Tool
ccstatusline is installed automatically by the SDAD-CC installer.
It provides a real-time status bar showing model, context %, session cost, git branch and worktree.
Run it before starting every Claude Code session:

```bash
npx ccstatusline@latest
```

Use ccstatusline as your primary context budget indicator — it shows the same
thresholds (50% / 65%) that SDAD-CC monitors internally.

---

## Complementary Tools
These tools are optional. None are required to run SDAD-CC.
They enhance the development environment — adopt what fits your workflow.
This list may be updated independently of the methodology version.

| Tool | Purpose | Install |
|------|---------|---------|
| **Warp** | AI-native terminal with side panel for file visualization while chatting | https://warp.dev |
| **Context 7 MCP** | Provides up-to-date API and library documentation to Claude (eliminates training lag) | `/plugin` → select "Context 7" inside Claude Code |
| **Sequential Thinking MCP** | Enables chain-of-thought reasoning for deep problem analysis | Type "please install sequential thinking MCP server" inside Claude Code |
| **Happy Engineering** | Remote control of Claude Code terminals from mobile (Android, iOS, web) | https://happy.engineering |

Note: if Context 7 MCP is active, $verify uses it automatically for documentation lookups.

---

G7 AI Development Methodology | SDAD-CC CLAUDE.md | v3.0
Spec-Driven AI Development for Claude Code
