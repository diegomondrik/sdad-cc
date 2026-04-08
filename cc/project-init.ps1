# SDAD-CC v3.1 - Project Initializer for Windows (PowerShell)
# G7 Spec-Driven AI Development for Claude Code
#
# HOW TO RUN (from inside your project folder):
#   cd C:\path\to\your\project
#   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.ps1" -OutFile "project-init.ps1"
#   powershell -ExecutionPolicy Bypass -File ".\project-init.ps1"

$ErrorActionPreference = "Stop"
$REPO = "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main"
$SDAD_MARKER = "G7 SDAD-CC"
$TODAY = (Get-Date -Format "yyyy-MM-dd")

function Show-Header {
    Write-Host ""
    Write-Host "SDAD-CC v3.1 - Project Initializer" -ForegroundColor Cyan
    Write-Host "Spec-Driven AI Development for Claude Code" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Step { param($msg); Write-Host "[STEP] $msg" -ForegroundColor Yellow }
function Show-OK   { param($msg); Write-Host "  [OK] $msg" -ForegroundColor Green }
function Show-Info { param($msg); Write-Host "  [INFO] $msg" -ForegroundColor Gray }

Show-Header

# Verify we are not in the user home folder
$currentPath = (Get-Location).Path
$homePath = $env:USERPROFILE
if ($currentPath -eq $homePath) {
    Write-Host ""
    Write-Host "  [WARNING] You are running this from your home folder ($homePath)." -ForegroundColor Red
    Write-Host "  Run the initializer from inside your project folder instead:" -ForegroundColor Red
    Write-Host "    cd C:\path\to\your\project" -ForegroundColor Yellow
    Write-Host "    powershell -ExecutionPolicy Bypass -File $PSCommandPath" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# STEP 1 - Verify SDAD-CC is installed
Show-Step "Checking SDAD-CC installation..."
$sdadFound = $false

if (Test-Path "CLAUDE.md") {
    $claudeContent = Get-Content "CLAUDE.md" -Raw -ErrorAction SilentlyContinue
    if ($claudeContent -and $claudeContent.Contains($SDAD_MARKER)) {
        Show-OK "SDAD-CC found in this repo (CLAUDE.md)"
        $sdadFound = $true
    }
}

if (-not $sdadFound) {
    Write-Host "  [INFO] SDAD-CC not found. Running methodology installer first..." -ForegroundColor Yellow
    Write-Host ""
    $installScript = (Invoke-WebRequest -Uri "$REPO/install.ps1" -UseBasicParsing).Content
    Invoke-Expression $installScript
    Write-Host ""
    Show-OK "SDAD-CC installed. Continuing with project setup..."
}

# STEP 2 - Collect project info
Write-Host ""
Show-Step "Project setup"
Write-Host ""

$defaultName = (Get-Item -Path ".").Name
$projectName = Read-Host "  Project name [$defaultName]"
if ([string]::IsNullOrWhiteSpace($projectName)) { $projectName = $defaultName }

$devName = Read-Host "  Your name (for AI Authorship Log)"
if ([string]::IsNullOrWhiteSpace($devName)) { $devName = "Developer" }

Write-Host ""
Write-Host "  Compliance tier:"
Write-Host "    1) Standard  - internal tools, POCs, personal projects"
Write-Host "    2) Business  - customer-facing products, SaaS, user data"
Write-Host "    3) Enterprise - regulated environments, corporate IT, cloud"
$tierInput = Read-Host "  Select tier [1]"
if ([string]::IsNullOrWhiteSpace($tierInput)) { $tierInput = "1" }

switch ($tierInput) {
    "2" { $tier = "Tier 2 - Business" }
    "3" { $tier = "Tier 3 - Enterprise" }
    default { $tier = "Tier 1 - Standard" }
}

# STEP 3 - Create SDAD project structure
Write-Host ""
Show-Step "Creating SDAD project structure..."

New-Item -ItemType Directory -Force -Path ".sdad" | Out-Null
New-Item -ItemType Directory -Force -Path ".sdad\flows" | Out-Null
New-Item -ItemType File -Force -Path ".sdad\.gitkeep" | Out-Null
Show-OK ".sdad\ and .sdad\flows\ created"

$gitignorePath = ".gitignore"
$ignoreEntry = ".sdad/agent_output.tmp"
if (Test-Path $gitignorePath) {
    $existing = Get-Content $gitignorePath -Raw -ErrorAction SilentlyContinue
    if (-not $existing -or -not $existing.Contains($ignoreEntry)) {
        Add-Content -Path $gitignorePath -Value "`n# SDAD-CC temp files`n$ignoreEntry"
    }
} else {
    Set-Content -Path $gitignorePath -Value "# SDAD-CC temp files`n$ignoreEntry"
}
Show-OK ".gitignore updated"

if (Test-Path "LESSON_LIBRARY.md") {
    $lines = (Get-Content "LESSON_LIBRARY.md" -ErrorAction SilentlyContinue).Count
    if ($lines -gt 5) {
        Show-Info "LESSON_LIBRARY.md has entries - preserved."
    } else {
        Set-Content -Path "LESSON_LIBRARY.md" -Value "# LESSON LIBRARY - $projectName`n# SDAD-CC v3.1 | Started: $TODAY`n# Add entries via: $lesson new inside Claude Code`n"
        Show-OK "LESSON_LIBRARY.md created"
    }
} else {
    Set-Content -Path "LESSON_LIBRARY.md" -Value "# LESSON LIBRARY - $projectName`n# SDAD-CC v3.1 | Started: $TODAY`n# Add entries via: $lesson new inside Claude Code`n"
    Show-OK "LESSON_LIBRARY.md created"
}

if (Test-Path "SPEC.md") {
    Show-Info "SPEC.md already exists - preserved. Run $spec to update."
} else {
    Set-Content -Path "SPEC.md" -Value "# SPEC - $projectName`nVersion: 0.1 | Date: $TODAY | Status: Draft`nDeveloper: $devName`nCompliance: $tier`n`n# Run $spec to begin requirements definition.`n"
    Show-OK "SPEC.md initialized"
}

$registryContent = "# SDAD-CC Project Registry`nProject: $projectName`nStarted: $TODAY`nDeveloper: $devName`nCompliance Tier: $tier`nSDAD Version: 3.1`nStatus: Initialized - pending $spec`n`n## Session Log`n| Date | Phase | Notes |`n|------|-------|-------|`n| $TODAY | Init | Project initialized via project-init.ps1 |`n"
Set-Content -Path ".sdad\project.md" -Value $registryContent
Show-OK ".sdad\project.md registered"

# DONE
Write-Host ""
Write-Host "Project '$projectName' is ready!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Configure ccstatusline if not done yet:"
Write-Host "     npx ccstatusline@latest"
Write-Host ""
Write-Host "  2. Start Claude Code:"
Write-Host "     claude"
Write-Host ""
Write-Host "  3. Inside Claude Code, type: " -NoNewline
Write-Host '$spec' -ForegroundColor Yellow
Write-Host ""
Write-Host "  Files created:"
Write-Host "    SPEC.md           - awaiting requirements"
Write-Host "    LESSON_LIBRARY.md - ready for lessons"
Write-Host "    .sdad\project.md  - project registry"
Write-Host "    .sdad\flows\      - project flows (empty)"
Write-Host ""