# Source baseline

Established October 27, 2026. This record identifies review inputs and navigation
keys. The [architecture](ARCHITECTURE.md) owns observed execution details; the
[assessment](ASSESSMENT-2026-10-27.md) owns dated findings.

## Identity and provenance

Workspace root: `C:/Users/jcheney/Documents/Codex/TD3ai`.

The user supplied current development exports named `530v1`. Use this pair for
this assessment and future work until a task selects a different baseline. Their
relationship to a deployed rig, production release, and adjacent `.project`
binaries is not independently verified.

| ID | Workspace input | Size | SHA-256 |
| --- | --- | ---: | --- |
| PLC-530 | [PLC archive](../Production_dev/TD3-Auto/exports_ojjo_TD3_cr711S_530v1.zip) | 517681 bytes | `a6a5631cf65a7353bffe910c6bf18b8044e5a59df4071fb1e249fc62888f8ea5` |
| HMI-530 | [HMI archive](../Production_dev/TD3-HMI/exports_ojjo_TD3_cr1203_530v1.zip) | 276031 bytes | `3d23432e7fb07d3079c295c0a35548edecdf9fa5c699348e04b7c6db6a711cb5` |
| GEO-06 | [Machine context, revision 0.6](../AI%20info/ET_Plumb_Machine_Context.txt) | See original file | `8053c2086e2be226f4fd7df64fc2bef8f28a05124baec51fad9c1e882d79f28b` |
| REF-AD | [Coworker AD/Bravo guidelines](../AI%20info/reference-guidelines/AD-Bravo-guidelines.reference.md) | 12593 bytes | `df21c897834d3706361e48907a7ead6ac98b277f6c8b0c244d5ffe77b1caefe0` |
| REF-POLARIS | [Coworker Polaris guidelines](../AI%20info/reference-guidelines/Polaris-guidelines.reference.md) | 23467 bytes | `5ac1a0d0251dfe03a22cc990dd3d64f359d30e32599747413b362b08704ceab8` |

The workspace archives match, byte for byte by hash, the user-named files under
`C:/Users/jcheney/Documents/TD3/Ojjo_TD3-1/Production_dev/TD3-Auto/` and
`.../TD3-HMI/`. GEO-06 matches
`C:/Users/jcheney/Downloads/ET_Plumb_Machine_Context (2).txt`.
REF-AD is an unchanged copy of Downloads `AGENTS.md`; REF-POLARIS is an unchanged
copy of Downloads `AGENTS 1.md`. The reference copies are deliberately not named
`AGENTS.md` and are not project instructions.

| Archive | Non-directory members | Uncompressed bytes | Source coverage |
| --- | ---: | ---: | --- |
| PLC-530 | 418 | 1121479 | StandardPLC, SafetyPLC, device/task/library metadata and ST text |
| HMI-530 | 189 | 1004097 | Device application, task/library metadata and ST text |

Both archives were inspected through temporary extracted copies. No extracted
source tree was installed in the workspace. Paths below are **archive members**,
not claims that a corresponding workspace file already exists.

## Application and library identity

| Evidence | Observed value |
| --- | --- |
| P-VERSION, active declaration, line 454 | `VERSION := '5.3.0v1'` |
| H-VERSION, active declaration, line 282 | `VERSION := 'dev'`; the `5.3.0v1` alternative is commented out |
| P-LIB, line 429 | `TD3-1 Framework, 3.1.0.12 (Ojjo)`, namespace `td3_1` |
| H-LIB, line 704 | `TD3-1 Framework, 3.1.1.11 (Ojjo)`, namespace `td3_1` |

Different framework references may be intentional. Their shared types and
compatibility still need checking. Library filenames alone do not establish
installed or resolved library identity. Readable framework/motor library source
was not supplied in these archives. Nearby `.library` binaries exist in
`Production_dev/libraries` and `Library`; their contents were not decoded.

The coworker's CODESYS SP21 Patch 1 statement concerns another workspace. TD3 has
SP21-related names/comments, but its exact IDE/compiler, device packages, library
resolutions, and firmware need a build-environment record.

Adjacent project binaries were fingerprinted for preservation, not opened or
matched semantically to the exports:

| Project | SHA-256 |
| --- | --- |
| `Production_dev/TD3-Auto/ojjo_TD3_cr711S_530v1.project` | `fd5fc26baf2eb8694bb4a43ca07fa4628548cb3b5e1e1d4f9e7096a3bde8e1c3` |
| `Production_dev/TD3-HMI/ojjo_TD3_cr1203_530v1.project` | `47158217a2f81c311b9412fabb4169662c06093350027a679543fd5194966dc8` |

## Source reference keys

Prefixes include the top-level folder **inside** the respective archive:

```text
P = exports_ojjo_TD3_cr711S_530v1/StandardPLC.dev/Plc Logic/Application/
S = exports_ojjo_TD3_cr711S_530v1/SafetyPLC.dev/Plc Logic/Application/
H = exports_ojjo_TD3_cr1203_530v1/Device.dev/Plc Logic/Application/
```

| Key | Member path after prefix |
| --- | --- |
| P-ENTRY | `P/POUs/PLC_PRG.pou/PLC_PRG.pou` |
| P-VERSION | `P/Global Variables/Version.gvl` |
| P-LIB | `P/Library Manager.lib` |
| P-TASK | `P/TaskConfiguration.tc/MachineControlTask.task` |
| P-CAN | `P/POUs/CanMonitor.pou` |
| P-GPS-CAN | `P/POUs/CAN_OPEN/Can3Management/manageCan3.pou/GPSdata.m` |
| P-GPS | `P/POUs/GPS/GPS.pou` |
| P-UPDATE | `P/POUs/GPS/GpsUpdate.pou` |
| P-TARGETS | `P/POUs/GPS/GpsSetTargets.pou` |
| P-ADJUST | `P/POUs/GPS/modifyTarget/setGPSpNEZdTargetAdjust.pou` |
| P-ASIN | `P/POUs/Utility/Conversions/ASIN_DEG.pou` |
| P-BS | `P/POUs/Utility/Conversions/Rotations/TD3/ROTATE_BS_ARM.pou` |
| P-DIMS | `P/Global Variables/Dimensions.gvl` |
| P-INIT | `P/POUs/MACHINE_LEVEL/machineInit.pou` |
| P-STATE | `P/POUs/MACHINE_LEVEL/machineState.pou/machineState.pou` |
| P-ESTOP | `P/POUs/MACHINE_LEVEL/checkEstop.pou` |
| P-ACT | `P/POUs/ACTUATORS/runActuators.pou` |
| P-NV | `P/Network variables/` directory |
| S-ENTRY | `S/PLC_PRG.pou` |
| S-TASK | `S/TaskConfiguration.tc/Task.task` |
| H-ENTRY | `H/POUs/PLC_PRG.pou/PLC_PRG.pou` |
| H-VERSION | `H/GlobalVariables/VersionHMI.gvl` |
| H-LIB | `H/Library Manager.lib` |
| H-TASKS | `H/Task configuration.tc/` directory |
| H-NV | `H/Network Variables/` directory |
| H-ASBUILT | `H/POUs/DataManagement/CaptureAsBuiltEvents.pou` |
| H-STORAGE | `H/POUs/DataManagement/DataStorage.pou/` directory |
| H-UPLINK | `H/POUs/DataManagement/DataUplinkDev/DataUplink.pou/` directory |

Line references in the assessment count LF-delimited lines in archive text,
consistent with `rg -n`. Some viewers handle mixed line endings differently;
use the named symbol and expression if their displayed line numbers differ.

## Refreshing the baseline

Keep a new export under a distinct versioned name, hash it, and record its origin,
export time, project identity, application version, compiler/device/library set,
machine configuration, and deployed status if known. Select it explicitly for the
task. Preserve this assessment's old identity so its findings remain reproducible.
Do not overwrite an old archive and retain its old evidence label.
