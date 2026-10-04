# Development checkpoint — 2026-10-04

## Stable verified boundary

The verified cutoff is U1/U2 and U3a/U3b at `14e4599`, following baseline main `691b915`. Routine and guide browsing remain the app UI. The session domain and durable persistence adapter expose their documented APIs but are not composed into session UI. U3b's full test result (43 passed) and build success are historical evidence; neither was rerun for this cutoff.

The U3b record retains its test-first sequencing deviation: a postimplementation no-op sensitivity check failed four of thirteen tests, but that is not a preimplementation RED. Do not rewrite it as strict RED/GREEN evidence.

## U4a status

U4a is paused and incomplete on `feat/first-useful-release`. It is unverified and not ready for acceptance or normal use. Today's genuine initial RED was one failed assertion. Four later startup failures were diagnosed as a missing Swift `DEBUG` compilation condition; project Debug was corrected, compiler `-DDEBUG` was confirmed, and Release remained unchanged. The final build succeeded, but the test runner failed to communicate before running tests. A physical-device passcode requirement and network/TCP transport were observed afterward; neither establishes the cause of the failed run. There is no U4a GREEN, unit/regression/navigation/UI pass, standalone-build evidence, or VoiceOver verification.

No further device tests or development were authorized today. The owner authorized publishing the verified stable-main cutoff and retaining the separate feature branch as WIP on 2026-10-04. Publication does not establish app acceptance or authorize distribution or additional feature work.

## Delivery boundary

Main integrates verified source through `14e4599` and the main-safe documentation commit `50900e6`; it excludes the partial U4a interface. The source WIP is archived at `c574d2b` on `feat/first-useful-release`; the published documentation correction `0a28397` supplies its feature-only session-flow record. Resume from that branch, not by merging its unverified interface into main. Remote synchronization is checked separately from functional acceptance; no device tests were rerun for this delivery.

## Safety and next evidence

Do not treat U4a as complete or safe for acceptance. No production-data reset or deletion path is authorized. Preserve its WIP separately from the stable cutoff. A later explicitly authorized work unit must establish focused behavior and UI test results before any U4a acceptance claim; device and accessibility checks remain outstanding.
