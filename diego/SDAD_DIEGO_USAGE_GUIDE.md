# SDAD-Diego-CC — Usage Guide
# Spec-Driven AI Development for Claude Code — Diego Personal Edition
# Version 3.2 | 2026

---

## Before Every Session

```powershell
# Terminal 1 — context budget monitor
npx ccstatusline@latest

# Terminal 2 — Claude Code
claude
```

Always run ccstatusline first. It shows model, context %, session cost, and git branch.

---

## Starting a New Project

### Option A — From scratch (most common)

```powershell
# 1. Create project folder and copy templates
python "C:\Users\diego\Documents\Cowork\05_Proyectos\SDAD Methodology\sdad-knowledge\scripts\sdad_new.py" "Project Name"

# 2. Open Claude Code in the new project folder
cd "C:\Users\diego\Documents\Cowork\[category]\[project_name]"
claude
```

Inside Claude Code, type `$nuevo` to start.

### Option B — Project already exists

Open Claude Code in the repo and type `$nuevo`. Claude reads all files automatically.

---

## The Full Workflow

```
$nuevo   →   $spec   →   $specout   →   $build   →   $qa   →   $close
```

| Command | Phase | What happens |
|---------|-------|-------------|
| `$nuevo` | 0 — Context | Claude reads the repo and infra docs. Surfaces relevant lessons from LESSON_LIBRARY_MASTER.md (cross-project) and local LESSON_LIBRARY.md. Shows INFRA DECLARATION. |
| `$spec` | 1 — Requirements | One question at a time with proposed defaults. Always ends with the compliance tier question. |
| `$specout` | 2 — Spec | Generates and writes full 13-section SPEC.md to repo root. Asks for approval before $build. |
| `$build` | 3 — Development | Announces each increment (files, tests, docs, dependencies). Waits for approval. Runs tests after each increment. |
| `$qa` | 4 — QA | Reviews the last increment. AUTO mode applies safe fixes and surfaces security/compliance for manual approval. |
| `$close` | 5 — Close | Updates all infra docs, registry, secrets. Captures lessons. Runs sdad_sync.py (Step 6) to push lessons to LESSON_LIBRARY_MASTER.md. |

---

## Command Reference

### Session management

| Command | Description |
|---------|-------------|
| `$nuevo` | Silent project start — reads everything, no questions |
| `$pause` | Show current session state: phase, spec status, context %, open findings, next step |
| `$pause compress` | Compact snapshot to paste at start of next session |
| `$skills` | Show active and available AI skills |
| `$sdad` | Show full methodology overview and all commands |

### Development

| Command | Description |
|---------|-------------|
| `$spec` | Start guided requirements — one question at a time |
| `$spec [section]` | Jump to a specific section (e.g., `$spec security`) |
| `$specout` | Generate and write full SPEC.md |
| `$build` | Start guided development from SPEC.md |
| `$build [feature]` | Build a specific feature |
| `$verify` | Check dependency documentation currency (runs automatically on new deps) |

### QA

| Command | Description |
|---------|-------------|
| `$qa` | Auto mode — applies safe fixes, surfaces security findings for approval |
| `$qa review` | Manual mode — full report, per-finding approval |
| `$qa full` | Full project audit |

### Documentation

| Command | Description |
|---------|-------------|
| `$doc` | Generate full documentation set (delegates to sub-agent) |
| `$doc readme` | Update README.md |
| `$doc runbook` | Update RUNBOOK.md |
| `$doc api` | Generate API reference |
| `$doc arch` | Generate architecture document |

### Project lifecycle

| Command | Description |
|---------|-------------|
| `$close` | Project close — updates all infra docs, syncs lessons to master |
| `$infra` | Show current infra state from filesystem |
| `$lesson` | Show all lesson library entries |
| `$lesson [keyword]` | Filter lessons |
| `$lesson new` | Add a lesson manually |
| `$flow [name]` | Define a repeatable workflow |
| `$flow list` | List all flows in `.sdad/flows/` |
| `$flow [name] run` | Execute a saved flow |

### Retroactive documentation (existing projects without SDAD)

| Command | Description |
|---------|-------------|
| `$docfinal` | Run all 4 retroactive steps — generates SPEC_RETROACTIVE.md, AI log, QA audit, lesson candidates |
| `$docfinal spec` | Step 1 only — retroactive spec |
| `$docfinal qa` | Step 3 only — standalone QA audit |

---

## sdad-knowledge Scripts

These scripts automate the cross-project memory infrastructure.

### Start a new project
```powershell
python "C:\...\sdad-knowledge\scripts\sdad_new.py" "Project Name"
```
- Pulls latest templates from GitHub
- Warns if templates are > 90 days old
- Creates project folder with interactive category resolution
- Prints Claude Project Knowledge upload checklist

### Sync lessons when closing a project
```powershell
python "C:\...\sdad-knowledge\scripts\sdad_sync.py" "Project Name"
```
Called automatically from `$close` Step 6. Run manually if needed.
- Appends approved lessons to LESSON_LIBRARY_MASTER.md
- Updates secrets_manager.py and automatizaciones_registry.md where possible
- Reports what still needs manual attention
- Commits and pushes to GitHub

### Update templates
See [UPDATING_TEMPLATES.md](../../sdad-knowledge/UPDATING_TEMPLATES.md).

---

## Context Budget

| Threshold | What happens |
|-----------|-------------|
| 50% | Soft warning — informational, continue normally |
| 65% | Hard warning — finish current increment, then run `$pause` and start a new session |

Always run ccstatusline to monitor context % in real time.

---

## Compliance Tiers

| Tier | For | QA additions |
|------|-----|-------------|
| **Tier 1** — Standard | Internal tools, automations, POCs | Security P0/P1/P2 layer |
| **Tier 2** — Business | Customer-facing products, user data | + PII handling, audit logging, auth review |
| **Tier 3** — Enterprise | Regulated environments, corporate IT | + Full regulatory controls, encryption, access model |

Tier is detected automatically in Phase 0 and confirmed in `$spec`.

---

## Security Rules (always enforced)

- All credentials via `secrets_helper.py` — never hardcoded
- Token files (`.json`) excluded from version control
- `.env` excluded from version control
- New secrets added to `secrets_manager.py` catalog before `$close`

---

## $close Step-by-Step

1. **QA confirmation** — confirms `$qa` was run on final code
2. **Update infra docs** — writes `infra_SECRETS.md`, `infra_PYTHON_LOCAL.md`, etc. directly to filesystem
3. **Registry entry** — adds project to `automatizaciones_registry.md`
4. **secrets_manager.py** — adds new credentials to catalog
5. **Lesson Library** — proposes up to 2 lesson candidates for this project
6. **Master Lesson Sync** — runs `sdad_sync.py` to push approved lessons to `LESSON_LIBRARY_MASTER.md`
7. **Close summary** — lists all updated files, new secrets, lessons synced, git status

After `$close`, re-upload changed files to Claude Project Knowledge:
- `infra_SECRETS.md` (if changed)
- `infra_PYTHON_LOCAL.md` (if changed)
- `automatizaciones_registry.md` (always)
- `LESSON_LIBRARY.md` (if lessons added)
- `LESSON_LIBRARY_MASTER.md` (after Step 6 sync)

---

## Session Snapshot (long sessions)

When context approaches 65%, run `$pause compress` to generate a snapshot.
Paste it at the start of the next session — Claude restores all state automatically.

```
$pause compress
→ Copy the output
→ Start new Claude Code session
→ Paste snapshot as first message
→ Claude confirms state restored and resumes where you left off
```

---

## Troubleshooting

**`$sdad` not recognized**
→ Verify `CLAUDE.md` is in the repo root and you started `claude` from inside the repo

**`$build` blocked**
→ Either SPEC.md not approved, or context is at 65% — check `$pause` output

**sdad_new.py or sdad_sync.py not found**
→ Verify `sdad-knowledge` repo is cloned at the expected path

**Push fails in sdad_sync.py**
→ Re-configure the remote with your PAT:
   `git remote set-url origin https://diegomondrik:[PAT]@github.com/diegomondrik/sdad-knowledge.git`

**Lessons not showing up in $nuevo**
→ Re-upload `LESSON_LIBRARY_MASTER.md` to Claude Project Knowledge after the last sync

---

G7 AI Development Methodology | SDAD-Diego-CC Usage Guide | v3.2
Spec-Driven AI Development for Claude Code — Diego Personal Edition
