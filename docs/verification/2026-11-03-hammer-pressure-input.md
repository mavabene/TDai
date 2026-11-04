# Hammer pressure input 203: static review

November 3, 2026. Owner asks whether an unconnected added hammer pressure
sensor is handled. Baseline: PLC-530 archive and hash in
[SOURCE_BASELINE](../SOURCE_BASELINE.md); relevant readPressureSensors,
hardwareInit and operateHammer POUs are byte-identical in local 530v2.
This is not confirmation of deployed code or any later owner changes.

Paths below are relative to archive member prefix
`exports_ojjo_TD3_cr711S_530v1/StandardPLC.dev/Plc Logic/Application/`.

- **HPR-01:** `Global Variables/IO_Hardware.gvl:48` assigns
  HAMMER_PRESSURE_POINT=203. `POUs/MACHINE_LEVEL/hardwareInit.pou:159-165`
  configures IN_CURRENT_CSI with FILTER_7 only for MACHINE_VERSION>=7.
  `POUs/Utility/readPressureSensors.pou:25-29` cyclically reads it under the
  same version condition, capturing only uiValueAnalogue. No application
  validity, channel diagnostic or raw-range check guards this read/conversion.
- **HPR-02:** readPressureSensors line 36 always calculates
  `(HAMMER_PRESSURE_RAW - PRESSURE_OFFSET) * PRESSURE_SCALE_FACTOR`.
  machineInit lines 56-57 set offset 4000 and scale 5800/16000, representing
  4-20 mA and 0-5800 psi. If the raw returned value is zero, reported pressure
  is -1450 psi (conditional arithmetic, not an observed unplugged reading).
  The network raw default is -1, not a separate validity flag; for versions
  below 7 the channel is not read, but conversion still occurs. A negative
  sentinel is not explicitly checked. Exact disconnected behavior of the
  vendor FB/hardware is unverified; do not assume its raw value is always zero.
- **HPR-03:** operateHammer lines 27-32 uses UPPER_ROTARY_PRESSURE when
  HAMMER_CONTROL_SOURCE=1, otherwise LOWER_CROWD_PRESSURE. The new
  HAMMER_PRESSURE does not drive that selection. HAMMER_CMD passes to
  setOutput/HaweOutput at the end of the FB, including existing forcing logic.
  The only located max-hammer-pressure consumer in updateMaxPressures.m is
  commented out. No active hammer-pressure-specific warning/validity consumer
  was found in application text.
- **HPR-04 (coverage):** pressure and raw are in PLC_TRANSMIT_1 and HMI
  RECEIVE_1. The HMI source search found those declarations but no other text
  references to HAMMER_PRESSURE. A working display or its invalid presentation
  is therefore not established from these exports.

Recommendation only: distinguish not installed / invalid / valid using a
presence rule plus the vendor INPUT diagnostic result and appropriate raw
limits. Publish validity for the HMI and show unavailable rather than a
misleading numeric pressure. Do not clamp invalid readings to zero as the
sole handling, or add a hammer inhibit without an explicit behavior decision.
No exact diagnostic fields or thresholds are proposed without checking the
installed ifm library and sensor specification.

Validation: static read/conversion/consumer/output-path trace and local source
comparison. No compile, hardware disconnect test, controller connection or
machine operation. Next action: agree optional-sensor presentation, inspect
actual library diagnostics/sensor range, then prepare a bounded validity patch.
