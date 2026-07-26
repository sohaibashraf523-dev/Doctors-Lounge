from __future__ import annotations

import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT / ".tools"


def status(label: str, ok: bool, detail: str = "") -> None:
    marker = "OK" if ok else "MISSING"
    suffix = f" — {detail}" if detail else ""
    print(f"[{marker}] {label}{suffix}")


def main() -> int:
    failures = 0

    commands = {
        "git": shutil.which("git"),
        "python3": sys.executable,
        "node": shutil.which("node"),
        "npm": shutil.which("npm"),
        "codex": shutil.which("codex"),
    }
    for label, found in commands.items():
        status(label, bool(found), found or "not on PATH")
        failures += int(not found)

    py_ok = sys.version_info >= (3, 10)
    status("Python >= 3.10", py_ok, sys.version.split()[0])
    failures += int(not py_ok)

    manifest_path = ROOT / "integrations" / "repositories.json"
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        status("repository manifest", False, str(exc))
        return 1

    for repo in manifest["repositories"]:
        target = TOOLS / repo["name"]
        ok = (target / ".git").exists()
        status(f"repo:{repo['name']}", ok, str(target))
        failures += int(not ok)

    expected = [
        ROOT / "AGENTS.md",
        ROOT / "skills" / "doctors-lounge" / "SKILL.md",
        ROOT / ".codex" / "config.toml",
        ROOT / ".venv",
    ]
    for path in expected:
        ok = path.exists()
        status(path.relative_to(ROOT).as_posix(), ok)
        failures += int(not ok)

    print(f"\nResult: {failures} missing requirement(s).")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
