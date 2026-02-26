---
name: visual-audit
description: Audit Beamer slides for overflow, layout, font consistency, and visual quality
disable-model-invocation: true
argument-hint: "[presentation.tex or specific section]"
allowed-tools: ["Read", "Grep", "Glob", "Bash", "Task"]
---

# Visual Audit

Perform an adversarial visual audit of Beamer presentation slides.

**Input:** `$ARGUMENTS` — path to presentation file or specific section to audit.

## Audit Checklist

### 1. Content Overflow
- [ ] No text overflowing frame boundaries
- [ ] Table `\scalebox{}` factor appropriate (0.6-0.9 for Beamer)
- [ ] No equation overflow from narrow frame width
- [ ] Bullet point lists ≤ 6 items per slide

### 2. Font & Readability
- [ ] Consistent font sizes across similar slide types
- [ ] Math mode uses serif (`\usefonttheme[onlymath]{serif}` — already set)
- [ ] No tiny text that would be illegible in a lecture hall
- [ ] Title slide has correct author, institution, date

### 3. Table Presentation
- [ ] Tables scaled appropriately with `\scalebox{}`
- [ ] Column headers visible and readable
- [ ] Significance stars (`\sym`) render correctly
- [ ] Table notes visible at bottom

### 4. Figure Quality
- [ ] PDF/PNG figures included with appropriate dimensions
- [ ] No pixelation from over-scaling
- [ ] Axis labels readable at presentation size
- [ ] Consistent color scheme across figures

### 5. Slide Flow
- [ ] Logical section progression (Motivation → Data → Methods → Results → Conclusions)
- [ ] `\pause` commands appropriate (if not in handout mode)
- [ ] Transition between sections makes sense
- [ ] Appendix slides clearly separated

### 6. Technical
- [ ] All `\input{}` paths resolve to existing files
- [ ] `\includegraphics{}` paths resolve
- [ ] No undefined `\ref{}` or `\cite{}` commands
- [ ] Compiles without errors

## Output

Severity-categorized report:
- **BLOCK**: Must fix before presenting (overflow, broken rendering)
- **FIX**: Should fix for professional quality (inconsistent fonts, missing labels)
- **NOTE**: Suggestion for improvement (reordering, adding content)

```
[SEVERITY] Slide [N] "[title]": [Issue]
  Details: [what's wrong]
  Fix: [how to fix it]
```
