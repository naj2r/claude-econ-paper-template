---
paths:
  - "Documentation/**/*.do"
  - "Documentation/**/*.R"
  - "Documentation/**/*.qmd"
  - "Documentation/**/*.tex"
---

# Quality Gates & Scoring

## Thresholds

- **80/100 = Save** — good enough to keep
- **90/100 = Paper-ready** — ready for co-author review
- **95/100 = Excellence** — submission-ready

## Stata Do-Files (.do)

| Severity | Issue | Deduction |
|----------|-------|-----------|
| Critical | Wrong specification (wrong FE, wrong clustering) | -100 |
| Critical | Missing `vce(cluster {{cluster_var}})` | -30 |
| Critical | Wrong treatment variable | -30 |
| Major | Missing `capture log close` / `log using` | -10 |
| Major | Hardcoded paths instead of relative | -10 |
| Major | Missing variable labels | -5 |
| Minor | Inconsistent variable naming | -2 |

## R Scripts (.R)

| Severity | Issue | Deduction |
|----------|-------|-----------|
| Critical | Syntax errors | -100 |
| Critical | Wrong panel/sample used | -30 |
| Major | Missing `set.seed()` for stochastic code | -10 |
| Major | `require()` instead of `library()` | -5 |
| Major | Missing figure export | -5 |
| Minor | No script header comment | -2 |

## Quarto Chapters (.qmd)

| Severity | Issue | Deduction |
|----------|-------|-----------|
| Critical | Render failure | -100 |
| Critical | Broken cross-reference | -15 |
| Major | Inconsistent notation | -5 |
| Major | Missing source attribution | -3 |
| Minor | Formatting inconsistency | -1 |

## LaTeX Paper (.tex)

| Severity | Issue | Deduction |
|----------|-------|-----------|
| Critical | Compilation failure | -100 |
| Critical | Undefined citation | -15 |
| Critical | Table-code mismatch (table doesn't match do-file) | -20 |
| Major | Overfull hbox > 10pt | -5 |
| Major | Missing footnote on table (FE, clustering, stars) | -5 |
| Minor | Inconsistent notation | -2 |

## Tolerance Thresholds

| Quantity | Tolerance | Rationale |
|----------|-----------|-----------|
| Point estimates | 0.01 | Display rounding in tables |
| Standard errors | 0.05 | Clustering variation |
| Sample sizes (N) | Exact | No reason for difference |
| p-values | Same significance level | Exact p may differ slightly |
