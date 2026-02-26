---
name: build-slides
description: Create or update Beamer presentation slides from paper content and tables
disable-model-invocation: true
argument-hint: "[section to add/update, or 'full' for complete rebuild]"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Edit", "Task"]
---

# Build Slides

Create or update Beamer presentation slides at `$OL/presentation.tex`.

**Input:** `$ARGUMENTS` — section name (e.g., "motivation", "results") or "full" for all.

## Architecture

The presentation lives alongside the paper in the same Overleaf project:
- **File:** `presentation.tex` (standalone Beamer document)
- **Tables:** Same `files/tab/` directory as the paper; use `\input{files/tab/...}` with `\scalebox{}`
- **Figures:** Same `files/fig/` directory; use `\includegraphics{}`
- **Style:** Default Beamer theme, miniframes header, custom footer (author/title/page)

## Current State
- Title page: {{paper title}} ({{author}}, {{institution}})
- Sections stubbed: Motivation, Data, Empirical Approach, Results, Conclusions, Appendix
- Citations: natbib/biblatex NOT currently active (commented out) — add if needed

## Slide Design Rules
- Max 5-6 bullet points per slide
- One key message per slide
- Tables via `\scalebox{0.7-0.9}{\input{files/tab/...}}` — test readability
- Keep text large (Beamer default is fine)
- Use `\pause` for sequential reveals (currently in handout mode which disables pauses)
- Appendix slides for robustness/mechanism details

## Suggested Structure (for conference talk ~20 min)

1. **Title** (1 slide)
2. **Motivation** (2-3 slides) — research gap, why this matters
3. **This Paper** (1 slide) — research question, data, preview of findings
4. **Institutional Background** (1-2 slides) — setting, data sources
5. **Data** (1-2 slides) — panel structure, treatment definitions
6. **Empirical Approach** (1 slide) — model equation, identification
7. **Main Results** (2-3 slides) — key tables with interpretation
8. **Robustness** (1 slide) — summary or key robustness table
9. **Conclusions** (1-2 slides)
10. **Appendix** (backup slides as needed)

## Steps

1. Read current `presentation.tex`
2. Read relevant paper Sections/ for content to adapt
3. Read relevant Quarto chapters for detailed content
4. Update/add slides for requested section
5. Verify all `\input{}` paths exist
6. Check for LaTeX syntax issues
