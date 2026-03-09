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
| `manuscript-critic` | `sonnet` | Audits .tex edits against user requests — READ-ONLY gatekeeper |
| `mccloskey-critic` | `sonnet` | McCloskey prose quality scoring — rule-based compliance checklist (READ-ONLY) |
| `mccloskey-fixer` | `sonnet` | Creative rewriting suggestions bounded by McCloskey rules (writes to QMD only) |
| `compressor` | `sonnet` | Produces compressed draft targeting word count range (READ-WRITE, QMD/md only). Biased toward shorter. |
| `nuance-contrarian` | `opus` | Reviews compressor output for lost nuance — deducts for lost caveats, effect sizes, precision (READ-ONLY critic). Biased toward preserving everything. |
| `compression-mediator` | `sonnet` | Resolves compressor vs. contrarian disputes — SUSTAIN/OVERRULE/COMPROMISE each objection. 50-50 weight, -10 per 200 words over max. Final output. (READ-WRITE, QMD/md only) |
| `organizer` | `sonnet` | Reorganizes paragraph order, section boundaries, splits/merges (READ-WRITE, QMD/md only) |
| `consolidator-fixer` | `opus` | Cherry-picks additions from source docs not yet in draft — "yes, and you need this" persona (READ-ONLY proposer) |
| `consolidator-critic` | `sonnet` | Reviews consolidator-fixer proposals — "do we actually need this?" gatekeeper (READ-ONLY evaluator) |

### Narrative quality agents

| Agent | Model | Rationale |
|-------|-------|-----------|
| `narrative-factcheck` | `sonnet` | Checks draft claims against user's persistent corrections memory. 95/100 pass threshold. Runs before McCloskey prose edit. (READ-ONLY critic) |
| `narrative-factcheck-fixer` | `sonnet` | Applies narrative corrections to QMD only. Cannot self-approve — requires re-audit by narrative-factcheck critic. (READ-WRITE: QMD/md only) |

### Section writing review agents

| Agent | Model | Rationale |
|-------|-------|-----------|
| `lit-review-inquisitor` | `haiku` → `sonnet` | Round 1: cheap broad scan for structural foibles (READ-ONLY). Round 2: upgraded context with cross-section checks. Escalates model between rounds. |
| `lit-review-clarifier` | `sonnet` → `opus` | Round 1: structural revision suggestions sourced to guide principles (READ-WRITE: writes to QMD only). Round 2: creative restructuring for rejected suggestions. Escalates model between rounds. |

### cheap-scan1 pipeline agents

| Agent | Model | Rationale |
|-------|-------|-----------|
| `pdf-scanner` | `haiku` | Pure pattern matching against regex dictionary — cheapest possible (READ-ONLY) |
| `pdf-text-summarizer` | `haiku` | Structured extraction from pre-split text — no reasoning required, just careful reading (READ-ONLY) |
| `pdf-visual-analyzer` | `sonnet` | Requires vision to read rendered table/figure PNGs — can't use haiku (READ-ONLY) |
| `pdf-equation-transcriber` | `sonnet` | Requires vision + structured LaTeX output from rendered equation PNGs (READ-ONLY) |
| `pdf-consolidator` | `sonnet` | Merges specialist outputs — needs judgment for triage scoring and section placement (READ-WRITE: writes notes.md) |

## Orchestrator Agent Selection

When the orchestrator (or a skill) needs to select review agents, use this table based on which files were modified:

| Files Modified | Agents to Run |
|---------------|---------------|
| `.tex` paper sections | **manuscript-critic first** → then proofreader + narrative-reviewer + domain-reviewer |
| `.tex` paper sections (prose review) | mccloskey-critic → mccloskey-fixer → mccloskey-critic (adversarial loop, max 2 rounds) |
| `.tex` presentation slides | proofreader + slide-auditor (+ tikz-reviewer if TikZ present) |
| `.tex` table files | table-auditor |
| `.qmd` chapters | proofreader + narrative-reviewer + quarto-auditor |
| `.qmd` with Overleaf counterpart | Above + domain-reviewer (parity check) |
| `.R` scripts | r-reviewer |
| `.do` Stata files | stata-reviewer |
| `.bib` files | bib-checker → bib-fixer (adversarial loop) |
| PDF render output | pdf-auditor → pdf-fixer (adversarial loop) |
| Multiple formats | verifier for cross-format parity |
| Draft consolidation (merging source docs) | consolidator-fixer → consolidator-critic → fixer rebuttal → critic final (adversarial loop, max 2 rounds) |
| Lit review / background (pedagogical review) | lit-review-inquisitor (haiku) → lit-review-clarifier (sonnet) → lit-review-inquisitor (sonnet) → [if needed] lit-review-clarifier (opus) → lit-review-inquisitor (sonnet). Max 2 rounds. |
| Section compression (word count reduction) | compressor (sonnet) → nuance-contrarian (opus) → compression-mediator (sonnet). Single pass, mediator's verdict is final. See `compression-triad.md`. |
| Draft finalization (narrative accuracy) | narrative-factcheck (sonnet) → [if < 95] narrative-factcheck-fixer (sonnet) → narrative-factcheck (sonnet). Max 2 rounds. See `narrative-corrections.md` for persistent memory. |

Independent agents run **in parallel**. The quarto-auditor → quarto-fixer loop runs **sequentially** (adversarial pattern: critic then fixer, up to 5 rounds).

**Writing pipeline order:** Review pipeline → Compression triad → **Narrative fact-check** → McCloskey prose edit → Final draft. Compression BEFORE McCloskey (shrink first, polish second). Fact-check BEFORE McCloskey (accuracy before style).

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
- `/own-writing-check` — audits .tex edits against conversation (uses manuscript-critic agent)
- `/mccloskey-prose-edit` — McCloskey prose quality audit (mccloskey-critic + mccloskey-fixer adversarial loop)
- `/consolidate` — consolidator-critic is sonnet; consolidator-fixer is opus (asymmetric: fixer argues harder, critic is lighter gatekeeper)

### Mixed models (multiple model tiers within one skill):
- `/cheap-scan1` — orchestrator runs locally (Python, zero tokens) + haiku (scanner, text summarizer) + sonnet (visual analyzer, equation transcriber, consolidator). Vision only on pages that need it.
- `/lit-writing-review` — inquisitor R1 (haiku) → clarifier R1 (sonnet) → inquisitor R2 (sonnet) → [if needed] clarifier R2 (opus) → inquisitor final (sonnet). Model escalation within rounds. Best case: 1 haiku call. Worst case: 5 calls (haiku + 2 sonnet + opus + sonnet).

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

**Parallel task cap:** Never dispatch more than 3 Task agents in a single message. If more than 3 independent tasks are needed, batch them in groups of 3. See `information-overload-failsafe.md`.
