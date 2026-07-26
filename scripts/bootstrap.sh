#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS="$ROOT/.tools"
SKILLS_HOME="${CODEX_HOME:-$HOME/.codex}/skills"

command -v git >/dev/null || { echo "git is required" >&2; exit 1; }
command -v python3 >/dev/null || { echo "Python 3.10+ is required" >&2; exit 1; }
command -v node >/dev/null || { echo "Node.js is required for Codex, Playwright MCP, and n8n" >&2; exit 1; }
command -v npm >/dev/null || { echo "npm is required" >&2; exit 1; }

mkdir -p "$TOOLS" "$SKILLS_HOME" "$ROOT/.codex"

python3 - <<'PY'
import sys
if sys.version_info < (3, 10):
    raise SystemExit("Python 3.10+ is required")
PY

clone_or_update() {
  local name="$1" url="$2" target="$TOOLS/$name"
  if [ -d "$target/.git" ]; then
    git -C "$target" pull --ff-only
  else
    git clone --depth 1 "$url" "$target"
  fi
}

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

python3 -m venv "$ROOT/.venv"
"$ROOT/.venv/bin/python" -m pip install --upgrade pip
"$ROOT/.venv/bin/pip" install -r "$ROOT/requirements.txt"

npm install -g @openai/codex

rm -rf "$SKILLS_HOME/doctors-lounge"
cp -R "$ROOT/skills/doctors-lounge" "$SKILLS_HOME/doctors-lounge"

if [ ! -f "$ROOT/.codex/config.toml" ]; then
  cp "$ROOT/.codex/config.toml.example" "$ROOT/.codex/config.toml"
fi

python3 "$ROOT/scripts/check_setup.py"
printf '\nSetup completed. Restart Codex before using the new skill.\n'
