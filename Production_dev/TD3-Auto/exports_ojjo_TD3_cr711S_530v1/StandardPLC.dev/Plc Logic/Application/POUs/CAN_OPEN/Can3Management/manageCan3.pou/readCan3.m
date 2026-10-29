
(********************** Declaration ****************************)
METHOD readCan3
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
// The Hutte engine monitor computer packages up engine oil temperature and engine fuel data and re-transmits it over the
//	CanBus.  Pick that up here.
RX_ATTEMPTS := RX_ATTEMPTS + 1;
RX_AVAILABLE := 1;

LHP_GPS_RX_INTERVAL := MSTIME - LHP_GPS_RX_LAST;
HUTTE_RX_INTERVAL := MSTIME - HUTTE_RX_LAST;
ENGINE_RX_INTERVAL := MSTIME - ENGINE_RX_LAST;
GPS_CAN_RX_INTERVAL := MSTIME - GPS_CAN_RX_LAST;

WHILE TO_BOOL(RX_AVAILABLE) DO
	// This is looking for a broad range of messages.
	Can_RX_MASK3(eChannel := CHANNEL, xExtended := TRUE, aData => DATA_READ, usiDLC => RX_NUM, uiAvailable => RX_AVAILABLE,
		xEnable := TRUE, xERROR => RX_ERROR, eDiagInfo => RX_DIAG, udiIDset := 16#0000, udiIDmask := 16#00000000, udiID => RX_MSG_ID);
	IF RX_MSG_ID <> 0 THEN
		RX_PGN := SHR(RX_MSG_ID, 8) AND 16#FFFF;
	END_IF
	IF RX_ERROR THEN
		RX_FAIL := RX_FAIL + 1;
	ELSIF RX_AVAILABLE <> 0 THEN
		
		IF RX_MSG_ID = 16#0100 THEN
			// From the Hutte PLC.	
			HUTTE_RX_LAST := MSTIME;
			HUTTE_RX_SUCCESS := HUTTE_RX_SUCCESS + 1;
			
			// This is a duplicate engine oil temp (of the analog signal).
			ENGINE_OIL_TEMP := SHL(TO_UINT(DATA_READ[1]), 8) + DATA_READ[0];
			// Fuel level is in units of 0.25% full.
			FUEL_LEVEL := (SHL(TO_UINT(DATA_READ[3]), 8) + DATA_READ[2]) / 4.0;
			FUEL_LOW_ALERT := DATA_READ[4];
		ELSIF (RX_PGN AND 16#FF00) = 16#EA00 THEN
			// Some node transmitted a PGN request to the bus.
			PGN_REQ := SHL(TO_UINT(DATA_READ[1]), 8) + TO_UINT(DATA_READ[0]);
			PGN_NEW := TRUE;
			FOR IDX := 1 TO PGN_SAVE_IDX DO
				IF PGN_SAVE[IDX] = PGN_REQ THEN
					PGN_NEW := FALSE;
					EXIT;
				END_IF
			END_FOR
			IF PGN_NEW THEN
				PGN_SAVE[PGN_SAVE_IDX] := PGN_REQ;
				PGN_SAVE_IDX := PGN_SAVE_IDX + 1;
			ELSE
				PGN_SAVE_COUNT[IDX] := PGN_SAVE_COUNT[IDX] + 1;
			END_IF
		ELSIF RX_PGN = 16#EF00 OR RX_PGN = 16#EF01 THEN
			// From the KZ valve.
			VALVE_RX_SUCCESS := VALVE_RX_SUCCESS + 1;
		ELSIF RX_PGN = 16#FEF3 OR RX_PGN = 16#FEE8 OR RX_PGN = 16#FBF6 THEN
			ENABLE_LHP_UPLINK := TRUE;
			// From the LHP telematics, GPS data.
			IF RX_PGN = 16#FEF3 THEN
				LATITUDE := ByteArrayToReal(4, 1, 0, 1E-7, -210, ADR(DATA_READ[0]));
				LONGITUDE := ByteArrayToReal(4, 1, 0, 1E-7, -210, ADR(DATA_READ[4]));
			END_IF
			RX_MSG_ID_LAST := RX_MSG_ID;
			RX_PGN_LAST := RX_PGN;
			LHP_GPS_RX_LAST := MSTIME;
			LHP_GPS_RX_SUCCESS := LHP_GPS_RX_SUCCESS + 1;
		ELSIF RX_PGN = 16#FEEE THEN
			DEBUG_MSG_ID := RX_MSG_ID;
			DEBUG_PGN := SHR(DEBUG_MSG_ID, 8) AND 16#FFFF;
			saveDebugData(ADR(DATA_READ), ADR(DEBUG_DATA));
			DEBUG_COUNTER := DEBUG_COUNTER + 1;

			OIL_TEMPERATURE := 0.03125 * (SHL(TO_UINT(DATA_READ[3]), 8) + DATA_READ[2]) - 273;
		ELSIF RX_PGN = 16#F004 THEN
			// Electronic engine controller 1
			ENGINE_RPM := (SHL(TO_UINT(DATA_READ[4]), 8) + DATA_READ[3]) * 0.125;
		ELSIF RX_PGN = 16#F606 THEN
			// Fuel level and volume.
			// DOESN'T work, this gear installed by Hutte and not Cummins!
			FUEL_LEVEL_MM := (SHL(TO_UINT(DATA_READ[1]), 8) + DATA_READ[0]) * 0.1;
			FUEL_VOLUME_L := (SHL(TO_UINT(DATA_READ[3]), 8) + DATA_READ[2]) * 0.1;
		ELSIF RX_PGN = 16#FEF5 THEN
			// DOESN'T work.
			;
			//AMBIENT_TEMPERATURE := DATA_READ[5] * 1.0 - 40;
		ELSIF RX_PGN = 16#FEFC THEN
			// Dash display.
			// DOESN'T work.
			FUEL_LEVEL_PCT := DATA_READ[1] * 1.0;
		ELSIF RX_PGN < 16#FF00 THEN
			// Unknown engine output.
			RX_MSG_ID_LAST := RX_MSG_ID;
			RX_PGN_LAST := RX_PGN;
			ENGINE_RX_LAST := MSTIME;
			ENGINE_RX_SUCCESS := ENGINE_RX_SUCCESS + 1;
		ELSE
			OTHER_RX_SUCCESS := OTHER_RX_SUCCESS + 1;
		END_IF
	END_IF
END_WHILE
	
