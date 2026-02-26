# Study Parameters

Reference data for this study. Loaded when working on code, regressions, tables, or paper content.

## Treatment Variables
| Tier | Variable | Definition |
|------|----------|-----------|
| T1 | `{{treatment_var}}` | {{definition}} |
| T2 | `{{mechanism_var}}` | {{definition}} |

## Headline Results
| Outcome | Treatment | Effect | p-value |
|---------|-----------|--------|---------|
| {{outcome}} | {{treatment}} | {{effect size}} | {{p-value}} |

## Panel Variants
| Panel | Description | Units | Obs |
|-------|-------------|-------|-----|
| {{A}} | {{description}} | {{N}} | {{obs}} |

## Non-Negotiables (Methodology)
- **{{Cluster-level}} SEs** on all regressions ({{N}} clusters)
- **{{Exclusion}}** always excluded from analysis
- **BibTeX key format**: `authorYYYYdescriptor`
- Fixed effects: {{unit}} + year in all specifications
- Panel {{X}} is the primary specification
