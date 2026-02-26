# Model Assignment Policy

When spawning subagents via the Task tool, use the appropriate model to balance cost and capability.

## Decision Matrix

| Task Type | Model | Why |
|-----------|-------|-----|
| Economic interpretation, identification critique, literature assessment | `opus` | Needs deep domain reasoning |
| Referee-style review, contribution assessment | `opus` | Nuanced judgment required |
| Research ideation, hypothesis generation | `opus` | Creative + domain knowledge |
| Condensing Quarto → paper sections | `opus` | Requires argumentative restructuring |
| Grammar, typos, formatting checks | `sonnet` | Pattern-matching, speed matters |
| Table verification (numbers match CSV) | `sonnet` | Mechanical comparison |
| Cross-language diff (Stata vs R output) | `sonnet` | Structured comparison |
| LaTeX syntax checking, brace matching | `sonnet` | Constrained pattern work |
| Citation key cross-referencing | `haiku` | Pure lookup task |
| File scanning, glob/grep operations | `haiku` | Trivial search |
| Slide overflow/layout checking | `sonnet` | Structured checklist |

## Agent Assignments (set in YAML frontmatter)

### Core agents (from Sant'Anna template)

| Agent | Model | Rationale |
|-------|-------|-----------|
| `domain-reviewer` | `opus` | Economic interpretation cannot be cheapened |
| `proofreader` | `sonnet` | Constrained pattern-matching |
| `slide-auditor` | `sonnet` | Bounded visual checklist |
| `narrative-reviewer` | `sonnet` | Argumentative flow is structural, not interpretive |
| `r-reviewer` | `sonnet` | Bounded code quality checks |
| `quarto-auditor` | `sonnet` | Mechanical render/cross-ref checks (READ-ONLY critic) |
| `quarto-fixer` | `sonnet` | Applies critic's fixes (READ-WRITE, cannot self-approve) |
| `verifier` | `sonnet` | Mechanical comparison |

### Project-specific agents (additions)

| Agent | Model | Rationale |
|-------|-------|-----------|
| `stata-reviewer` | `sonnet` | Bounded code quality checks |
| `table-auditor` | `sonnet` | Mechanical formatting + number verification |
| `tikz-reviewer` | `sonnet` | TikZ syntax/scaling — Beamer + R integration |
| `bib-checker` | `haiku` | Pure cross-referencing lookup |
| `bib-fixer` | `sonnet` | Applies bib-checker fixes (READ-WRITE, cannot self-approve) |
| `pdf-auditor` | `sonnet` | LaTeX log parsing, overflow/font/float checks (READ-ONLY critic) |
| `pdf-fixer` | `sonnet` | Applies pdf-auditor fixes to QMD/YAML (READ-WRITE, cannot self-approve) |
| `session-logger` | `haiku` | Hourly session log summaries (user can override to sonnet/opus for detail) |

## Orchestrator Agent Selection

When the orchestrator (or a skill) needs to select review agents, use this table based on which files were modified:

| Files Modified | Agents to Run |
|---------------|---------------|
| `.tex` paper sections | proofreader + narrative-reviewer + domain-reviewer |
| `.tex` presentation slides | proofreader + slide-auditor (+ tikz-reviewer if TikZ present) |
| `.tex` table files | table-auditor |
| `.qmd` chapters | proofreader + narrative-reviewer + quarto-auditor |
| `.qmd` with Overleaf counterpart | Above + domain-reviewer (parity check) |
| `.R` scripts | r-reviewer |
| `.do` Stata files | stata-reviewer |
| `.bib` files | bib-checker → bib-fixer (adversarial loop) |
| PDF render output | pdf-auditor → pdf-fixer (adversarial loop) |
| Multiple formats | verifier for cross-format parity |

Independent agents run **in parallel**. The quarto-auditor → quarto-fixer loop runs **sequentially** (adversarial pattern: critic then fixer, up to 5 rounds).

## Skill Guidance (when spawning Task subagents)

When a skill uses the Task tool to delegate work:

### Use `model: "opus"` for:
- `/review-paper` — the reviewer agent needs deep economic reasoning
- `/devils-advocate` — generating tough referee questions requires domain expertise
- `/condense-to-overleaf` — restructuring from pedagogical to argumentative prose
- `/lit-review` — synthesizing literature and identifying gaps
- `/research-ideation` — creative research question generation
- `/interview-me` — formulating identification strategies

### Use `model: "sonnet"` for:
- `/proofread` — grammar and formatting
- `/verify` — mechanical checks against source data
- `/validate-bib` — citation key cross-referencing
- `/overleaf-check` — LaTeX syntax validation
- `/compile-latex` — log file parsing
- `/review-r` — code convention checking
- `/visual-audit` — slide layout checklist
- `/insert-tables` — finding and wiring `\input{}` commands
- `/qa-quarto` — render checking and cross-ref validation
- `/render-pdf` — PDF compilation + LaTeX log audit

### Use `model: "haiku"` for:
- `/context-status` — reading files and reporting status
- File search/glob operations within any skill
- Simple formatting tasks (renaming, restructuring YAML)

## Rule of Thumb

> If the task requires understanding *why* something is correct (economic logic, identification, interpretation) → **opus**.
> If the task requires checking *whether* something is correct (matching numbers, valid syntax, resolved references) → **sonnet**.
> If the task is pure lookup or simple formatting → **haiku**.

## Cost Optimization (from Sant'Anna §4.5.2)

> Run Sonnet-level reviewers **in parallel** (cheap). Run Opus-level agents **sequentially** (expensive).
> A typical review runs proofreader + slide-auditor + narrative-reviewer on Sonnet in parallel, then domain-reviewer on Opus sequentially. This saves ~40-60% compared to running everything on Opus.
