# SDAD-CC v3.0 — Installer for Windows (PowerShell)
# G7 Spec-Driven AI Development for Claude Code
#
# HOW TO RUN (avoids antivirus and Execution Policy blocks):
#
#   Option A — download first, then run (recommended for BitDefender / Defender):
#     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1" -OutFile "install-sdad.ps1"
#     powershell -ExecutionPolicy Bypass -File ".\install-sdad.ps1"
#
#   Option B — paste directly in PowerShell:
#     $sdad = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1" -UseBasicParsing).Content
#     Invoke-Expression $sdad

$ErrorActionPreference = "Stop"
$REPO = "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/kit"
$SDAD_MARKER = "G7 SDAD-CC"

function Write-Header {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "  SDAD-CC v3.0 - Installer" -ForegroundColor Cyan
    Write-Host "  Spec-Driven AI Development for Claude Code" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step { param($msg); Write-Host ">> $msg" -ForegroundColor Yellow }
function Write-OK   { param($msg); Write-Host "  OK: $msg" -ForegroundColor Green }
function Write-Info { param($msg); Write-Host "  INFO: $msg" -ForegroundColor Gray }
function Write-Fail { param($msg); Write-Host "  FAIL: $msg" -ForegroundColor Red; exit 1 }

function Download-File {
    param($url, $dest)
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-OK $dest
    } catch {
        Write-Fail "Could not download $url — check internet connection"
    }
}

Write-Header

# --- STEP 1: Node.js ---
Write-Step "Checking Node.js..."
$nodeOk = $false

try {
    $nodeVer = node --version 2>$null
    if ($nodeVer) {
        $major = [int]($nodeVer -replace 'v(\d+)\..*', '$1')
        if ($major -ge 18) {
            Write-OK "Node.js $nodeVer"
            $nodeOk = $true
        } else {
            Write-Info "Node.js $nodeVer found but below v18."
        }
    }
} catch {
    Write-Info "Node.js not found."
}

if (-not $nodeOk) {
    Write-Info "Installing Node.js via winget..."
    try {
        winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
        Write-OK "Node.js installed. Restart PowerShell if npm commands fail."
    } catch {
        Write-Fail "Cannot install Node.js automatically. Install from https://nodejs.org then re-run."
    }
}

# --- STEP 2: Claude Code ---
Write-Step "Checking Claude Code..."
$claudeFound = $false

try {
    $claudeVer = claude --version 2>$null
    if ($claudeVer) {
        Write-OK "Claude Code $claudeVer"
        $claudeFound = $true
    }
} catch {}

if (-not $claudeFound) {
    Write-Info "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    Write-OK "Claude Code installed"
}

# --- STEP 3: ccstatusline ---
Write-Step "Installing ccstatusline (context budget monitor)..."
npm install -g ccstatusline
Write-OK "ccstatusline installed"
Write-Host "  NOTE: Run 'npx ccstatusline@latest' once to configure it." -ForegroundColor Cyan
Write-Host "  After that it appears automatically in every Claude Code session." -ForegroundColor Cyan

# --- STEP 4: git ---
Write-Step "Checking git..."
$gitOk = $false

try {
    git rev-parse --git-dir 2>$null | Out-Null
    Write-OK "Git repo detected"
    $gitOk = $true
} catch {}

if (-not $gitOk) {
    Write-Info "No git repo found. Initializing..."
    git init
    Write-OK "Git initialized"
}

# --- STEP 5: Download SDAD-CC files ---
Write-Step "Downloading SDAD-CC v3.0 files..."

if (Test-Path "CLAUDE.md") {
    $claudeContent = Get-Content "CLAUDE.md" -Raw -ErrorAction SilentlyContinue
    if ($claudeContent -and $claudeContent.Contains($SDAD_MARKER)) {
        Write-Info "CLAUDE.md already contains SDAD-CC. Skipping."
    } else {
        Write-Info "CLAUDE.md exists (non-SDAD). Appending SDAD-CC content..."
        $sdadContent = (Invoke-WebRequest -Uri "$REPO/SDAD_CC_CLAUDE_MD_v3_0.md" -UseBasicParsing).Content
        Add-Content -Path "CLAUDE.md" -Value "`n$sdadContent"
        Write-OK "CLAUDE.md updated"
    }
} else {
    Download-File "$REPO/SDAD_CC_CLAUDE_MD_v3_0.md" "CLAUDE.md"
}

Download-File "$REPO/SDAD_CC_SKILL_SDAD_METHODOLOGY_v3_0.md" "SKILL_SDAD_METHODOLOGY.md"
Download-File "$REPO/SDAD_CC_SKILL_AI_ARCHITECT_v3_0.md"     "SKILL_AI_ARCHITECT.md"
Download-File "$REPO/SDAD_CC_SKILL_AI_ENGINEER_v3_0.md"      "SKILL_AI_ENGINEER.md"
Download-File "$REPO/SDAD_CC_SKILL_COMPLIANCE_v3_0.md"       "SKILL_COMPLIANCE.md"

if (Test-Path "LESSON_LIBRARY.md") {
    $lineCount = (Get-Content "LESSON_LIBRARY.md" -ErrorAction SilentlyContinue).Count
    if ($lineCount -gt 5) {
        Write-Info "LESSON_LIBRARY.md has entries — preserved."
    } else {
        Download-File "$REPO/SDAD_CC_LESSON_LIBRARY_v3_0.md" "LESSON_LIBRARY.md"
    }
} else {
    Download-File "$REPO/SDAD_CC_LESSON_LIBRARY_v3_0.md" "LESSON_LIBRARY.md"
}

# --- STEP 6: Create .sdad/ structure ---
Write-Step "Creating .sdad/ directory structure..."
New-Item -ItemType Directory -Force -Path ".sdad" | Out-Null
New-Item -ItemType Directory -Force -Path ".sdad\flows" | Out-Null
New-Item -ItemType File -Force -Path ".sdad\.gitkeep" | Out-Null
Write-OK ".sdad\ and .sdad\flows\ created"

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
Write-OK ".gitignore updated"

# --- DONE ---
Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  SDAD-CC v3.0 installed!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Configure ccstatusline (run once):"
Write-Host "     npx ccstatusline@latest"
Write-Host ""
Write-Host "  2. Set up User Preferences in Claude:"
Write-Host "     claude.ai/settings/profile -> Preferences"
Write-Host "     Paste the content of SDAD_USER_PREFERENCES_SNIPPET.md"
Write-Host ""
Write-Host "  3. Initialize a new project:"
Write-Host "     Download project-init.ps1 and run:"
Write-Host "     powershell -ExecutionPolicy Bypass -File .\project-init.ps1"
Write-Host ""
Write-Host "  4. Start Claude Code and verify:"
Write-Host "     claude"
Write-Host "     Then type: " -NoNewline
Write-Host '$sdad' -ForegroundColor Yellow
Write-Host ""