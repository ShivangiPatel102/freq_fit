# Rebuild notes

## What the original project was

FreqFit was a hackathon prototype for portable pure tone audiometry using Flutter, Firebase authentication, Riverpod, an Android-oriented tone generator, and Syncfusion charts. Its intended audience was medical personnel and outreach settings. The README described a low-cost alternative to expensive audiometers and proposed speech/bone-conduction testing and patient management.

## Gaps found in the source

| Area | Original gap | Rebuild response |
| --- | --- | --- |
| Navigation | Trial, tutorials, and history tiles had empty callbacks; history was a placeholder. | Every workspace destination has a working flow. |
| Results | Both audio-provider setters assigned arguments to themselves. Records were also mutated directly. | Session snapshots are saved and restored through one storage service. |
| Identity | Intake text fields did not feed a session; chart identity was hardcoded to “Patient 1”. | A validated session label follows the response data and notes. |
| Audio | Linear `volume / 100` was labelled dB; balance state and selected-ear UI disagreed. | Logarithmic digital amplitude and explicitly isolated left/right PCM channels. |
| Lifecycle | No audio disposal; subscriptions could outlive a screen; play button changes were not consistently rebuilt. | Short pulses, explicit stop/disposal, lifecycle pause handling, and stale playback guards. |
| Playback validity | Settings could be changed and saved without confirming a tone at that setting. | Recording requires a completed pulse at the selected ear/frequency/level. |
| Startup | Firebase initialization was mandatory, with no startup error recovery. | Local storage startup and an explicit failure state. |
| UX | Duplicate home screens, rigid Spacer/Expanded layouts, sparse guidance, debug banner. | Responsive layout, coherent typography, preparation, practice, review, empty/error states. |
| Verification | Only the stock counter test, unrelated to the app. | Session, waveform, mobile/desktop, and complete-flow tests. |
| Web | Old loader/bootstrap and platform-specific audio assumptions. | Current Flutter bootstrap and cross-platform WAV playback. |

## Product choices

This rebuild makes the project runnable as a local personal exploration tool. It deliberately replaces the old account gate rather than depending on an unknown hackathon Firebase deployment. It does not add a simulated clinical diagnosis or pretend a digital-volume slider is a calibrated audiometer. No sample patient data or fake history is seeded.

## Remaining work, in priority order

1. **If clinical screening is the goal:** work with an audiologist on a defined protocol, device/headphone calibration, output verification, ambient noise requirements, masking, and validation. The current app is not suitable for clinical decisions.
2. **Native readiness:** modernize the old Android Gradle/Kotlin shell, confirm platform minimum versions, test audio interruption/routing on real Android/iOS hardware, configure release signing and app identity, and check desktop platform setup. Only web has been built here. Full Xcode is not installed on the development host, so Apple native builds could not be verified.
3. **Durable records:** export/import with structured schema validation, optional secure backup, and a storage layer appropriate for the data volume. Preferences are a lightweight prototype store.
4. **If returning to clinician workflows:** explicit patient consent, secure patient identifiers, role-based access, encrypted storage, retention controls, and an authenticated backend. The local rebuild does not migrate legacy Firebase data.
5. **Longitudinal interpretation:** record equipment and environmental metadata before offering cross-session comparisons. Different hardware/settings make raw levels incomparable.
6. **Accessibility validation:** keyboard, screen reader, large-text, and hearing-impaired usability studies. A text response table accompanies the chart; assistive-technology testing remains to be done.
7. **Larger scope:** speech and bone-conduction assessments require their own hardware/protocol decisions; an AI assistant would not fix the measurement gaps above.
