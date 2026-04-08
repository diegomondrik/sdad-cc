#!/usr/bin/env bash
# SDAD-CC v3.1 — Project Initializer for Mac / Linux
# G7 Spec-Driven AI Development for Claude Code
#
# Run from inside your project folder:
#   bash <(curl -fsSL https://raw.githubusercontent.com/diegomondrik/sdad-cc/main/project-init.sh)
#
# What this does:
#   1. Verifies SDAD-CC is installed — installs it if not
#   2. Creates SDAD project structure in the current repo
#   3. Registers project metadata ready for $spec

set -e

REPO="https://raw.githubusercontent.com/diegomondrik/sdad-cc/main"
SDAD_MARKER="G7 SDAD-CC"
TODAY=$(date +%Y-%m-%d)

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║     SDAD-CC v3.1 — Project Initializer       ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ─── STEP 1: Verify SDAD-CC is installed ────────────────────────────────────
echo "▶ Checking SDAD-CC installation..."

SDAD_FOUND=false

# Check current repo
if [ -f "CLAUDE.md" ] && grep -q "$SDAD_MARKER" CLAUDE.md; then
  echo "  ✓ SDAD-CC found in this repo (CLAUDE.md)"
  SDAD_FOUND=true
fi

# Check global install markers
if [ -f "$HOME/.sdad-cc/installed" ]; then
  echo "  ✓ SDAD-CC global install detected"
  SDAD_FOUND=true
fi

if [ "$SDAD_FOUND" = false ]; then
  echo "  ⚠️  SDAD-CC not found. Running methodology installer first..."
  echo ""
  bash <(curl -fsSL "$REPO/install.sh")
  echo ""
  echo "  ✓ SDAD-CC installed. Continuing with project setup..."
fi

# ─── STEP 2: Collect project info ───────────────────────────────────────────
echo ""
echo "▶ Project setup"
echo ""

# Project name — infer from folder, allow override
DEFAULT_NAME=$(basename "$PWD")
read -rp "  Project name [$DEFAULT_NAME]: " PROJECT_NAME
PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_NAME}"

# Developer name
read -rp "  Your name (for AI Authorship Log): " DEV_NAME
DEV_NAME="${DEV_NAME:-Developer}"

# Compliance tier
echo ""
echo "  Compliance tier:"
echo "    1) Standard  — internal tools, POCs, personal projects"
echo "    2) Business  — customer-facing products, SaaS, user data"
echo "    3) Enterprise — regulated environments, corporate IT, cloud"
read -rp "  Select tier [1]: " TIER_INPUT
TIER_INPUT="${TIER_INPUT:-1}"

case "$TIER_INPUT" in
  2) TIER="Tier 2 — Business" ;;
  3) TIER="Tier 3 — Enterprise" ;;
  *) TIER="Tier 1 — Standard" ;;
esac

# ─── STEP 3: Create SDAD project structure ──────────────────────────────────
echo ""
echo "▶ Creating SDAD project structure..."

# .sdad/ directories
mkdir -p .sdad/flows
touch .sdad/.gitkeep
echo "  ✓ .sdad/ and .sdad/flows/ created"

# .gitignore entry
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

# LESSON_LIBRARY.md — preserve if exists with content
if [ -f "LESSON_LIBRARY.md" ] && [ "$(wc -l < LESSON_LIBRARY.md)" -gt 5 ]; then
  echo "  ℹ️  LESSON_LIBRARY.md has entries — preserved."
else
  cat > LESSON_LIBRARY.md << EOF
# LESSON LIBRARY — $PROJECT_NAME
# SDAD-CC v3.1 | Started: $TODAY
# Format: L-XX entries grouped by category
# Add entries via \$lesson new inside Claude Code

EOF
  echo "  ✓ LESSON_LIBRARY.md created"
fi

# SPEC.md — only if it doesn't exist
if [ -f "SPEC.md" ]; then
  echo "  ℹ️  SPEC.md already exists — preserved. Run \$spec to update."
else
  cat > SPEC.md << EOF
# SPEC — $PROJECT_NAME
Version: 0.1 | Date: $TODAY | Status: Draft — run \$spec to begin requirements
Developer: $DEV_NAME
Compliance: $TIER

---

*This file will be populated by \$specout after completing \$spec requirements.*
*Do not edit manually — use SDAD-CC commands inside Claude Code.*
EOF
  echo "  ✓ SPEC.md initialized"
fi

# Project registry entry in .sdad/
cat > .sdad/project.md << EOF
# SDAD-CC Project Registry
Project: $PROJECT_NAME
Started: $TODAY
Developer: $DEV_NAME
Compliance Tier: $TIER
SDAD Version: 3.1
Status: Initialized — pending \$spec

## Session Log
| Date | Phase | Notes |
|------|-------|-------|
| $TODAY | Init | Project initialized via project-init.sh |
EOF
echo "  ✓ .sdad/project.md registered"

# ─── DONE ────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║      ✅ Project '$PROJECT_NAME' ready!       ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Run: npx ccstatusline@latest"
echo "  2. In a new terminal: claude"
echo "  3. Inside Claude Code: \$spec"
echo ""
echo "  Files created:"
echo "    SPEC.md              — awaiting requirements"
echo "    LESSON_LIBRARY.md    — ready for lessons"
echo "    .sdad/project.md     — project registry"
echo "    .sdad/flows/         — project flows (empty)"
echo ""
