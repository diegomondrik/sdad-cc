# G7 SDAD-CC — Training & Podcast Reference
# Why SDAD-CC Exists, What It Solves, and How to Teach It
# Includes NotebookLM prompts for podcast and training content generation
# Version 2.0 | 2025

---

## Part 1 — The Problem SDAD-CC Solves

### The Developer's Dilemma

Every developer using AI tools today faces the same dilemma: the faster you move with
AI assistance, the less control you seem to have over where you end up.

There are two failure modes:

**Failure Mode A — Vibe Coding**
You describe what you want, the AI writes code, you run it, it mostly works.
You repeat. Three hours later you have something that kind of does the thing,
but you cannot explain its architecture, the tests are thin, and you just realized
the data model you implicitly chose will make the next feature very hard.
The AI was fast. The software is fragile.

**Failure Mode B — Spec Paralysis**
You try to be rigorous. You write a spec before touching code.
The spec takes two days. By day three, requirements have changed.
By day five, the spec is already wrong and nobody is reading it.
The software is more intentional, but the process is slow and the spec
becomes a liability instead of an asset.

SDAD-CC is the third path.

---

### The Core Insight

The problem is not that developers are undisciplined. The problem is that
traditional spec-first processes were designed for a world where writing specs
was expensive and AI couldn't help. Now AI can carry most of the spec-writing
work — but only if you give it a structure to work within.

SDAD-CC uses the AI to guide requirement definition (Phase 1), generate the
living spec (Phase 2), propose each increment before implementing it (Phase 3),
and run QA on what it just built (Phase 4). The developer's job shifts from
"type code" to "make decisions" — which is what senior engineers should be doing.

**The AI proposes. You decide. Every major choice is explicit and recorded.**

---

### Why Claude Code Changes Everything

The web UI version of SDAD (v1.3) required a set of compensatory rituals:
the developer had to manually copy code, paste it into their editor, confirm deployment,
and paste lesson library entries. These rituals existed because the AI had no access
to the actual environment.

Claude Code eliminates the gap between the AI's context and the real codebase.
When Claude Code is running, it sees the same files you see. It can run the same tests.
It writes directly to your editor. The compensatory rituals disappear, and what remains
is pure methodology: spec-first discipline, vertical increments, and integrated QA.

This is why SDAD-CC is notably faster than v1.3 while being equally rigorous.

---

## Part 2 — Key Concepts for Training

### The Spec as Living Documentation

The most common objection to spec-first development is: "specs go stale."
SDAD-CC solves this by making the AI responsible for keeping the spec current.

After every `$build` increment, Claude updates the AI Authorship Log in SPEC.md.
When a deviation is required, Claude flags it and updates the relevant section before
implementing. The spec is not a document you write once — it's a contract Claude
maintains automatically.

**Training exercise:** show developers the SPEC.md from a completed project.
Ask them to trace a feature from §3 (Functional Flows) through §5 (Architecture)
to §13 (AI Authorship Log). The full audit trail is there. Every decision is recorded.

---

### The $qa Two-Speed Model

Traditional code review creates a bottleneck because every finding — from a security
vulnerability to a renamed variable — gets the same treatment: stop, review, approve.

SDAD-CC introduces a two-speed QA model:

**Auto mode (default):** Claude applies style and structure fixes directly and shows
you a unified diff for one-click confirmation. You spend time on what matters.

**Review mode:** Full report, per-finding approval. Use for architectural changes
or when you want to understand what was found — not just fix it.

**Security findings are never auto-fixed.** P0/P1/P2 findings always require your
explicit approval, regardless of mode. The AI knows the difference between "this
variable is badly named" and "this endpoint is unprotected."

**Training exercise:** run `$qa review` on an increment, then run `$qa` (auto) on the
next increment. Compare the time spent. Ask developers: when would you choose each?

---

### The AI Engineer Skill

The AI Engineer skill (new in v1.4) fills a gap that existed in earlier versions.
The Architect designs the system. The QA Engineer validates correctness.
The AI Engineer owns the space in between: the quality of the implementation itself.

Its job is to ask: "Would I be comfortable maintaining this at 2am?"

In Phase 0, it reads the repo and flags missing tooling before a single line is written.
Missing test runner? Flag it. No `.env.example`? Flag it. No linter? Flag it.
These are not nice-to-haves — they are the infrastructure that makes AI-assisted
development sustainable. Tooling debt compounds faster than code debt.

**Training exercise:** show a repo with missing tooling. Run Phase 0. Count the
AI Engineer flags. Then show the same repo after Phase 0 recommendations were applied.
The difference is the foundation that everything else is built on.

---

### The Lesson Library

The Lesson Library is the methodology's memory across projects.

In traditional development, hard-won knowledge lives in developers' heads or in
long Confluence pages nobody reads. When a developer leaves, their lessons leave with them.

The Lesson Library captures lessons in a structured format — category, signal,
problem, solution, transferable principle — and stores them in a file that travels
with the kit. When a new project starts, Claude reads the library and surfaces
relevant lessons from previous projects.

In SDAD-CC, Claude writes entries directly to `LESSON_LIBRARY.md` when you approve
a lesson candidate. No copy/paste. The library grows automatically.

**The signal field is the most important field.** It is one line that answers:
"How would another developer recognize that this lesson applies to them?"
A good signal means a developer reads it and thinks "that's exactly my situation."
A bad signal is too vague to be useful.

**Training exercise:** take 3 real bugs from a past project. Write them as lesson
entries. Evaluate: are the titles pattern-based (not symptom-based)?
Are the signals specific enough for self-identification?

---

### Vertical vs Horizontal Increments

One of the most important concepts in SDAD-CC is the difference between vertical
and horizontal increments.

**Horizontal increment (what most teams do with AI):**
- "Build the database layer"
- "Build the API layer"
- "Build the UI layer"

Each layer is complete before the next starts. Nothing works end-to-end until
all three are done. If the database model turns out to be wrong, you find out
at the end.

**Vertical increment (what SDAD-CC requires):**
- "Build user authentication end-to-end: DB schema, API endpoint, and login UI"
- "Build product listing end-to-end: DB query, API response, and product card"

Each increment is a working feature. You can demo it. You can test it.
If something is wrong, you find out immediately, not at integration time.

**Training exercise:** take a feature list from a real project. Ask developers to
plan it as horizontal increments, then as vertical increments. Discuss: which plan
would surface design errors sooner? Which is easier to show to a stakeholder?

---

## Part 3 — SDAD-CC vs Alternatives

| Approach | Speed | Predictability | Testability | AI Integration |
|----------|-------|---------------|-------------|----------------|
| Vibe coding | 🟢 Fast start | 🔴 Unpredictable | 🔴 Thin | Ad hoc |
| Traditional spec-first | 🔴 Slow | 🟢 High | 🟢 Good | None |
| GitHub Copilot only | 🟡 Fast | 🟡 Medium | 🟡 Medium | Autocomplete only |
| SDAD v1.3 (Web UI) | 🟡 Medium | 🟢 High | 🟢 Good | Structured |
| SDAD-CC v2.0 (Claude Code) | 🟢 Fast | 🟢 High | 🟢 Tests run in CI | Native + direct write |

The key differentiator of SDAD-CC over alternatives is the combination of:
1. Spec-first discipline (predictability)
2. Vertical increments (early error detection)
3. Tests that actually run (not just generated)
4. Security findings that require human approval (safety without slowness)
5. Lesson Library that accumulates across projects (compound knowledge)

---

## Part 4 — Addressing Common Objections

**"Writing a spec before coding slows me down."**
Phase 1 ($spec) takes 10-20 minutes for most projects. It asks one question at a time
and proposes defaults you can accept without thinking. The time saved by not rebuilding
the data model in Phase 3 is measured in hours, not minutes.

**"The QA adds too many steps."**
This is the feedback that drove $qa auto mode. In SDAD-CC, most QA findings are handled
in one turn — Claude fixes them, shows you a diff, you confirm once. Only security
findings and Spec deviations require explicit per-finding approval.

**"I already use Copilot / Cursor / another AI tool."**
SDAD-CC is a methodology, not a tool. You can use any AI coding assistant for
autocomplete and inline suggestions. SDAD-CC structures the higher-level decisions:
what to build, in what order, and how to verify it. The two layers complement each other.

**"My project changes too fast for a spec."**
The Spec is a living document. Every time requirements change, you use `$spec [section]`
to update the relevant section. The AI updates SPEC.md in place. A stale spec is a
choice — not an inevitability.

**"I don't have time to write lessons after every QA."**
You don't write them. Claude proposes one lesson candidate after each QA (only when
there is something worth capturing), and if you say "yes," Claude writes it. Your time
investment is one word per session.

---

## Part 5 — NotebookLM Prompts

Use these prompts in NotebookLM after uploading the SDAD-CC kit files as sources.
The recommended sources to upload are: this document, the Usage Guide, the Install
Guide, and the Methodology Skill file.

---

### Podcast Generation Prompts

**Prompt 1 — Introductory Episode (general audience)**
```
Generate a podcast episode script for a 20-minute conversation between two hosts
discussing SDAD-CC. One host is a developer who has used it in production.
The other host is hearing about it for the first time and asks skeptical questions.

Cover:
- The core problem it solves (vibe coding vs spec paralysis)
- The moment the developer realized they needed a methodology
- The one feature that surprised them most (hint: $qa auto mode or the Lesson Library)
- One concrete example of a mistake it helped them avoid
- Who should and should not use it

Tone: conversational, practical, no hype. The developer is honest about tradeoffs.
Length: approximately 2500 words.
```

**Prompt 2 — Technical Deep Dive Episode**
```
Generate a podcast episode script for a 25-minute technical conversation between
a senior engineer and a developer who just shipped their first project with SDAD-CC.

Cover:
- How the $qa two-speed model works in practice (auto vs review)
- The AI Engineer skill — what it catches that most developers miss
- How SPEC.md evolves across a real project (show the AI Authorship Log)
- The Lesson Library — how to write a good entry vs a bad entry
- Vertical vs horizontal increments — why it matters for AI-assisted development
- When to deviate from the methodology

Tone: peer-to-peer, technically specific, willing to go deep on tradeoffs.
Length: approximately 3000 words.
```

**Prompt 3 — Short Episode — The Lesson Library**
```
Generate a 10-minute podcast episode focused entirely on the Lesson Library concept
in SDAD-CC. Include:
- What problem it solves (knowledge that disappears when developers leave)
- The anatomy of a good lesson entry (signal vs symptom, principle vs solution)
- A concrete example of a bad lesson entry rewritten as a good one
- How Claude maintains it automatically in SDAD-CC v2.0
- How teams share it across projects

Tone: focused, educational, with one concrete before/after example.
Length: approximately 1200 words.
```

---

### Training Material Prompts

**Prompt 4 — Workshop Outline (half-day)**
```
Generate a half-day workshop outline for onboarding a team of 4-8 developers
onto SDAD-CC. Assume they are experienced developers but new to AI-driven
methodology. Include:
- Learning objectives (what they can do after the workshop)
- Session breakdown with timing
- Hands-on exercises for each phase
- Common mistakes to address proactively
- Materials needed
- Facilitator notes for the hardest concepts to teach

Format: structured outline with timing estimates. Total: 4 hours including breaks.
```

**Prompt 5 — Onboarding Doc for New Team Members**
```
Generate a 2-page onboarding document for a developer joining a team that already
uses SDAD-CC. They have 5 years of experience but have never used a structured
AI development methodology. Cover:
- What to expect in their first week (what they will see Claude doing)
- The three commands they will use most
- How to read SPEC.md and understand the project state
- How to contribute to the Lesson Library
- What to do when they disagree with a Claude recommendation

Tone: welcoming, practical, peer-level (not condescending). Under 800 words.
```

**Prompt 6 — FAQ for Skeptical Developers**
```
Generate a Q&A document addressing the most common objections from experienced
developers who are skeptical of AI-assisted methodology. Include at least 8
questions and answers. The answers should be honest about tradeoffs — do not
oversell. For each objection, acknowledge what is true in it before explaining
the SDAD-CC approach.

Questions to include:
- "Doesn't writing a spec slow you down?"
- "What happens when requirements change mid-development?"
- "How is this different from just using Copilot?"
- "What if Claude makes wrong architectural decisions?"
- "Does this work for small one-person projects or just teams?"
- "What if I disagree with the QA findings?"
- Add 2 more questions you infer from the source material.
```

**Prompt 7 — Slide Deck Outline**
```
Generate a slide deck outline for a 30-minute presentation introducing SDAD-CC
to an engineering team. Include:
- Slide titles and bullet points for each slide
- Speaker notes for the 3 slides most likely to generate questions
- A live demo script (5 minutes) showing $spec → $specout → $build → $qa auto
- One slide comparing SDAD-CC to vibe coding with a concrete example

Format: numbered slides with title, bullets, and optional speaker notes.
Total: 15-20 slides.
```

**Prompt 8 — Assessment: Are Developers Using It Correctly?**
```
Generate a checklist that a tech lead can use to evaluate whether a developer
is using SDAD-CC correctly after 2 weeks. Include checks for:
- SPEC.md quality (is it being maintained or frozen?)
- Increment naming and size (are increments vertical and named?)
- QA usage (are they using auto vs review appropriately?)
- Lesson Library (are lessons being captured? are they good quality?)
- Security handling (are P0/P1 findings being reviewed, not auto-fixed?)

Format: checklist with pass/fail criteria for each item. Include one example
of what "good" looks like and what "needs coaching" looks like for each check.
```

---

## Part 6 — Glossary for Training

| Term | Definition |
|------|-----------|
| SDAD-CC | Spec-Driven AI Development for Claude Code — the v1.4 kit |
| CLAUDE.md | The file in your repo root that Claude Code reads as its instructions |
| SPEC.md | The living specification document, auto-generated and maintained by Claude |
| Vertical increment | A complete feature (DB + API + UI + tests) built in one $build step |
| Horizontal increment | A layer built in isolation (all DB first, then all API) — avoided in SDAD |
| $qa auto | QA mode that applies safe fixes directly; surfaces security for human review |
| $qa review | QA mode where every finding requires explicit per-finding approval |
| Lesson Library | LESSON_LIBRARY.md — team knowledge file that grows across projects |
| Lesson candidate | A proposed lesson entry generated by Claude after QA |
| AI Authorship Log | SPEC.md §13 — audit trail of every increment: model, date, feature |
| P0 / P1 / P2 | Security finding severity: P0 = immediate exposure, P1 = latent risk, P2 = hardening |
| AI Engineer skill | Always-active skill focused on implementation quality, tooling, and DX |
| Phase 0 | Context Ingestion — Claude reads the repo before asking any questions |
| Spec deviation | When implementation requires departing from an approved SPEC.md section |
| Lesson signal | The one-line field that tells another developer "this lesson applies to me" |

---

G7 AI Development Methodology | SDAD-CC Training & Podcast Reference | v2.0
Spec-Driven AI Development for Claude Code
