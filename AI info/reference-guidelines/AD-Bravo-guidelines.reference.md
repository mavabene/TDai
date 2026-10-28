# Codex Notes for NXT_TMM

## Default Agent Workflow: Read-Only

Treat this repository as read-only by default. The normal job for Codex/agents is to inspect exported Structured Text, reason about it, and give the user copy-pastable code or a concrete implementation plan. The user will manually apply code changes inside CODESYS `.project` files.

Do not edit `exports_*` files. Do not edit `.project`, `.library`, generated CODESYS artifacts, or other project files just because the user asks to fix, add, implement, refactor, or prototype machine code. In this repo, those words usually mean: analyze the exports and return proposed code for the user to paste.

Only modify files in this workspace when the user explicitly asks for a file edit, such as updating `AGENTS.md`, updating `AD_TODO.md`, or creating a clearly named planning/scratch document. If the requested work is about PLC/HMI/library behavior, default to no file edits.

When proposing code changes, include the target export path/POU/action/method and provide complete contiguous replacement blocks. For CODESYS POUs, separate declaration/variable changes from implementation changes because the IDE stores and displays those sections separately.

## Project Shape

This workspace contains the Anchor Driver machine codebase plus Bravo, a fork of the AD PLC/HMI software. Anchor Driver is a prototype lineage based on the Truss Driver / TMM machines, and Bravo is a new prototype machine, loosely based on the Anchor Driver machines. The active machine code is Structured Text for CODESYS V3.5 SP21 Patch 1.

The primary AD/Bravo areas are:

- `C:\Users\jfrabosilio\Documents\NXT_TMM\AD-PLC` - PLC project and exports.
- `C:\Users\jfrabosilio\Documents\NXT_TMM\AD-HMI` - HMI/display project and exports.
- `C:\Users\jfrabosilio\Documents\NXT_TMM\BRAVO-PLC` - Bravo PLC project and exports. Has a debug version (used for remote/IO/valve testing).
- `C:\Users\jfrabosilio\Documents\NXT_TMM\BRAVO-HMI` - Bravo HMI/display project and exports. Has a debug version (used for remote/IO/valve testing).
- `C:\Users\jfrabosilio\Documents\NXT_TMM\Library` - shared CODESYS libraries and exports.

Each primary area has one or more `exports_*` folders. These are the file-system-readable CODESYS exports and are usually the right place for source inspection, diffs, and text edits. The `.project` / `.library` files are the CODESYS project binaries opened by the IDE.

When the user asks questions in this workspace, assume they are almost always referring to code visible in the `exports_*` folders. The user normally exports the current CODESYS projects before asking, so treat the exports as matching what is actually running on the PLC/HMI. The user will usually want either AD or Bravo; if the target is not clear, ask which one before analyzing or proposing code.

## Current Primary Files

- AD PLC project: `AD-PLC\ojjo_AD_cr711s.project`
- AD PLC readable export: `AD-PLC\exports_ojjo_AD_cr711s`
- AD HMI project: `AD-HMI\ojjo_AD_cr1203.project`
- AD HMI readable export: `AD-HMI\exports_ojjo_AD_cr1203`
- Bravo PLC project: `BRAVO-PLC\nx_bravo_cr711s.project`
- Bravo PLC readable export: `BRAVO-PLC\exports_nx_bravo_cr711s`
- Bravo HMI project: `BRAVO-HMI\nx_bravo_cr1203.project`
- Bravo HMI readable export: `BRAVO-HMI\exports_nx_bravo_cr1203`
- Bravo PLC debug project: `BRAVO-PLC\bravo-cr711S-io_debug.project`
- Bravo PLC debug readable export: `BRAVO-PLC\exports_bravo-cr711S-io_debug`
- Bravo HMI debug project: `BRAVO-HMI\bravo-cr1203-io_debug.project`
- Bravo HMI debug readable export: `BRAVO-HMI\exports_bravo-cr1203-io_debug`
- AD framework library: `Library\ad3.library`
- AD framework export: `Library\exports_ad3`
- Bravo framework library: `Library\bravo.library`
- Bravo framework export: `Library\exports_bravo`
- Motor2 library: `Library\ad_motor2.library`
- Motor2 export: `Library\exports_ad_motor2`

Bravo and AD share the motor2 library. 

The Bravo debug projects were specialized projects designed to test specific sensors and IOs on the Bravo machine during development. Findings from the debug projects are currently being implemented into the proper Bravo projects.

## Inherited TD Design Context

The PDFs in `doc\` are TD/TDM design and operations notes. Use them as historical architecture context for Anchor Driver, not as proof that every TD name still exists unchanged in AD.

Durable design rules from those docs:

- The CR711S/PLC owns machine control. The CR1203/HMI is for display, operator interaction, logging/uplink, and settings; core machine functions should remain available without the HMI connected.
- Manual vs Automatic is a working method. Operation mode selects the current machine context. TD modes were Idle, Track, Rough Working Point, and Screw; AD maps this lineage into its Track/WP/Pile-style folders and states.
- `PLC_PRG` is the scan entry point. The intended order is housekeeping/powerup/watchdogs, receive HMI settings, run state logic, run actuator/device control from the latest state, then transmit updated values back to the HMI.
- State machines should decide state transitions and explain blocked transitions to the HMI. They should not directly command actuators or on/off devices.
- Actuator code is the layer that samples feedback, handles feedback faults, respects Estop, chooses behavior for the current state, runs profiler/loop logic when appropriate, and always applies a final output. It should only force a state change for unrecoverable errors.
- Keep generic motion-control behavior in the motor library, shared machine-family types/state helpers in the AD library, and machine-specific rules in the application code.
- Hydraulic valves behave like velocity-mode actuators: operator-facing values are engineering units, but low-level control ultimately works in raw feedback/output units.
- Safety posture matters even during software planning. Manual mode is still software-mediated; if the engine is running, software can move machine elements. Do not propose shortcuts that rely on people being near moving hardware or bypassing stop/fault handling.
- Follow the local CODESYS conventions closely: folder layout, names, case, indentation, and where information lives are part of the design. Refactor only when it clearly improves function or maintainability.

## PLC Map

The PLC export has `StandardPLC.dev` and `SafetyPLC.dev`.

Important AD StandardPLC paths:

- Main program: `AD-PLC\exports_ojjo_AD_cr711s\StandardPLC.dev\Plc Logic\Application\POUs\PLC_PRG.pou`
- Global variables: `...\Application\Global Variables\`
- Network variables: `...\Application\Network variables\`
- Task config: `...\Application\TaskConfiguration.tc\`

Bravo PLC mirrors this structure under `BRAVO-PLC\exports_nx_bravo_cr711s`.

StandardPLC task notes:

- `MachineControlTask`: cyclic `t#20ms`, priority 2, runs `PLC_PRG`.
- `CanMonitorTask`: cyclic `t#10ms`, priority 1, runs `CanMonitor`.
- `UtilityTask`: cyclic `t#1000ms`, priority 3, runs `MTS_CONFIG`.

`PLC_PRG` does startup NVM/default handling, increments `PLC_WATCHDOG`, delays for 24V settling, tracks cycle time, samples remote and analog inputs, updates GPS when enabled, receives HMI settings, runs `machineState_01`, runs actuators, operates ancillary functions, and transmits values back to the HMI.

Notable StandardPLC POU folders:

- `MACHINE_LEVEL` - machine state, init, E-stop/warnings, remote processing, analog/pressure handling, persistent defaults.
- `ACTUATORS` - mast and rotator-forward actuator logic.
- `M1-TRACK`, `M2-WP`, `M3-PILE` - mode/state machines; `M3-PILE\pileStateMachine.pou` is a large pile-mode hub.
- `CAN_OPEN` - CANopen/J1939, Kar-Tech remote, node states, CAN3 management, remote display handling.
- `GPS` and `KINEMATICS` - auto-targeting and coordinate/pose calculations.
- `HMI` - PLC side of HMI network variable receive/transmit.

SafetyPLC has its own `PLC_PRG` and a cyclic `Task` at `t#10ms`, priority 1, with watchdog enabled at `t#8ms`. The user says SafetyPLC is not used; do not spend time there unless explicitly asked.

## HMI Map

The HMI export has `Device.dev` and `ecomatDisplay_64bit.dev`.

Important AD HMI paths:

- Main program: `AD-HMI\exports_ojjo_AD_cr1203\Device.dev\Plc Logic\Application\POUs\PLC_PRG.pou\PLC_PRG.pou`
- Global variables: `...\Application\GlobalVariables\`
- Network variables: `...\Application\Network Variables\`
- Task config: `...\Application\Task configuration.tc\`

Bravo HMI mirrors this structure under `BRAVO-HMI\exports_bravo-cr1203-io_debug`.

HMI task notes:

- `MainTask`: cyclic `t#10ms`, priority 1, runs `PLC_PRG`.
- `DataAcq`: cyclic 20 ms, priority 7, runs `DataStorage`.
- `DataUplinkTask`: cyclic 50 ms, priority 0, runs `DataUplink`.
- `VISU_TASK`: cyclic `t#20ms`, priority 15, runs `VisuElems.Visu_Prg`.
- `TrendRecordingTask`: cyclic 100 ms, priority 31, runs `VisuTrendStorageAccess.GlobalInstances.g_TrendRecordingManager.CyclicCall`.

`PLC_PRG` increments `HMI_WATCHDOG`, updates node status, receives PLC values, handles key press/release actions, initializes HMI NVM, updates visualization elements, checks login state, manages HMI temperature behavior, updates readable time, transmits settings back to the PLC, and can trigger HMI recovery/reboot when `UPDATE_HMI` is set.

Notable HMI POU folders:

- `DataAcquisition\DataStorage.pou` - cycle logging/storage and related write methods.
- `DataUplink` - Azure/cloud uplink side.
- `PersistentSettingSaveLoad` - USB persistent setting manager and FNV hashing.
- `Utilities` - PLC/HMI variable transfer, visualization colors/status, GPS strings, AD2/AD3 detection.
- `NODE_STATUS.pou`, `Login`, and `PLC_PRG.pou` support display state and operator interaction.

## Libraries

`Library\exports_ad3` is the AD framework. It contains data types, global variables, remote helpers, state logic, kinematics, and utilities. Its library manager references `Library\exports_ad_motor2`.

`Library\exports_bravo` is the Bravo framework. It is very similar to the AD framework, with differences pertaining to physical machine geometry and actuators. Its library manager references `Library\exports_ad_motor2`.

`Library\exports_ad_motor2` is the AD motor/control support library. Its POUs are grouped into conversion, feedback, hacks, initializers, loops, profilers, and utility code.

## Editing Guidance

- Prefer inspecting the `exports_*` text files, not the binary `.project` or `.library` files.
- Keep prototypes, bug-fix sketches, and feature plans in the response as snippets, replacement blocks, state tables, or implementation steps. Do not apply them to the exports.
- If a scratch artifact is truly useful, ask before creating it and keep it clearly separate from the CODESYS project/export files.
- CODESYS export conventions in this repo:
  - `.pou` for programs/functions/function blocks.
  - `.gvl` for global variable lists.
  - `.dut` for data types/enums/structs.
  - `.m` for methods under exported POU folders.
  - `.act` for actions.
  - `.task` and `.dev` are XML-like CODESYS export artifacts.
- When suggesting changes to POUs, always return copy-pastable blocks. If suggesting changes to a whole POU, split the copy-pastable block between the function name / variables section and the implementation/code section, because CODESYS splits them. In general, return complete contiguous code sections and do not generate a whole POU unless the user asks for it.
- Quote paths in shell commands. Many important folders contain spaces, for example `Plc Logic`, `Global Variables`, and `Task configuration.tc`.
- Treat `.opt`, `.~u`, `.precompilecache`, `.compileinfo`, `.bootinfo`, `.imgcache`, `.projectarchive`, and `.backup` files as volatile/generated unless the user specifically asks about them.
- There is no obvious local CLI build/test harness for the CODESYS projects. Validation is usually static review, targeted search/diff, and then compile/download in CODESYS V3.5 SP21 Patch 1.
- Check `git status` before edits. This workspace may have many unrelated CODESYS-generated changes; do not revert or clean them without explicit instruction.

## Other Workspace Notes

- `TMM-Auto` and `TMM-HMI` contain Truss Driver / TMM project history and exports. They are useful for comparison because Anchor Driver was split from TMM, but they are not the primary AD targets.
- TD 5.0.1 source/export is at `C:\Users\jfrabosilio\Documents\TD3-1\Production\TD3-Auto\exports_ojjo_TD3_cr711S_prod_501`. This is a useful comparison source for features that were added after the older TD/TMM lineage that TMM was forked from.

