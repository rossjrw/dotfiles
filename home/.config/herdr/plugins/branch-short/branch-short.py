#!/usr/bin/python3
"""Report each herdr space's branch, abbreviated like ~/.p10k.zsh, as the $branch_short token.

Run by git (global hook.herdr-branch-short config, on post-checkout and post-rewrite)
and by the herdr plugin in this directory (startup, new spaces, space switches).
Herdr's own branch refresh emits no event a plugin could hook, hence both triggers.
"""
import json
import os
import subprocess

HERDR = os.environ.get("HERDR_BIN_PATH", "herdr")
SOCKET = os.environ.get("HERDR_SOCKET_PATH", os.path.expanduser("~/.config/herdr/herdr.sock"))
SOURCE = "branch-short"
TOKEN = "branch_short"

# A git hook inherits GIT_DIR, GIT_INDEX_FILE etc. for the repo being checked out,
# which would make `git -C <other space>` read the wrong repo.
GIT_ENV = {k: v for k, v in os.environ.items() if not k.startswith("GIT_")}


def git(cwd, *args):
    result = subprocess.run(
        ["git", "-C", cwd, *args], env=GIT_ENV, capture_output=True, text=True
    )
    return result.stdout.strip() if result.returncode == 0 else None


def abbreviate(branch):
    # Same prefix rules as my_git_formatter in ~/.p10k.zsh. Its middle truncation is left
    # out because the sidebar is narrower than the prompt and truncates at its edge anyway.
    for prefix, short in (("feature/", "f./"), ("shed/", "s./"), ("hotfix/", "h./")):
        if branch.startswith(prefix):
            return short + branch[len(prefix):]
    return branch


def describe(cwd):
    branch = git(cwd, "symbolic-ref", "--quiet", "--short", "HEAD")
    if branch:
        return abbreviate(branch)
    tag = git(cwd, "describe", "--tags", "--exact-match", "HEAD")
    if tag:
        return "#" + abbreviate(tag)
    commit = git(cwd, "rev-parse", "--short=8", "HEAD")
    return "@" + commit if commit else None


def space_cwds(snapshot):
    """Map each space to the cwd herdr uses for its branch: the first pane of its first tab."""
    first_tab = {}
    for tab in sorted(snapshot["tabs"], key=lambda t: t["number"]):
        first_tab.setdefault(tab["workspace_id"], tab["tab_id"])
    cwds = {}
    for pane in snapshot["panes"]:
        if pane["tab_id"] == first_tab.get(pane["workspace_id"]) and pane.get("cwd"):
            cwds.setdefault(pane["workspace_id"], pane["cwd"])
    return cwds


def main():
    if not os.path.exists(SOCKET):
        return
    out = subprocess.run([HERDR, "api", "snapshot"], capture_output=True, text=True)
    if out.returncode != 0:
        return
    snapshot = json.loads(out.stdout)["result"]["snapshot"]
    for workspace_id, cwd in space_cwds(snapshot).items():
        value = describe(cwd)
        # Hang the branch off the space name above it with a U+2514 corner and U+2574 half line,
        # indented one cell. Herdr trims token values, including Unicode spaces, so the
        # indent is U+2800 BRAILLE PATTERN BLANK: blank, but not whitespace.
        token_args = ["--token", f"{TOKEN}=⠀└╴{value}"] if value else ["--clear-token", TOKEN]
        subprocess.run(
            [HERDR, "workspace", "report-metadata", workspace_id, "--source", SOURCE, *token_args],
            capture_output=True,
        )


if __name__ == "__main__":
    main()
