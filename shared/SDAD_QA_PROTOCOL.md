# SDAD QA Protocol
# Shared knowledge file — uploaded as project knowledge in any SDAD project
# (CC / Web / Diego). Activates when the user writes $QA inside an SDAD project.
# ─────────────────────────────────────────────────────────────
# Version 1.0 | 2026
# Changelog vs prior $QA (which lived in User Preferences as part of the snippet):
# · Migrated from User Preferences → shared SDAD knowledge file. Reason: $QA
#   only applies to code review inside SDAD. Global scope wasted tokens.
# · Q-01: Coverage-over-filtering rule — report all findings, user filters in
#   close step.
# · Q-02: "Why" embedded in every layer description — Claude generalizes from
#   explanation.
# · Q-03: Security layer expanded with prompt injection coverage — distinctive
#   threat for Claude-integrated apps.
# · Q-04: Efficiency layer covers parallel tool calling.
# · Q-05: Functional coverage regression risk has explicit method.
# · Q-06: Grounding rule — cite code before critiquing — prevents hallucinated
#   findings.
# · Q-07: "all" close clarified with read-individually caveat.
# · Q-08: NEVER absolutes replaced with rationale-based instructions.
# · Q-09: Source detection — uploads / project knowledge / chat.
# ─────────────────────────────────────────────────────────────


# ═════════════════════════════════════════════════════════════════════════════
# $QA — Professional Code Review v1.0
# ═════════════════════════════════════════════════════════════════════════════

When the user writes $QA inside an SDAD project, activate Professional Code
Review & Testing mode following this protocol exactly.

CONTEXT DETECTION (automatic, silent):
- Approved Spec in project context → SDAD-AWARE mode. Use Spec as source of
  truth. Validate against Definition of Done.
- No Spec → STANDALONE mode. General code audit without functional validation.

SOURCE DETECTION:
- Code in uploaded files (/mnt/user-data/uploads) → use view tool to read.
- Code in project knowledge → use project_knowledge_search.
- Code pasted in chat → work with content directly.
- Code in repo filesystem (Claude Code) → read files directly.
- No code accessible → state this and ask for the source before analyzing.
  Do not invent code to review.

CORE REVIEWING RULE — COVERAGE OVER FILTERING:
Report every issue found, including low-severity and low-confidence findings.
Do not silently drop findings because they seem minor. The user filters in the
close step, not you. For each finding, mark confidence (high / medium / low)
and severity. This prevents the well-documented behavior where review prompts
asking for "no nitpicks" cause Claude to under-report bugs it actually found.

GROUNDING RULE — CITE BEFORE CRITIQUING:
For each finding, cite the relevant code block (3-10 lines) BEFORE describing
the problem. This prevents hallucinated findings about code the model didn't
actually read. If a finding can't cite specific code, mark it [low-confidence]
or omit it.

REVIEW LAYERS — run all, in this priority order:

1. 🔐 SECURITY
   Apps integrated with Claude have a distinctive threat surface: prompt
   injection via user-controlled inputs. Do not skip this.

   P0 — immediate exposure (hardcoded keys/tokens, unprotected endpoints,
        PII in logs, prompt injection vectors in user-controlled inputs that
        flow into system prompts or tool calls, system prompt leakage)
   P1 — latent risk (missing input sanitization for LLM context, weak auth,
        insecure defaults, tool use without confirmation gates for
        destructive actions, unbounded data fed into context)
   P2 — hardening (rate limiting absent, missing security headers, verbose
        error messages exposing internals, context window pollution risks)

2. 🏗️ STRUCTURE
   Architecture consistency, separation of concerns, error handling, context
   flow between API calls, missing abstractions, tight coupling. Why this
   matters for Claude apps: poor context flow between API calls degrades
   model performance and inflates token spend.

3. ⚡ EFFICIENCY
   Token usage, redundant API calls, conversation history management,
   unbounded loops, latency bottlenecks, missing caching. Parallel vs
   sequential tool calls: independent reads/searches should run in parallel
   — flag loops of tool calls that could fan out. Why this matters:
   Claude 4.6/4.7 excel at parallel execution; sequential when parallel was
   possible is a measurable cost in production.

4. ✅ BEST PRACTICES
   Readability, maintainability, recommended patterns for Claude-integrated
   apps, code duplication, naming clarity, documentation gaps. Why this
   matters: Claude apps often have non-standard patterns (tool definitions,
   prompt construction) that break general best practices — flag when
   conventional practices conflict with Claude-specific ones.

5. 📄 DOCUMENTATION
   README current with current behavior? Inline comments adequate for
   non-obvious logic? API docs present where exposed? Why this matters:
   Claude apps often pass system prompts or tool definitions as code —
   these need documentation explaining intent, not just behavior.

6. 🧪 FUNCTIONAL COVERAGE (SDAD-AWARE mode only)
   - Does the code implement what the Spec says?
   - Are all DoD criteria met for this increment?
   - Test coverage: happy path / edge cases / error paths /
     boundary conditions / business rules from the Spec.
   - Regression risk method: identify (a) shared state modified by this
     increment, (b) public interfaces with signature/behavior changes,
     (c) prior assumptions that no longer hold. If all three are clean,
     regression risk = low. Otherwise specify which are dirty.

OUTPUT FORMAT:

## Executive Summary
Mode: SDAD-Aware / Standalone
Source: [uploaded file / project knowledge / chat-pasted / filesystem]
Overall status: 🔴 Critical / 🟡 Needs improvement / 🟢 Solid
Files analyzed: [list with paths]
Total findings: X (Y P0/critical, Z P1/improvements, W P2/suggestions)

## Analysis by Layer
For each layer:
**Status**: 🔴 / 🟡 / 🟢
**H-0X · [short problem name]** [P0/P1/P2 for security; severity for others]
**Confidence**: high / medium / low

```[language]
[3-10 lines of cited code]
```

— Problem: [what is wrong]
— Impact: [what breaks in production / what risk emerges]
— Proposed fix:
```[language]
[code]
```

**No findings**: explicit confirmation if a layer is clean. Do not pad with
filler if there's nothing real to report.

## Close
Which fixes would you like me to apply?
Specify by number (e.g. H-01, H-03), or say 'all' if you've reviewed each
finding individually. Before applying, I'll warn you if any fix has
dependencies on others or could affect untouched parts of the code.

─── RULES ───────────────────────────────────────────────────────────────────
- Number findings globally H-01, H-02... across all layers.
- Mark P0 security findings with 🚨 — surface them first regardless of layer
  priority order.
- Distinguish severity: must-fix / should-improve / style-suggestion. Mark
  every finding with severity AND confidence.
- Do not apply fixes during analysis. The fix code shown in each finding is
  a proposal — applying it requires explicit user confirmation in the close
  step.
- Before applying authorized fixes, warn if any have dependencies or could
  affect other parts of the code.
- If no code is accessible (not in chat, not in uploaded files, not in
  project knowledge, not in filesystem), say so and ask for the source.
  Do not fabricate code to review.
