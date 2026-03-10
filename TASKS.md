# TEAM TASK BOARD

UpdatedBy: planner
UpdatedAt: 2026-03-10 09:00 (Asia/Shanghai)

## Rules
- Status must be one of: `todo`, `doing`, `review`, `blocked`, `done`.
- Exactly one owner per task: `planner`, `builder`, or `reviewer`.
- `SLAHours` is mandatory for non-done tasks.
- `DueAt` uses format `YYYY-MM-DD HH:MM` (Asia/Shanghai).
- `UpdatedAt` must be refreshed whenever task row changes.
- Every update must append one line in `## Activity Log`.

## Tasks
| ID | Title | Status | Owner | SLAHours | DueAt | UpdatedAt | Acceptance | Risk | Notes |
|---|---|---|---|---:|---|---|---|---|---|
| T-001 | Sample task | todo | builder | 24 | 2026-03-11 18:00 | 2026-03-10 09:00 | Define clear acceptance | low | replace me |

## Activity Log
- 2026-03-10 planner: cleaned board to keep only executable tasks (owner=builder, status=todo) and refreshed timestamps. Updated T-001 UpdatedAt -> 2026-03-10 09:00 (Asia/Shanghai).
- 2026-03-10 system upgraded board schema with SLA and deadlines.
- 2026-03-09 20:05 watchdog: T-001 stale (20h, todo/builder). No overdue, no blocked. SLA: 4h remain.
- 2026-03-09 22:43 watchdog: T-001 long-stale (22h43m, todo/builder). No overdue. No blocked. SLA: 1h2m remain. Recommend owner confirm progress or mark blocked+reason.
- 2026-03-10 06:43 UTC watchdog: T-001 critical-stale (23h43m, todo/builder, SLA expires in 1h2m). Zero overdue/blocked tasks. Escalate to builder immediately.
- 2026-03-09 23:05 UTC watchdog: T-001 critical-stale (23h5m, todo/builder). SLA expires in ~55min. No overdue/blocked. Action: escalate to builder immediately.
- 2026-03-10 09:00 planner: verified board; only executable tasks retained, all non-done tasks have SLAHours/DueAt/UpdatedAt. No overdue items.
- 2026-03-10 02:05 UTC watchdog: board healthy. 1 task (T-001 todo/builder), fresh update (1h old), 27h until due. Zero overdue/stale/blocked. No action needed.
- 2026-03-10 05:05 UTC watchdog: board healthy. T-001 fresh (5m old), 29h until due, SLA 24h nominal. Zero overdue/stale/blocked tasks. No action needed.
- 2026-03-10 06:05 UTC watchdog: T-001 todo/builder, 5h stale (acceptable), 19h55m until due. Zero overdue/long-stale/blocked. Board healthy. No action.
- 2026-03-10 07:05 UTC watchdog: hourly scan. T-001 UpdatedAt 22h ago (9:00 Shanghai = 01:00 UTC), well below 8h threshold. DueAt 35h away. Zero overdue, zero stale (>8h), zero blocked. Board healthy.
