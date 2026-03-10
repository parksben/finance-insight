# gh CLI Cheatsheet

## Repository

```bash
gh repo create <name> --private --description "..."     # create private repo
gh repo create <name> --public                          # create public repo
gh repo list [--limit 30]                               # list repos
gh repo view <owner/repo>                               # view repo info
gh repo delete <owner/repo>                             # ⚠️ delete repo (confirm first)
gh repo clone <owner/repo> [dir]                        # clone
gh repo fork <owner/repo> --clone                      # fork + clone
```

## Branches & Code

```bash
git checkout -b <branch>
git push origin <branch>
gh repo set-default <owner/repo>                        # set default repo for gh commands
```

## Pull Requests

```bash
gh pr create --title "..." --body "..." --base main
gh pr list
gh pr view <number>
gh pr merge <number> [--squash|--rebase|--merge] [--delete-branch]
gh pr close <number>
gh pr review <number> --approve
gh pr diff <number>
```

## Issues

```bash
gh issue create --title "..." --body "..." [--label "..."] [--assignee "@me"]
gh issue list [--state open|closed]
gh issue view <number>
gh issue close <number>
gh issue comment <number> --body "..."
```

## GitHub Actions (CI/CD)

```bash
gh workflow list                                        # list workflows
gh workflow run <workflow.yml> [--repo owner/repo] [-f key=value]   # trigger
gh run list [--repo owner/repo] [--limit 10]           # list runs
gh run watch <run-id>                                  # watch live
gh run view <run-id> [--log]                           # view details/logs
gh run cancel <run-id>                                 # cancel run
gh run rerun <run-id>                                  # rerun failed
```

## Releases

```bash
gh release create <tag> [--title "..."] [--notes "..."] [--draft] [--prerelease]
gh release list
gh release upload <tag> <file>
gh release delete <tag>
```

## Secrets & Variables

```bash
gh secret set <NAME> --body "value"                    # set repo secret
gh secret list
gh variable set <NAME> --body "value"
gh variable list
```

## Gists

```bash
gh gist create <file> [--public] [--desc "..."]
gh gist list
gh gist view <id>
```

## Misc

```bash
gh auth status                                          # check auth
gh auth token                                          # get token (for scripting)
gh api /user                                            # raw API call
gh api graphql -f query='...'                          # GraphQL
```
