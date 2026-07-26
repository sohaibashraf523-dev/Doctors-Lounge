#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS="$ROOT/.tools"
SKILLS_HOME="${CODEX_HOME:-$HOME/.codex}/skills"
PYTHON_BIN=""

log() {
  printf '\n==> %s\n' "$1"
}

die() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

append_path_line() {
  local line="$1"
  local profile="$HOME/.zprofile"
  touch "$profile"
  grep -Fqx "$line" "$profile" 2>/dev/null || printf '\n%s\n' "$line" >> "$profile"
}

load_brew() {
  local brew_bin=""
  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  elif [ -x /opt/homebrew/bin/brew ]; then
    brew_bin="/opt/homebrew/bin/brew"
  elif [ -x /usr/local/bin/brew ]; then
    brew_bin="/usr/local/bin/brew"
  fi

  if [ -n "$brew_bin" ]; then
    eval "$("$brew_bin" shellenv)"
    append_path_line "eval \"\$($brew_bin shellenv)\""
    return 0
  fi
  return 1
}

ensure_homebrew() {
  if load_brew; then
    return
  fi

  [ "$(uname -s)" = "Darwin" ] || die "Automatic prerequisite installation currently supports macOS only."
  command -v curl >/dev/null 2>&1 || die "curl is required to install Homebrew."

  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew || die "Homebrew installed but could not be added to PATH. Open a new Terminal and rerun this script."
}

python_is_compatible() {
  "$1" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 10) else 1)' >/dev/null 2>&1
}

find_python() {
  local candidate
  for candidate in python3.13 python3.12 python3.11 python3.10 python3; do
    if command -v "$candidate" >/dev/null 2>&1 && python_is_compatible "$(command -v "$candidate")"; then
      PYTHON_BIN="$(command -v "$candidate")"
      return 0
    fi
  done
  return 1
}

ensure_python() {
  if find_python; then
    log "Using $($PYTHON_BIN --version 2>&1) at $PYTHON_BIN"
    return
  fi

  ensure_homebrew
  log "Installing Python 3.12"
  brew install python@3.12
  PYTHON_BIN="$(brew --prefix python@3.12)/bin/python3.12"
  [ -x "$PYTHON_BIN" ] || die "Python 3.12 installation could not be located."
  log "Using $($PYTHON_BIN --version 2>&1) at $PYTHON_BIN"
}

node_is_compatible() {
  node -e 'process.exit(Number(process.versions.node.split(".")[0]) >= 22 ? 0 : 1)' >/dev/null 2>&1
}

ensure_node() {
  if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1 && node_is_compatible; then
    log "Using Node $(node --version)"
    return
  fi

  ensure_homebrew
  log "Installing current Node.js"
  brew install node
  hash -r
  command -v node >/dev/null 2>&1 || die "Node.js installation completed but node is not on PATH."
  command -v npm >/dev/null 2>&1 || die "Node.js installation completed but npm is not on PATH."
  node_is_compatible || die "Node.js 22 or newer is required."
}

ensure_codex() {
  if command -v codex >/dev/null 2>&1; then
    log "Using $(codex --version)"
    return
  fi

  ensure_homebrew
  log "Installing OpenAI Codex CLI"
  if ! brew install --cask codex; then
    log "Homebrew Codex installation failed; using the official standalone installer"
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
  fi

  hash -r
  local candidate_dir
  for candidate_dir in "$HOME/.local/bin" "$HOME/.codex/bin" "$HOME/bin"; do
    if [ -x "$candidate_dir/codex" ]; then
      export PATH="$candidate_dir:$PATH"
      append_path_line "export PATH=\"$candidate_dir:\$PATH\""
      break
    fi
  done

  command -v codex >/dev/null 2>&1 || die "Codex installed but is not on PATH. Open a new Terminal and run: codex --version"
  log "Installed $(codex --version)"
}

clone_or_update() {
  local name="$1" url="$2" target="$TOOLS/$name"
  if [ -d "$target/.git" ]; then
    git -C "$target" pull --ff-only
  else
    git clone --depth 1 "$url" "$target"
  fi
}

command -v git >/dev/null 2>&1 || die "Git is required. Run: xcode-select --install"
ensure_homebrew
ensure_python
ensure_node
ensure_codex

mkdir -p "$TOOLS" "$SKILLS_HOME" "$ROOT/.codex"

log "Cloning or updating reference repositories"
clone_or_update codex https://github.com/openai/codex.git
clone_or_update openai-skills https://github.com/openai/skills.git
clone_or_update openai-cookbook https://github.com/openai/openai-cookbook.git
clone_or_update agents-md https://github.com/agentsmd/agents.md.git
clone_or_update mcp-servers https://github.com/modelcontextprotocol/servers.git
clone_or_update playwright https://github.com/microsoft/playwright.git
clone_or_update apps-sdk-examples https://github.com/openai/openai-apps-sdk-examples.git
clone_or_update agents-python https://github.com/openai/openai-agents-python.git
clone_or_update agents-js https://github.com/openai/openai-agents-js.git
clone_or_update n8n https://github.com/n8n-io/n8n.git

log "Creating Python environment"
"$PYTHON_BIN" -m venv "$ROOT/.venv"
"$ROOT/.venv/bin/python" -m pip install --upgrade pip
"$ROOT/.venv/bin/python" -m pip install -r "$ROOT/requirements.txt"

log "Installing Doctors Lounge Codex skill"
rm -rf "$SKILLS_HOME/doctors-lounge"
cp -R "$ROOT/skills/doctors-lounge" "$SKILLS_HOME/doctors-lounge"

if [ ! -f "$ROOT/.codex/config.toml" ]; then
  cp "$ROOT/.codex/config.toml.example" "$ROOT/.codex/config.toml"
fi

log "Verifying setup"
"$ROOT/.venv/bin/python" "$ROOT/scripts/check_setup.py"

cat <<'EOF'

Setup completed.

Next commands:
  codex login
  codex

Restart Terminal or run `source ~/.zprofile` if a newly installed command is not immediately found.
EOF
