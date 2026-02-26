# Plan-First Workflow

**For any non-trivial task, enter plan mode before writing code.**

## The Protocol

1. **Enter Plan Mode** — use `EnterPlanMode`
2. **Check MEMORY.md** — read any `[LEARN]` entries relevant to this task
3. **Requirements Specification (for complex/ambiguous tasks)** — see below
4. **Draft the plan** — what changes, which files, in what order
5. **Save to disk** — write to `quality_reports/plans/YYYY-MM-DD_short-description.md`
6. **Present to user** — wait for approval
7. **Exit plan mode** — only after approval
8. **Implement** — execute the plan

## When to Use Requirements Specification

- Task is high-level or vague ("improve the paper", "clean up the analysis")
- Multiple valid interpretations exist
- Significant effort required (>1 hour or >3 files)

**Skip for:** clear single-file edits, specific bug fixes, formatting tasks.

**Protocol:**
1. Use AskUserQuestion to clarify ambiguities (max 3-5 questions)
2. Create `quality_reports/specs/YYYY-MM-DD_description.md`
3. Mark each requirement: **MUST** / **SHOULD** / **MAY**
4. Get user approval, THEN draft the plan

## Plans on Disk

Plans survive context compression. Save every plan to:
`$RB/quality_reports/plans/YYYY-MM-DD_short-description.md`

## Session Recovery

After compression or new session:
1. Read `CLAUDE.md` + MEMORY.md + most recent plan in `quality_reports/plans/`
2. Read most recent session log in `quality_reports/session_logs/`
3. State what you understand the current task to be
