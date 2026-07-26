$ErrorActionPreference = 'Stop'

$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Tools = Join-Path $Root '.tools'
$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
$SkillsHome = Join-Path $CodexHome 'skills'

foreach ($cmd in @('git','python','node','npm')) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        throw "$cmd is required"
    }
}

New-Item -ItemType Directory -Force -Path $Tools, $SkillsHome, (Join-Path $Root '.codex') | Out-Null

function Sync-Repo([string]$Name, [string]$Url) {
    $Target = Join-Path $Tools $Name
    if (Test-Path (Join-Path $Target '.git')) {
        git -C $Target pull --ff-only
    } else {
        git clone --depth 1 $Url $Target
    }
}

$Repos = @{
    'codex'='https://github.com/openai/codex.git'
    'openai-skills'='https://github.com/openai/skills.git'
    'openai-cookbook'='https://github.com/openai/openai-cookbook.git'
    'agents-md'='https://github.com/agentsmd/agents.md.git'
    'mcp-servers'='https://github.com/modelcontextprotocol/servers.git'
    'playwright'='https://github.com/microsoft/playwright.git'
    'apps-sdk-examples'='https://github.com/openai/openai-apps-sdk-examples.git'
    'agents-python'='https://github.com/openai/openai-agents-python.git'
    'agents-js'='https://github.com/openai/openai-agents-js.git'
    'n8n'='https://github.com/n8n-io/n8n.git'
}

foreach ($entry in $Repos.GetEnumerator()) { Sync-Repo $entry.Key $entry.Value }

python -m venv (Join-Path $Root '.venv')
& (Join-Path $Root '.venv\Scripts\python.exe') -m pip install --upgrade pip
& (Join-Path $Root '.venv\Scripts\pip.exe') install -r (Join-Path $Root 'requirements.txt')

npm install -g @openai/codex

$SkillTarget = Join-Path $SkillsHome 'doctors-lounge'
if (Test-Path $SkillTarget) { Remove-Item -Recurse -Force $SkillTarget }
Copy-Item -Recurse (Join-Path $Root 'skills\doctors-lounge') $SkillTarget

$Config = Join-Path $Root '.codex\config.toml'
if (-not (Test-Path $Config)) {
    Copy-Item (Join-Path $Root '.codex\config.toml.example') $Config
}

python (Join-Path $Root 'scripts\check_setup.py')
Write-Host "`nSetup completed. Restart Codex before using the new skill."
