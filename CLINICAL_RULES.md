# FreqFit clinical observations — rules 1.0.0

This is an **unvalidated clinician-support prototype**, not a diagnostic, triage, treatment, or referral system. The engine describes externally supplied adult air-conduction thresholds. Its deterministic output does not establish that an audiogram was obtained reliably. User confirmations are attestations, not equipment verification.

## Input contract

The clinical-review screen accepts **unquoted numeric CSV**, pasted as text:

```csv
frequency_hz,left_dbhl,right_dbhl
250,15,10
500,20,15
1000,30,20
2000,40,25
4000,55,30
8000,60,35
```

These are synthetic demonstration values, not a patient's measurements. The example does not confirm calibration or reliability for the user.

Allowed frequencies: 125, 250, 500, 750, 1000, 1500, 2000, 3000, 4000, 6000, 8000 Hz. Values must be finite whole numbers from −10 to 120 dB HL. These are software input bounds, not claims about device capabilities or clinically obtainable thresholds. Duplicate rows, ambiguous units, invalid numbers, and unsupported frequencies are rejected instead of corrected silently. The core engine independently validates values, even if the CSV parser is bypassed.

Blank fields are missing values. A no-response result is a censored measurement, not a threshold at the equipment output limit. `NR` is rejected with instructions to leave it blank. This version does not preserve no-response limits separately, so it must not be used when censored-response interpretation is required. No missing data are interpolated.

## Rule registry

| ID | Calculation or condition | Output and limits |
| --- | --- | --- |
| G01 | Unit is not explicitly dB HL | Block clinical observations. No dBFS/dB SPL conversion. |
| G02 | Calibrated source not confirmed | Block clinical observations. |
| G03 | Clinician review of reliability not confirmed | Block clinical observations. Reliability includes method, environment and masking as indicated. |
| G04 | Age outside 18–120 | Block clinical observations. No pediatric interpretation. |
| G05 | Empty measurement/equipment source | Block clinical observations. |
| G06 | No numeric measurements in either ear | Block clinical observations. |
| G07 | Invalid frequency or numeric value | Block clinical observations. |
| Q01 | Missing any of 250/500/1000/2000/4000/8000 Hz, separately per ear | Report gaps; describe only available values. This core set is an app completeness convention, not a claim of complete clinical assessment. |
| Q02 | Missing paired values at 500/1000/2000/4000/8000 Hz | Disclose incomplete ear comparison. |
| D01 | Apply ASHA/Clark bands separately to each individual threshold | Descriptive frequency-specific bands, not an overall diagnosis. |
| D02 | Arithmetic mean of 500/1000/2000 Hz, separately per ear | Numerical PTA3 to one decimal. All three are required. No severity classification of the average. This is the app's explicitly chosen averaging convention. |
| D03 | Left threshold minus right threshold at each available paired frequency | Signed differences; positive means a higher recorded left threshold. No referral or symmetry classification. |
| H01 | Mean(4000,8000) − mean(250,500), per ear | Requires all four points. Absolute difference ≥20 dB triggers a descriptive higher/lower high-frequency flag. **Unvalidated app heuristic**, not a published diagnostic cutoff. A non-trigger does not establish a flat configuration or exclude loss. |
| L01 | Air-conduction-only input | Explicitly withhold hearing-loss type and cause. |

All gates are checked before any D/H calculations. A report can show multiple gate failures, but never a clinical finding alongside a gate failure. Partial valid data can produce partial observations; missing evidence is disclosed.

### D01 individual-threshold bands

| Threshold (dB HL) | Band |
| --- | --- |
| −10 through 15 | Normal range |
| 16 through 25 | Slight |
| 26 through 40 | Mild |
| 41 through 55 | Moderate |
| 56 through 70 | Moderately severe |
| 71 through 90 | Severe |
| 91 or above | Profound |

Source: [ASHA Hearing Loss in Adults](https://www.asha.org/practice-portal/clinical-topics/hearing-loss/), which attributes this classification to Clark (1981). Only whole-number inputs are accepted, avoiding unspecified fractional band boundaries. A threshold in the normal range does not rule out hearing difficulty or other pathology.

## Clinical scope

ASHA describes diagnosis as interpretation of a test battery in the context of history, potentially including otoscopy, bone conduction, masking, speech audiometry, immittance, and other assessments. This engine has none of that clinical context. It must not label conductive, sensorineural, or mixed loss, infer a disease from the curve, recommend treatment, or return “no referral needed.” [ASHA assessment guidance](https://www.asha.org/practice-portal/clinical-topics/hearing-loss/).

We intentionally do not automate the NICE asymmetry/MRI recommendation: it applies in a particular clinical context, including sensorineural loss, that this input does not establish. Numeric ear differences alone do not satisfy those prerequisites. [NICE NG98 recommendations](https://www.nice.org.uk/guidance/ng98/chapter/recommendations).

## UI, privacy and export

Open **Checks → Review a calibrated audiogram**. The normal listening session flow and its dBFS history cannot feed clinical classification. Calibration and reliability confirmations default to off, including after loading the synthetic CSV. Any input edit invalidates the previous report. Reports display source, age, rule IDs, evidence, explanation, and provenance. The graph uses a dB HL axis increasing downwards; a numeric table accompanies it. Points are unconnected to avoid implying interpolated thresholds.

Clinical inputs/reports are held in memory on that screen, are not uploaded, and are not added to local session history. Copying the report is explicit and includes the measurement-source reference, age, attestations, rules version, evidence, limitations and sources. Use de-identified references. Leaving the screen loses the review; copy it first if needed. The existing local history remains solely for exploratory listening sessions.

## Validation and next steps

Automated checks exercise unit/provenance gates, age limits, all D01 boundaries, invalid/non-finite values, exact PTA prerequisites, missing ears/pairs, H01's boundary/direction, immutable input snapshots, deterministic reports, strict CSV parsing, mobile layout/navigation and invalidation after edits. These prove implementation behavior, **not clinical validity**.

Before clinical deployment: obtain audiologist review of every rule and workflow, define the intended clinical use, preserve no-response and masking metadata, validate against independent representative audiograms, assess human factors and false reassurance, and address applicable clinical software requirements. Record rule changes with version updates and regression fixtures. No ML model or training data is involved.
