# FreqFit

A small, thoughtful Flutter workspace for exploring responses to sound. Rebuilt from the original hackathon app on `codex/freqfit-rebuild`.

## Run

Use Flutter 3.47.8 / Dart 3.13.7, the versions verified for this rebuild. The checked-in dependency lock targets Flutter 3.47+ and Dart 3.13+.

```sh
flutter pub get
flutter run -d chrome
```

No Firebase project, account, API key, or backend setup is needed. The web app is the verified target for this rebuild; the native platform shells remain in the repository and need separate device testing and toolchain updates before distribution.

```sh
flutter analyze
flutter test
flutter build web
```

## What you can do

- Use a responsive desktop workspace or compact bottom navigation.
- Read preparation guidance and try a practice tone without saving a session.
- Create a named check after confirming headphones, surroundings, and measurement limitations.
- Play one-second, stereo-isolated tones at 250, 500, 1,000, 2,000, 4,000, and 8,000 Hz.
- Adjust digital amplitude from −60 to −12 dBFS in 3 dB steps. Each pulse has a 20 ms fade at both ends.
- Record a response only after playing a tone at the current setting. Changing ear, frequency, or level resets that requirement.
- Review each ear on a response-level plot, add notes, and save locally.
- Search history, reopen sessions, copy a plain-text/CSV-style report, or delete after confirmation.
- Save a partial session after recording at least one response; it is explicitly marked as partial.

## Clinical observations engine

Open **Checks → Review a calibrated audiogram** for a separate adult clinician-support prototype. Paste numeric CSV from external calibrated dB HL air-conduction measurements, enter an age and source reference, and confirm calibration/reliability. It reports individual-threshold bands, PTA3, ear differences, low/high comparison heuristics, missing evidence, and explicit interpretation limits. Every observation has a rule ID and evidence. Clinical reports can be copied but are not stored in listening-session history. Editing any input invalidates the report.

The engine refuses clinical calculations on dBFS/unknown units or failed provenance gates. It is not clinically validated and does not diagnose disease, hearing-loss type, or referral need. See [CLINICAL_RULES.md](CLINICAL_RULES.md) for the complete rule registry, sources, input contract and limitations.

## Measurement boundaries

This app is an **uncalibrated listening exploration**, not a medical audiometer. dBFS measures relative digital amplitude; it does not measure dB HL or dB SPL. Device volume, headphone sensitivity, signal processing, and ambient sound all influence what is heard. FreqFit does not diagnose or classify hearing loss, automatically determine clinical thresholds, or claim clinical accuracy. Physical sound output has not been measured.

Preparation and follow-up copy is informed by [ASHA adult hearing screening guidance](https://www.asha.org/practice-portal/professional-issues/adult-hearing-screening/) and [NIDCD sudden hearing loss guidance](https://www.nidcd.nih.gov/health/sudden-deafness). Clinical use would require calibrated transducers and equipment, validated protocols, and professional review.

## Storage and privacy

Sessions are JSON in `shared_preferences` under `freqfit.sessions.v2`. There is no cloud sync or analytics. Use a nickname/session label rather than identifying patient information. Local preferences are **not encrypted clinical storage**, and clearing browser/app data removes history. Clipboard reports are user initiated and contain the entered session name and notes. Corrupt stored history is preserved and surfaced as an error rather than overwritten.

The old Firebase-backed login and provider implementation have been replaced. Existing Firebase accounts and cloud records are not migrated or accessed. The original implementation remains in Git history on `main`.

## Structure

- `lib/core/session.dart`: session model, local persistence, and date formatting.
- `lib/core/clinical_rules.dart`: clinical input contract, strict CSV parser, versioned deterministic observations.
- `lib/ui/clinical_review.dart`: calibrated-audiogram entry, provenance gates, report, dB HL plot and text table.
- `lib/core/tone.dart`: stereo PCM WAV synthesis and audio player lifecycle.
- `lib/ui/workspace.dart`: overview, checks, searchable history, reports, and guide.
- `lib/ui/check_screen.dart`: preparation, listening, review, and save flow.
- `lib/ui/components.dart`: visual primitives, waveform illustration, and response chart.

## Verification

Tests cover desktop/mobile navigation and layout, the complete 12-response flow using an injected audio fake, local persistence/reload/deletion, corrupt storage protection, and generated WAV channel isolation/amplitude/fades. Audio unit tests verify the generated samples; they do not validate acoustic output through hardware. Browser visual checks cover the rendered app. Native device builds and clinical validation remain outstanding.

See [REBUILD_NOTES.md](REBUILD_NOTES.md) for the audit and remaining product work.
