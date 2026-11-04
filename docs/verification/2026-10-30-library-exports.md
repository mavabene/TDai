# Library source extraction for the stable-release diagram workflow

October 30, 2026. Owner authorized exporting local TD3 and motor3 libraries to
close source-coverage gaps; the diagram update itself remains unexecuted.

## Identity and coverage

The owner identifies the supplied PLC/HMI 511_prod pair as the last stable release.
Both active application version declarations are 5.1.1. External inputs remain at:

- `C:/Users/jcheney/Documents/TD3/Ojjo_TD3-1/Production/TD3-Auto/exports_ojjo_TD3_cr711S_511_prod.zip`
  SHA-256 `de4e874bceb11f525ad1671e74f444b75fb1008cb25b881c8beee57836baa1cd`.
- `C:/Users/jcheney/Documents/TD3/Ojjo_TD3-1/Production/TD3-HMI/exports_ojjo_TD3_cr1203_511_prod.zip`
  SHA-256 `670b211511d5104c7eb23e142309f6e898374daf61a05da42f634a1d186d627b`.

The PLC StandardPLC Library Manager names TD3-1 Framework 3.1.0.10 (Ojjo).
Its matching local library's Library Manager names Motor3-1 control 3.1.0.4
(Ojjo). Internal project identities confirm these titles, versions, and company.
These are matching source candidates by identity, not proof of the binary used
in a particular controller build.

| Local input | SHA-256 | Preserved readable output | Files |
| --- | --- | --- | ---: |
| `Library/td3_31010.library` | `3a4907dcb9a4f1eb81af457e34e70f1d3fdb0ae9ac8843a382a461b74989b394` | [TD3 source](../../Library/exports/exports_td3_31010/) | 75 |
| `Library/motor3_3104.library` | `52858f6d18a1c07236f603f11a96440e45bb00064e9fb48594f8d3227b356180` | [motor3 source](../../Library/exports/exports_motor3_3104/) | 64 |

The HMI Library Manager names TD3-1 Framework **3.1.1.9**. No inspected local
candidate has that internal version. `td3_3109.library` is **3.1.0.9**, not a match.
`td3_3102.library` is 3.1.1.0, illustrating why filenames are insufficient.
Do not substitute another framework for the HMI's missing exact source.

## Extraction and validation

A separate hidden CODESYS V3.5 SP21 Patch 1 process ran
[run_library_exports.py](../../tools/run_library_exports.py) with the existing
text exporter. It deduplicated local TD3/motor3 candidates by SHA-256, opened
scratch copies with NoUpdates, read internal identities, exported, and closed
without saving originals. All 19 distinct candidates exported successfully;
all source hashes remained unchanged. The two matching output trees above were
copied to maintained paths and compared byte-for-byte with scratch output.
Other candidate exports remain ignored scratch evidence.

[Manifest](2026-10-30-library-export-manifest.json) records all identities, hashes,
counts and outcomes. Scratch run: `.export-work/libraries-2lswj7`.
The startup AP Installer logger reported access denied, but the same process
continued and emitted LIBRARY_ALL_FINISHED and successful per-library results.
No retry, installation, library resolution repair, compilation, or online action
was performed. No diagram was generated.

Unknown object inventories include Project Settings, Project information and
GlobalImagePool. Generated project-information POUs and separately queried
identity support matching; this custom exporter does not capture every project
setting or image. File counts and extraction success do not prove build success
or complete semantic coverage.

## Information now available to the diagram review

TD3 `Data types/eTrackStates.dut`, `eRWPStates.dut`, `eScrewStates.dut` and
`POUs/StateLogic/OperatorState.pou` supply the missing enum and shared operator
logic. OperatorState includes pause handling, automatic/manual/bump selection,
first-call handling, E-stop mode selection, load/unload-only behavior, and a
500 ms no-touch mode-change delay. Trace actual callers and output gating before
describing the effect on motion; these observations alone are not a safety claim.

motor3 supplies axis/control data types, profiling/loop and settling helpers,
hard-stop helpers, and `POUs/Utility/HaweOutput.pou`, which writes the signed valve
command. This closes the earlier blanket statement that those library internals
were unavailable for this release; the end-to-end actuator review is still pending.

Next unresolved action: obtain matching HMI framework 3.1.1.9 source if its behavior
is needed to complete diagram coverage. Available PLC/framework/motor3 source can
support the initial pilot when the owner invokes the diagram update.
