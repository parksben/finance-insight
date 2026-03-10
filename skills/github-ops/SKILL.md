---
name: github-ops
description: GitHub operations via the `gh` CLI — create repos, push code, manage branches, run/monitor Actions workflows (CI/CD pipelines), manage issues and PRs. Use when user asks to create a GitHub repo, push code changes, trigger or check GitHub Actions, open/close issues or PRs, or do any GitHub platform operation. Requires `gh` CLI authenticated on the server (already configured for parksben).
---

# GitHub Ops Skill

Uses the `gh` CLI (already authenticated as `parksben` on this server). No additional token setup needed.

## Quick Reference

```bash
gh auth status                          # verify auth
gh repo create <name> --private         # create repo
gh repo clone <owner/repo>              # clone repo
gh pr create --title "..." --body "..."
gh issue create --title "..." --body "..."
gh workflow run <workflow.yml>
gh run list --repo <owner/repo>
gh run watch <run-id>
```

## Common Workflows

### 1. Create a new repo and push code

```bash
gh repo create <name> [--private|--public] [--description "..."]
cd /path/to/local && git init && git remote add origin https://github.com/parksben/<name>.git
git add . && git commit -m "init" && git push -u origin main
```

### 2. Branch + PR workflow

```bash
git checkout -b feature/xxx
# make changes, commit
git push origin feature/xxx
gh pr create --title "..." --body "..." --base main
gh pr merge <number> --squash --delete-branch
```

### 3. Trigger & monitor CI/CD

```bash
gh workflow run <workflow-file> --repo parksben/<repo> [-f key=value]
gh run list --repo parksben/<repo> --limit 5
gh run watch <run-id> --repo parksben/<repo>
gh run view <run-id> --log                    # view logs on failure
```

### 4. Issues

```bash
gh issue create --title "..." --body "..." [--label bug]
gh issue list --repo parksben/<repo>
gh issue close <number>
```

## Auth & Token

- Auth managed by `gh` CLI: `/root/.config/gh/hosts.yml`
- Account: `parksben`
- Token scopes: `repo`, `workflow`, `admin:repo`, `admin:org`, etc. (full access)
- **Never hardcode the token in scripts**; always call `gh` CLI or use `gh auth token` to retrieve dynamically

## Safety Notes

- Destructive ops (repo delete, force push, branch delete) → confirm with user before executing
- Workflow triggers on production repos → confirm with user before executing
- `--public` repo creation → confirm with user (default to `--private`)

## References

- See `references/gh-cheatsheet.md` for extended command reference
