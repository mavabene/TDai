# Architecture and source map

Status: initial static observations from the [530v1 baseline](SOURCE_BASELINE.md).
Source keys below resolve to exact archive members there. Intended behavior and
acceptance criteria still need feature-specific requirements.

## Control boundary

The StandardPLC application contains machine state logic, hydraulic actuator
control, remote processing, GPS targeting, and CAN handling. The HMI application
contains operator/settings exchange, visualization support, data acquisition,
as-built event handling, and uplink logic. This is the observed code distribution.
The required behavior during HMI loss has not yet been specified or validated.

Proposed design rule for future work: keep machine control and final permissives
in the PLC; let the HMI request behavior and explain status. Before relying on
independence from the HMI, trace settings, startup synchronization, watchdogs,
and fault recovery for the particular operation.

## Exported tasks

| Application/task | Interval | Priority | Entry | Task watchdog |
| --- | --- | ---: | --- | --- |
| StandardPLC / MachineControlTask | 20 ms | 2 | `PLC_PRG` | Disabled; 50 ms value stored |
| SafetyPLC / Task | 10 ms | 1 | `PLC_PRG` | Enabled, 8 ms, sensitivity 1 |
| HMI / MainTask | 10 ms | 1 | `PLC_PRG` | Disabled |
| HMI / DataAcq | 100 ms | 7 | `DataStorage` | Disabled |
| HMI / DataUplinkTask | 10 ms | 6 | `DataUplink` | Disabled |
| HMI / VISU_TASK | 20 ms | 15 | `VisuElems.Visu_Prg` | Disabled |

Evidence: P-TASK, S-TASK, and H-TASKS. No separate StandardPLC CanMonitorTask or
UtilityTask appears in this archive; `CanMonitor()` is called in P-ENTRY. Do not
copy the different task map from the AD/Bravo guidelines. These are configuration
values, not measured execution times, jitter, or deadline evidence.

S-ENTRY contains an empty implementation. This does not establish the installed
safety architecture, external safety circuit, or whether that application runs.

## StandardPLC scan

P-ENTRY shows this order after startup handling:

1. Track cycle timing, initialize NVM on first count, monitor supply/shutdown,
   publish the PLC watchdog, and handle system information.
2. Wait for the one-second startup power delay.
3. Sample the Kar-Tech remote and analog inputs.
4. Run `CanMonitor()`, including node monitoring and CAN3 management.
5. Run `GPS_01()` when `GPS_VENDOR_VALUE > 0 OR ET2_TEST <> 0`; otherwise reset
   several GPS-use/readiness flags.
6. Interpret HMI updates, then run `machineState_01()` and `runActuators_01()`.
7. Run ancillary devices and tuning support; transmit updated HMI values.
8. Update initialization and execution-time accounting.

P-CAN calls `NODE_STATES()` before a return while `TIME_SECONDS_FLOAT < 30`.
CAN3 management is below that startup return. This is a source timing dependency
to account for in startup tests, not a measured communications-ready time.

The scan calculates GPS targets before interpreting this scan's HMI updates.
Avoid changing that order without tracing state and configuration dependencies.

## PLC navigation

| Area under `P/POUs/` | First inspection point |
| --- | --- |
| `MACHINE_LEVEL/` | P-STATE, P-ESTOP, `machineInit.pou`, remote/analog handling |
| `ACTUATORS/` | P-ACT, then the affected actuator's feedback/control/output path |
| `TRACK/`, `RWP/`, `SCREW/` | Mode state machines and transitions |
| `ON_OFF_DEVICES/` | Ancillary hydraulic/electrical device behavior |
| `CAN_OPEN/` | CANopen/J1939, remote, CAN3 management and vendor GPS decoding |
| `GPS/` | P-GPS, P-UPDATE, P-TARGETS and `modifyTarget/` |
| `Utility/Conversions/Rotations/` | Frame helpers and product geometry conversions |
| `HMI/` | `interpretReceiveHmiVars.pou/` and `updateTransmitHmiVars.pou` |
| `PLC_PRG.pou/` | P-ENTRY and `initializeNVM.m` |

Global variables include `Dimensions.gvl`, `GPS_Settings.gvl`, `StatePositions.gvl`,
`IO_Hardware.gvl`, and `IO_Backbone.gvl`. Defaults can be changed during machine
initialization or by persistent settings; declarations alone are not calibration
evidence.

P-ESTOP uses different stop-condition treatment for automatic/manual operation,
including `ESTOP_MANUAL_MASK := 16#8003`. Its logic and output call were inspected
as an entry point only. A complete cause-to-output, hydraulic, and restart review
has not been done. No stop limits or masks are endorsed by this assessment.

## GPS data path

```text
CAN3 vendor messages -> GPSdata -> GPS_OFFSETS / GPS_AXES
    -> GPS -> GpsUpdate -> GpsSetTargets -> actuator targets
    -> state/permissive/actuator execution -> final hydraulic outputs

product + operation + selected geometry compensation
    -> setGPSpNEZdTargetAdjust -> Northing/Easting/Z target adjustments
    -> GPSdata outgoing CAN -> GPS effective target

PLC network variables -> HMI receive/interpret -> display / as-built / storage
```

P-GPS maps heading to yaw, X to X-slide, Y to boom swing, and Z to Z-slide.
P-UPDATE evaluates reach, tolerances, filtered targets, GPS readiness, point
changes, and target adjustments. P-GPS-CAN contains vendor-specific units, signs,
message assembly, and conditional offset handling. Review the full applicable
branch before choosing an interface interpretation.

Targets are coupled through the articulated mechanism. See [GEOMETRY](GEOMETRY.md)
for physical context and [assessment findings](ASSESSMENT-2026-10-27.md) for the
unresolved pitch calculation and numerical-limit concerns.

## HMI execution and interfaces

H-ENTRY initializes NVM updates on the first count and runs node status,
Kar-Tech analog error handling, visualization updates, PLC transmit/receive
interpretation, login, uplink management, and `CaptureAsBuiltEvents()`. It also
handles device/time information, compressor power-down timing, recovery boot,
splash loading, and touch configuration. The order is the supplied TD3 order,
not the coworker's AD HMI description.

The HMI POUs are organized under `DataManagement`, `FileActions`, `GPS`, `Login`,
and `Utilities`, with `NODE_STATUS.pou`, `LED_CONTROL.pou`, and `PLC_PRG.pou/`.
The uplink implementation is under `DataManagement/DataUplinkDev/DataUplink.pou/`.
Storage/uplink have separate tasks; source contains shared data and queue logic
that needs a focused consistency/ownership review when those features change.
The text archive contains no `.visu` screen-definition files, so this assessment
does not cover screen layout, widget bindings, navigation, or operator usability.

PLC/HMI exchange includes seven PLC transmit lists and two HMI transmit lists.
Receive lists are extensionless files. See the dated [declaration comparison](ASSESSMENT-2026-10-27.md#interface-check)
for its limited result. This was not a verification of UDP list configuration,
packet packing, resolved library types, freshness, synchronization, or runtime
communication. The CAN contract and as-built event semantics remain to document.
