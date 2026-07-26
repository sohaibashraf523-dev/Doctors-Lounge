# Doctors Lounge AI Workspace

This repository is the control layer for using ChatGPT and Codex with Doctors Lounge projects. It does **not** copy third-party source code into the repository. The bootstrap scripts clone the upstream repositories into a local, ignored `.tools/` directory so they remain separately updateable.

## What is connected

| Component | Integration mode | Status after setup |
|---|---|---|
| ChatGPT GitHub app | Reads this repository directly | Connected |
| OpenAI Codex CLI | Installed locally and opened in this repository | Available after bootstrap |
| `AGENTS.md` | Project instructions automatically supplied to Codex | Active |
| OpenAI Skills | Selected skills copied to the local Codex skills directory | Active after bootstrap and Codex restart |
| OpenAI Cookbook | Shallow local reference clone | Available in `.tools/` |
| Agents.md specification | Shallow local reference clone | Available in `.tools/` |
| MCP reference servers | Shallow local reference clone | Available in `.tools/` |
| Playwright | Browser automation reference plus MCP launcher | Configured, but requires local Node.js |
| OpenAI Apps SDK examples | ChatGPT app and MCP examples | Available in `.tools/` |
| OpenAI Agents SDK Python | Installed in the local Python virtual environment | Active after bootstrap |
| OpenAI Agents SDK JS | Shallow local reference clone | Available in `.tools/` |
| n8n | Automation reference clone and `npx` launcher | Available after bootstrap |

## Quick start

### macOS or Linux

```bash
git clone https://github.com/sohaibashraf523-dev/Doctors-Lounge.git
cd Doctors-Lounge
bash scripts/bootstrap.sh
codex
```

### Windows PowerShell

```powershell
git clone https://github.com/sohaibashraf523-dev/Doctors-Lounge.git
Set-Location Doctors-Lounge
powershell -ExecutionPolicy Bypass -File scripts/bootstrap.ps1
codex
```

After installation, restart Codex so newly installed skills are discovered.

## Repository map

```text
.
├── AGENTS.md                         # Mandatory operating instructions for Codex
├── .codex/config.toml.example       # Playwright MCP configuration example
├── integrations/repositories.json  # Upstream repository manifest
├── skills/doctors-lounge/SKILL.md  # Reusable Doctors Lounge skill
├── scripts/bootstrap.sh             # macOS/Linux setup
├── scripts/bootstrap.ps1            # Windows setup
├── requirements.txt                 # Python agent dependencies
└── package.json                     # Convenience launch commands
```

## ChatGPT usage

The GitHub app is already authorized for this repository. In ChatGPT, select GitHub as a source and use `sohaibashraf523-dev/Doctors-Lounge` when asking for repository analysis. ChatGPT reads the committed instructions and files; it does not execute the local bootstrap scripts.

## Codex usage

Open Codex from the repository root. Codex should inspect `AGENTS.md` before changing files. The bootstrap script creates a local `.codex/config.toml` from the example only when one does not already exist.

Useful commands:

```bash
npm run playwright:mcp
npm run n8n
python scripts/check_setup.py
```

## Security boundaries

- Never commit `.env`, API keys, OAuth tokens, browser profiles, cookies, Instagram credentials, or Codex authentication files.
- Browser automation must remain supervised for account changes, publishing, payments, medical replies, and destructive actions.
- Instagram publishing requires a Meta professional account and properly authorized API credentials. This repository does not grant those permissions.
- Health-related content must be reviewed by a human before publication.

## Upstream repositories

The complete list is stored in `integrations/repositories.json`. Run the bootstrap script again to update shallow clones. The scripts use official upstream repositories and do not modify them.
