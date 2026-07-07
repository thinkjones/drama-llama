#!/usr/bin/env bash
#
# Camp Drama Llama — student machine setup (run INSIDE WSL / Ubuntu).
#
# What it installs:
#   - git, curl, unzip, build tools, Python 3
#   - Java 17 (needed for the Minecraft mod in Activity 3)
#   - Node.js (needed by Claude Code)
#   - Claude Code CLI
#   - Zed editor
#   - This repo, cloned to ~/drama-llama
#
# Usage (from inside Ubuntu):
#   bash setup-wsl.sh
#
# It is safe to run more than once (idempotent). If one step fails it keeps
# going and reports what failed at the end.

set -u
REPO_URL="${DRAMA_LLAMA_REPO_URL:-https://github.com/thinkjones/drama-llama.git}"
TARGET_DIR="$HOME/drama-llama"
FAILURES=()

step()  { echo -e "\n\033[1;36m==> $*\033[0m"; }
ok()    { echo -e "  \033[1;32m✔ $*\033[0m"; }
warn()  { echo -e "  \033[1;33m! $*\033[0m"; FAILURES+=("$*"); }

# --- 1. System packages -----------------------------------------------------
step "Updating package lists"
sudo apt-get update -y && ok "apt updated" || warn "apt update failed"

step "Installing base tools (git, curl, unzip, build tools, Python 3)"
sudo apt-get install -y git curl unzip build-essential python3 python3-pip \
  && ok "base tools installed" || warn "base tools failed"

step "Installing Java 17 (for the Minecraft mod)"
sudo apt-get install -y openjdk-17-jdk && ok "Java 17 installed" || warn "Java 17 failed"

# --- 2. Node.js (for Claude Code) -------------------------------------------
step "Installing Node.js LTS"
if command -v node >/dev/null 2>&1; then
  ok "Node.js already present ($(node --version))"
else
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - \
    && sudo apt-get install -y nodejs \
    && ok "Node.js installed ($(node --version 2>/dev/null))" \
    || warn "Node.js install failed"
fi

# --- 3. Claude Code ---------------------------------------------------------
step "Installing Claude Code CLI"
if command -v claude >/dev/null 2>&1; then
  ok "Claude Code already installed"
else
  # Official installer; falls back to npm if that fails.
  if curl -fsSL https://claude.ai/install.sh | bash; then
    ok "Claude Code installed (official installer)"
  elif sudo npm install -g @anthropic-ai/claude-code; then
    ok "Claude Code installed (npm)"
  else
    warn "Claude Code install failed — install manually later"
  fi
fi

# --- 4. Zed editor ----------------------------------------------------------
# Note: Zed is a GUI app. In WSL it needs WSLg (built into Windows 11).
# If Zed won't open, use VS Code with the WSL extension instead.
step "Installing Zed editor"
if command -v zed >/dev/null 2>&1; then
  ok "Zed already installed"
else
  if curl -fsSL https://zed.dev/install.sh | sh; then
    ok "Zed installed (you may need to open a new terminal for the 'zed' command)"
  else
    warn "Zed install failed — VS Code + WSL extension is a fine fallback"
  fi
fi

# --- 5. The workshop repo ---------------------------------------------------
step "Setting up the workshop repo at $TARGET_DIR"
if [ -d "$TARGET_DIR/.git" ]; then
  ok "Repo already at $TARGET_DIR — pulling latest"
  git -C "$TARGET_DIR" pull --ff-only || warn "git pull failed (not fatal)"
elif [ -d "$TARGET_DIR" ]; then
  warn "$TARGET_DIR exists but is not a git repo — leaving it untouched"
else
  if git clone "$REPO_URL" "$TARGET_DIR"; then
    ok "Repo cloned to $TARGET_DIR"
  else
    warn "Clone failed. Edit REPO_URL at the top of this script (or set \$DRAMA_LLAMA_REPO_URL) and re-run, or copy the folder in manually."
  fi
fi

# --- Summary ----------------------------------------------------------------
echo
if [ ${#FAILURES[@]} -eq 0 ]; then
  echo -e "\033[1;32m🦙 All done! This machine is ready for Camp Drama Llama.\033[0m"
else
  echo -e "\033[1;33m⚠ Setup finished with ${#FAILURES[@]} item(s) needing attention:\033[0m"
  for f in "${FAILURES[@]}"; do echo "   - $f"; done
fi
echo
echo "Verify with:  git --version && python3 --version && java -version && node --version && claude --version"
echo "Then log in once:  claude   (it will prompt you to sign in)"
