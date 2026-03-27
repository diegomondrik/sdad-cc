#!/usr/bin/env bash
# SDAD-CC v3.0 — Installer for Mac / Linux
# G7 Spec-Driven AI Development for Claude Code
# Run from inside your project folder:
#   curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash
#
# To update an existing install:
#   curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash -s -- --update

set -e

REPO="https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/kit"
REPO_ROOT="https://raw.githubusercontent.com/diegomondrik/sdad-cc/main"
SDAD_MARKER="G7 SDAD-CC"
UPDATE_MODE=false

# ─── FLAGS ──────────────────────────────────────────────────────────────────
for arg in "$@"; do
  case $arg in
    --update) UPDATE_MODE=true ;;
  esac
done

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║        SDAD-CC v3.0 — Installer              ║"
echo "║   Spec-Driven AI Development for Claude Code ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ─── UPDATE MODE ────────────────────────────────────────────────────────────
if [ "$UPDATE_MODE" = true ]; then
  echo "▶ Checking for updates..."

  REMOTE_VERSION=$(curl -fsSL "$REPO_ROOT/version.json" | grep '"version"' | sed 's/.*"version": *"\([^"]*\)".*/\1/')

  if [ -f ".sdad/version.json" ]; then
    LOCAL_VERSION=$(grep '"version"' .sdad/version.json | sed 's/.*"version": *"\([^"]*\)".*/\1/')
  else
    LOCAL_VERSION="none"
  fi

  echo "  Local version:  ${LOCAL_VERSION}"
  echo "  Remote version: ${REMOTE_VERSION}"

  if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
    echo ""
    echo "  ✓ Already up to date (v${REMOTE_VERSION})"
    echo ""
    exit 0
  fi

  echo "  ↑ Update available: ${LOCAL_VERSION} → ${REMOTE_VERSION}"
  echo ""
  echo "▶ Updating CLAUDE.md..."
  curl -fsSL "$REPO/SDAD_CC_CLAUDE_MD_v3_0.md" -o "CLAUDE.md"
  echo "  ✓ CLAUDE.md updated"

  echo "▶ Saving version..."
  echo "{" > .sdad/version.json
  echo "  \"version\": \"${REMOTE_VERSION}\"," >> .sdad/version.json
  echo "  \"updated\": \"$(date +%Y-%m-%d)\"" >> .sdad/version.json
  echo "}" >> .sdad/version.json
  echo "  ✓ .sdad/version.json → v${REMOTE_VERSION}"

  echo ""
  echo "╔══════════════════════════════════════════════╗"
  echo "║      ✅ SDAD-CC updated to v${REMOTE_VERSION}!         ║"
  echo "╚══════════════════════════════════════════════╝"
  echo ""
  exit 0
fi

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

# ─── STEP 3: cc-status-line ─────────────────────────────────────────────────
echo "▶ Installing cc-status-line (required — context budget monitor)..."
npm install -g cc-status-line 2>/dev/null || npx cc-status-line@latest --version &>/dev/null || true
echo "  ✓ cc-status-line ready — run 'npx cc-status-line@latest' before each session"

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
echo "▶ Downloading SDAD-CC v3.0 files..."

download_file() {
  local remote="$1"
  local local_name="$2"
  curl -fsSL "$REPO/$remote" -o "$local_name"
  echo "  ✓ $local_name"
}

# CLAUDE.md — append if exists, create if not
if [ -f "CLAUDE.md" ]; then
  if grep -q "$SDAD_MARKER" CLAUDE.md; then
    echo "  ℹ️  CLAUDE.md already contains SDAD-CC. Skipping — run with --update to upgrade."
  else
    echo "  CLAUDE.md exists (non-SDAD). Appending SDAD-CC content..."
    echo "" >> CLAUDE.md
    curl -fsSL "$REPO/SDAD_CC_CLAUDE_MD_v3_0.md" >> CLAUDE.md
    echo "  ✓ CLAUDE.md updated"
  fi
else
  download_file "SDAD_CC_CLAUDE_MD_v3_0.md" "CLAUDE.md"
fi

# ─── STEP 6: Create .sdad/ structure ────────────────────────────────────────
echo "▶ Creating .sdad/ directory structure..."
mkdir -p .sdad/flows
touch .sdad/.gitkeep
echo "  ✓ .sdad/ and .sdad/flows/ ready"

# .gitignore
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

# ─── STEP 7: Save version ───────────────────────────────────────────────────
echo "▶ Saving version info..."
REMOTE_VERSION=$(curl -fsSL "$REPO_ROOT/version.json" | grep '"version"' | sed 's/.*"version": *"\([^"]*\)".*/\1/')
echo "{" > .sdad/version.json
echo "  \"version\": \"${REMOTE_VERSION}\"," >> .sdad/version.json
echo "  \"installed\": \"$(date +%Y-%m-%d)\"" >> .sdad/version.json
echo "}" >> .sdad/version.json
echo "  ✓ .sdad/version.json → v${REMOTE_VERSION}"

# ─── DONE ────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║          ✅ SDAD-CC v3.0 installed!          ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Go to claude.ai/settings/profile → Preferences"
echo "     Paste the content of SDAD_USER_PREFERENCES_SNIPPET.md"
echo ""
echo "  2. To start a new project with SDAD:"
echo "     bash <(curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/kit/project-init.sh)"
echo ""
echo "  3. Before each Claude Code session, run:"
echo "     npx cc-status-line@latest"
echo "     Then in a new terminal: claude"
echo ""
echo "  4. Inside Claude Code, type \$sdad to verify installation"
echo ""
echo "  To update SDAD-CC in future:"
echo "     curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/install.sh | bash -s -- --update"
echo ""