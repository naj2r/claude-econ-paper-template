# Claude Code Economics Paper Template

A complete workflow template for writing empirical economics papers with [Claude Code](https://claude.ai/claude-code). Includes 26 AI agents, 34 skills, and a two-layer documentation architecture (Quarto internal + Overleaf external).

## What's Included

### AI Infrastructure (`.claude/`)

| Component | Count | Purpose |
|-----------|-------|---------|
| **Agents** | 26 | Narrow-scope reviewers: domain expertise, proofreading, code review, LaTeX audit, writing pipeline, etc. |
| **Skills** | 34 | Invocable workflows: `/render-pdf`, `/review-paper`, `/mccloskey-prose-edit`, `/consolidate`, etc. |
| **Rules** | 13 | Conventions: code style, quality gates, model assignment, manuscript protection, replication protocol |

### Quarto Replication Book (`replication_book/`)

A Quarto book scaffold with chapters that mirror the paper structure:

- **Ch. 01–02**: Environment & raw data inventory
- **Ch. 10–40**: Data construction pipeline
- **Ch. 50–70**: Variable construction
- **Ch. 75**: Empirical strategy (formal TWFE specification)
- **Ch. 80**: Regressions & table generation
- **Ch. 85**: Literature sources & theoretical framework
- **Ch. 90**: Verification checks
- **Ch. 91–95**: Backmatter audit trail (change log, decisions, problems, verification, session history)

### Overleaf Paper Template

**Overleaf template:** [{{LINK TO PUBLISHED OVERLEAF TEMPLATE}}]({{URL}})

The Overleaf project provides:
- `main.tex` with `natbib`/`apalike` bibliography
- 8 section files (introduction through appendix)
- `presentation.tex` Beamer template
- Table pipeline: `files/tab/` for Stata `esttab` output
- Figure pipeline: `files/fig/` for R/Stata graphics

## Setup Instructions

### 1. Create your project

```bash
# Clone this template
gh repo create my-paper --template jensenn/claude-econ-paper-template --private
git clone https://github.com/USERNAME/my-paper
```

Or click "Use this template" on GitHub.

### 2. Create your Overleaf project

Option A: Use the [published Overleaf template]({{URL}})
Option B: Create a new Overleaf project and upload the files manually

### 3. Customize `CLAUDE.md`

Fill in the `{{placeholders}}`:
- Paper title and author
- `$RB` path (Quarto project root)
- `$OL` path (Overleaf project, synced via Dropbox)
- `$PAPERS` path (source PDFs)

### 4. Customize project-specific rules

These files need your study's details:
- `.claude/rules/study-parameters.md` — treatment variables, headline results, panel definitions
- `.claude/rules/replication-protocol.md` — your do-file/script pipeline
- `.claude/rules/overleaf-workflow.md` — section writing status
- `.claude/rules/single-source-of-truth.md` — authority chain for your data flow
- `.claude/agents/domain-reviewer.md` — study context for the domain expert agent

### 5. Render the Quarto book

```bash
cd $RB && quarto render
```

### 6. Start working

```bash
claude  # Start Claude Code in your project directory
```

## Architecture

```
Your Paper/
├── .claude/                    # AI workflow infrastructure
│   ├── agents/                 # 16 reviewer agents
│   ├── skills/                 # 22 invocable skills
│   └── rules/                  # 12 convention files
├── CLAUDE.md                   # Project config (paths, state, principles)
├── _quarto.yml                 # Quarto book config (HTML + PDF)
├── replication_book/           # Internal documentation chapters
├── code/                       # Stata do-files / R scripts
├── data_raw/ → data_final/     # Data pipeline
├── output/results/             # Regression CSV
├── quality_reports/            # Plans, session logs, specs
└── Overleaf/ (separate)        # Paper + slides (synced via Dropbox)
```

## Key Skills

### Core Workflow

| Skill | What it does |
|-------|-------------|
| `/render-pdf` | Compile Quarto book to PDF with LaTeX quality checks |
| `/review-paper` | Domain expert review of paper sections |
| `/validate-bib` | Check bibliography for completeness and consistency |
| `/condense-to-overleaf` | Convert verbose Quarto docs to concise paper sections |
| `/qa-quarto` | Audit Quarto book for crossref, render, and content issues |
| `/session-log` | Timestamped hourly session logging (idle-aware) |
| `/devils-advocate` | Generate tough referee questions |

### Academic Writing Pipeline (8-stage, run in order)

These skills form a complete writing pipeline for taking a rough draft to publication-ready prose. Each stage has a narrow focus and must run in sequence:

| Stage | Skill | What it does | When to use |
|-------|-------|-------------|-------------|
| 1 | `/draft-slop-fixer` | Clean up stream-of-consciousness drafts — resolve `(CITE)` markers, reword copy-paste chunks, fill TODOs | First pass on any rough draft |
| 2 | `/proofread` | Grammar, formatting, citation consistency, formal register | After slop is fixed |
| 3 | `/review-paper` | Narrative flow, argumentative structure, "so what" clarity | After proofreading |
| 4 | `/review-paper` | Domain expert review — econometric validity, overclaiming, literature accuracy | After narrative check |
| 5 | `/consolidate` | Cherry-pick additions from co-author notes, earlier drafts, source docs. Adversarial: fixer proposes, critic evaluates (max 2 rounds) | When merging contributions |
| 6 | `/mccloskey-prose-edit` | McCloskey *Economical Writing* audit — critic scores (100-point rubric), fixer suggests rewrites, critic re-grades | After content is final |
| 7 | — (organizer agent) | Reorder paragraphs, fix section boundaries, split/merge paragraphs | After McCloskey pass |
| 8 | — (compressor agents) | Score word count compliance against journal targets, compress if over | Final length check |

### Literature Management

| Skill | What it does | When to use |
|-------|-------------|-------------|
| `/split-pdf` | Download, split PDFs into 4-page chunks, deep-read with structured extraction | Reading any academic paper |
| `/lit-filter` | Organize, critique inclusion value, filter redundancy across all paper notes | After all papers are read |
| `/lit-synthesizer` | Rate papers by relevance, organize by subtopic, condense into narrative review | Building the lit review section |

### Manuscript Protection

| Skill | What it does | When to use |
|-------|-------------|-------------|
| `/own-writing-check` | Audit `.tex` changes — flag any edit the user didn't explicitly request | After any session touching Overleaf files |

## All Agents (26)

### Review Agents (READ-ONLY critics)

| Agent | Model | What it checks |
|-------|-------|---------------|
| `domain-reviewer` | opus | Economic interpretation, identification, overclaiming |
| `narrative-reviewer` | sonnet | Argumentative flow, transitions, "so what" clarity |
| `proofreader` | sonnet | Grammar, register, citation format, capitalization |
| `slide-auditor` | sonnet | Beamer layout, overflow, font consistency |
| `r-reviewer` | sonnet | R code quality, reproducibility |
| `stata-reviewer` | sonnet | Stata code conventions, clustering, file naming |
| `table-auditor` | sonnet | Table formatting, number verification against CSV |
| `tikz-reviewer` | sonnet | TikZ diagram quality |
| `quarto-auditor` | sonnet | Quarto render, crossrefs, YAML |
| `bib-checker` | haiku | Citation key cross-referencing |
| `pdf-auditor` | sonnet | LaTeX log parsing, overflow, font issues |
| `session-logger` | haiku | Session log summaries |
| `manuscript-critic` | sonnet | Audits `.tex` edits against user requests |
| `mccloskey-critic` | sonnet | McCloskey prose quality scoring (100-point rubric) |
| `compressor-critic` | sonnet | Section word count compliance |
| `consolidator-critic` | sonnet | Skeptical gatekeeper for proposed additions |
| `lit-filter` | sonnet | Paper inclusion value, redundancy filtering |
| `lit-synthesizer` | sonnet | Literature rating, subtopic organization |

### Fixer Agents (READ-WRITE, cannot self-approve)

| Agent | Model | What it fixes |
|-------|-------|--------------|
| `quarto-fixer` | sonnet | Applies quarto-auditor findings |
| `bib-fixer` | sonnet | Applies bib-checker findings |
| `pdf-fixer` | sonnet | Applies pdf-auditor findings |
| `mccloskey-fixer` | sonnet | Generates prose revision suggestions |
| `compressor-fixer` | sonnet | Compresses prose to meet word count targets |
| `organizer` | sonnet | Reorders paragraphs, fixes section boundaries |
| `consolidator-fixer` | opus | Cherry-picks additions from source documents |
| `verifier` | sonnet | End-to-end task completion verification |

## Agent Model Assignment

| Model | Used For | Cost |
|-------|----------|------|
| **Opus** | Domain review, economic interpretation, research ideation, consolidation | $$$ |
| **Sonnet** | Code review, proofreading, table verification, LaTeX audit, prose editing | $$ |
| **Haiku** | File search, citation lookup, session logging | $ |

See `.claude/rules/model-assignment.md` for the full decision matrix.

## Extending the Template

### Adding agents

Create `.claude/agents/my-agent.md` with YAML frontmatter (`model`, `description`, `tools`) and update `CLAUDE.md`.

### Adding skills

Create `.claude/skills/my-skill/SKILL.md` with YAML frontmatter (`name`, `description`, `allowed-tools`) and update `CLAUDE.md`.

### Project-specific agents

The template includes generic agents. For domain-specific needs (e.g., a health economics reviewer, an IO theory critic), duplicate `domain-reviewer.md` and customize the expertise and context sections.

## Credits

Built on the [pedrohcgs/claude-code-my-workflow](https://github.com/pedrohcgs/claude-code-my-workflow) template by Pedro H.C. Sant'Anna.

## License

MIT
