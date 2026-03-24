# ============================================================
# G7 SDAD-CC v2.0 — Installer for Windows
# Spec-Driven AI Development for Claude Code
# https://github.com/diegomondrik/sdad-cc
#
# Run from PowerShell as Administrator:
#   irm https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.ps1 | iex
#
# Or save and run locally:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   .\install.ps1
# ============================================================

$ErrorActionPreference = "Stop"

# ── Config ───────────────────────────────────────────────────
$SDAD_VERSION    = "2.0"
$SDAD_REPO       = "https://raw.githubusercontent.com/diegomondrik/sdad-cc/main"
$NODE_MIN_VERSION = 18

$REQUIRED_FILES = @(
  @{ Dest = "CLAUDE.md";                  Source = "SDAD_CC_CLAUDE_MD_v2_0.md" },
  @{ Dest = "SKILL_SDAD_METHODOLOGY.md";  Source = "SDAD_CC_SKILL_SDAD_METHODOLOGY_v2_0.md" },
  @{ Dest = "SKILL_AI_ARCHITECT.md";      Source = "SDAD_CC_SKILL_AI_ARCHITECT_v2_0.md" },
  @{ Dest = "SKILL_AI_ENGINEER.md";       Source = "SDAD_CC_SKILL_AI_ENGINEER_v2_0.md" },
  @{ Dest = "SKILL_COMPLIANCE.md";        Source = "SDAD_CC_SKILL_COMPLIANCE_v2_0.md" },
  @{ Dest = "LESSON_LIBRARY.md";          Source = "SDAD_CC_LESSON_LIBRARY_v2_0.md" }
)

# ── Helpers ──────────────────────────────────────────────────
function Write-Ok($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "  [!!] $msg" -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "  [XX] $msg" -ForegroundColor Red }
function Write-Info($msg) { Write-Host "  --> $msg" -ForegroundColor Cyan }
function Write-Step($msg) { Write-Host "`n$msg" -ForegroundColor White }

function Confirm-Action($prompt, $default = "y") {
  $answer = Read-Host "  $prompt [Y/n]"
  if ([string]::IsNullOrWhiteSpace($answer)) { $answer = $default }
  return $answer -match "^[Yy]$"
}

function Command-Exists($cmd) {
  return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

# ── Header ───────────────────────────────────────────────────
function Show-Header {
  Write-Host ""
  Write-Host "  ============================================" -ForegroundColor Blue
  Write-Host "  G7 SDAD-CC v$SDAD_VERSION — Installer (Windows)" -ForegroundColor Blue
  Write-Host "  Spec-Driven AI Development for Claude Code" -ForegroundColor Blue
  Write-Host "  ============================================" -ForegroundColor Blue
  Write-Host ""
}

# ── Node.js ──────────────────────────────────────────────────
function Check-Node {
  Write-Step "Step 1/5 — Checking Node.js"

  if (Command-Exists "node") {
    $version = (node --version).TrimStart("v").Split(".")[0]
    if ([int]$version -ge $NODE_MIN_VERSION) {
      Write-Ok "Node.js $(node --version) — OK"
      return
    }
    else {
      Write-Warn "Node.js $(node --version) found but v$NODE_MIN_VERSION+ required"
    }
  }
  else {
    Write-Warn "Node.js not found"
  }

  Install-Node
}

function Install-Node {
  if (-not (Confirm-Action "Install Node.js $NODE_MIN_VERSION+?")) {
    Write-Fail "Node.js is required. Install from https://nodejs.org and re-run."
    exit 1
  }

  # Try winget first (Windows 11 / updated Windows 10)
  if (Command-Exists "winget") {
    Write-Info "Installing Node.js via winget..."
    winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
  }
  # Try Chocolatey
  elseif (Command-Exists "choco") {
    Write-Info "Installing Node.js via Chocolatey..."
    choco install nodejs-lts -y
  }
  # Try Scoop
  elseif (Command-Exists "scoop") {
    Write-Info "Installing Node.js via Scoop..."
    scoop install nodejs-lts
  }
  else {
    Write-Fail "No package manager found (winget / choco / scoop)."
    Write-Fail "Install Node.js manually: https://nodejs.org"
    Write-Info "Then re-run this installer."
    exit 1
  }

  # Refresh PATH
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")

  if (Command-Exists "node") {
    Write-Ok "Node.js $(node --version) installed"
  }
  else {
    Write-Warn "Node.js installed but not in PATH yet. Restart PowerShell and re-run."
    exit 1
  }
}

# ── Claude Code ───────────────────────────────────────────────
function Check-ClaudeCode {
  Write-Step "Step 2/5 — Checking Claude Code"

  if (Command-Exists "claude") {
    $version = (claude --version 2>$null | Select-Object -First 1)
    Write-Ok "Claude Code $version — OK"
    return
  }

  Write-Warn "Claude Code not found"
  if (Confirm-Action "Install Claude Code now?") {
    Write-Info "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")

    if (Command-Exists "claude") {
      Write-Ok "Claude Code installed"
    }
    else {
      Write-Warn "Installed but not in PATH yet. Restart PowerShell and re-run."
      exit 1
    }
  }
  else {
    Write-Fail "Claude Code required. Install: npm install -g @anthropic-ai/claude-code"
    exit 1
  }
}

# ── Git ───────────────────────────────────────────────────────
function Check-Git {
  Write-Step "Step 3/5 — Checking Git repository"

  if (-not (Command-Exists "git")) {
    Write-Fail "git not found. Install from https://git-scm.com"
    exit 1
  }

  $gitCheck = git rev-parse --git-dir 2>$null
  if ($LASTEXITCODE -eq 0) {
    $repoRoot = git rev-parse --show-toplevel
    Write-Ok "Git repository found: $repoRoot"
    Set-Location $repoRoot
  }
  else {
    Write-Warn "Current directory is not a git repository: $(Get-Location)"
    if (Confirm-Action "Initialize a git repository here?") {
      git init
      Write-Ok "Git repository initialized: $(Get-Location)"
    }
    else {
      Write-Fail "SDAD-CC must be installed inside a git repository."
      Write-Info "Run 'git init' in your project folder, then re-run."
      exit 1
    }
  }
}

# ── Download Files ────────────────────────────────────────────
function Install-SdadFiles {
  Write-Step "Step 4/5 — Installing SDAD-CC v$SDAD_VERSION files"

  # Handle existing CLAUDE.md
  $appendClaude = $false
  if (Test-Path "CLAUDE.md") {
    Write-Warn "CLAUDE.md already exists"
    if (Confirm-Action "Append SDAD-CC to existing CLAUDE.md? (recommended)") {
      $appendClaude = $true
    }
  }

  # Handle existing LESSON_LIBRARY.md with content
  $keepLessons = $false
  if (Test-Path "LESSON_LIBRARY.md") {
    $lineCount = (Get-Content "LESSON_LIBRARY.md").Count
    if ($lineCount -gt 30) {
      Write-Warn "Existing LESSON_LIBRARY.md found with entries"
      if (Confirm-Action "Keep existing Lesson Library? (recommended)") {
        $keepLessons = $true
        Write-Ok "LESSON_LIBRARY.md preserved"
      }
    }
  }

  $downloadOk = $true

  foreach ($file in $REQUIRED_FILES) {
    $dest   = $file.Dest
    $source = $file.Source
    $url    = "$SDAD_REPO/kit/$source"

    if ($dest -eq "LESSON_LIBRARY.md" -and $keepLessons) {
      Write-Ok "LESSON_LIBRARY.md — kept existing"
      continue
    }

    Write-Info "Installing $dest..."

    try {
      if ($dest -eq "CLAUDE.md" -and $appendClaude) {
        $content = (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
        Add-Content -Path $dest -Value "`n# -- SDAD-CC v$SDAD_VERSION --"
        Add-Content -Path $dest -Value $content
        Write-Ok "CLAUDE.md — appended"
      }
      else {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Ok "$dest — installed"
      }
    }
    catch {
      Write-Warn "Could not download $source — $($_.Exception.Message)"
      $downloadOk = $false
    }
  }

  if (-not $downloadOk) {
    Write-Host ""
    Write-Warn "Some files could not be downloaded. Check your connection."
    Write-Warn "Manual install instructions: SDAD_CC_INSTALL_GUIDE_v2_0.md"
    if (-not (Confirm-Action "Continue anyway?")) { exit 1 }
  }
}

# ── User Preferences ─────────────────────────────────────────
function Show-PreferencesInstructions {
  Write-Step "Step 5/5 — Claude User Preferences (`$SM and `$QA)"
  Write-Host ""
  Write-Host "  Manual step required — takes 60 seconds" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "  1. Open: https://claude.ai/settings/profile"
  Write-Host "  2. Scroll to 'Preferences'"
  Write-Host "  3. Paste the content of SDAD_USER_PREFERENCES_SNIPPET_v1_3.md"
  Write-Host "  4. Save"
  Write-Host ""

  if (Confirm-Action "Open Claude settings in your browser?") {
    Start-Process "https://claude.ai/settings/profile"
  }

  $snippetFile = "SDAD_USER_PREFERENCES_SNIPPET_v1_3.md"
  if (Test-Path $snippetFile) {
    Get-Content $snippetFile | Set-Clipboard
    Write-Ok "Preferences snippet copied to clipboard — paste and save"
  }
  else {
    Write-Info "Copy content from SDAD_USER_PREFERENCES_SNIPPET_v1_3.md manually"
  }
}

# ── External Skills ───────────────────────────────────────────
function Show-ExternalSkills {
  Write-Host ""
  Write-Host "  Optional: External Skills" -ForegroundColor White
  Write-Host ""
  Write-Host "  Run these inside a Claude Code session:"
  Write-Host ""
  Write-Host "  # Always relevant" -ForegroundColor Cyan
  Write-Host "  /plugin install example-skills@anthropic-agent-skills"
  Write-Host ""
  Write-Host "  # REST/GraphQL APIs" -ForegroundColor Cyan
  Write-Host "  npx skills add https://github.com/wshobson/agents --skill api-design-principles"
  Write-Host ""
  Write-Host "  # TDD + debugging" -ForegroundColor Cyan
  Write-Host "  /plugin marketplace add obra/superpowers"
  Write-Host ""
}

# ── Verification ─────────────────────────────────────────────
function Show-Verification {
  Write-Host ""
  Write-Host "  Verification — run these inside 'claude':" -ForegroundColor White
  Write-Host ""
  Write-Host "  `$sdad     → All 5 phases + active skills listed" -ForegroundColor Cyan
  Write-Host "  `$skills   → 4 skills active by default" -ForegroundColor Cyan
  Write-Host "  `$spec     → First requirements question" -ForegroundColor Cyan
  Write-Host "  `$pause    → Session state from SPEC.md + git log" -ForegroundColor Cyan
  Write-Host "  `$SM hello → SIMPLE MODE response" -ForegroundColor Cyan
  Write-Host ""
}

# ── Summary ───────────────────────────────────────────────────
function Show-Summary {
  Write-Host ""
  Write-Host "  ============================================" -ForegroundColor Green
  Write-Host "  SDAD-CC v$SDAD_VERSION installed successfully!" -ForegroundColor Green
  Write-Host "  ============================================" -ForegroundColor Green
  Write-Host ""
  Write-Host "  Files installed in: $(Get-Location)"
  Write-Host ""
  Write-Host "  Next steps:"
  Write-Host "  1. Complete User Preferences step (if not done)"
  Write-Host "  2. Run: claude"
  Write-Host "  3. Type: `$sdad"
  Write-Host ""
  Write-Host "  Docs: https://github.com/diegomondrik/sdad-cc" -ForegroundColor Cyan
  Write-Host ""
}

# ── Main ─────────────────────────────────────────────────────
Show-Header
Check-Node
Check-ClaudeCode
Check-Git
Install-SdadFiles
Show-PreferencesInstructions
Show-ExternalSkills
Show-Verification
Show-Summary
