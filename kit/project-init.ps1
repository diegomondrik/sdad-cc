
# SDAD-CC v3.0 — Project Initializer for Windows (PowerShell)
# G7 Spec-Driven AI Development for Claude Code
#
# HOW TO RUN:
#   Option A — download first, then run (recommended):
#     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.ps1" -OutFile "project-init.ps1"
#     powershell -ExecutionPolicy Bypass -File ".\project-init.ps1"
#
#   Option B — paste directly in PowerShell:
#     $init = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.ps1" -UseBasicParsing).Content
#     Invoke-Expression $init

$ErrorActionPreference = "Stop"
$REPO = "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main"
$SDAD_MARKER = "G7 SDAD-CC"
$TODAY = (Get-Date -Format "yyyy-MM-dd")

function Write-Header {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║     SDAD-CC v3.0 — Project Initializer       ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step($msg) { Write-Host "▶ $msg" -ForegroundColor Yellow }
function Write-OK($msg)   { Write-Host "  ✓ $msg" -ForegroundColor Green }
function Write-Info($msg) { Write-Host "  ℹ️  $msg" -ForegroundColor Gray }

Write-Header

# ─── STEP 1: Verify SDAD-CC is installed ────────────────────────────────────
Write-Step "Checking SDAD-CC installation..."

$sdadFound = $false

if (Test-Path "CLAUDE.md") {
    $claudeContent = Get-Content "CLAUDE.md" -Raw
    if ($claudeContent -match [regex]::Escape($SDAD_MARKER)) {
        Write-OK "SDAD-CC found in this repo (CLAUDE.md)"
        $sdadFound = $true
    }
}

if (-not $sdadFound) {
    Write-Host "  ⚠️  SDAD-CC not found. Running methodology installer first..." -ForegroundColor Yellow
    Write-Host ""
    $installScript = (Invoke-WebRequest -Uri "$REPO/install.ps1" -UseBasicParsing).Content
    Invoke-Expression $installScript
    Write-Host ""
    Write-OK "SDAD-CC installed. Continuing with project setup..."
}

# ─── STEP 2: Collect project info ───────────────────────────────────────────
Write-Host ""
Write-Step "Project setup"
Write-Host ""

$defaultName = (Get-Item -Path ".").Name
$projectName = Read-Host "  Project name [$defaultName]"
if ([string]::IsNullOrWhiteSpace($projectName)) { $projectName = $defaultName }

$devName = Read-Host "  Your name (for AI Authorship Log)"
if ([string]::IsNullOrWhiteSpace($devName)) { $devName = "Developer" }

Write-Host ""
Write-Host "  Compliance tier:"
Write-Host "    1) Standard  — internal tools, POCs, personal projects"
Write-Host "    2) Business  — customer-facing products, SaaS, user data"
Write-Host "    3) Enterprise — regulated environments, corporate IT, cloud"
$tierInput = Read-Host "  Select tier [1]"
if ([string]::IsNullOrWhiteSpace($tierInput)) { $tierInput = "1" }

switch ($tierInput) {
    "2" { $tier = "Tier 2 — Business" }
    "3" { $tier = "Tier 3 — Enterprise" }
    default { $tier = "Tier 1 — Standard" }
}

# ─── STEP 3: Create SDAD project structure ──────────────────────────────────
Write-Host ""
Write-Step "Creating SDAD project structure..."

# .sdad/ directories
New-Item -ItemType Directory -Force -Path ".sdad" | Out-Null
New-Item -ItemType Directory -Force -Path ".sdad\flows" | Out-Null
New-Item -ItemType File -Force -Path ".sdad\.gitkeep" | Out-Null
Write-OK ".sdad\ and .sdad\flows\ created"

# .gitignore
$ignoreEntry = ".sdad/agent_output.tmp"
if (Test-Path ".gitignore") {
    $existing = Get-Content ".gitignore" -Raw
    if ($existing -notmatch [regex]::Escape($ignoreEntry)) {
        Add-Content -Path ".gitignore" -Value "`n# SDAD-CC — temp files`n$ignoreEntry"
    }
} else {
    Set-Content -Path ".gitignore" -Value "# SDAD-CC — temp files`n$ignoreEntry"
}
Write-OK ".gitignore updated"

# LESSON_LIBRARY.md
if (Test-Path "LESSON_LIBRARY.md") {
    $lines = (Get-Content "LESSON_LIBRARY.md").Count
    if ($lines -gt 5) {
        Write-Info "LESSON_LIBRARY.md has entries — preserved."
    } else {
        Set-Content -Path "LESSON_LIBRARY.md" -Value @"
# LESSON LIBRARY — $projectName
# SDAD-CC v3.0 | Started: $TODAY
# Format: L-XX entries grouped by category
# Add entries via `$lesson new inside Claude Code

"@
        Write-OK "LESSON_LIBRARY.md created"
    }
} else {
    Set-Content -Path "LESSON_LIBRARY.md" -Value @"
# LESSON LIBRARY — $projectName
# SDAD-CC v3.0 | Started: $TODAY
# Format: L-XX entries grouped by category
# Add entries via `$lesson new inside Claude Code

"@
    Write-OK "LESSON_LIBRARY.md created"
}

# SPEC.md
if (Test-Path "SPEC.md") {
    Write-Info "SPEC.md already exists — preserved. Run `$spec to update."
} else {
    Set-Content -Path "SPEC.md" -Value @"
# SPEC — $projectName
Version: 0.1 | Date: $TODAY | Status: Draft — run `$spec to begin requirements
Developer: $devName
Compliance: $tier

---

*This file will be populated by `$specout after completing `$spec requirements.*
*Do not edit manually — use SDAD-CC commands inside Claude Code.*
"@
    Write-OK "SPEC.md initialized"
}

# Project registry
New-Item -ItemType Directory -Force -Path ".sdad" | Out-Null
Set-Content -Path ".sdad\project.md" -Value @"
# SDAD-CC Project Registry
Project: $projectName
Started: $TODAY
Developer: $devName
Compliance Tier: $tier
SDAD Version: 3.0
Status: Initialized — pending `$spec

## Session Log
| Date | Phase | Notes |
|------|-------|-------|
| $TODAY | Init | Project initialized via project-init.ps1 |
"@
Write-OK ".sdad\project.md registered"

# ─── DONE ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║      ✅ Project '$projectName' ready!        ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Run: npx ccstatusline@latest"
Write-Host "  2. In a new terminal: claude"
Write-Host "  3. Inside Claude Code: `$spec"
Write-Host ""
Write-Host "  Files created:"
Write-Host "    SPEC.md              — awaiting requirements"
Write-Host "    LESSON_LIBRARY.md    — ready for lessons"
Write-Host "    .sdad\project.md     — project registry"
Write-Host "    .sdad\flows\         — project flows (empty)"
Write-Host ""
