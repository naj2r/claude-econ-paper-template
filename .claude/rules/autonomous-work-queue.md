---
paths:
  - "**/*.qmd"
  - "**/*.md"
---

# Autonomous Work Queue

**When the TODO list is empty or nearly empty, automatically pick up the next autonomous task from the permanent agenda.**

## Trigger

After completing all current TODO items (or when only the stenographer TODO remains), check the permanent agenda at:
`$RB/quality_reports/plans/[most-recent-agenda-file].md`

Read the agenda, identify the next unchecked `[ ]` item that is **autonomous** (see classification below), add it to the TODO list, and begin work. No user confirmation needed for autonomous tasks.

## Task Classification

### AUTONOMOUS (proceed without asking)
These tasks can run without user feedback. Pick these up automatically:

| Task Type | Examples |
|-----------|---------|
| BibTeX entry additions | Adding entries from scan notes |
| Paper scans via Consensus API | Scanning papers from hunt lists |
| Review pipeline agents | Inquisitor, domain reviewer, proofreader, narrative reviewer |
| Clarifier structural revisions | Applying approved revision patterns |
| Stenographer logging | Recording completed work |
| Agenda/session log updates | Updating status, writing logs |
| QMD draft assembly | Writing/editing Quarto book chapters |
| McCloskey prose edit | Running mccloskey-critic → mccloskey-fixer on QMD |
| Compression passes | Reducing QMD word count to targets |
| Bib validation | Cross-referencing citations |
| Quarto rendering checks | `quarto render` + error resolution |

### REQUIRES USER (ask before starting)
These tasks need user input or approval:

| Task Type | Why |
|-----------|-----|
| Writing .tex paper sections | Manuscript protection rule |
| Design/architectural decisions | User writes the paper |
| Changing regression specifications | Analytical decisions |
| Adding new treatment variables | Study design decisions |
| Choosing which papers to cite in .tex | User's argumentative choices |
| Anything in `$OL/Sections/1-6*.tex` | Protected files |

### BACKGROUND-SUITABLE (dispatch as background agent)
These can run in background while other work continues:

| Task Type | Model |
|-----------|-------|
| Paper scans | haiku |
| Bib validation | haiku |
| Review agents (read-only) | sonnet |
| File searches and inventories | haiku |

## Protocol

1. **Check agenda** — Read the permanent agenda file
2. **Find next autonomous task** — First unchecked `[ ]` item classified as AUTONOMOUS
3. **Add to TODO list** — Create proper TODO entry with content + activeForm
4. **Execute** — Run the task
5. **Update agenda** — Mark `[x]` on completion
6. **Log** — Stenographer entry (unless the task itself IS the stenographer)
7. **Loop** — Check for next task

## Priority Order

When multiple autonomous tasks are available, prioritize:
1. **Pipeline-blocking** — tasks that block downstream work (e.g., draft before review pipeline)
2. **Quick wins** — tasks completable in <2 minutes (bib entries, key verification)
3. **Background-dispatchable** — tasks that can run as background agents while doing #1-2
4. **Infrastructure** — template sync, rule updates, documentation

## Session Continuity

If the session is ending (context compression imminent or user signing off):
1. Write any in-progress work to disk
2. Update the agenda with current status
3. Add a "Next Steps" entry to the session log
4. Update MEMORY.md if any [LEARN] items emerged

## Integration with Existing Rules

This rule extends `incremental-documentation.md` and `session-logging.md`:
- Stenographer still fires after every completed task (no change)
- Session logs still capture decisions and problems (no change)
- This rule adds the **automatic pickup** behavior when the queue empties
