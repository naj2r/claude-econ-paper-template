# Claude Code Economics Paper Template

This is a constant work-in-progress, only possible due to Pedro Sant'Anna and Scott Cunningham's guides that inspired the current (messy) repository setup for claude code. Copy it and strip it for parts. It's useful to me, so you might find it useful too.

A complete workflow template for writing empirical economics papers with [Claude Code](https://claude.ai/claude-code). Includes 38 AI agents, 37 skills, 2 hooks, and a two-layer documentation architecture (Quarto internal + Overleaf external).

## What's Included

### AI Infrastructure (`.claude/`)

| Component | Count | Purpose |
|-----------|-------|---------|
| **Agents** | 38 | Narrow-scope reviewers + 5 cheap-scan1 pipeline agents + 2 background automation agents (stenographer, codevolution) + 4 section writing review agents (lit-review + generic) |
| **Skills** | 37 | Invocable workflows: `/render-pdf`, `/review-paper`, `/mccloskey-prose-edit`, `/consolidate`, `/cheap-scan1`, `/lit-organizer`, `/section-writing-review`, etc. |
| **Rules** | 19 | Conventions: code style, quality gates, model assignment, manuscript protection, replication protocol, compression triad, autonomous work queue, Quarto presentation pipeline |
| **Hooks** | 2 | Event-driven: manuscript protection (PreToolUse), context recovery (SessionStart) |

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

### Conference Presentations (Quarto Multi-Format)

Two approaches for conference slides:

| Approach | Source | Outputs | When to use |
|----------|--------|---------|-------------|
| **Option A: Pure Beamer** | `$OL/presentation.tex` | PDF only | Full LaTeX control, Overleaf compilation |
| **Option B: Quarto multi-format** | `Quarto/conference/*.qmd` | RevealJS HTML + Beamer PDF | Web-accessible slides + PDF handout from one source |

Option B uses a starter kit in `templates/quarto-presentation/` with:
- `presentation.qmd` — template QMD with `{{placeholders}}` for title, author, colors
- `styles/beamer-preamble.tex` — Beamer theme with TikZ box environments
- `styles/revealjs-theme.scss` — RevealJS theme with matching CSS box classes
- `filters/custom-boxes.lua` — Lua filter converting div classes to LaTeX environments
- `_quarto.yml` — shared settings only (bibliography, CSL, mermaid, execute)

**Quick start:**
```bash
cp -r templates/quarto-presentation/ Quarto/conference/
# Edit presentation.qmd — fill in {{placeholders}}
quarto render presentation.qmd --to revealjs   # HTML slides
quarto render presentation.qmd --to beamer      # PDF slides
```

See `.claude/rules/quarto-presentation-pipeline.md` for the full reference (config inheritance, Mermaid constraints, format-conditional content, two-deck architecture).

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

---

## Sessions, Context, and Portability

Claude Code has no built-in memory between sessions. Every time you run `claude`, it starts fresh and reconstructs context by reading files — primarily `CLAUDE.md`. Understanding this is key to working effectively.

### How Claude "Remembers"

| File | What It Preserves | Read Automatically? |
|------|-------------------|---------------------|
| `CLAUDE.md` | Project config, paths, agent/skill inventory, current state | **Yes** — every session |
| `MEMORY.md` | `[LEARN]` entries — corrections, discovered patterns, things Claude got wrong | **Yes** — every session |
| `.claude/rules/*.md` | Conventions, quality gates, study parameters | **Yes** — loaded by path scope |
| `quality_reports/plans/` | Saved plans from plan-first workflow | On demand (read at session start per plan-first rule) |
| `quality_reports/session_logs/` | What happened in each session | On demand (read at session start per plan-first rule) |
| Backmatter chapters (91–95) | Reviewer-facing audit trail: changes, decisions, problems, verification | On demand |

The **Current State** table in `CLAUDE.md` is the single most important thing to keep updated. It tells Claude what's done, what's in progress, and what needs work — without re-reading every file.

### Scenario A: New Session, Same Project

You hit a context limit, or you closed the terminal and came back tomorrow. The project files haven't moved.

```bash
# Just run claude from the same directory. That's it.
cd /path/to/my-paper
claude
```

**What happens automatically:**
1. Claude reads `CLAUDE.md` → knows the project, paths, agents, skills, current state
2. Claude reads `MEMORY.md` → knows past corrections and patterns
3. Rules load by path scope as you work on files
4. The plan-first-workflow rule tells Claude to check the most recent plan and session log

**What you should do before ending a session** (if you want clean handoff):
1. Update the **Current State** table in `CLAUDE.md` if anything major changed
2. Make sure there's a session log in `quality_reports/session_logs/`
3. Any `[LEARN]` entries should be in `MEMORY.md`

**Quick context recovery prompt** (optional — paste if Claude seems lost):

> Read the most recent session log in `quality_reports/session_logs/` and the current state table in CLAUDE.md. Summarize where we left off and what's next.

### Scenario B: New Project from the Template

You're starting a different paper — new data, new question, separate repo entirely.

**Step 1: Create the repo**

```bash
# Option A: GitHub CLI (recommended)
gh repo create my-new-paper --template naj2r/claude-econ-paper-template --private
git clone https://github.com/YOUR_USERNAME/my-new-paper
cd my-new-paper

# Option B: GitHub web UI
# Click "Use this template" on the repo page, then clone
```

**Step 2: Open Claude Code and paste one prompt**

```bash
claude
```

Then paste:

> I am starting to work on **[PAPER TITLE]** in this repo. **[2-3 sentences: topic, data, methods, target journal.]**
>
> The Claude Code economics paper template is set up. Please read CLAUDE.md and all configuration files, then update them for my project — fill in all `{{placeholders}}`, customize study-parameters.md with my treatment variables and panel structure, and set up the Overleaf path.
>
> Enter plan mode and start by adapting the configuration for this project.

**Step 3: Claude customizes 5 files** (everything else works immediately):

| File | What to fill in |
|------|----------------|
| `CLAUDE.md` | Paper title, `$RB` / `$OL` / `$PAPERS` paths, current state |
| `.claude/rules/study-parameters.md` | Treatment variables, headline results, panel definitions, sample structure |
| `.claude/rules/replication-protocol.md` | Your do-file or script pipeline |
| `.claude/rules/overleaf-workflow.md` | Section writing status tracker |
| `.claude/agents/domain-reviewer.md` | Study context for the domain expert reviewer |

All 36 agents, 36 skills, and 18 rules reference these config files via variables (`$OL`, `$RB`, `study-parameters.md`) rather than hardcoded paths — so they work for any project without modification.

### Quick Reference: Which Scenario Am I In?

| Situation | What to do |
|-----------|-----------|
| Closed terminal, same paper | `cd /path/to/paper && claude` — everything auto-loads |
| Hit context limit mid-task | Same as above; paste the context recovery prompt if needed |
| Starting a brand new paper | Create repo from template → paste setup prompt → customize 5 files |
| Working on two papers simultaneously | Each paper is its own repo with its own `CLAUDE.md` — open separate terminals |
| Want to share infrastructure updates | Pull from the template repo, or manually copy new agents/skills from it |

### The Overleaf Connection

Each project needs its own Overleaf project. The template doesn't create one for you — set it up separately:

1. Create an Overleaf project (from the published template or manually)
2. Sync it to your machine via Dropbox (Overleaf → Menu → Sync → Dropbox)
3. Set `$OL` in your `CLAUDE.md` to the local Dropbox path
4. The table pipeline (`esttab` → `.tex` → `\input{}`) works identically across projects

---

## Architecture

```
Your Paper/
├── .claude/                    # AI workflow infrastructure
│   ├── agents/                 # 36 agents (29 reviewers + 5 cheap-scan1 pipeline + 2 background automation)
│   ├── skills/                 # 36 invocable skills
│   └── rules/                  # 18 convention files
├── CLAUDE.md                   # Project config (paths, state, principles)
├── _quarto.yml                 # Quarto book config (HTML + PDF)
├── replication_book/           # Internal documentation chapters
├── code/                       # Stata do-files / R scripts
├── data_raw/ → data_final/     # Data pipeline
├── output/results/             # Regression CSV
├── quality_reports/            # Plans, session logs, specs
├── templates/
│   └── quarto-presentation/    # Starter kit: QMD + SCSS + Beamer preamble + Lua filter
├── Quarto/conference/          # Your presentation (copy from template, customize)
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
| `/split-pdf` | Download, split PDFs into 4-page chunks, deep-read with structured extraction | Reading any academic paper (baseline) |
| `/cheap-scan1` | Token-efficient PDF pipeline: local text extraction + routed specialists. ~55-76% cheaper than split-pdf | Reading papers when token cost matters; falls back to split-pdf for scanned PDFs |
| `/lit-organizer` | Single-pass pipeline: score relevance (1-5), assign inclusion tiers (A-D), identify redundancy clusters, write synthesized narrative by subtopic. Replaces the old lit-filter + lit-synthesizer two-step. | After all papers are read |

### Conference Presentations

| Skill | What it does | When to use |
|-------|-------------|-------------|
| `/build-slides` | Build slides — auto-detects Beamer-only (Option A) or Quarto multi-format (Option B). For Quarto: renders RevealJS + Beamer from QMD | After editing slide content |
| `/visual-audit` | Adversarial layout audit — checks overflow, font sizes, box fatigue. Supports both Beamer and Quarto (Mermaid, format-conditional, cross-format) | Before presenting or committing slides |
| `/slide-excellence` | Multi-agent review (visual + pedagogy + proofreading) | Comprehensive quality check before milestones |

### Manuscript Protection

| Skill | What it does | When to use |
|-------|-------------|-------------|
| `/own-writing-check` | Audit `.tex` changes — flag any edit the user didn't explicitly request | After any session touching Overleaf files |

## All Agents (36)

### Review Agents (READ-ONLY critics)

| Agent | Model | What it checks |
|-------|-------|---------------|
| `domain-reviewer` | opus | Economic interpretation, identification, overclaiming |
| `narrative-reviewer` | sonnet | Argumentative flow, transitions, "so what" clarity |
| `narrative-factcheck` | sonnet | Draft claims against user's persistent corrections memory (95/100 threshold) |
| `lit-review-inquisitor` | haiku→sonnet | Lit review structural compliance (foible scoring, escalates R1→R2) |
| `proofreader` | sonnet | Grammar, register, citation format, capitalization |
| `slide-auditor` | sonnet | Beamer + Quarto layout, overflow, font consistency, Mermaid constraints |
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

### Fixer Agents (READ-WRITE, cannot self-approve)

| Agent | Model | What it fixes |
|-------|-------|--------------|
| `quarto-fixer` | sonnet | Applies quarto-auditor findings |
| `bib-fixer` | sonnet | Applies bib-checker findings |
| `pdf-fixer` | sonnet | Applies pdf-auditor findings |
| `mccloskey-fixer` | sonnet | Generates prose revision suggestions |
| `narrative-factcheck-fixer` | sonnet | Applies narrative accuracy corrections (per corrections memory) |
| `lit-review-clarifier` | sonnet→opus | Proposes structural revisions for lit review foibles, escalates R1→R2 |
| `compressor-fixer` | sonnet | Compresses prose to meet word count targets |
| `organizer` | sonnet | Reorders paragraphs, fixes section boundaries |
| `consolidator-fixer` | opus | Cherry-picks additions from source documents |
| `verifier` | sonnet | End-to-end task completion verification |

### Pipeline Agents (cheap-scan1 PDF processing + literature organization)

| Agent | Model | What it does |
|-------|-------|-------------|
| `pdf-scanner` | haiku | Classifies extracted PDF pages by content type (text/table/figure/equation/reference) — produces routing manifest |
| `pdf-text-summarizer` | haiku | Deep-reads per-section markdown files, produces structured notes for prose sections |
| `pdf-visual-analyzer` | sonnet | Extracts table data and figure descriptions from rendered PNG pages (vision required) |
| `pdf-equation-transcriber` | sonnet | Transcribes mathematical equations to LaTeX from rendered PNG pages (vision required) |
| `pdf-consolidator` | sonnet | Merges all specialist outputs into two-layer notes.md (8 main sections + 5 appendices) compatible with `/lit-organizer` |
| `literature-organizer` | sonnet | Single-pass: scores relevance (1-5), assigns inclusion tiers (A-D), identifies redundancy clusters, writes synthesized narrative by subtopic |

### Background Automation Agents (fire autonomously)

| Agent | Model | What it does |
|-------|-------|-------------|
| `stenographer` | haiku | Raw action log after every TODO completion — files, commands, pass/fail |
| `codevolution` | sonnet | Infrastructure sync — propagates new/updated agents, skills, rules to the template repo |

## Agent Model Assignment

| Model | Used For | Cost |
|-------|----------|------|
| **Opus** | Domain review, economic interpretation, research ideation, consolidation | $$$ |
| **Sonnet** | Code review, proofreading, table verification, LaTeX audit, prose editing | $$ |
| **Haiku** | File search, citation lookup, session logging, stenographer | $ |

See `.claude/rules/model-assignment.md` for the full decision matrix.

## Hooks (2)

Event-driven handlers in `.claude/hooks/` that enforce rules mechanically.

| Hook | Event | What it does |
|------|-------|-------------|
| `manuscript_protection.py` | `PreToolUse` (Edit\|Write) | Blocks edits to protected .tex files (Sections/1-6, presentation.tex). Warn-once-then-allow per session. Defense-in-depth for `manuscript-protection.md` rule. |
| `context_recovery.py` | `SessionStart` | Outputs most recent plan + session log filenames as system message. Helps Claude orient after context compression or session resume. |

Hooks are configured in `.claude/settings.json` under the `hooks` key. Add the following to your project settings:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/manuscript_protection.py",
            "timeout": 10
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/context_recovery.py",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

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
