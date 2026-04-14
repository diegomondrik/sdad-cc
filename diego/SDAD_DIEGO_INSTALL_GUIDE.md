# SDAD-Diego — Installation & Setup Guide
# Version 3.1 | 2026

---

## Overview

SDAD-Diego wraps SDAD-CC v3.1 with Diego's personal infrastructure context.
One project per product. Setup takes ~3 minutes per new project.
After setup, Claude knows your entire infrastructure from the first message.

---

## File inventory — what goes where

### SDAD-Diego kit files

| File | Destination |
|------|-------------|
| `SDAD_DIEGO_SKILL.md` | Upload as knowledge file |
| `SDAD_DIEGO_PROJECT_INSTRUCTIONS.md` | Paste into Project Instructions |

### Your infra docs (always from your machine — never from a previous project)

| File | Location on machine | Destination |
|------|---------------------|-------------|
| `infra_SECRETS.md` | `C:\Users\diego\Documents\Cowork\infra\` | Upload as knowledge file |
| `automatizaciones_registry.md` | `C:\Users\diego\Documents\Cowork\` | Upload as knowledge file |
| `LESSON_LIBRARY_DIEGO.md` | `C:\Users\diego\Documents\Cowork\` | Upload as knowledge file |
| `infra_PYTHON_LOCAL.md` | `C:\Users\diego\Documents\Cowork\infra\` | Upload if project uses Python |
| `infra_QBO_AUTH.md` | `C:\Users\diego\Documents\Cowork\infra\` | Upload if project uses QBO |
| `infra_XXXXX.md` | Created during project | Upload when ready |

> Always upload current versions from your machine — not copies from previous projects.
> Your machine is the source of truth. These files are updated by $close.

---

## Setup per new project (~3 minutes)

### Step 1 — Create a new Claude Project

1. claude.ai → Projects → New Project
2. Name it for the product (e.g. "QBO Extractor", "Sales Dashboard", "Invoice Parser")
3. Click Create

### Step 2 — Upload knowledge files

Click the paperclip / 'Add content' icon. Upload in this order:

**Always (every project):**
- `SDAD_DIEGO_SKILL.md`
- `infra_SECRETS.md` ← current version from your machine
- `automatizaciones_registry.md` ← current version from your machine
- `LESSON_LIBRARY_DIEGO.md` ← current version, not blank template

**If project uses Python (most projects):**
- `infra_PYTHON_LOCAL.md`

**If project uses QuickBooks Online:**
- `infra_QBO_AUTH.md`

**If project uses a new integration:**
- `infra_XXXXX.md` — create it as the project develops, upload when ready

### Step 3 — Paste Project Instructions

1. Inside the project → 'Edit project instructions'
2. Open `SDAD_DIEGO_PROJECT_INSTRUCTIONS.md`
3. Select all → Copy
4. Paste into the Project Instructions field
5. If you have project-specific notes (frozen decisions, known constraints),
   append them after the pasted content
6. Save

### Step 4 — User Preferences (once per account)

`$SM`/`$S` and `$QA` are installed in User Preferences and work in any conversation.

If not yet set up — or upgrading from a previous version:
1. Go to Settings → Profile → Preferences
2. Copy the content of `SDAD_USER_PREFERENCES_SNIPPET.md`
3. Paste at the **end** of the field (append — do not replace existing content)
4. Save

> v3.1 changes in User Preferences: $QA now has 6 layers (Documentation added),
> $SM now includes a Phase 6 feedback loop after delivering the prompt.
> If you already have $SM and $QA, replace the entire block with the v3.1 snippet.

---

## Verify the Setup

After completing all steps:

1. Open a new conversation inside the project
2. Type `$nuevo` and send
3. Claude should output the CONTEXT ANALYSIS block followed by the INFRA DECLARATION block
4. If infra docs are loaded correctly, credentials and stack will be listed

If `$nuevo` produces both blocks without asking questions, setup is complete.

---

## End of project — what to update

After every `$close`, re-upload the changed files to the Claude project:

**Re-upload checklist (after $close):**
- [ ] `infra_SECRETS.md` — if new credentials were added
- [ ] `infra_PYTHON_LOCAL.md` — if new patterns or libraries were used
- [ ] `infra_QBO_AUTH.md` — if QBO was used and new lessons were learned
- [ ] `automatizaciones_registry.md` — always (new entry added)
- [ ] `LESSON_LIBRARY_DIEGO.md` — if new lessons were approved
- [ ] `LESSON_LIBRARY_MASTER.md` — after sdad_sync.py runs (Step 6 of $close)

> When starting a new project: always pull the latest infra docs from your machine,
> not from a previous Claude project. Your machine is the source of truth.

---

## Setup de sdad-knowledge (una sola vez)

`sdad-knowledge` es el repo central de memoria cross-proyecto del kit SDAD-Diego v3.2.
Guarda las lecciones aprendidas de todos tus proyectos y los templates actualizados.

### Prerequisito
Tener `GITHUB_PAT` cargado en Windows Credential Manager vía `secrets_manager.py`:
1. Ejecutá `python infra\secrets_manager.py`
2. Opción 3 — Agregar secret
3. Clave: `GITHUB_PAT` | Valor: tu Personal Access Token de GitHub
   (el PAT necesita scope `repo` — github.com → Settings → Developer settings → Tokens)

### Paso a paso

```powershell
# 1. Clonar el repo (si no lo tenés aún)
cd "C:\Users\diego\Documents\Cowork\05_Proyectos\SDAD Methodology"

# 2. Correr el setup (SOLO UNA VEZ — aborta si el repo ya existe)
python "sdad-knowledge\scripts\sdad_setup.py"
```

El script:
- Crea el repo privado `sdad-knowledge` en tu GitHub
- Sube los templates actuales del kit
- Registra la automatización en `automatizaciones_registry.md`
- Muestra el checklist de acciones manuales restantes

### Verificar
```powershell
python "sdad-knowledge\scripts\sdad_new.py" "Test Proyecto"
```
Si ves el checklist de Claude Project Knowledge, el setup está completo.

---

## Upgrading from SDAD-Diego v3.0

Replace in each active project:

| Remove | Replace with |
|--------|-------------|
| `SKILL_SDAD_DIEGO_v3_0.md` | `SDAD_DIEGO_SKILL.md` |
| `PROJECT_INSTRUCTIONS_SDAD_DIEGO_v3_0.md` | `SDAD_DIEGO_PROJECT_INSTRUCTIONS.md` |

Update User Preferences: replace the $SM/$QA block with `SDAD_USER_PREFERENCES_SNIPPET.md`.

Key changes in v3.1:
- $build guardrail: explicit handling when SPEC.md is missing (offers $spec or $docfinal)
- Tier 3 $build blocker now stated explicitly in Compliance Tiers section
- QA layers now 6 (Documentation layer added — was missing from v3.0)
- $qa full vs $QA clearly differentiated: $qa full = SDAD-Aware; $QA = any session
- $QA command summary updated to reflect Standalone vs SDAD-Aware distinction
- $SM Phase 6 feedback loop added to User Preferences
- Sub-agent failure guardrail added (WHEN agent_output.tmp empty → surface error)
- QA finding numbering now reads DECISIONS.md to continue from prior session number
- Core Rule exception for $docfinal documented explicitly
- External Skills and Complementary Tools converted to comment blocks in Diego CC CLAUDE.md

---

## Exporting to a new machine or account

1. Copy `C:\Users\diego\Documents\Cowork\infra\` to the new machine
2. Run `secrets_manager.py` on the new machine to re-enter credentials
   (credentials live in Windows Credential Manager, not in files)
3. Set up User Preferences on the new account (paste `SDAD_USER_PREFERENCES_SNIPPET.md`)
4. For each project: repeat Steps 1–4 above using the current infra docs

---

## Complete knowledge file checklist per project

| File | Required | Condition |
|------|----------|-----------|
| `SDAD_DIEGO_SKILL.md` | ✅ Always | — |
| `infra_SECRETS.md` | ✅ Always | Current version from machine |
| `automatizaciones_registry.md` | ✅ Always | Current version from machine |
| `LESSON_LIBRARY_DIEGO.md` | ✅ Always | Current version, not blank |
| `LESSON_LIBRARY_MASTER.md` | ✅ Always (v3.2+) | From sdad-knowledge repo — cross-project lessons |
| `infra_PYTHON_LOCAL.md` | If Python | Most projects |
| `infra_QBO_AUTH.md` | If QBO | QBO-related projects |
| `infra_XXXXX.md` | If new integration | Create during project, upload when ready |

---

G7 AI Development Methodology | SDAD-Diego Installation Guide | v3.1
Spec-Driven AI Development — Diego Personal Edition
