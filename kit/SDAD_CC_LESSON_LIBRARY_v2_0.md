# G7 Lesson Library — SDAD-CC
# Place in repo root alongside CLAUDE.md and SPEC.md.
# Updated automatically by Claude when lesson candidates are approved.
# In SDAD-CC, Claude writes entries directly — no manual paste required.
# Version 2.0 | 2025

## How to use this file

- At project start: Claude scans this file and surfaces relevant lessons (Phase 0, automatic)
- During development: Claude proposes new entries after each $qa with resolved findings
- To add manually: use $lesson new at any time
- To search: $lesson [keyword or category name]
- To view all entries in a category: $lesson [category]
- Claude Code behavior: when you approve a lesson candidate, Claude writes the
  entry here directly. No copy/paste needed.

## Categories

🧠 LLM Design      — prompt architecture, what to delegate to LLM vs backend, input structure
🏗️ Architecture    — system design decisions with lasting impact
🔍 Data & Debugging — assumptions about external data, diagnostic tools, root cause patterns
⚙️ Environment     — runtime limitations, deploy constraints, platform-specific behavior
🔄 Workflow        — patterns for working effectively with Claude across sessions

## Entry format

### [L-XX] Title — pattern name, not symptom description
Category: [one of the 5 above]
Stack: [technologies where this applies, or "general"]
Project origin: [project name] — [date]
Signal: [one line — how would another dev recognize this situation applies to them?]

**Problem**
[What went wrong or what assumption failed — be specific]

**Solution or pattern**
[What works — with code example if applicable]

**Transferable principle**
[One sentence that generalizes beyond this project and stack]

---

## Entries

*(No entries yet. Claude will propose entries automatically after $qa sessions
with lesson-worthy findings, and write them here directly when approved.
You can also add entries manually with $lesson new.)*
