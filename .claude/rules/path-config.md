# Path Configuration

**All file paths in this project are resolved through shorthand variables defined in CLAUDE.md.**

No skill, agent, or rule file should contain absolute paths. Every path reference must use one of these variables.

## Path Variables (defined in CLAUDE.md → Shorthand Paths)

| Variable | What It Points To | Example |
|----------|------------------|---------|
| `$RB` | Quarto project root (contains `_quarto.yml`, `replication_book/`, `code/`, etc.) | `C:/Users/you/Dropbox/Research Papers/My Study/` |
| `$OL` | Overleaf project directory (synced via Dropbox) | `C:/Users/you/Dropbox/Apps/Overleaf/My Paper/` |
| `$PAPERS` | Source PDFs for literature review | `C:/Users/you/Dropbox/Research Resources/Papers/` |

## Derived Paths (do NOT define separately — compute from the variables above)

| Derived Path | Resolves To | Used By |
|-------------|-------------|---------|
| `$RB/replication_book/` | Quarto chapter `.qmd` files | qa-quarto, render-pdf, condense-to-overleaf |
| `$RB/code/` | Stata do-files, R scripts | stata-code, r-quarto, translate-code |
| `$RB/data_raw/` | Raw source data | data-analysis |
| `$RB/data_final/` | Cleaned analysis-ready data | data-analysis, stata-code |
| `$RB/output/` | Regression results, figures | stata-code, r-quarto, review-paper |
| `$RB/quality_reports/` | Plans, session logs, specs | session-log, context-status, interview-me |
| `$RB/explorations/` | Sandbox for ad-hoc analysis | exploration-folder-protocol |
| `$RB/_book/` | Quarto render output (HTML + PDF) | render-pdf, qa-quarto |
| `$OL/Sections/` | Paper section `.tex` files | condense-to-overleaf, overleaf-check, review-paper |
| `$OL/files/tab/` | LaTeX tables from Stata esttab | insert-tables, stata-code, verification-protocol |
| `$OL/files/fig/` | Figures for the paper | r-quarto |
| `$OL/bibliography.bib` | Bibliography (natbib/apalike) | validate-bib, single-source-of-truth |
| `$OL/presentation.tex` | Beamer slides | build-slides, slide-excellence |
| `$OL/main.tex` | Paper main file | compile-latex, overleaf-check |

## Rules for Skills and Agents

1. **Never hardcode absolute paths** — always use `$RB`, `$OL`, or `$PAPERS`
2. **Resolve at runtime** — when a skill runs, read `$RB` / `$OL` from CLAUDE.md's Shorthand Paths section
3. **Relative paths within $RB are fine** — `code/07_regressions.do` is acceptable because it's implicitly relative to `$RB`
4. **Relative paths within $OL are fine** — `Sections/1-introduction.tex` is acceptable because it's implicitly relative to `$OL`
5. **Cross-variable paths are explicit** — if a skill needs both `$RB` and `$OL`, spell out both variables

## Setup: How Users Configure Their Paths

When starting a new project from this template, users fill in three lines in CLAUDE.md:

```
## Shorthand Paths
- `$RB` = `C:/Users/yourname/Dropbox/Research Papers/Your Study/`
- `$OL` = `C:/Users/yourname/Dropbox/Apps/Overleaf/Your Paper Title/`
- `$PAPERS` = `C:/Users/yourname/Dropbox/Research Resources/Papers/`
```

That's it. Everything else resolves from these three definitions.

## Stata Integration

If your Stata do-files also use path globals, mirror the CLAUDE.md paths:

```stata
* code/master/paths.do
global RB "C:/Users/yourname/Dropbox/Research Papers/Your Study"
global OL "C:/Users/yourname/Dropbox/Apps/Overleaf/Your Paper Title"
global DATA "$RB/data_final"
global OUTPUT "$RB/output"
global TABLES "$OL/files/tab"
```

## R Integration

```r
# scripts/config.R
RB <- "C:/Users/yourname/Dropbox/Research Papers/Your Study"
OL <- "C:/Users/yourname/Dropbox/Apps/Overleaf/Your Paper Title"
DATA <- file.path(RB, "data_final")
OUTPUT <- file.path(RB, "output")
TABLES <- file.path(OL, "files", "tab")
```
