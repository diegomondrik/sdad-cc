#!/usr/bin/env bash
# SDAD-CC v3.1 — Installer for Mac / Linux
# G7 Spec-Driven AI Development for Claude Code
# Run from inside your project folder:
#   curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash

set -e

REPO="https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/kit"
SDAD_MARKER="G7 SDAD-CC"

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║        SDAD-CC v3.1 — Installer              ║"
echo "║   Spec-Driven AI Development for Claude Code ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ─── STEP 1: Node.js ────────────────────────────────────────────────────────
echo "▶ Checking Node.js..."
if command -v node &>/dev/null; then
  NODE_VER=$(node -e "process.exit(parseInt(process.versions.node) < 18 ? 1 : 0)" 2>/dev/null && echo "ok" || echo "old")
  if [ "$NODE_VER" = "old" ]; then
    echo "  ⚠️  Node.js found but version is below 18. Updating..."
    if command -v brew &>/dev/null; then
      brew upgrade node
    elif command -v nvm &>/dev/null; then
      nvm install --lts && nvm use --lts
    else
      echo "  ✗ Cannot auto-update Node.js. Please install Node.js 18+ from https://nodejs.org"
      exit 1
    fi
  else
    echo "  ✓ Node.js $(node --version)"
  fi
else
  echo "  Node.js not found. Installing..."
  if command -v brew &>/dev/null; then
    brew install node
  elif command -v apt-get &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
  elif command -v nvm &>/dev/null; then
    nvm install --lts && nvm use --lts
  else
    echo "  ✗ Cannot auto-install Node.js. Please install from https://nodejs.org"
    exit 1
  fi
  echo "  ✓ Node.js $(node --version) installed"
fi

# ─── STEP 2: Claude Code ────────────────────────────────────────────────────
echo "▶ Checking Claude Code..."
if command -v claude &>/dev/null; then
  echo "  ✓ Claude Code $(claude --version)"
else
  echo "  Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
  echo "  ✓ Claude Code installed"
fi

# ─── STEP 3: ccstatusline ───────────────────────────────────────────────────
echo "▶ Installing ccstatusline (required — context budget monitor)..."
npm install -g ccstatusline
echo "  ✓ ccstatusline installed"
echo ""
echo "  📋 Run the configuration TUI once to set up your status line:"
echo "     npx ccstatusline@latest"
echo "  After that it appears automatically in every Claude Code session."

# ─── STEP 4: git ────────────────────────────────────────────────────────────
echo "▶ Checking git..."
if ! git rev-parse --git-dir &>/dev/null; then
  echo "  No git repo found. Initializing..."
  git init
  echo "  ✓ Git initialized"
else
  echo "  ✓ Git repo detected"
fi

# ─── STEP 5: Download SDAD-CC files ─────────────────────────────────────────
GITHUB_REPO="https://raw.githubusercontent.com/diegomondrik/sdad-cc/main"
echo "▶ Downloading SDAD-CC v3.1 files..."

download_file() {
  local remote_path="$1"
  local dest="$2"
  curl -fsSL "$GITHUB_REPO/$remote_path" -o "$dest"
  echo "  ✓ $dest"
}

# CLAUDE.md — append if exists, create if not
if [ -f "CLAUDE.md" ]; then
  if grep -q "$SDAD_MARKER" CLAUDE.md; then
    echo "  ℹ️  CLAUDE.md already contains SDAD-CC. Skipping — run with --force to overwrite."
  else
    echo "  CLAUDE.md exists (non-SDAD). Appending SDAD-CC content..."
    echo "" >> CLAUDE.md
    curl -fsSL "$GITHUB_REPO/cc/SDAD_CC_CLAUDE_MD.md" >> CLAUDE.md
    echo "  ✓ CLAUDE.md updated"
  fi
else
  download_file "cc/SDAD_CC_CLAUDE_MD.md" "CLAUDE.md"
fi

# Skill files — always replace with latest version
download_file "core/SDAD_CORE_SKILL_METHODOLOGY.md" "SDAD_CORE_SKILL_METHODOLOGY.md"
download_file "core/SDAD_CORE_SKILL_AI_ARCHITECT.md" "SDAD_CORE_SKILL_AI_ARCHITECT.md"
download_file "core/SDAD_CORE_SKILL_AI_ENGINEER.md"  "SDAD_CORE_SKILL_AI_ENGINEER.md"
download_file "core/SDAD_CORE_SKILL_COMPLIANCE.md"   "SDAD_CORE_SKILL_COMPLIANCE.md"

# LESSON_LIBRARY.md — preserve if it has content
if [ -f "LESSON_LIBRARY.md" ] && [ "$(wc -l < LESSON_LIBRARY.md)" -gt 5 ]; then
  echo "  ℹ️  LESSON_LIBRARY.md has entries — preserved."
else
  download_file "core/SDAD_LESSON_LIBRARY.md" "LESSON_LIBRARY.md"
fi

# ─── LOCAL INSTALL (for development use only) ─────────────────────────────────
# If running the script directly from the cloned repo, you can copy files locally
# instead of downloading. Uncomment the block below and comment out Step 5 above.
#
# SDAD_REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# cp "$SDAD_REPO_DIR/cc/SDAD_CC_CLAUDE_MD.md"          CLAUDE.md
# cp "$SDAD_REPO_DIR/core/SDAD_CORE_SKILL_METHODOLOGY.md" SDAD_CORE_SKILL_METHODOLOGY.md
# cp "$SDAD_REPO_DIR/core/SDAD_CORE_SKILL_AI_ARCHITECT.md" SDAD_CORE_SKILL_AI_ARCHITECT.md
# cp "$SDAD_REPO_DIR/core/SDAD_CORE_SKILL_AI_ENGINEER.md"  SDAD_CORE_SKILL_AI_ENGINEER.md
# cp "$SDAD_REPO_DIR/core/SDAD_CORE_SKILL_COMPLIANCE.md"   SDAD_CORE_SKILL_COMPLIANCE.md
# cp "$SDAD_REPO_DIR/core/SDAD_LESSON_LIBRARY.md"          LESSON_LIBRARY.md

# ─── STEP 6: Create .sdad/ structure ────────────────────────────────────────
echo "▶ Creating .sdad/ directory structure..."
mkdir -p .sdad/flows
touch .sdad/.gitkeep
echo "  ✓ .sdad/ and .sdad/flows/ ready"

# Add .sdad to .gitignore except flows/
if [ -f ".gitignore" ]; then
  if ! grep -q ".sdad/agent_output.tmp" .gitignore; then
    echo "" >> .gitignore
    echo "# SDAD-CC — temp files" >> .gitignore
    echo ".sdad/agent_output.tmp" >> .gitignore
  fi
else
  echo "# SDAD-CC — temp files" > .gitignore
  echo ".sdad/agent_output.tmp" >> .gitignore
fi
echo "  ✓ .gitignore updated"

# ─── DONE ────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║          ✅ SDAD-CC v3.1 installed!          ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Go to claude.ai/settings/profile → Preferences"
echo "     Paste the content of SDAD_USER_PREFERENCES_SNIPPET.md"
echo ""
echo "  2. To start a new project with SDAD:"
echo "     bash <(curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.sh)"
echo ""
echo "  3. Before each Claude Code session, run:"
echo "     npx ccstatusline@latest"
echo "     Then in a new terminal: claude"
echo ""
echo "  4. Inside Claude Code, type \$sdad to verify installation"
echo ""
