---
name: section-writing-review
description: Run pedagogical compliance audit on any paper section (intro, data, methods, results, conclusion). Generic inquisitor scores against section-specific rubric, clarifier proposes structural revisions, inquisitor re-grades. Output to QMD.
disable-model-invocation: true
argument-hint: "<section> [file path] — e.g., 'data 3-data.tex' or 'results results_draft1.qmd'"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Task", "Edit"]
---

# Section Writing Review

Run a pedagogical compliance audit on any paper section. Uses the adversarial inquisitor→clarifier→inquisitor pattern with the generic `section-inquisitor` and `section-clarifier` agents, loading the appropriate section-specific rubric.

For the **literature review / background** section, use `/lit-writing-review` instead if you have dedicated lit-review agents.

## Arguments

- `<section>` — one of: `intro`, `data`, `methods`, `results`, `conclusion`
- `[file path]` — path to the file containing the section
  - QMD files: `results_draft1.qmd`, etc.
  - Overleaf files: `3-data.tex` (READ-ONLY — output goes to QMD)
- If no file path given, search for the most recent QMD or .tex file for that section

## Rubric Mapping

| Section Argument | Rubric File | Adjacent Sections for Cross-Check |
|-----------------|-------------|-----------------------------------|
| `intro` | `rubric_introduction_section.md` | methods (RQ→spec), results (preview→findings) |
| `data` | `rubric_data_section.md` | methods (variables→equation), results (units consistency) |
| `methods` | `rubric_methods_section.md` | data (variables defined), results (spec matches) |
| `results` | `rubric_results_section.md` | methods (spec promised), conclusion (summary accuracy), intro (preview) |
| `conclusion` | `rubric_conclusion_section.md` | results (no inflation), intro (contributions match) |

**Rubric location:** `$RB/quality_reports/writing_rubrics/` (or wherever your project stores rubric files)

## Workflow

### Step 1: Load Inputs

```
Read [target file]                                                      # Section text
Read [rubric directory]/rubric_[section]_section.md                     # Section rubric
Read .claude/agents/section-inquisitor.md                               # Agent instructions
Read .claude/agents/section-clarifier.md                                # Agent instructions
```

### Step 2: Spawn Inquisitor (Round 1 — haiku)

```python
Task(
    subagent_type="general-purpose",
    model="haiku",
    prompt="""You are the Section Inquisitor agent.
    [Include full agent instructions from section-inquisitor.md]

    SECTION TYPE: [intro/data/methods/results/conclusion]

    RUBRIC:
    [Include the section-specific rubric content]

    SECTION TEXT:
    [Include the section text]

    This is ROUND 1. No adjacent sections for cross-checks.
    Produce a SECTION COMPLIANCE AUDIT with score and foible list."""
)
```

**Early exit:** If score >= 95, write a brief "passing" note and skip the clarifier.

### Step 3: Spawn Clarifier (Round 1 — sonnet)

```python
Task(
    subagent_type="general-purpose",
    model="sonnet",
    prompt="""You are the Section Clarifier agent.
    [Include full agent instructions from section-clarifier.md]

    SECTION TYPE: [intro/data/methods/results/conclusion]

    RUBRIC:
    [Include rubric content]

    INQUISITOR'S FOIBLE REPORT:
    [Include inquisitor output from Step 2]

    ORIGINAL SECTION TEXT:
    [Include the section text]

    Generate SUGGESTED REVISIONS for every foible. Source each revision."""
)
```

### Step 4: Re-Spawn Inquisitor (Round 2 — sonnet)

```python
Task(
    subagent_type="general-purpose",
    model="sonnet",
    prompt="""You are the Section Inquisitor agent performing a RE-GRADE.
    [Include inquisitor instructions]

    This is ROUND 2. Upgraded context with adjacent sections.

    SECTION TYPE: [section]
    RUBRIC: [rubric]
    ORIGINAL TEXT: [section text]
    ADJACENT SECTIONS: [load per rubric mapping table above]
    CLARIFIER'S SUGGESTED REVISIONS: [clarifier output from Step 3]

    Evaluate each suggestion AS IF applied.
    APPROVED (resolves foible) or REJECTED (doesn't help or introduces new issue).
    Auto-REJECT unsourced corrections.
    Apply curve if score < 95 (exponent base 0.9)."""
)
```

**If score >= 95:** Go to Step 6.
**If score < 95:** Proceed to Step 5.

### Step 5: Clarifier Round 2 (if needed — opus)

```python
Task(
    subagent_type="general-purpose",
    model="opus",
    prompt="""You are the Section Clarifier agent, ROUND 2.
    [Include clarifier instructions]

    Refine ONLY the REJECTED suggestions. Keep APPROVED as-is.
    All revisions must be SOURCED."""
)
```

Final inquisitor scoring (sonnet). Take highest-scoring round. **Cap at 2 rounds.**

### Step 6: Write Results

Write to: `$RB/quality_reports/drafts/section_revisions/[section]_writing_review.md`

Format:
- Audit metadata (source file, score progression, foible counts)
- Quick scan results
- Per-foible problem + approved revision
- Competing advice encountered
- Cross-section flags
- Full scoring detail

### Step 7: Log

Append to session log:
```
[writing] [Section Name]: scored [X]/100 → [Y]/100, [N] foibles. Revisions to section_revisions/[section]_writing_review.md
```

## Cost Profile

| Scenario | Calls | Models |
|----------|-------|--------|
| Best case (passes Round 1) | 1 | haiku |
| Typical (Round 1 fails, Round 2 passes) | 3 | haiku + sonnet + sonnet |
| Worst case (both rounds fail) | 5 | haiku + sonnet + sonnet + opus + sonnet |

## Prerequisites

This skill requires section-specific rubric files. Build these from your paper-writing guide sources before using this skill. Each rubric should contain:
- Scoring protocol (escalating penalty formula)
- Conceptual frameworks
- Foible categories with DO/DON'T guidance
- Competing advice summary
- Quick reference table

Sources that work well for rubric construction:
- Bellemare (2020) "How to Paper" — most comprehensive per-section guidance
- Nikolov (2022) IZA DP 15057 — strong on results, data, lit review
- Paper Crafting Guide (Head, McCloskey, et al.) — broad coverage
- Weisbach (2021) "The Economist's Craft" — results and prose

## Key Constraints

- **Manuscript protection applies.** Reads Overleaf files, never writes to them.
- **Cost cap:** Maximum 2 rounds. ~3-5 calls per audit.
- **Separate from McCloskey.** This handles structural compliance; prose quality is a separate pass.
- **Source verification required.** Inquisitor auto-rejects unsourced clarifier suggestions.

## Example Invocations

```
/section-writing-review data 3-data.tex
/section-writing-review methods methods_draft1.qmd
/section-writing-review results 5-results.tex
/section-writing-review conclusion 6-conclusion.tex
/section-writing-review intro 1-introduction.tex
```
