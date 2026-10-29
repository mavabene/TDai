
(********************** Declaration ****************************)
METHOD screwDriveRecord_backup
VAR_INPUT
END_VAR

(********************** Implementation ****************************)
(* Errors are additive below, for instance consecutive writes can proceed without return checks, because the
	value in ERROR is ORed with each operation.  Since it is ORed, we need to set it to false each pass through. *)
ERROR := FALSE;

CASE STATE OF
	DATA_ACQ_IDLE:
		(* Idle, waiting for somebody to start driving a screw. *)
		IF LOG_DEBUG OR (MACHINE_MODE_TRANSMIT = SCREW_MODE AND SCREW_STATE_TRANSMIT = SCREW_STATE_DRIVE_SCREW) THEN
			NUM_LINES := 0;
			StateTransition(DATA_ACQ_OPEN, DATA_ERR_NONE, 'Logging...', 'Open file');
		END_IF
	DATA_ACQ_OPEN:
		(* Start by opening an output file on the HMI.  This is always named the same thing, then renamed when copied
			to the USB. *)
		DATAPOINTS := 0;
		
		(* Only switch the frequency when starting to sample. *)
		updateDivisor();
		
		(* We always want to produce a datapoint on the first pass. *)
		SAMPLE_COUNT := DATA_ACQ_FREQ_DIVISOR;
		
		(* Started to drive a screw.  Open file. *)
		IF LOG_DEBUG THEN
			ConstructFilename(ADR(SCREW_DRIVE_FILENAME), 'x', '1', TRUE);
		ELSE
			ConstructFilename(ADR(SCREW_DRIVE_FILENAME), TO_STRING(RECEIVE_1.SCREW_NUMBER_TRANSMIT), '1', TRUE);
		END_IF
		
		(* Open the output file and check the status. *)
		FH_SCREW_DRIVE := SysFileOpen(szFile := PLC_FILENAME, am := SysFile.ACCESS_MODE.AM_WRITE, pResult := ADR(ERROR_OPEN));
		IF FH_SCREW_DRIVE > 0 THEN
			(* Write the file header. *)
			ERROR := FALSE;

			ConstructMessage01();			
			Write(FH := FH_SCREW_DRIVE);
			
			ConstructMessage02();
			Write(FH := FH_SCREW_DRIVE);

			ConstructMessage10();
			Write(FH := FH_SCREW_DRIVE);
			
			ConstructMessage20();
			Write(FH := FH_SCREW_DRIVE);
			
			IF ERROR THEN
				SysFileClose(hFile := FH_SCREW_DRIVE);
				StateTransition(DATA_ACQ_WAIT, DATA_ERR_WRITE, 'Error, write', 'Stopped'); 
			ELSE
				(* Success, start logging data. *)
				StateTransition(DATA_ACQ_WRITE, DATA_ERR_NONE, 'Logging...', 'Sampling'); 
			
				(* Reset write time counters. *)
				WRITE_TIME_MAX := 0;
				WRITE_TIME_SUM := 0;
				WRITE_TIME_COUNT := 0;
			END_IF;
		ELSE
			(* Failed to open. *)
			StateTransition(DATA_ACQ_WAIT, DATA_ERR_OPEN, 'Error, open', 'Stopped');
		END_IF;
	DATA_ACQ_WRITE:
		(* Monitoring and storing data. *)
		IF (LOG_DEBUG AND NUM_LINES < NUM_POINTS) OR isScrewDriveStates(SCREW_STATE_TRANSMIT)
			THEN
			(* We are still monitoring data.  Check to see if it is time to report. *)

			SAMPLE_COUNT := SAMPLE_COUNT + 1;
			IF SAMPLE_COUNT >= DATA_ACQ_FREQ_DIVISOR THEN
				SAMPLE_COUNT := 0;
				
				(* Put one point into the output file. *)
				NUM_LINES := NUM_LINES + 1;
				DATAPOINTS := DATAPOINTS + 1;
				
				ConstructMessage11();
				Write(FH := FH_SCREW_DRIVE);
				
				// Sample GPS position if it is time.  This frequency is turned down from screw drive sample rate.
				GPS_MONITOR_COUNT := GPS_MONITOR_COUNT + 1;
				IF GPS_MONITOR_COUNT > GPS_MONITOR_DIVISOR THEN
					GPS_MONITOR_COUNT := 0;
					
					ConstructMessage14();
					Write(FH := FH_SCREW_DRIVE);
				END_IF
				
				IF ERROR THEN
					SysFileClose(hFile := FH_SCREW_DRIVE);
					StateTransition(DATA_ACQ_WAIT, DATA_ERR_WRITE, 'Error, write', 'Stopped');
				END_IF
			ELSE
				(* Not time for us to sample. *)
				;	
			END_IF;
		ELSE
			(* We have exited our screw mode, and want to close the file. *)
			LOG_DEBUG := FALSE;
			StateTransition(DATA_ACQ_CLOSE, DATA_ERR_NONE, 'Close file', 'Logging...');
		END_IF
	DATA_ACQ_CLOSE:
		(* Screw drive is over, however it went. *)
		IF (MACHINE_MODE_TRANSMIT = SCREW_MODE) AND isDoneDriveStates() THEN
			(* Put a line in saying we hit embedment. *)
			ConstructMessage12();
			Write(FH := FH_SCREW_DRIVE);
			PLC_PRG.manageUplinkData_01.bufferScrewDriveDone(1);
		ELSE
			(* Put a line in saying we did not hit embedment. *)
			ConstructMessage13();
			Write(FH := FH_SCREW_DRIVE);
			PLC_PRG.manageUplinkData_01.bufferScrewDriveDone(0);
		END_IF
		
		(* Close the file. *)
		SysFileClose(hFile := FH_SCREW_DRIVE);

		IF ERROR THEN
			StateTransition(DATA_ACQ_WAIT, DATA_ERR_WRITE, 'Error, write', 'Stopped');
		ELSE
			(* Get ready to copy the file to USB.  In true industrial equipment fashion, the fucking hardest thing to do it to COPY A FILE!
				The sequence of everything that happens here is critical, so take care when changing. *)
			StateTransition(DATA_ACQ_COPY, DATA_ERR_NONE, 'Copy to USB', 'Logging...');

			(* Prepare to execute the copy COMMAND_SCREW when the COPY state is entered on the next scan. *)
			EXEC_01.xExecute := TRUE;
			
			(* Put the falling edge for the on-delay timer used for timeout.  Make this a loooooong timeout. *)
			USB_TON_01(IN := FALSE, PT := T#120S);
		END_IF
		
	DATA_ACQ_COPY:
		(* Do we have a USB drive attached? *)
		USB_01(xEnable := TRUE, eDiagInfo => DIAG_INFO);
		
		IF USB_01.usiNumOfUSBdevice = 1 THEN
			(* Start the timeout. *)
			USB_TON_01(IN := TRUE);
			
			(* Move the hardcoded file in the PLC memory to the USB stick. *)
			COMMAND_SCREW := '';
			COMMAND_SCREW := CONCAT(COMMAND_SCREW, 'cp -R -f ');
			COMMAND_SCREW := CONCAT(COMMAND_SCREW, PLC_FILENAME);
			COMMAND_SCREW := CONCAT(COMMAND_SCREW, ' ');
			COMMAND_SCREW := CONCAT(COMMAND_SCREW, USB_01.sAccessPath);
			COMMAND_SCREW := CONCAT(COMMAND_SCREW, '/');
			COMMAND_SCREW := CONCAT(COMMAND_SCREW, DIRECTORY_SCREW_DRIVE);
			COMMAND_SCREW := CONCAT(COMMAND_SCREW, '/');
			COMMAND_SCREW := CONCAT(COMMAND_SCREW, SCREW_DRIVE_FILENAME);
			EXEC_01.sCommand := COMMAND_SCREW; 	
			
			(* Make the linux call to copy the file here.  This is async, so will be called over and over while xExecute
				is true. *)
			EXEC_01(wCmdResult => CMD1_RESULT);
			IF CMD1_RESULT <> 0 THEN
				CMD1_LAST_FAIL := CMD1_RESULT;
			END_IF
			
			(* Keep xExecute true until either DONE or ERROR come back. *)
			EXEC_01.xExecute := (EXEC_01.xExecute AND NOT(EXEC_01.xDone OR EXEC_01.xError));
			(* Check for successful copy. *)
			DATA_COPIED := (EXEC_01.xDone AND NOT(EXEC_01.xError));
			
			(* Reset the linuxCall FB to idle.  This must be called with xExecute low to put a rising edge into the FB
				to get it ready for *next* time! *)
			IF NOT EXEC_01.xExecute OR USB_TON_01.Q THEN
				EXEC_01(xExecute := FALSE);
			END_IF

			(* Success or failure checked here. *)
			IF DATA_COPIED THEN
				(* Finished. *)
				LOG_DEBUG := FALSE;
				StateTransition(DATA_ACQ_IDLE, DATA_ERR_NONE, 'Success', 'Idle');
			ELSE
				(* Timeout or error. *)
				IF USB_TON_01.Q OR EXEC_01.xError THEN
					LOG_DEBUG := FALSE;
					StateTransition(DATA_ACQ_IDLE, DATA_ERR_COPY, 'Error, copy to USB', 'Idle');
				END_IF;
			END_IF
		ELSE
			(* No USB, return to idle. *)
			LOG_DEBUG := FALSE;
			StateTransition(DATA_ACQ_IDLE, DATA_ERR_USB, 'Error, no USB', 'Idle');
		END_IF;			
	DATA_ACQ_WAIT:
		(* Couldn't open an output file, or failed to write to it.  Just wait here while the screw is being driven, and when this is done, return to idle. *)
		IF LOG_DEBUG OR ((MACHINE_MODE_TRANSMIT = SCREW_MODE) AND NOT isScrewDriveStates(SCREW_STATE_TRANSMIT))
			THEN
			(* Don't set the state here, some other failure ended us up here. *)
			LOG_DEBUG := FALSE;
			(* State transition, but keep error messages intact. *)
			StateTransition(DATA_ACQ_IDLE, RESULT, LOG_RESULT, 'Idle');
		END_IF;
END_CASE
