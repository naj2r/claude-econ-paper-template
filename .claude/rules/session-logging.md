# Session Logging

**Location:** `$RB/quality_reports/session_logs/YYYY-MM-DD_description.md`

## Three Triggers

### 1. Post-Plan Log
After plan approval, immediately capture: goal, approach, rationale, key context.

### 2. Incremental Logging
Append 1-3 lines whenever: a design decision is made, a problem is solved, the user corrects something, or the approach changes. Do not batch.

### 3. End-of-Session Log
When wrapping up: high-level summary, open questions, blockers, next steps.

## Backmatter Updates (Quarto Replication Book)

In addition to session log files, propagate changes to the reviewer-facing backmatter chapters:

| What Happened | Update This Chapter |
|--------------|-------------------|
| Made an analytical or data decision | `92_decisions_and_assumptions.qmd` — add new entry |
| Encountered and solved a problem | `93_problems_and_solutions.qmd` — add new entry |
| Changed data, code, spec, or tables | `91_change_log.qmd` — add new entry (newest first) |
| Ran verification checks or confirmed results | `94_verification_evidence.qmd` — add evidence |
| End of session | `95_session_history.qmd` — add session summary |

These chapters serve as the reviewer-facing supplemental replication documentation. Keep them current — they should be publishable as "Other Materials" alongside the paper.

## Context Survival

Before auto-compression or session end:
1. Update MEMORY.md with any `[LEARN]` entries from this session
2. Ensure session log is current
3. Update relevant backmatter chapters (91--95)
4. Active plan is saved to disk
5. Open questions are documented

## Session Log Template

```markdown
# Session Log: [Date] — [Short Description]

## Goal
[What we set out to do]

## Key Decisions
- [Decision 1]: [Rationale]

## Completed
- [x] [Task 1]
- [x] [Task 2]

## Open Questions
- [ ] [Question 1]

## Next Steps
- [ ] [Next task 1]

## Files Modified
- `path/to/file1` — [what changed]
```
