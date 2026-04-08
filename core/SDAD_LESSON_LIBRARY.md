# G7 Lesson Library
# Upload as knowledge file in Project Knowledge.
# Consulted automatically at Phase 0. Updated via $lesson trigger after $qa.
# Version 3.1 | 2026
#
# CC edition:   Claude writes entries directly to this file after approval.
# Web edition:  Claude generates copy-paste blocks — paste them here manually.
# Diego edition: Claude writes entries directly to LESSON_LIBRARY_DIEGO.md after approval.

---

## How to use this file

- **At project start:** Claude surfaces relevant lessons based on your stack (Phase 0, automatic)
- **During development:** Claude proposes one entry after each $qa when a finding is lesson-worthy
- **After $docfinal:** Claude proposes up to 3 candidates from the full codebase audit
- **To add manually:** use `$lesson new` at any time
- **To search:** `$lesson [keyword or category name]`
- **To view a specific entry:** `$lesson [L-XX]`

Lesson capture is always silent when nothing is worth capturing — Claude never forces an entry.

---

## Categories

🧠 LLM Design       — prompt architecture, what to delegate to LLM vs backend, input structure
🏗️ Architecture     — system design decisions with lasting impact
🔍 Data & Debugging  — assumptions about external data, diagnostic tools, root cause patterns
⚙️ Environment      — runtime limitations, deploy constraints, platform-specific behavior
🔄 Workflow         — patterns for working effectively with Claude across sessions

---

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
with lesson-worthy findings. You can also add entries manually with `$lesson new`.)*
