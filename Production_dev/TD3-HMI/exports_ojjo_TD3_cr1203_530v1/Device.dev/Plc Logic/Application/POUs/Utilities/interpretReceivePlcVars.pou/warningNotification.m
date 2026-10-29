
(********************** Declaration ****************************)
METHOD warningNotification : BOOL
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
WARNINGS := 0;
NOTIFICATIONS_COLOR := FALSE;
IF RECEIVE_1.WARNING_CURRENT <> 0 THEN
	Visualization_Variables.NOTIFICATIONS := 'WARNING: ';
	NOTIFICATIONS_COLOR := TRUE;
ELSE
	Visualization_Variables.NOTIFICATIONS := '';
END_IF

demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_0), MASK := 16#0001, MSG := 'Pitch');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_1), MASK := 16#0002, MSG := 'Lower crowd');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_2), MASK := 16#0004, MSG := 'Base pitch');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_3), MASK := 16#0008, MSG := 'Base roll');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_4), MASK := 16#0010, MSG := 'Pump 1 Pressure');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_5), MASK := 16#0020, MSG := 'Pump 2 pressure');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_6), MASK := 16#0040, MSG := 'Remote battery');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_7), MASK := 16#0080, MSG := 'Valve status');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_8), MASK := 16#0100, MSG := 'Axis range');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_9), MASK := 16#0200, MSG := 'Upper crowd range');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_10), MASK := 16#0400, MSG := 'Drifter too high');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_11), MASK := 16#0800, MSG := 'High speed tracking');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_12), MASK := 16#1000, MSG := 'Engine fuel low');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_13), MASK := 16#2000, MSG := 'Hydraulic fluid hot');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_14), MASK := 16#4000, MSG := 'Remote input error');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_15), MASK := 16#8000, MSG := 'Rotator range');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_16), MASK := 16#10000, MSG := 'Air compressor');
// removed because we adjust pressures below these limits to reduce twizzling, and we can see the data anyway
// demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_17), MASK := 16#20000, MSG := 'UR pressure possibly low');
// demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_18), MASK := 16#40000, MSG := 'LC pressure possibly low');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_19), MASK := 16#80000, MSG := 'PNEZD invalid D field');
demuxWarning(pWBIT := ADR(Visualization_Variables.WARNING_BIT_20), MASK := 16#100000, MSG := 'Proximity Sensor failed');