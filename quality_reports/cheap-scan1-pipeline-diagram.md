# cheap-scan1 Pipeline Diagram

**Created:** 2026-02-27
**Purpose:** Visual reference for how the PDF reader works and where it fits in the writing pipeline.

---

## Part A: How `extract_pdf.py` Works (Standalone)

All of this runs **locally on your machine** — zero API tokens.

```
INPUT: academic_paper.pdf
         │
         ▼
┌─────────────────────────────────────────────────────┐
│  STAGE 0: LOCAL PYTHON EXTRACTION (pymupdf)         │
│  ─────────────────────────────────────────────────── │
│                                                     │
│  1. Open PDF with fitz (pymupdf)                    │
│  2. For each page:                                  │
│     • Extract text → string                         │
│     • Count chars, detect embedded images            │
│     • Grade quality: good / poor / ocr_needed / empty│
│  3. Check if PDF is a scan (>50% pages ocr_needed)  │
│     └─ If scan → print WARNING, recommend /split-pdf │
│  4. Write extracted_text.md (full text + page markers)│
│  5. Write metadata.json (per-page quality metrics)   │
│                                                     │
│  OUTPUT: extracted_text.md + metadata.json            │
│          (cost: $0.00)                               │
└─────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────┐
│  SECTION SPLITTING (anti-skimming failsafe)          │
│  ─────────────────────────────────────────────────── │
│                                                     │
│  1. DETECT PUBLISHER (check first ~8000 chars)       │
│     ├─ Journal override? (e.g., Southern Econ Journal)│
│     └─ Publisher fingerprint? (Wiley DOI, JSTOR footer│
│        Springer boilerplate, Elsevier, OUP, etc.)    │
│     Result: reorder regex patterns to try most-likely │
│             header format first                      │
│                                                     │
│  2. DETECT SECTION HEADERS (scan full page text)     │
│     Pattern priority:                                │
│     [0] "1. Introduction" (Arabic + title)           │
│     [1] "II. Background"  (Roman + title)            │
│     [2] "2\n|\nDATA"      (Wiley pipe + ANY CAPS)    │
│     [3] "INTRODUCTION"    (ALL CAPS standalone)      │
│     [4] "Introduction"    (Title case standalone)    │
│                                                     │
│  3. SPLIT DECISION                                   │
│     ┌─ --split-method=chunks? → 4-page chunks        │
│     ├─ ≥2 headers detected?  → split at headers      │
│     └─ <2 headers?           → fall back to chunks   │
│                                                     │
│  4. ADAPTIVE SUB-SPLITTING                           │
│     If any section > 4 pages:                        │
│        "robustness" (5pp) → robustness_pt1 + _pt2   │
│     If section ≤ 4 pages: keep as single file        │
│                                                     │
│  OUTPUT: sections/sec_01_pp01-01_front_matter.md     │
│          sections/sec_02_pp02-03_introduction.md     │
│          sections/sec_03_pp04-04_related_literature.md│
│          ... (one file per section)                  │
│          (cost: $0.00)                               │
└─────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────┐
│  PAGE RENDERING (only when requested)                │
│  ─────────────────────────────────────────────────── │
│                                                     │
│  Only renders pages flagged by the scanner agent     │
│  as needing visual analysis (tables, figures, eqns). │
│  Typically 5-8 pages out of 20-30.                   │
│                                                     │
│  OUTPUT: pages/page_09.png, page_10.png, etc.        │
│          (cost: $0.00)                               │
└─────────────────────────────────────────────────────┘
```

---

## Part A (continued): The Full cheap-scan1 Pipeline (After Extraction)

This is what happens when `/cheap-scan1` runs — extraction is Stage 0, then agents take over.

Two modes: **default** (progressive triage — may eliminate early) and **--safe** (reads everything, tags irrelevant sections).

```
                    extract_pdf.py output
                           │
    ┌──────────────────────┼──────────────────────┐
    │                      │                      │
    ▼                      ▼                      ▼
sections/*.md        metadata.json         pages/*.png
(per-section text)   (quality metrics)     (visual pages)
    │                      │
    ▼                      ▼

═══ DEFAULT MODE: Progressive Triage Funnel ═══════════

┌──────────────────────────────────────────────────────┐
│  STAGE 1a: ABSTRACT TRIAGE (~200 tokens)             │
│  Read abstract section → score 1-5                   │
│  Score 1: ██ ELIMINATE ██ (zero chance of relevance)  │
│  Score 5: PROCEED → skip to scanner                  │
│  Score 2-4: uncertain → continue to 1b               │
└──────────────────────────────────────────────────────┘
         │ (if score 2-4)
         ▼
┌──────────────────────────────────────────────────────┐
│  STAGE 1b-TRIAGE: INTRODUCTION (~600-1,200 tokens)   │
│  Read intro section(s) → re-evaluate                 │
│  Drops to 1: ██ ELIMINATE ██ (scope confirmed wrong)  │
│  Rises to 4-5: PROCEED → skip to scanner             │
│  Stays at 2-3: uncertain → continue to 1c            │
└──────────────────────────────────────────────────────┘
         │ (if score 2-3)
         ▼
┌──────────────────────────────────────────────────────┐
│  STAGE 1c: CONCLUSION — NON-LINEAR JUMP              │
│  (~800-1,600 tokens total across triage stages)       │
│  Jump to conclusion section(s) — skip middle!         │
│  Score 1-2: ██ ELIMINATE ██ (final scope decision)    │
│  Score 3-5: PROCEED → scanner                        │
└──────────────────────────────────────────────────────┘
         │ (if score 3+)
         ▼
┌──────────────────────────────────────────────────────┐
│  STAGE 1d: SELECTIVE SECTION FILTERING               │
│  (only if paper is partially relevant)                │
│  ─────────────────────────────────────────────────── │
│  Check TOC / section map from metadata.json           │
│  From abstract+intro+conclusion context:              │
│    Mark sections as RELEVANT or SKIP                  │
│  Only RELEVANT sections → text summarizer             │
│  SKIPPED sections → logged with rationale             │
│  (No TOC? → send all sections, like --safe mode)      │
└──────────────────────────────────────────────────────┘

═══ --SAFE MODE: Exhaustive + Tag ═════════════════════

  (Skips all triage stages above — sends ALL sections)
  After text summarizer: tags each section
    CORE / TANGENTIAL / OUT-OF-SCOPE
  Consolidator uses tags to trim bloat

═══════════════════════════════════════════════════════

         │ (papers that survive triage / all in --safe)
         ▼
┌──────────────────────────────────────────────────────┐
│  STAGE 1b: SCANNER AGENT (haiku, ~500-1000 tokens)   │
│  ───────────────────────────────────────────────────  │
│  Reads metadata.json + scanner_patterns.json          │
│  Pattern-matches each page for:                       │
│    tables → visual_analyzer                           │
│    figures → visual_analyzer                          │
│    equations → equation_transcriber                   │
│    references → text_only (skip vision)               │
│    prose → text_summarizer (cheapest)                 │
│                                                      │
│  OUTPUT: scan_manifest.json (routing decisions)       │
└──────────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────────┐
│  STAGE 2: PARALLEL SPECIALIST DISPATCH                │
│  ─────────────────────────────────────────────────── │
│                                                      │
│  ┌─── Text sections ─► 2a: Text Summarizer (haiku)   │
│  │    (selected or all)   Reads per-section files     │
│  │                        Produces structured notes   │
│  │                        --safe: adds CORE/TANG/OOS  │
│  │                        (~3,000-25,000 tokens)      │
│  │                                                   │
│  ├─── Table/Fig pages ► 2b: Visual Analyzer (sonnet)  │
│  │    (pages/*.png)       Reads rendered PNGs         │
│  │                        Extracts exact numbers,     │
│  │                        significance stars, SEs     │
│  │                        (~5,000-10,000 tokens)      │
│  │                                                   │
│  └─── Equation pages ─► 2c: Equation Transcriber     │
│       (pages/*.png)       (sonnet)                    │
│                           Transcribes to LaTeX        │
│                           (~2,000-5,000 tokens)       │
│                                                      │
│  All three run IN PARALLEL (independent)              │
└──────────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────────┐
│  STAGE 3: CONSOLIDATION (sonnet, ~2,000-3,000 tokens)│
│  ─────────────────────────────────────────────────── │
│  Merges text + visual + equation outputs into one     │
│  notes.md file with 8-section format:                 │
│    Research Question | Audience | Data | Findings     │
│    Contributions | Replication Feasibility             │
│    Method | Connection to Our Study                    │
│                                                      │
│  --safe mode: uses relevance tags to control depth    │
│    CORE → full treatment | TANGENTIAL → brief mention │
│    OUT-OF-SCOPE → listed as skipped with reason       │
│                                                      │
│  Also assigns:                                        │
│    Triage score (1-5) | Subtopic code | BibTeX key    │
│                                                      │
│  OUTPUT: scanned_[papername]/notes.md                  │
│          + Triage Log (sections read/skipped/saved)    │
│          (same format as /split-pdf output)            │
└──────────────────────────────────────────────────────┘

COST COMPARISON (30-page econ paper / 80-page law review):
┌────────────────┬──────────┬────────────┬────────────┐
│ Component      │ split-pdf│ default    │ --safe     │
├────────────────┼──────────┼────────────┼────────────┤
│ Reading pages  │ ~60-160k │ 0 (local)  │ 0 (local)  │
│ Triage funnel  │ 0        │ ~200-1,600 │ 0 (skip)   │
│ Scanner        │ 0        │ ~600-1,000 │ ~1,000     │
│ Text (haiku)   │ 0        │ ~4-12k     │ ~6-25k     │
│ Vision         │ 0        │ ~0-8k      │ ~0-8k      │
│ Consolidation  │ 0        │ ~2-2.5k    │ ~2.5-3k    │
│ TOTAL          │ ~60-160k │ ~12-19k    │ ~18-29k    │
│ SAVINGS vs PDF │          │ 73-92%     │ 55-82%     │
│ ELIMINATED?    │ never    │ ~200 tok   │ N/A        │
└────────────────┴──────────┴────────────┴────────────┘
```

---

## Part B: Where cheap-scan1 Fits in the Writing Pipeline

```
═══════════════════════════════════════════════════════
 PHASE 1: LITERATURE ACQUISITION
═══════════════════════════════════════════════════════

  Source PDFs ($PAPERS/Prosecutors/*.pdf)
       │
       ├──── /cheap-scan1 ◄──── DEFAULT (text-extractable PDFs)
       │     (local extraction + multi-agent pipeline)
       │     Output: articles/scanned_*/notes.md
       │
       ├──── /split-pdf ◄────── FALLBACK (scanned PDFs, OCR needed)
       │     (4-page image chunks to Claude)
       │     Output: articles/split_*/notes.md
       │
       └──── /lit-review ◄───── DISCOVERY (when you don't have the PDF)
             (web search + Consensus API)
             Output: quality_reports/lit_review_*.md


═══════════════════════════════════════════════════════
 PHASE 2: LITERATURE ORGANIZATION
═══════════════════════════════════════════════════════

  All notes.md files (from both cheap-scan1 + split-pdf)
       │
       ▼
  /lit-filter ─────────── Tier A/B/C/D assignment
  (sonnet)                Redundancy clusters
       │                  Shortened summaries
       ▼                  Output: articles/literature_filter_report.md
       │
  /lit-synthesizer ────── Relevance ratings (1-5)
  (sonnet)                Subtopic grouping
                          Gap analysis
                          Output: docs/literature_synthesis.md
                                  → feeds into 85_literature_sources.qmd


═══════════════════════════════════════════════════════
 PHASE 3: DRAFTING
═══════════════════════════════════════════════════════

  85_literature_sources.qmd (+ other QMD chapters)
       │
       ▼
  [USER WRITES DRAFT] ◄── Claude's Quarto chapters = raw material
       │                    User writes prose themselves
       ▼
  /draft-slop-fixer ────── Stage 1 cleanup
  (no agents)              Resolve TODOs, fill citation gaps
       │                   Reword copy-paste in author voice
       ▼
  /consolidate ──────────── Cherry-pick missing content
  (opus fixer +             Adversarial: fixer argues FOR inclusion
   sonnet critic)           Critic evaluates, max 2 rounds
       │                    *** BOTTLENECK: nothing proceeds until done ***
       ▼


═══════════════════════════════════════════════════════
 PHASE 4: PROSE QUALITY & REVIEW
═══════════════════════════════════════════════════════

  Cleaned draft (QMD)
       │
       ├──── /proofread ─────────── Grammar, typos, formatting
       │     (sonnet)                Run FIRST (mechanical cleanup)
       │
       ├──── /review-paper ──────── Referee-style review
       │     (opus)                  Identification, econometrics, gaps
       │                             Run on near-complete drafts
       │
       └──── /mccloskey-prose-edit ─ Writing quality audit
             (sonnet critic+fixer)   21 McCloskey rules
                                     Suggestions → 86_prose_revisions.qmd
                                     (NEVER writes to Overleaf directly)


═══════════════════════════════════════════════════════
 PHASE 5: PAPER ASSEMBLY
═══════════════════════════════════════════════════════

  Polished QMD draft + prose revision suggestions
       │
       ▼
  /condense-to-overleaf ── Quarto → LaTeX conversion
  (opus)                    Pedagogical → argumentative restructuring
       │                    Verifies all citations in .bib
       ▼
  Overleaf Sections/*.tex
       │
       ├──── /validate-bib ────────── Citation cross-reference
       │     (haiku)
       │
       ├──── /overleaf-check ──────── Structural validation
       │     (tools-based)             \ref ↔ \label, \input paths,
       │                               brace matching, key format
       │
       └──── /compile-latex ───────── Local pdflatex verification
             (tools-based)             Log file error parsing


═══════════════════════════════════════════════════════
 PHASE 6: INTEGRITY AUDIT
═══════════════════════════════════════════════════════

  After any Overleaf modifications:
       │
       ▼
  /own-writing-check ──── Did Claude write prose it shouldn't have?
  (sonnet)                 Audits each .tex change against user requests
                           PERMITTED: mechanical fixes (keys, syntax)
                           VIOLATION: substantive prose without instruction


═══════════════════════════════════════════════════════
 CROSS-CUTTING: SESSION LOGGING
═══════════════════════════════════════════════════════

  Every phase logs to:
    • quality_reports/session_logs/YYYY-MM-DD_description.md
    • Backmatter chapters 91-95 (reviewer-facing audit trail)
    • MEMORY.md for [LEARN] entries that persist across sessions
```

---

## Key Decision Points

| Question | Answer |
|----------|--------|
| Which PDF reader to use? | cheap-scan1 if text-extractable; split-pdf if scanned |
| Default or --safe mode? | Default for batch processing with clear scope; --safe for borderline papers or unfamiliar subfields |
| Headers or chunks? | `--split-method=auto` tries headers first, falls back to chunks |
| Which model for text? | haiku (cheapest) — prose pages don't need vision |
| Which model for tables? | sonnet (needs vision to read table layout) |
| When is a paper eliminated? | Only in default mode, only for scope reasons (not quality), only after abstract/intro/conclusion triage |
| Can I override an elimination? | Yes — re-run with `--safe` to force exhaustive reading |
| When does the user write? | After Phase 2 (lit organized) and before Phase 4 (quality review) |
| Who writes to Overleaf? | USER writes prose. Claude does mechanical fixes only. |
