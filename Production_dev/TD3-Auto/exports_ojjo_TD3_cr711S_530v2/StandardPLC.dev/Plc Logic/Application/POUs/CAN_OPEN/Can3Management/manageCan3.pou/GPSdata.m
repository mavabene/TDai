
(********************** Declaration ****************************)
METHOD GPSdata

VAR
	
	GPS_MSG_ID: UDINT := 0;
	GPS_CAN_NODE: USINT := 0;
	GPS_CAN_SUB_INDEX: USINT := 0;
	GPS_CAN_INDEX: UINT := 0;
	GPS_TX_MSG_ID: UDINT := 0;
	GPS_TX_MSG_BYTES: USINT := 0;
	GPS_EXTENDED: BOOL := FALSE;
	GPS_RX_AVAILABLE: UINT;
	GPS_DATA_READ: ARRAY[0..7] OF USINT := [0, 0, 0, 0, 0, 0, 0, 0];
	GPS_DATA_WRITE: ARRAY[0..7] OF USINT := [0, 0, 0, 0, 0, 0, 0, 0];
	
	GPS_RX_DIAG: ifmTYPES.DIAG_INFO;
	RX_NUM_CYCLES: UINT := 0;
	
	GPS_OTHER_RX_SUCCESS: INT := 0;
	GPS_TX_FAIL: ULINT := 0;
	GPS_RX_FAIL: ULINT := 0;
	GPS_CAN_TX_REQUEST: BOOL := FALSE;
	//COB_ID: UDINT;
	
	MAST_XSLOPE_AS_INT: INT := 0; // MAST_PITCH.POSITION_ENGR * 100 - sent to StonEx for position corrections
	MAST_YSLOPE_AS_INT: INT := 0; // KNUCKLE_ROLL.POSITION_ENGR
	//Z_OFFSET_AS_INT: INT := 0; // get Z offset as an integer to pack into USINT bytes for transmit to StonEx

	GPS_CAN_REQUEST: BOOL := FALSE;
	
	GPS_TRIMBLE_STATE: INT :=0;
	GPS_TRIMBLE_DELTA_HEIGHT: INT :=0 ;
	GPS_TRIMBLE_DELTA_ROLL_MAST: REAL :=0 ;
	GPS_TRIMBLE_DELTA_PITCH_MAST: REAL :=0 ;
	GPS_TRIMBLE_X_NORTHING: REAL :=0;
	//(*
	GPS_TIME_INTERVAL_100MS: UDINT := 100000;
	GPS_CURRENT_TIME_US: SysTime := 0;
	// CYCLE_START: SysTime := 0; 
	//*)
	
	GPS_TX_READY: BOOL := TRUE;
	CAN_TX_REQUEST: BOOL := FALSE;
	
	GPS_INDEX: INT := 1; // index
	GPS_SUBINDEX: INT := 0; // index
	
	GPS_NUM_TX_MSGS: USINT := 4; // number of messages to be sent  This is the StonEx setup, change for other vendors as appropriate
	CYCLE_NUM_STD_TX_REQUEST: UDINT := 0;
 	MAX_NUMBER_PNEZD_POLE_ID_MSGS: USINT := 3;
	MAX_NUMBER_PNEZD_D_MSGS: USINT := 9;
	

	MSG_BYTE: BYTE := 0;
//	MSG_ARRAY: ARRAY [0..5] OF STRING(7);
	i: INT := 0;
	j: INT := 0;
	
	//GPS_PNEZD_MSGS: ARRAY [0..5] OF STRING(7);
	IS_NEW_MSG: BOOL := TRUE;
	
	//PNEZD_TEXT_RESET: BOOL := FALSE; // return vars to here after debug
	//PNEZD_PD_RX_CTR: USINT := 0; // count messages received
	//debug
	temp_easting_offset: LINT := 8976;// 1023; 8961 for 0123
	//temp_TRUSS_COMPLETE: LINT := 7777;
END_VAR

(********************** Implementation ****************************)
// standard (11 bit) CAN messages
// if desired to access other than CAN 3 can change channel and do the same process

IF GPS_FIRST_TIME THEN
	GPS_FIRST_TIME := FALSE;
	SysTimeGetUs(LAST_TX_100MS); 
	SysTimeGetUs(GPS_CURRENT_TIME_US); 
END_IF

//ensure we check at least once to update RX_AVAILABLE
GPS_RX_AVAILABLE := 1;

// change values so it's apparent values need updating
IF GPS_VENDOR_LAST <> GPS_VENDOR_VALUE THEN 
	GPS_VENDOR_LAST := GPS_VENDOR_VALUE;
	GPS_AXES[GPS_HEADING].OFFSET := 77.7;
	GPS_AXES[GPS_X].OFFSET := 7777;
	GPS_AXES[GPS_Y].OFFSET := 7777;
	GPS_AXES[GPS_Z].OFFSET := 7777;
ELSIF GPS_VENDOR_VALUE = 0 THEN
	GPS_AXES[GPS_HEADING].OFFSET := 66.6;
	GPS_AXES[GPS_X].OFFSET := 666;
	GPS_AXES[GPS_Y].OFFSET := 666;
	GPS_AXES[GPS_Z].OFFSET := 666;
END_IF

// Rx messages
WHILE TO_BOOL(GPS_RX_AVAILABLE) DO
	// This is looking for any standard (11 bit id: EXTENDED = FALSE) CAN messages.
	StdCan_RX_MASK3(eChannel := CHANNEL, xExtended := GPS_EXTENDED, aData => GPS_DATA_READ, usiDLC => GPS_RX_NUM, uiAvailable => GPS_RX_AVAILABLE,
		xEnable := TRUE, xERROR => GPS_CAN_RX_ERROR, eDiagInfo => GPS_RX_DIAG, udiIDset := 16#0000, udiIDmask := 16#00000000, udiID => GPS_MSG_ID);
	
	IF GPS_CAN_RX_ERROR THEN
		GPS_RX_FAIL := GPS_RX_FAIL + 1;
	ELSIF GPS_RX_AVAILABLE <> 0 THEN
		GPS_CAN_RX_LAST := MSTIME;
		GPS_CAN_RX_MSGS := GPS_CAN_RX_MSGS + 1 ;
		IF GPS_VENDOR_VALUE = 1 THEN // STONEX 
			// receive from StonEx
			IF GPS_MSG_ID = 16#192 THEN // requires receipt at CubeSP of 0x194 - transmitted below
				// sometimes get 2#1000 0000 0000 0000 (or [0, 128] from StonEx. disregard these spurious values. 
				// StonEx engineers say it happens when there isn't a targeted point available, but it also happens at other times.
				IF GPS_DATA_READ[1] <> 128 THEN 
					//GPS_AXES[GPS_Z].OFFSET := -1 * ByteArrayToReal(2,1,1,1,0,ADR(GPS_DATA_READ[0])); // z offset raw value in mm
					GPS_OFFSETS[GPS_Z] := -1 * ByteArrayToReal(2,1,1,1,0,ADR(GPS_DATA_READ[0])); // z offset raw value in mm
				END_IF
				IF GPS_DATA_READ[3] <> 128 THEN // heading offset raw value in tenths of a degree, ccw sent as positive
					//GPS_AXES[GPS_HEADING].OFFSET := ByteArrayToReal(2,1,1,0.1,0,ADR(GPS_DATA_READ[2])); 
					GPS_OFFSETS[GPS_HEADING] := ByteArrayToReal(2,1,1,0.1,0,ADR(GPS_DATA_READ[2])); 
				END_IF
				GPS_ABSOLUTE_HEADING := ByteArrayToReal(2,1,1,0.1,0,ADR(GPS_DATA_READ[4])) - 90.0;
				IF GPS_ABSOLUTE_HEADING < 0 THEN
					GPS_ABSOLUTE_HEADING := GPS_ABSOLUTE_HEADING + 360;
				END_IF
				
			
			ELSIF GPS_MSG_ID = 16#7D THEN // 125
				IF GPS_DATA_READ[1] <> 128 THEN 
					//GPS_AXES[GPS_Y].OFFSET := ByteArrayToReal(2, 1, 1, 1, 0, ADR(GPS_DATA_READ[0]));
					GPS_OFFSETS[GPS_Y] := ByteArrayToReal(2, 1, 1, 1, 0, ADR(GPS_DATA_READ[0]));
				END_IF
				IF GPS_DATA_READ[4] <> 128 THEN 
					//GPS_AXES[GPS_X].OFFSET := ByteArrayToReal(2, 1, 1, 1, 0, ADR(GPS_DATA_READ[3])); // 
					GPS_OFFSETS[GPS_X] := ByteArrayToReal(2, 1, 1, 1, 0, ADR(GPS_DATA_READ[3])); // 
					//*)
					(* if not using StonEx feedback to correct offsets
					IF (pNVM3^.PRODUCT_INSTALL = eProductType.PRODUCT_NXT) AND // can't use isNxt3lmNsScrew because latches not set until screw mode
						(getTrussType() = eTrussType.TRUSS_TYPE_CENTER_STRUCTURE) AND
						(getScrewSide() = eScrewSide.SCREW_CENTER) THEN
							
							IF (MACHINE_MODE = RWP_MODE) AND (RWP_STATE = RWP_STATE_SQUARE_YAW OR RWP_STATE = RWP_STATE_WAIT_LEVEL OR
								RWP_STATE = RWP_STATE_LOCATE_WP) THEN // don't update in track mode!
									NXT_MOTOR_THIRD_LEG_ANGLE := 20 + TRACKER_ROW_TYPE_VALUE * 15;
									NXT_MOTOR_TOP_OF_MOUNT := 182 + ( AXES[AXIS_Z_SLIDE].FEEDBACK.POSITION_ENGR - Z_SLIDE_RWP_POS ); // rwp entry default measured at 183.5 cm on flat ground
									// 230.124 is cm from ground to pitch pivot pin; 110.2792 is cm vertically from truss wp to 3rd leg wp; 61 corrects difference between standard and heavy
									// 93.472 is cm from pitch pivot pin to drill rod center axis
									NXT_MOTOR_THIRD_LEG_X_ADJUST := TAN_DEG( NXT_MOTOR_THIRD_LEG_ANGLE ) * ( 230.124 - NXT_MOTOR_TOP_OF_MOUNT  - ( 110.2792 - TRACKER_ROW_TYPE_VALUE * 61) ) 
																	+ 93.472 * ( 1 / COS_DEG( NXT_MOTOR_THIRD_LEG_ANGLE )  - 1 );							
							END_IF
						// rotate to world frame, add offset to x, rotate back to TD frame
						RotateGpsTdToWorldNS( X_TD := GPS_AXES[GPS_X].OFFSET, Y_TD := GPS_AXES[GPS_Y].OFFSET, YAW_BEGIN := GPS_AXES[GPS_HEADING].OFFSET,
											  X_WORLD => GPS_AXES[GPS_X].OFFSET, Y_WORLD => GPS_AXES[GPS_Y].OFFSET );
						GPS_AXES[GPS_X].OFFSET := GPS_AXES[GPS_X].OFFSET + NXT_MOTOR_THIRD_LEG_X_ADJUST * 10; // convert cm to mm
						RotateGpsTdToWorldNS( X_TD := GPS_AXES[GPS_X].OFFSET, Y_TD := GPS_AXES[GPS_Y].OFFSET, YAW_BEGIN := -GPS_AXES[GPS_HEADING].OFFSET,
											  X_WORLD => GPS_AXES[GPS_X].OFFSET, Y_WORLD => GPS_AXES[GPS_Y].OFFSET );
					END_IF //*)
				END_IF
				
				GPS_VELOCITY := (SHL(TO_INT(GPS_DATA_READ[7]), 8) + GPS_DATA_READ[6]);  

			ELSIF GPS_MSG_ID = 16#83 THEN  // information related to gps signal (# satelites, VRMS,HRMS,PDOP); status of StonEx application software - "Stakeout" mode or other
				IF (GPS_DATA_READ[5] = 4) THEN // 0 = No fix; 1 = single; 2 = DGNSS; 3 = FLOAT; 4 = Fixed
					GPS_RTK_FIXED := TRUE; 
					GPS_CAN_REQUEST := TRUE; // if gps reliable then send 194 message (Z data) to get 192 in return
				ELSE 
					GPS_RTK_FIXED := FALSE; 
				END_IF
				GPS_RTK_SIGNAL_DELAY := GPS_DATA_READ[2]; // rtk radio signal delay in seconds
				GPS_NUM_SAT := GPS_DATA_READ[3]; // number of locked satelites
				GPS_HRMS := GPS_DATA_READ[4]; // Horizontal rms precision error
				GPS_VRMS := GPS_DATA_READ[6]; // vertical rms precision error
				GPS_PDOP := TO_REAL(GPS_DATA_READ[7])/10; // Position Dilution of Precision
				IF GPS_RTK_SIGNAL_DELAY = 0 OR GPS_HRMS = 0 OR GPS_VRMS = 0 THEN // if reading 0 it likely is not receiving the rtk signal
					GPS_RTK_SIGNAL_DELAY := 86;
					GPS_HRMS := 86;
					GPS_VRMS := 86;
				END_IF
			// PNEZD
			ELSIF GPS_MSG_ID = 16#47F THEN // P - Point info
				 // read serial # and put data in that line
				IF (GPS_DATA_READ[7] > MAX_NUMBER_PNEZD_POLE_ID_MSGS - 1) AND GPS_DATA_READ[7] <> 255 THEN
					MSG_LONG_ERROR_POLE := MAX(MSG_LONG_ERROR_POLE, GPS_DATA_READ[7]); // TODO: some kind of flag
				ELSE
					IF PNEZD_TEXT_RESET THEN
						// decode message
						FOR i := 0 TO 6 DO
							GPS_P_MSGS[MIN(MAX_NUMBER_PNEZD_POLE_ID_MSGS - 1, GPS_DATA_READ[7])][i] := TO_BYTE(GPS_DATA_READ[i]);
						END_FOR
						PNEZD_PD_RX_CTR := PNEZD_PD_RX_CTR + 1; // TODO: more accurate method than this
						IF PNEZD_PD_RX_CTR = 20 THEN
							PNEZD_PD_RX_CTR := 0;
							PNEZD_TEXT_RESET := FALSE;
							GPS_PNEZD_D := ''; // create blank slate
							FOR i := 0 TO MAX_NUMBER_PNEZD_D_MSGS - 1 DO
								GPS_PNEZD_D := CONCAT(GPS_PNEZD_D, GPS_D_MSGS[i]);
								GPS_D_MSGS[i] := ''; 
							END_FOR
							GPS_PNEZD_P := '';
							FOR i := 0 TO MAX_NUMBER_PNEZD_POLE_ID_MSGS - 1 DO
								GPS_PNEZD_P := CONCAT(GPS_PNEZD_P, GPS_P_MSGS[i]);
								GPS_P_MSGS[i] := ''; 
							END_FOR
						END_IF
					ELSE
						// check to see if message changed and set flag to decode
						FOR i := 0 TO 6 DO
							IF GPS_P_MSGS[MIN(MAX_NUMBER_PNEZD_POLE_ID_MSGS - 1, GPS_DATA_READ[7])][i] <> TO_BYTE(GPS_DATA_READ[i]) THEN 
								// write values and reset:
								
								PNEZD_TEXT_RESET := TRUE;
								i := 6;
							END_IF
						END_FOR
					END_IF
				END_IF 
				
			// convert mm to m
			ELSIF GPS_MSG_ID = 16#27F THEN // N - Northing
				GPS_PNEZD_N := ByteArrayToReal(8, 1, 1, 0.001, 0, ADR(GPS_DATA_READ[0])); 
			ELSIF GPS_MSG_ID = 16#17F THEN // E - Easting
				GPS_PNEZD_E := ByteArrayToReal(8, 1, 1, 0.001, 0, ADR(GPS_DATA_READ[0]));
			ELSIF GPS_MSG_ID = 16#37F THEN // Z - elevation/height
				GPS_PNEZD_Z := ByteArrayToReal(4, 1, 1, 0.001, 0, ADR(GPS_DATA_READ[0]));
				
			ELSIF GPS_MSG_ID = 16#47E THEN // D - Description
				
				IF GPS_DATA_READ[7] > MAX_NUMBER_PNEZD_D_MSGS - 1 AND GPS_DATA_READ[7] <> 255 THEN
					MSG_LONG_ERROR_DESC := MAX(MSG_LONG_ERROR_DESC, GPS_DATA_READ[7]); ; // TODO: some kind of flag
				ELSE
					IF PNEZD_TEXT_RESET THEN
						// write new message
						FOR i := 0 TO 6 DO
							GPS_D_MSGS[MIN(MAX_NUMBER_PNEZD_D_MSGS - 1, GPS_DATA_READ[7])][i] := TO_BYTE(GPS_DATA_READ[i]);
						END_FOR
					END_IF
						
				END_IF 
			END_IF
		
		ELSIF GPS_VENDOR_VALUE = 2 THEN // Trimble
			//;(*
			//Trimble (sent every 100ms):
			IF GPS_MSG_ID = 16#19E THEN // TPDO 1
				GPS_TRIMBLE_STATE := (SHL(TO_INT(GPS_DATA_READ[1]), 8) + GPS_DATA_READ[0]); // 00 = No GNSS ; 01 = ok; 10 = ERROR; 11 not used
			ELSIF GPS_MSG_ID = 16#29E THEN // TPDO 2
				GPS_AXES[GPS_Z].OFFSET := TO_REAL((SHL(TO_INT(GPS_DATA_READ[1]), 8) + GPS_DATA_READ[0])); // raw value in mm - remaining distance
				GPS_TRIMBLE_DELTA_ROLL_MAST := TO_REAL(SHL(TO_INT(GPS_DATA_READ[3]), 8) + GPS_DATA_READ[2])/100.0; // raw value +/- deg X 100
				GPS_TRIMBLE_DELTA_PITCH_MAST := TO_REAL(SHL(TO_INT(GPS_DATA_READ[5]), 8) + GPS_DATA_READ[4])/100.0; // raw value +/- deg X 100
			ELSIF GPS_MSG_ID = 16#39E THEN // TPDO 3
				GPS_AXES[GPS_X].OFFSET := (SHL(TO_INT(GPS_DATA_READ[1]), 8) + GPS_DATA_READ[0])*10;  // raw value in cm - convert to mm
				GPS_AXES[GPS_Y].OFFSET := (SHL(TO_INT(GPS_DATA_READ[3]), 8) + GPS_DATA_READ[2])*10;  // raw value in cm - convert to mm
				(*
				IF isNxt3lmNsScrew() THEN
					NXT_MOTOR_THIRD_LEG_ANGLE := 20 + TRACKER_ROW_TYPE_VALUE * 15;
					NXT_MOTOR_TOP_OF_MOUNT := 185.5 + ( AXES[AXIS_Z_SLIDE].FEEDBACK.POSITION_ENGR - Z_SLIDE_RWP_POS ); // rwp entry default measured at 185.5 cm on flat ground
					NXT_MOTOR_THIRD_LEG_X_ADJUST := TAN_DEG( NXT_MOTOR_THIRD_LEG_ANGLE ) * ( 230.124 - NXT_MOTOR_TOP_OF_MOUNT  - ( 104.379 - TRACKER_ROW_TYPE_VALUE * 61) ) 
													+ 93.472 * ( 1 / COS_DEG( NXT_MOTOR_THIRD_LEG_ANGLE )  - 1 );							
					GPS_AXES[GPS_X].OFFSET := GPS_AXES[GPS_X].OFFSET + NXT_MOTOR_THIRD_LEG_X_ADJUST;
				END_IF
				//*)
				//MSG_5 := ArrayOfUsintsToLWORD(8,1,GPS_DATA_READ);
			ELSIF GPS_MSG_ID = 16#19F THEN // TPDO 5
				GPS_PNEZD_N := ByteArrayToReal(8, 1, 0, 1, 0, ADR(GPS_DATA_READ)); // coordinate in mm 
				//MSG_6 := ArrayOfUsintsToLWORD(8,1,GPS_DATA_READ); // ***** debug *****
			ELSIF GPS_MSG_ID = 16#29F THEN // TPDO 6
				GPS_PNEZD_E := ByteArrayToReal(8, 1, 0, 1, 0, ADR(GPS_DATA_READ)); // coordinate in mm ***** signed 2's on or off??*****
				//MSG_15 := ArrayOfUsintsToLWORD(8,1,GPS_DATA_READ); // ***** debug *****
			ELSIF GPS_MSG_ID = 16#39F THEN // TPDO 7
				GPS_PNEZD_Z := ByteArrayToReal(8, 1, 1, 1, 0, ADR(GPS_DATA_READ)); // coordinate in mm ***** signed 2's on or off??*****
				GPS_AXES[GPS_HEADING].OFFSET := TO_INT(SHL(TO_INT(GPS_DATA_READ[3]), 8) + GPS_DATA_READ[2])*0.01; // raw heading in degrees * 100
				//MSG_16 := ArrayOfUsintsToLWORD(8,1,GPS_DATA_READ); // ***** debug *****
			ELSE
				GPS_OTHER_RX_SUCCESS := GPS_OTHER_RX_SUCCESS + 1;
			END_IF
		 
		// Ojjo protocol - RDO Carlsen, ..	
		ELSIF GPS_VENDOR_VALUE = 3 THEN 
			// receive Ojjo protocol
			IF GPS_MSG_ID = 16#1BC THEN // offsets
				GPS_OFFSETS[1] := ByteArrayToReal(2,1,1,0.1,0,ADR(GPS_DATA_READ[0])); 
 				GPS_OFFSETS[2] := ByteArrayToReal(2,1,1,1,0,ADR(GPS_DATA_READ[2])); 
				GPS_OFFSETS[3] := ByteArrayToReal(2,1,1,1,0,ADR(GPS_DATA_READ[4])); 
				GPS_OFFSETS[4] := ByteArrayToReal(2,1,1,1,0,ADR(GPS_DATA_READ[6])); 
				
				(*	
				GPS_ABSOLUTE_HEADING := ByteArrayToReal(2,1,1,0.1,0,ADR(GPS_DATA_READ[4])) - 90.0;
				IF GPS_ABSOLUTE_HEADING < 0 THEN
					GPS_ABSOLUTE_HEADING := GPS_ABSOLUTE_HEADING + 360;
				END_IF
				*)
				
			ELSIF GPS_MSG_ID = 16#2BC THEN // GPS quality info and compass heading
				IF (GPS_DATA_READ[0] = 4) THEN // 0 = No fix; 1 = single; 2 = DGNSS; 3 = FLOAT; 4 = Fixed
					GPS_RTK_FIXED := TRUE; 
					GPS_CAN_REQUEST := TRUE; // if gps reliable then send 194 message (Z data) to get 192 in return
				ELSE 
					GPS_RTK_FIXED := FALSE; 
				END_IF
				GPS_RTK_SIGNAL_DELAY := GPS_DATA_READ[1]; // rtk radio signal delay in seconds
				GPS_NUM_SAT := GPS_DATA_READ[2]; // number of locked satelites
				GPS_HRMS := GPS_DATA_READ[3]; // Horizontal rms precision error
				GPS_VRMS := GPS_DATA_READ[4]; // vertical rms precision error
				GPS_PDOP := TO_REAL(GPS_DATA_READ[5])/10; // Position Dilution of Precision
				IF GPS_RTK_SIGNAL_DELAY = 0 OR GPS_HRMS = 0 OR GPS_VRMS = 0 THEN // if reading 0 it likely is not receiving the rtk signal
					GPS_RTK_SIGNAL_DELAY := 86;
					GPS_HRMS := 86;
					GPS_VRMS := 86;
				END_IF
			// PNEZD
			ELSIF GPS_MSG_ID = 16#3BC THEN // P - Point info
				 // read serial # and put data in that line
				IF (GPS_DATA_READ[7] > MAX_NUMBER_PNEZD_POLE_ID_MSGS - 1) AND GPS_DATA_READ[7] <> 255 THEN
					MSG_LONG_ERROR_POLE := MAX(MSG_LONG_ERROR_POLE, GPS_DATA_READ[7]); // TODO: some kind of flag
				ELSE
					IF PNEZD_TEXT_RESET THEN
						// decode message
						FOR i := 0 TO 6 DO
							GPS_P_MSGS[MIN(MAX_NUMBER_PNEZD_POLE_ID_MSGS - 1, GPS_DATA_READ[7])][i] := TO_BYTE(GPS_DATA_READ[i]);
						END_FOR
						PNEZD_PD_RX_CTR := PNEZD_PD_RX_CTR + 1; // TODO: more accurate method than this
						IF PNEZD_PD_RX_CTR = 20 THEN
							PNEZD_PD_RX_CTR := 0;
							PNEZD_TEXT_RESET := FALSE;
							GPS_PNEZD_D := ''; // create blank slate
							FOR i := 0 TO MAX_NUMBER_PNEZD_D_MSGS - 1 DO
								GPS_PNEZD_D := CONCAT(GPS_PNEZD_D, GPS_D_MSGS[i]);
								GPS_D_MSGS[i] := ''; 
							END_FOR
							GPS_PNEZD_P := '';
							FOR i := 0 TO MAX_NUMBER_PNEZD_POLE_ID_MSGS - 1 DO
								GPS_PNEZD_P := CONCAT(GPS_PNEZD_P, GPS_P_MSGS[i]);
								GPS_P_MSGS[i] := ''; 
							END_FOR
						END_IF
					ELSE
						// check to see if message changed and set flag to decode
						FOR i := 0 TO 6 DO
							IF GPS_P_MSGS[MIN(MAX_NUMBER_PNEZD_POLE_ID_MSGS - 1, GPS_DATA_READ[7])][i] <> TO_BYTE(GPS_DATA_READ[i]) THEN 
								// write values and reset:
								
								PNEZD_TEXT_RESET := TRUE;
								i := 6;
							END_IF
						END_FOR
					END_IF
				END_IF 
				
			// convert mm to m
			ELSIF GPS_MSG_ID = 16#4BC THEN // N - Northing
				GPS_PNEZD_N := ByteArrayToReal(8, 1, 1, 0.001, 0, ADR(GPS_DATA_READ[0])); 
			ELSIF GPS_MSG_ID = 16#5BC THEN // E - Easting
				GPS_PNEZD_E := ByteArrayToReal(8, 1, 1, 0.001, 0, ADR(GPS_DATA_READ[0]));
			ELSIF GPS_MSG_ID = 16#6BC THEN // Z - elevation/height
				GPS_PNEZD_Z := ByteArrayToReal(4, 1, 1, 0.001, 0, ADR(GPS_DATA_READ[0]));
			ELSIF GPS_MSG_ID = 16#7BC THEN // D - Description
				
				IF GPS_DATA_READ[7] > MAX_NUMBER_PNEZD_D_MSGS - 1 AND GPS_DATA_READ[7] <> 255 THEN
					MSG_LONG_ERROR_DESC := MAX(MSG_LONG_ERROR_DESC, GPS_DATA_READ[7]); ; // TODO: some kind of flag
				ELSE
					IF PNEZD_TEXT_RESET THEN
						// write new message
						FOR i := 0 TO 6 DO
							GPS_D_MSGS[MIN(MAX_NUMBER_PNEZD_D_MSGS - 1, GPS_DATA_READ[7])][i] := TO_BYTE(GPS_DATA_READ[i]);
						END_FOR
					END_IF
						
				END_IF 
			END_IF
		END_IF
	END_IF
END_WHILE

// Tx messages
IF GPS_VENDOR_VALUE > 0 THEN 

	GPS_CAN_TX_REQUEST := TRUE;

	FOR GPS_INDEX := 1 TO GPS_NUM_TX_MSGS DO

		FOR GPS_SUBINDEX := 0 TO 7 DO // reset the data for a clean slate
			GPS_DATA_WRITE[GPS_SUBINDEX] := 0; // 68 for debug (44 in hex) for debugging.
		END_FOR
		SysTimeGetUs(GPS_CURRENT_TIME_US);
		
		IF pNVM4^.GPS_VENDOR = 1 THEN
			// emulate StonEx inclinometer with 1A0 and 2A0 messages at 25ms			
			// send 0x194 - this should be unnecessary after StonEx update - z differential. for now send 0's
			
			// check if it's time to send a message
	
			CASE GPS_INDEX OF
				
				// 25 ms messages - just sending every cycle ~ every 20ms
			//	(* emulating stonex inclinometer
				1:  
					GPS_TX_MSG_ID := 16#1A0; 
					GPS_TX_MSG_BYTES := 3;
					//MAST_XSLOPE_AS_INT := TO_INT( PITCH_ANGLE * 100 );
					//MAST_XSLOPE_AS_INT := TO_INT( MAST_PITCH.POSITION_ENGR * -100); // convert to hundredths of degree and change sign to match StonEx math
					MAST_XSLOPE_AS_INT := TO_INT(CORRECTED_MAST_PITCH * -100); // convert to hundredths of degree and change sign to match StonEx math
					GPS_DATA_WRITE[0] := TO_USINT(MAST_XSLOPE_AS_INT); // (X slope LSB)
					GPS_DATA_WRITE[1] := TO_USINT(SHR(MAST_XSLOPE_AS_INT,8)); // (X slope MSB)
					GPS_DATA_WRITE[2] := 0; 
			
					//*)
				(*  // original instruction from StonEx to bypass their inclinometer.  Tried it with new
						set up and it didn't work.
				1:
					TX_MSG_ID := 16#81;
					TX_MSG_BYTES := 8;
					
					MAST_XSLOPE_AS_INT := TO_INT(MAST_PITCH.POSITION_ENGR * 100); //34;//22 in hex> 
					MAST_YSLOPE_AS_INT := TO_INT(AXES[AXIS_ROTATOR].FEEDBACK.POSITION_ENGR * 100); //51;//33 in hex>
				
					GPS_DATA_WRITE[0] := TO_USINT(MAST_XSLOPE_AS_INT AND 16#FF); // (X slope LSB)
					GPS_DATA_WRITE[1] := TO_USINT((SHR(MAST_XSLOPE_AS_INT,8)) AND 16#FF); // (X slope MSB)
					GPS_DATA_WRITE[3] := TO_USINT(MAST_YSLOPE_AS_INT AND 16#FF);  // (Y slope LSB)
					GPS_DATA_WRITE[4] := TO_USINT((SHR(MAST_YSLOPE_AS_INT,8)) AND 16#FF); // (Y slope MSB)
					//STONEX_TX_COUNT := STONEX_TX_COUNT +1; // for debugging
					CASE_1_CTR := CASE_1_CTR +1;
					i := 3;
				//*)	
				2: // emulating stonex inclinometer
					//(*
					GPS_TX_MSG_ID := 16#2A0; // rotator angle correlates to y-slope 
					GPS_TX_MSG_BYTES := 3;
					//MAST_YSLOPE_AS_INT := -1*TO_INT(AXES[AXIS_ROTATOR].FEEDBACK.POSITION_ENGR * 100);
					MAST_YSLOPE_AS_INT := TO_INT(AXES[AXIS_ROTATOR].FEEDBACK.POSITION_ENGR * -100); // convert to hundredths of degree and change sign to match StonEx math
					GPS_DATA_WRITE[0] := TO_USINT(MAST_YSLOPE_AS_INT);  // (Y slope LSB)
					GPS_DATA_WRITE[1] := TO_USINT(SHR(MAST_YSLOPE_AS_INT,8)); // (Y slope MSB)
					GPS_DATA_WRITE[2] := 0; 
					//debug_msgs[18] := ArrayOfUsintsToLWORD(8,1,GPS_DATA_WRITE);
					//*)
					
				// 50 ms messages - send every other cycle ~ 40ms
				3:
					// send #194 info to StonEx every 50ms to get #192 with heading and z offset 
					(* this emulates StonEx original use case where the tool position changes relative to the antenna.  
					   For Ojjo TD's this only happens when the wp moves relative to the z-slide, as in the case of going to crimping.  
					   StonEx software expects this message before it will return Z and heading offset message (#192)
					*)
					//IF EVERY_OTHER_CYCLE THEN // should be able to send every other cycle, but if we do, the y offset bounces by ~20 mm.  Why????
						GPS_TX_MSG_ID := 16#194; 
						GPS_TX_MSG_BYTES := 8;
						// adjust z offset 	
						// Stonex z offset assumes it's along the mast, so we are converting to an absolute (world/pNEZd) frame offset:
						PNEZD_ADJUST_Z := TO_INT(PNEZD_ADJUST_Z / (COS_DEG(MAST_PITCH.POSITION_ENGR)) * COS_DEG(AXES[AXIS_ROTATOR].FEEDBACK.POSITION_ENGR));		
						GPS_DATA_WRITE[3] := TO_USINT(PNEZD_ADJUST_Z);  // (Y slope LSB)
						GPS_DATA_WRITE[4] := TO_USINT(SHR(PNEZD_ADJUST_Z, 8)); // (Y slope MSB)
						GPS_CAN_TX_REQUEST := TRUE;
						//debug_msgs[17] := ArrayOfUsintsToLWORD(8,1,GPS_DATA_WRITE);
					//END_IF
				4:
					IF EVERY_OTHER_CYCLE THEN
						GPS_TX_MSG_ID := 16#74; // to StonEx to adjust Easting position of PNEZD for 3rd leg positioning
						GPS_TX_MSG_BYTES := 8;
						FOR GPS_SUBINDEX := 0 TO 7 DO // TODO this is redundant - delete and confirm no effect
							GPS_DATA_WRITE[GPS_SUBINDEX] := 0;
						END_FOR
						GPS_DATA_WRITE[0] := TO_USINT(98); // data id FOR StonEx 
																			
// 								IF is3lmEwAdjustNeeded()  THEN
// 									GPS_THIRD_LEG_ADJUST_ON := TRUE;
// // 									// adjust Easting
// // 									GPS_THIRD_LEG_ADJUST_ON := TRUE;
// // 									GPS_DATA_WRITE[1] := TO_USINT(GPS_ADJUST_EASTING); // dE (LSB)
// // 									GPS_DATA_WRITE[2] := TO_USINT(SHR(GPS_ADJUST_EASTING, 8));  // dE
// // 									GPS_DATA_WRITE[3] := TO_USINT(SHR(GPS_ADJUST_EASTING, 16)); // dE (MSB)
// // 									// adjust Northing
// // 									GPS_DATA_WRITE[4] := 0; // dN (LSB)
// // 									GPS_DATA_WRITE[5] := 0; // dN
// // 									GPS_DATA_WRITE[6] := 0; // dN (MSB) //*)
// 									//debug_msgs[6] := ArrayOfUsintsToLWORD(8,0,GPS_DATA_WRITE);
// 								ELSE // reset offsets to 0
// 									//debug_msgs[7] := ArrayOfUsintsToLWORD(8,0,GPS_DATA_WRITE);
// 									GPS_THIRD_LEG_ADJUST_ON := FALSE;
// 									
// 								END_IF
						// adjust Easting
						
						GPS_DATA_WRITE[1] := TO_USINT(PNEZD_ADJUST_EASTING); // dE (LSB)
						GPS_DATA_WRITE[2] := TO_USINT(SHR(PNEZD_ADJUST_EASTING, 8));  // dE
						GPS_DATA_WRITE[3] := TO_USINT(SHR(PNEZD_ADJUST_EASTING, 16)); // dE (MSB)
						// adjust Northing
						GPS_DATA_WRITE[4] := TO_USINT(PNEZD_ADJUST_NORTHING); // dN (LSB)
						GPS_DATA_WRITE[5] := TO_USINT(SHR(PNEZD_ADJUST_NORTHING, 8));  // dN
						GPS_DATA_WRITE[6] := TO_USINT(SHR(PNEZD_ADJUST_NORTHING, 16)); // dN (MSB)
						GPS_CAN_TX_REQUEST := TRUE;
						EVERY_OTHER_CYCLE := FALSE;
					ELSE
						EVERY_OTHER_CYCLE := TRUE;
						GPS_CAN_TX_REQUEST := FALSE;
					END_IF 
					
			END_CASE

		ELSIF GPS_VENDOR_VALUE = 2 THEN
		//Have to send some combo of 21e, 31e, 41e to get response (determined by trial and error)
			GPS_NUM_TX_MSGS := 3;
			IF ((GPS_CURRENT_TIME_US - LAST_TX_100MS) > GPS_TIME_INTERVAL_100MS) THEN
				CASE GPS_INDEX OF
					1:
						GPS_TX_MSG_ID := 16#21E;  // RPDO 1
						GPS_TX_MSG_BYTES := 8;
						MAST_XSLOPE_AS_INT := TO_INT(MAST_PITCH.POSITION_ENGR * 100); 
						GPS_DATA_WRITE[4] := TO_USINT(MAST_XSLOPE_AS_INT); // (X slope LSB)
						GPS_DATA_WRITE[5] := TO_USINT(SHR(MAST_XSLOPE_AS_INT,8)); // (X slope MSB)
						MAST_YSLOPE_AS_INT := TO_INT(AXES[AXIS_ROTATOR].FEEDBACK.POSITION_ENGR * 100);
						GPS_DATA_WRITE[2] := TO_USINT(MAST_YSLOPE_AS_INT);  // (Y slope LSB)
						GPS_DATA_WRITE[3] := TO_USINT(SHR(MAST_YSLOPE_AS_INT,8)); // (Y slope MSB)

					// *** formulate message ***
					// put data in appropriate place
					2:
						GPS_TX_MSG_ID := 16#31E;  // RPDO 2
						GPS_TX_MSG_BYTES := 8;
						FOR GPS_SUBINDEX := 0 TO 7 DO
							GPS_DATA_WRITE[GPS_SUBINDEX] := 2;
						END_FOR
					// send message
					3:
						GPS_TX_MSG_ID := 16#41E;  // RPDO 3
						GPS_TX_MSG_BYTES := 8;
						FOR GPS_SUBINDEX := 0 TO 7 DO
							GPS_DATA_WRITE[GPS_SUBINDEX] := 1;
						END_FOR
						GPS_CAN_TX_REQUEST := FALSE;
				END_CASE
			END_IF
			
		ELSIF GPS_VENDOR_VALUE = 3 THEN // Ojjo protocol 
		
			CASE GPS_INDEX OF
				
				// 25 ms messages - just sending every cycle ~ every 20ms
				//	mast tilt correction info
				1:  
					GPS_TX_MSG_ID := 16#1AD; 
					GPS_TX_MSG_BYTES := 8;
					
					// mast pitch
// 					MAST_XSLOPE_AS_INT := TO_INT( MAST_PITCH.POSITION_ENGR * 100); // convert to hundredths of degree and change sign to match StonEx math
					MAST_XSLOPE_AS_INT := TO_INT( CORRECTED_MAST_PITCH * 100); // convert to hundredths of degree and change sign to match StonEx math
				
					GPS_DATA_WRITE[0] := TO_USINT(MAST_XSLOPE_AS_INT); // (X slope LSB)
					GPS_DATA_WRITE[1] := TO_USINT(SHR(MAST_XSLOPE_AS_INT,8)); // (X slope MSB)
				
					// mast roll
					MAST_YSLOPE_AS_INT := TO_INT(AXES[AXIS_ROTATOR].FEEDBACK.POSITION_ENGR * -100); // convert to hundredths of degree and change sign to match StonEx math
					GPS_DATA_WRITE[2] := TO_USINT(MAST_YSLOPE_AS_INT);  // (Y slope LSB)
					GPS_DATA_WRITE[3] := TO_USINT(SHR(MAST_YSLOPE_AS_INT,8)); // (Y slope MSB)
									
					// z correction for mast and lower crowd not aligned with work point
					GPS_DATA_WRITE[4] := TO_USINT(PNEZD_ADJUST_Z);  // (Y slope LSB)
					GPS_DATA_WRITE[5] := TO_USINT(SHR(PNEZD_ADJUST_Z, 8)); // (Y slope MSB)
					//GPS_CAN_TX_REQUEST := TRUE;
				// 50 ms messages - send every other cycle ~ 40ms
				2: GPS_CAN_TX_REQUEST := FALSE;
				3: GPS_CAN_TX_REQUEST := FALSE;
				4:
					IF EVERY_OTHER_CYCLE OR
						(AUTOMATIC AND MACHINE_MODE = SCREW_MODE AND SCREW_STATE = SCREW_STATE_CRIMP AND isScrewModeStateChange()) THEN
						//IF is3lmEwAdjustNeeded() THEN //OR RESET_OFFSETS THEN
							GPS_TX_MSG_ID := 16#2AD; // to StonEx to adjust Easting position of PNEZD for 3rd leg positioning
							GPS_TX_MSG_BYTES := 8;
							FOR GPS_SUBINDEX := 0 TO 7 DO // TODO this is redundant - delete and confirm no effect
								GPS_DATA_WRITE[GPS_SUBINDEX] := 0;
							END_FOR
							// adjust Easting
							GPS_DATA_WRITE[1] := TO_USINT(PNEZD_ADJUST_EASTING); // dE (LSB)
							GPS_DATA_WRITE[2] := TO_USINT(SHR(PNEZD_ADJUST_EASTING, 8));  // dE
							GPS_DATA_WRITE[3] := TO_USINT(SHR(PNEZD_ADJUST_EASTING, 16)); // dE (MSB)
							// adjust Northing
							GPS_DATA_WRITE[4] := TO_USINT(PNEZD_ADJUST_NORTHING); // dN (LSB)
							GPS_DATA_WRITE[5] := TO_USINT(SHR(PNEZD_ADJUST_NORTHING, 8));  // dN
							GPS_DATA_WRITE[6] := TO_USINT(SHR(PNEZD_ADJUST_NORTHING, 16)); // dN (MSB)
							GPS_CAN_TX_REQUEST := TRUE;
							EVERY_OTHER_CYCLE := FALSE;
							IF (AUTOMATIC AND MACHINE_MODE = SCREW_MODE AND SCREW_STATE = SCREW_STATE_CRIMP) THEN
								GPS_DATA_WRITE[6] := TO_USINT(PLC_TRANSMIT_6.LAST_CYCLE_TIME);  // 
								GPS_DATA_WRITE[7] := TO_USINT(SHR(PLC_TRANSMIT_6.LAST_CYCLE_TIME, 8)); // 	
							END_IF
						GPS_CAN_TX_REQUEST := TRUE;
						EVERY_OTHER_CYCLE := FALSE;	
					ELSE
						EVERY_OTHER_CYCLE := TRUE;
						GPS_CAN_TX_REQUEST := FALSE;
					END_IF 
			END_CASE
		END_IF 
		
		IF GPS_CAN_TX_REQUEST THEN
			// Add to Transmit buffer
			CanMsgIdToNodeIndexSubIndex(GPS_TX_MSG_ID, NODE_ID => GPS_CAN_NODE, SUB_INDEX => GPS_CAN_SUB_INDEX, INDEX => GPS_CAN_INDEX);
			bufferMessage(GPS_CAN_NODE, GPS_CAN_INDEX, GPS_CAN_SUB_INDEX, GPS_DATA_WRITE, GPS_TX_MSG_BYTES, FALSE);
		END_IF
		
	END_FOR
END_IF

IF GPS_OFFSETS[1] = 0 AND GPS_OFFSETS[2] = 0 AND GPS_OFFSETS[3] = 0 AND GPS_OFFSETS[4] = 0 AND
	((GPS_AXES[1].OFFSET = 0 AND GPS_AXES[2].OFFSET = 0 AND GPS_AXES[3].OFFSET = 0 AND GPS_AXES[4].OFFSET = 0) 
		OR
	(GPS_AXES[1].OFFSET = 8686 AND GPS_AXES[2].OFFSET = 8686 AND GPS_AXES[3].OFFSET = 8686 AND GPS_AXES[4].OFFSET = 8686)) 
	THEN
		FOR i := 1 TO NUM_GPS_AXES DO
			GPS_AXES[i].OFFSET := 8686;
		END_FOR
	ELSE
		FOR i := 1 TO NUM_GPS_AXES DO
			GPS_AXES[i].OFFSET := GPS_OFFSETS[i];
		END_FOR
END_IF





(*
// adjust for approximate outrigger effect on x, y, and z
IF (MACHINE_MODE = TRACK_MODE) OR 
	( (MACHINE_MODE = RWP_MODE) AND 
	  ((RWP_STATE = RWP_STATE_ENTRY) OR (RWP_STATE = RWP_STATE_SELECT_OPERATION)) ) THEN // adjust for outrigger lifting machine effect on gps offsets
	GPS_AXES[GPS_HEADING].OFFSET := GPS_OFFSETS[1];
	GPS_AXES[GPS_X].OFFSET := GPS_OFFSETS[2] + ( COS_DEG ( GPS_OFFSETS[1] ) * pNVM4^.GPS_GENERAL_SETTINGS[GPS_TRACKING_X_ADJUST] );//
	GPS_AXES[GPS_Y].OFFSET := GPS_OFFSETS[3] - ( SIN_DEG ( GPS_OFFSETS[1] ) * pNVM4^.GPS_GENERAL_SETTINGS[GPS_TRACKING_X_ADJUST] );
	GPS_AXES[GPS_Z].OFFSET := GPS_OFFSETS[4] + pNVM4^.GPS_GENERAL_SETTINGS[GPS_TRACKING_Z_ADJUST] ;	
ELSE
	FOR i := 1 TO NUM_GPS_AXES DO
		GPS_AXES[i].OFFSET := GPS_OFFSETS[i];
	END_FOR
END_IF

// adjust values if A-B direction reversed
IF pNVM4^.GPS_AUTOTARGET_SELECTION.GPS_WP_AUTOTARGET_ON  THEN
	IF GPS_OFFSETS[1] > 91 THEN
		GPS_AXES[GPS_HEADING].OFFSET := GPS_OFFSETS[1] - 180;
	ELSIF GPS_OFFSETS[1] < -91 THEN
		GPS_AXES[GPS_HEADING].OFFSET := GPS_OFFSETS[1] + 180;
	END_IF
END_IF
*)
// can adjust offsets directly here
