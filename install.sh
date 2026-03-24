#!/usr/bin/env bash
# ============================================================
# G7 SDAD-CC v2.0 — Installer
# Spec-Driven AI Development for Claude Code
# https://github.com/diegomondrik/sdad-cc
# ============================================================

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ── Config ───────────────────────────────────────────────────
SDAD_VERSION="2.0"
SDAD_REPO="https://raw.githubusercontent.com/diegomondrik/sdad-cc/main"
NODE_MIN_VERSION=18
REQUIRED_FILES=(
  "CLAUDE.md:SDAD_CC_CLAUDE_MD_v2_0.md"
  "SKILL_SDAD_METHODOLOGY.md:SDAD_CC_SKILL_SDAD_METHODOLOGY_v2_0.md"
  "SKILL_AI_ARCHITECT.md:SDAD_CC_SKILL_AI_ARCHITECT_v2_0.md"
  "SKILL_AI_ENGINEER.md:SDAD_CC_SKILL_AI_ENGINEER_v2_0.md"
  "SKILL_COMPLIANCE.md:SDAD_CC_SKILL_COMPLIANCE_v2_0.md"
  "LESSON_LIBRARY.md:SDAD_CC_LESSON_LIBRARY_v2_0.md"
)

# ── Helpers ──────────────────────────────────────────────────
print_header() {
  echo ""
  echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${BLUE}║   G7 SDAD-CC v${SDAD_VERSION} — Installer              ║${NC}"
  echo -e "${BOLD}${BLUE}║   Spec-Driven AI Development               ║${NC}"
  echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════╝${NC}"
  echo ""
}

ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}⚠${NC}  $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; }
info() { echo -e "  ${CYAN}→${NC} $1"; }
step() { echo -e "\n${BOLD}$1${NC}"; }

confirm() {
  local prompt="$1"
  local default="${2:-y}"
  local answer
  if [[ "$default" == "y" ]]; then
    read -rp "  $prompt [Y/n] " answer
    answer="${answer:-y}"
  else
    read -rp "  $prompt [y/N] " answer
    answer="${answer:-n}"
  fi
  [[ "$answer" =~ ^[Yy]$ ]]
}

command_exists() { command -v "$1" &>/dev/null; }

# ── OS Detection ─────────────────────────────────────────────
detect_os() {
  case "$OSTYPE" in
    darwin*)  echo "mac" ;;
    linux*)   echo "linux" ;;
    *)        echo "unknown" ;;
  esac
}

OS=$(detect_os)

# ── Node.js ──────────────────────────────────────────────────
check_node() {
  step "Step 1/5 — Checking Node.js"
  if command_exists node; then
    local version
    version=$(node --version | sed 's/v//' | cut -d. -f1)
    if [[ "$version" -ge "$NODE_MIN_VERSION" ]]; then
      ok "Node.js $(node --version) — OK"
      return 0
    else
      warn "Node.js $(node --version) found but v${NODE_MIN_VERSION}+ required"
      install_node
    fi
  else
    warn "Node.js not found"
    install_node
  fi
}

install_node() {
  if ! confirm "Install Node.js ${NODE_MIN_VERSION}+?"; then
    fail "Node.js is required. Install it manually from https://nodejs.org and re-run this script."
    exit 1
  fi

  case "$OS" in
    mac)
      if command_exists brew; then
        info "Installing Node.js via Homebrew..."
        brew install node
      elif command_exists nvm; then
        info "Installing Node.js via nvm..."
        nvm install --lts
        nvm use --lts
      else
        fail "Homebrew not found. Install it first: https://brew.sh"
        fail "Or install Node.js directly: https://nodejs.org"
        exit 1
      fi
      ;;
    linux)
      if command_exists nvm; then
        info "Installing Node.js via nvm..."
        nvm install --lts
        nvm use --lts
      elif command_exists apt-get; then
        info "Installing Node.js via apt..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
      elif command_exists dnf; then
        info "Installing Node.js via dnf..."
        sudo dnf install -y nodejs npm
      elif command_exists pacman; then
        info "Installing Node.js via pacman..."
        sudo pacman -S --noconfirm nodejs npm
      else
        fail "Could not detect package manager. Install Node.js manually: https://nodejs.org"
        exit 1
      fi
      ;;
    *)
      fail "Unsupported OS. Install Node.js manually: https://nodejs.org"
      exit 1
      ;;
  esac

  ok "Node.js $(node --version) installed"
}

# ── Claude Code ───────────────────────────────────────────────
check_claude_code() {
  step "Step 2/5 — Checking Claude Code"
  if command_exists claude; then
    ok "Claude Code $(claude --version 2>/dev/null | head -1) — OK"
  else
    warn "Claude Code not found"
    if confirm "Install Claude Code now?"; then
      info "Installing Claude Code..."
      npm install -g @anthropic-ai/claude-code
      if command_exists claude; then
        ok "Claude Code installed — $(claude --version 2>/dev/null | head -1)"
      else
        fail "Installation failed. Try manually: npm install -g @anthropic-ai/claude-code"
        exit 1
      fi
    else
      fail "Claude Code is required. Install it with: npm install -g @anthropic-ai/claude-code"
      exit 1
    fi
  fi
}

# ── Git ───────────────────────────────────────────────────────
check_git() {
  step "Step 3/5 — Checking Git repository"
  if ! command_exists git; then
    fail "git is not installed. Install it from https://git-scm.com"
    exit 1
  fi

  if git rev-parse --git-dir &>/dev/null 2>&1; then
    local repo_root
    repo_root=$(git rev-parse --show-toplevel)
    ok "Git repository found: $repo_root"
    cd "$repo_root"
  else
    warn "Current directory is not a git repository: $(pwd)"
    if confirm "Initialize a git repository here?"; then
      git init
      ok "Git repository initialized: $(pwd)"
    else
      fail "SDAD-CC must be installed inside a git repository."
      info "Run 'git init' in your project folder, then re-run this installer."
      exit 1
    fi
  fi
}

# ── Download SDAD-CC files ────────────────────────────────────
install_sdad_files() {
  step "Step 4/5 — Installing SDAD-CC v${SDAD_VERSION} files"

  # Check if CLAUDE.md already exists
  local claude_md_exists=false
  if [[ -f "CLAUDE.md" ]]; then
    claude_md_exists=true
    warn "CLAUDE.md already exists in this repo"
    if confirm "Append SDAD-CC content to existing CLAUDE.md? (recommended)"; then
      APPEND_CLAUDE=true
    else
      APPEND_CLAUDE=false
      warn "CLAUDE.md will be overwritten"
    fi
  fi

  # Check if LESSON_LIBRARY.md exists with content
  local keep_lessons=false
  if [[ -f "LESSON_LIBRARY.md" ]] && [[ $(wc -l < "LESSON_LIBRARY.md") -gt 30 ]]; then
    warn "Existing LESSON_LIBRARY.md found with entries"
    if confirm "Keep existing Lesson Library? (recommended)"; then
      keep_lessons=true
      ok "Existing LESSON_LIBRARY.md preserved"
    fi
  fi

  # Download each file
  local download_ok=true
  for entry in "${REQUIRED_FILES[@]}"; do
    local dest="${entry%%:*}"
    local source_file="${entry##*:}"

    # Skip LESSON_LIBRARY if keeping existing
    if [[ "$dest" == "LESSON_LIBRARY.md" ]] && [[ "$keep_lessons" == true ]]; then
      ok "LESSON_LIBRARY.md — kept existing"
      continue
    fi

    # Handle CLAUDE.md append vs overwrite
    if [[ "$dest" == "CLAUDE.md" ]] && [[ "${APPEND_CLAUDE:-false}" == true ]]; then
      info "Appending SDAD-CC to existing CLAUDE.md..."
      if download_and_append "$source_file" "$dest"; then
        ok "CLAUDE.md — appended"
      else
        fail "Failed to download $source_file"
        download_ok=false
      fi
      continue
    fi

    # Normal download
    info "Installing $dest..."
    if download_file "$source_file" "$dest"; then
      ok "$dest — installed"
    else
      fail "Failed to download $source_file"
      download_ok=false
    fi
  done

  if [[ "$download_ok" == false ]]; then
    echo ""
    warn "Some files could not be downloaded from GitHub."
    warn "This may be a network issue or the repo may not be public yet."
    warn "Manual installation instructions: see SDAD_CC_INSTALL_GUIDE_v2_0.md"
    echo ""
    if ! confirm "Continue anyway?"; then
      exit 1
    fi
  fi
}

download_file() {
  local source="$1"
  local dest="$2"
  local url="${SDAD_REPO}/kit/${source}"

  if command_exists curl; then
    curl -fsSL "$url" -o "$dest" 2>/dev/null
  elif command_exists wget; then
    wget -q "$url" -O "$dest" 2>/dev/null
  else
    fail "Neither curl nor wget found. Cannot download files."
    return 1
  fi
}

download_and_append() {
  local source="$1"
  local dest="$2"
  local url="${SDAD_REPO}/kit/${source}"
  local tmp
  tmp=$(mktemp)

  if command_exists curl; then
    curl -fsSL "$url" -o "$tmp" 2>/dev/null || return 1
  elif command_exists wget; then
    wget -q "$url" -O "$tmp" 2>/dev/null || return 1
  else
    return 1
  fi

  echo "" >> "$dest"
  echo "# ── SDAD-CC v${SDAD_VERSION} ─────────────────────────────────────" >> "$dest"
  cat "$tmp" >> "$dest"
  rm "$tmp"
}

# ── User Preferences ─────────────────────────────────────────
show_preferences_instructions() {
  step "Step 5/5 — Claude User Preferences (\$SM and \$QA)"

  echo ""
  echo -e "  ${YELLOW}Manual step required — takes 60 seconds${NC}"
  echo ""
  echo "  \$SM and \$QA work in ALL Claude sessions (web UI + Claude Code)."
  echo "  They must be added to your Claude account preferences once."
  echo ""
  echo "  1. Open: https://claude.ai/settings/profile"
  echo "  2. Scroll to 'Preferences'"
  echo "  3. Paste the content of SDAD_USER_PREFERENCES_SNIPPET_v1_3.md"
  echo "  4. Save"
  echo ""

  # Try to open browser
  if confirm "Open Claude settings in your browser now?"; then
    case "$OS" in
      mac)   open "https://claude.ai/settings/profile" 2>/dev/null ;;
      linux) xdg-open "https://claude.ai/settings/profile" 2>/dev/null || true ;;
    esac
  fi

  # Try to copy snippet to clipboard
  local snippet_file="SDAD_USER_PREFERENCES_SNIPPET_v1_3.md"
  if [[ -f "$snippet_file" ]]; then
    if command_exists pbcopy; then
      pbcopy < "$snippet_file"
      ok "Preferences snippet copied to clipboard — just paste and save"
    elif command_exists xclip; then
      xclip -selection clipboard < "$snippet_file"
      ok "Preferences snippet copied to clipboard — just paste and save"
    elif command_exists xsel; then
      xsel --clipboard --input < "$snippet_file"
      ok "Preferences snippet copied to clipboard — just paste and save"
    else
      info "Open SDAD_USER_PREFERENCES_SNIPPET_v1_3.md and copy its contents"
    fi
  else
    info "Snippet file not found locally — copy it from the SDAD-CC kit folder"
  fi
}

# ── External Skills ───────────────────────────────────────────
show_external_skills() {
  echo ""
  echo -e "${BOLD}Optional: External Skills${NC}"
  echo ""
  echo "  Run these inside a Claude Code session to install recommended skills:"
  echo ""
  echo -e "  ${CYAN}# Always relevant${NC}"
  echo "  /plugin install example-skills@anthropic-agent-skills   # frontend-design, skill-creator, mcp-builder"
  echo ""
  echo -e "  ${CYAN}# REST/GraphQL API projects${NC}"
  echo "  npx skills add https://github.com/wshobson/agents --skill api-design-principles"
  echo ""
  echo -e "  ${CYAN}# Python performance${NC}"
  echo "  npx skills add https://github.com/wshobson/agents --skill python-performance-optimization"
  echo ""
  echo -e "  ${CYAN}# TDD + debugging (Claude Code)${NC}"
  echo "  /plugin marketplace add obra/superpowers"
  echo ""
  echo -e "  ${CYAN}# LLM-intensive projects${NC}"
  echo "  npx skills add https://github.com/deanpeters/Product-Manager-Skills --skill context-engineering-advisor"
  echo ""
}

# ── Verification checklist ────────────────────────────────────
show_verification() {
  echo ""
  echo -e "${BOLD}Verification — run these inside 'claude' to confirm everything works:${NC}"
  echo ""
  echo -e "  ${CYAN}\$sdad${NC}     → All 5 phases + active skills listed"
  echo -e "  ${CYAN}\$skills${NC}   → AI Architect, AI Engineer, Security Reviewer, QA Engineer active"
  echo -e "  ${CYAN}\$spec${NC}     → First requirements question with proposed default"
  echo -e "  ${CYAN}\$pause${NC}    → Session state from SPEC.md + git log"
  echo -e "  ${CYAN}\$lesson${NC}   → Library entries or 'no entries yet'"
  echo -e "  ${CYAN}\$SM hello${NC} → ⚡ SIMPLE MODE response"
  echo ""
}

# ── Summary ───────────────────────────────────────────────────
show_summary() {
  echo ""
  echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${GREEN}║   SDAD-CC v${SDAD_VERSION} installed successfully!     ║${NC}"
  echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════╝${NC}"
  echo ""
  echo "  Files installed in: $(pwd)"
  echo ""
  echo -e "  ${BOLD}Next steps:${NC}"
  echo "  1. Complete the User Preferences step above (if not done)"
  echo "  2. Run: claude"
  echo "  3. Type: \$sdad"
  echo ""
  echo -e "  ${CYAN}Docs: https://github.com/diegomondrik/sdad-cc${NC}"
  echo ""
}

# ── Main ──────────────────────────────────────────────────────
main() {
  print_header
  check_node
  check_claude_code
  check_git
  install_sdad_files
  show_preferences_instructions
  show_external_skills
  show_verification
  show_summary
}

main "$@"
