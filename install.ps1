# SDAD-CC v3.0 — Installer for Windows (PowerShell)
# G7 Spec-Driven AI Development for Claude Code
#
# HOW TO RUN (does NOT require Administrator — avoids antivirus triggers):
#
#   Option A — paste directly in PowerShell (recommended):
#     $sdad = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1" -UseBasicParsing).Content
#     Invoke-Expression $sdad
#
#   Option B — download first, then run (avoids download+execute in one step):
#     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1" -OutFile "install-sdad.ps1"
#     powershell -ExecutionPolicy Bypass -File ".\install-sdad.ps1"
#
#   To update an existing install:
#     powershell -ExecutionPolicy Bypass -File ".\install-sdad.ps1" --update
#
# WHY THIS APPROACH:
#   The classic "irm url | iex" pattern is flagged by Windows Defender and
#   Execution Policy because it downloads and executes in a single pipeline.
#   Option A reads the script as a string first (no execution flag triggered).
#   Option B downloads the file separately so it can be inspected before running.

param([switch]$update)

$ErrorActionPreference = "Stop"
$REPO = "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/kit"
$REPO_ROOT = "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main"
$SDAD_MARKER = "G7 SDAD-CC"

function Write-Header {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║        SDAD-CC v3.0 — Installer              ║" -ForegroundColor Cyan
    Write-Host "║   Spec-Driven AI Development for Claude Code ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step($msg) { Write-Host "▶ $msg" -ForegroundColor Yellow }
function Write-OK($msg)   { Write-Host "  ✓ $msg" -ForegroundColor Green }
function Write-Info($msg) { Write-Host "  ℹ️  $msg" -ForegroundColor Gray }
function Write-Fail($msg) { Write-Host "  ✗ $msg" -ForegroundColor Red; exit 1 }

function Download-File($url, $dest) {
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-OK $dest
    } catch {
        Write-Fail "Could not download $url — check internet connection"
    }
}

function Get-RemoteVersion {
    $json = (Invoke-WebRequest -Uri "$REPO_ROOT/version.json" -UseBasicParsing).Content
    if ($json -match '"version"\s*:\s*"([^"]+)"') { return $Matches[1] }
    return "unknown"
}

function Get-LocalVersion {
    if (Test-Path ".sdad/version.json") {
        $json = Get-Content ".sdad/version.json" -Raw
        if ($json -match '"version"\s*:\s*"([^"]+)"') { return $Matches[1] }
    }
    return "none"
}

function Save-Version($version, $key) {
    New-Item -ItemType Directory -Force -Path ".sdad" | Out-Null
    Set-Content -Path ".sdad\version.json" -Value @"
{
  "version": "$version",
  "$key": "$(Get-Date -Format 'yyyy-MM-dd')"
}
"@
    Write-OK ".sdad\version.json → v$version"
}

Write-Header

# ─── UPDATE MODE ────────────────────────────────────────────────────────────
if ($update) {
    Write-Step "Checking for updates..."

    $remoteVersion = Get-RemoteVersion
    $localVersion = Get-LocalVersion

    Write-Host "  Local version:  $localVersion"
    Write-Host "  Remote version: $remoteVersion"

    if ($localVersion -eq $remoteVersion) {
        Write-Host ""
        Write-OK "Already up to date (v$remoteVersion)"
        Write-Host ""
        exit 0
    }

    Write-Host "  ↑ Update available: $localVersion → $remoteVersion"
    Write-Host ""
    Write-Step "Updating CLAUDE.md..."
    Download-File "$REPO/SDAD_CC_CLAUDE_MD_v3_0.md" "CLAUDE.md"

    Write-Step "Saving version..."
    Save-Version $remoteVersion "updated"

    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║    ✅ SDAD-CC updated to v$remoteVersion!         ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    exit 0
}

# ─── STEP 1: Node.js ────────────────────────────────────────────────────────
Write-Step "Checking Node.js..."
$nodeOk = $false
try {
    $nodeVer = (node --version 2>$null)
    $major = [int]($nodeVer -replace 'v(\d+)\..*','$1')
    if ($major -ge 18) {
        Write-OK "Node.js $nodeVer"
        $nodeOk = $true
    } else {
        Write-Info "Node.js $nodeVer found but version is below 18."
    }
} catch {}

if (-not $nodeOk) {
    Write-Info "Installing Node.js via winget..."
    try {
        winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
        Write-OK "Node.js installed. You may need to restart PowerShell if 'node' is not found."
        Write-Info "If the installer fails at npm steps, restart PowerShell and re-run."
    } catch {
        Write-Fail "Could not install Node.js automatically. Please install from https://nodejs.org"
    }
}

# ─── STEP 2: Claude Code ────────────────────────────────────────────────────
Write-Step "Checking Claude Code..."
try {
    $claudeVer = (claude --version 2>$null)
    Write-OK "Claude Code $claudeVer"
} catch {
    Write-Info "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    Write-OK "Claude Code installed"
}

# ─── STEP 3: ccstatusline ───────────────────────────────────────────────────
Write-Step "Installing ccstatusline (context budget monitor)..."
npm install -g ccstatusline
Write-OK "ccstatusline installed"
Write-Host ""
Write-Host "  📋 Run the configuration TUI once to set up your status line:"
Write-Host "     npx ccstatusline@latest"
Write-Host "  After that it appears automatically in every Claude Code session."

# ─── STEP 4: git ────────────────────────────────────────────────────────────
Write-Step "Checking git..."
try {
    git rev-parse --git-dir 2>$null | Out-Null
    Write-OK "Git repo detected"
} catch {
    Write-Info "No git repo found. Initializing..."
    git init
    Write-OK "Git initialized"
}

# ─── STEP 5: Download SDAD-CC files ─────────────────────────────────────────
Write-Step "Downloading SDAD-CC v3.0 files..."

# CLAUDE.md
if (Test-Path "CLAUDE.md") {
    $content = Get-Content "CLAUDE.md" -Raw
    if ($content -match [regex]::Escape($SDAD_MARKER)) {
        Write-Info "CLAUDE.md already contains SDAD-CC. Skipping — run with --update to upgrade."
    } else {
        Write-Info "CLAUDE.md exists (non-SDAD). Appending SDAD-CC content..."
        $sdadContent = (Invoke-WebRequest -Uri "$REPO/SDAD_CC_CLAUDE_MD_v3_0.md" -UseBasicParsing).Content
        Add-Content -Path "CLAUDE.md" -Value "`n$sdadContent"
        Write-OK "CLAUDE.md updated"
    }
} else {
    Download-File "$REPO/SDAD_CC_CLAUDE_MD_v3_0.md" "CLAUDE.md"
}

# ─── STEP 6: Create .sdad/ structure ────────────────────────────────────────
Write-Step "Creating .sdad/ directory structure..."
New-Item -ItemType Directory -Force -Path ".sdad" | Out-Null
New-Item -ItemType Directory -Force -Path ".sdad\flows" | Out-Null
New-Item -ItemType File -Force -Path ".sdad\.gitkeep" | Out-Null
Write-OK ".sdad\ and .sdad\flows\ ready"

# .gitignore
$gitignorePath = ".gitignore"
$ignoreEntry = ".sdad/agent_output.tmp"
if (Test-Path $gitignorePath) {
    $existing = Get-Content $gitignorePath -Raw
    if ($existing -notmatch [regex]::Escape($ignoreEntry)) {
        Add-Content -Path $gitignorePath -Value "`n# SDAD-CC — temp files`n$ignoreEntry"
    }
} else {
    Set-Content -Path $gitignorePath -Value "# SDAD-CC — temp files`n$ignoreEntry"
}
Write-OK ".gitignore updated"

# ─── STEP 7: Save version ───────────────────────────────────────────────────
Write-Step "Saving version info..."
$remoteVersion = Get-RemoteVersion
Save-Version $remoteVersion "installed"

# ─── DONE ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          ✅ SDAD-CC v3.0 installed!          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Go to claude.ai/settings/profile → Preferences"
Write-Host "     Paste the content of SDAD_USER_PREFERENCES_SNIPPET.md"
Write-Host ""
Write-Host "  2. To start a new project with SDAD:"
Write-Host "     Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/kit/project-init.ps1' -OutFile 'project-init.ps1'"
Write-Host "     powershell -ExecutionPolicy Bypass -File '.\project-init.ps1'"
Write-Host ""
Write-Host "  3. Before each Claude Code session, run:"
Write-Host "     npx ccstatusline@latest"
Write-Host "     Then in a new terminal: claude"
Write-Host ""
Write-Host "  4. Inside Claude Code, type `$sdad to verify installation"
Write-Host ""
Write-Host "  To update SDAD-CC in future:"
Write-Host "     powershell -ExecutionPolicy Bypass -File '.\install-sdad.ps1' --update"
Write-Host ""