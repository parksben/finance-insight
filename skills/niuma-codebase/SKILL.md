---
name: niuma-codebase
description: Read and analyze niuma project source code across all three repos (niuma, niuma-cli, niuma-server). Use when working on niuma features, fixing bugs, reviewing code, or when you need to understand the codebase. Triggers on "niuma", "牛马", project code review, or any development work related to the multi-agent collaboration platform.
---

# Niuma Codebase Navigator

## Project Layout

All source code lives on the server at `/root/.openclaw/projects/`:

```
/root/.openclaw/projects/
├── niuma/            # Monorepo: Flutter mobile app + desktop (Tauri)
│   ├── apps/mobile/  # Flutter (Dart) — Android/iOS client
│   └── .github/      # CI workflows
├── niuma-server/     # Express.js backend (Node.js)
│   ├── index.js      # Entry point
│   ├── src/          # Routes, services, DB, auth
│   └── data/         # SQLite DB (niuma.db)
└── niuma-cli/        # CLI installer + service manager (Bun-compiled)
    ├── install.sh    # One-click install script
    └── src/          # Commander.js commands
```

## Quick Reference Commands

```bash
# List all source files (excluding deps/git)
find /root/.openclaw/projects/niuma -type f -not -path '*/.git/*' -not -path '*/node_modules/*' -not -name '*.lock' -not -name '*.png' | sort

# Check server status
curl -s http://localhost:3002/health

# View server logs
journalctl -u niuma-server -n 50

# Run server DB queries
sqlite3 /root/.openclaw/projects/niuma-server/data/niuma.db "SELECT * FROM agents;"
```

## After Making Changes

1. Update memory: edit `/root/.openclaw/workspace/memory/niuma-project.md`
2. Git commit in workspace: `cd /root/.openclaw/workspace && git add memory/ && git commit -m "update niuma memory"`
3. If editing project code: commit in the project repo too
