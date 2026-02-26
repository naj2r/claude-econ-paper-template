# Claude Code Economics Paper Template

A complete workflow template for writing empirical economics papers with [Claude Code](https://claude.ai/claude-code). Includes 16 AI agents, 22 skills, and a two-layer documentation architecture (Quarto internal + Overleaf external).

## What's Included

### AI Infrastructure (`.claude/`)

| Component | Count | Purpose |
|-----------|-------|---------|
| **Agents** | 16 | Narrow-scope reviewers: domain expertise, proofreading, code review, LaTeX audit, etc. |
| **Skills** | 22 | Invocable workflows: `/render-pdf`, `/review-paper`, `/validate-bib`, etc. |
| **Rules** | 12 | Conventions: code style, quality gates, model assignment, replication protocol |

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

| Skill | What it does |
|-------|-------------|
| `/render-pdf` | Compile Quarto book to PDF with LaTeX quality checks |
| `/review-paper` | Domain expert review of paper sections |
| `/validate-bib` | Check bibliography for completeness and consistency |
| `/condense-to-overleaf` | Convert verbose Quarto docs to concise paper sections |
| `/qa-quarto` | Audit Quarto book for crossref, render, and content issues |
| `/session-log` | Timestamped hourly session logging (idle-aware) |
| `/devils-advocate` | Generate tough referee questions |

## Agent Model Assignment

| Model | Used For | Cost |
|-------|----------|------|
| **Opus** | Domain review, economic interpretation, research ideation | $$$ |
| **Sonnet** | Code review, proofreading, table verification, LaTeX audit | $$ |
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
