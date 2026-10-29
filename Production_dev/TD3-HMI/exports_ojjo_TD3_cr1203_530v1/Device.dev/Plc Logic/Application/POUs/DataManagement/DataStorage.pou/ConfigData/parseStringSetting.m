
(********************** Declaration ****************************)
// only works with string size 20

METHOD parseStringSetting  : BOOL 
VAR_INPUT
    wsKey : WSTRING(255);
    secondPass : BOOL;
    xRequired : BOOL;

    (* Maximum permitted characters, excluding terminator. *)
    uiMaximumLength : UINT;

    (* Destination size in bytes, including terminator. *)
    uiDestinationCapacity : UINT;

    (* Must point to the first byte of the destination STRING. *)
    pDestination : POINTER TO BYTE;
END_VAR

VAR
    JSON_ELEMENT_LOCAL : JSON.JSONElement;
    xFound : BOOL;
    xTerminated : BOOL;
    uiLength : UINT;
    uiIndex : UINT;
    wCharacter : WORD;
END_VAR
(********************** Implementation ****************************)

parseStringSetting := TRUE;
xFound := FALSE;
xTerminated := FALSE;
uiLength := 0;


// Find and validate the JSON value.
IF NOT validateJsonValue(
    wsKey := wsKey,
    eKind := eJsonConfigValueKind.eJSON_CFG_STRING,
    xRequired := xRequired,
    xUseLimits := FALSE,
    lrMinimum := 0.0,
    lrMaximum := 0.0,
    jsonElement => JSON_ELEMENT_LOCAL,
    xFound => xFound
) THEN

    parseStringSetting := FALSE;
    RETURN;
END_IF;


// Optional key was not present.
IF NOT xFound THEN
    RETURN;
END_IF;


// No destination is needed during validation pass.
// It is required during the writing pass.
IF secondPass THEN

    IF pDestination = 0
        OR uiDestinationCapacity = 0 THEN

        parseStringSetting := FALSE;

        Data_Handling.CONFIG_STATUS_MSG :=
            Standard.CONCAT(
                TO_STRING(wsKey),
                ' has an invalid destination'
            );

        RETURN;
    END_IF;
END_IF;


// Find the WSTRING length without converting it first.
// The loop checks one character beyond the permitted length.
FOR uiIndex := 0 TO uiMaximumLength DO

    IF JSON_ELEMENT_LOCAL.value.wsValue[uiIndex] = WORD#0 THEN
        xTerminated := TRUE;
        uiLength := uiIndex;
        EXIT;
    END_IF;

END_FOR;


// No terminator means the value exceeds the allowed length.
IF NOT xTerminated THEN

    parseStringSetting := FALSE;

    Data_Handling.CONFIG_STATUS_MSG :=
        Standard.CONCAT(
            TO_STRING(wsKey),
            ' is longer than allowed'
        );

    RETURN;
END_IF;


// Confirm that the destination can hold the string
// and its null terminator.
IF secondPass
    AND (uiLength + 1 > uiDestinationCapacity) THEN

    parseStringSetting := FALSE;

    Data_Handling.CONFIG_STATUS_MSG :=
        Standard.CONCAT(
            TO_STRING(wsKey),
            ' does not fit in destination'
        );

    RETURN;
END_IF;


// Write only during the second pass.
IF secondPass THEN

    (* Handle non-empty strings. *)
    IF uiLength > 0 THEN

        FOR uiIndex := 0 TO uiLength - 1 DO

            wCharacter :=
                JSON_ELEMENT_LOCAL.value.wsValue[uiIndex];

            (* STRING is single-byte; reject non-ASCII characters. *)
            IF wCharacter > 255 THEN

                parseStringSetting := FALSE;

                Data_Handling.CONFIG_STATUS_MSG :=
                    Standard.CONCAT(
                        TO_STRING(wsKey),
                        ' contains unsupported characters'
                    );

                RETURN;
            END_IF;

            pDestination[uiIndex] :=
                TO_BYTE(wCharacter);
        END_FOR;
    END_IF;

    (* Always write the terminating zero. *)
    pDestination[uiLength] := 0;
END_IF;


// 
// parseStringSetting := TRUE;
// xFound := FALSE;
// xTerminated := FALSE;
// uiLength := 0;
// 
// 
// // Find and validate the JSON value.
// IF NOT validateJsonValue(
//     wsKey := wsKey,
//     eKind := eJsonConfigValueKind.eJSON_CFG_STRING,
//     xRequired := xRequired,
//     xUseLimits := FALSE,
//     lrMinimum := 0.0,
//     lrMaximum := 0.0,
//     jsonElement => JSON_ELEMENT_LOCAL,
//     xFound => xFound
// ) THEN
// 
//     parseStringSetting := FALSE;
//     RETURN;
// END_IF;
// 
// 
// // Optional key was not present.
// IF NOT xFound THEN
//     RETURN;
// END_IF;
// 
// 
// // Destination is only required during the writing pass.
// IF secondPass THEN
//     IF pDestination = 0
//         OR uiDestinationCapacity = 0 THEN
// 
//         parseStringSetting := FALSE;
//         Data_Handling.CONFIG_STATUS_MSG :=
//             Standard.CONCAT(
//                 TO_STRING(wsKey),
//                 ' has an invalid destination'
//             );
//         RETURN;
//     END_IF;
// END_IF;
// 
// 
// uiLength := 0;
// xTerminated := FALSE;
// 
// (* Scan through the maximum permitted character plus one. *)
// FOR uiIndex := 0 TO uiMaximumLength DO
// 
//     IF JSON_ELEMENT_LOCAL.value.wsValue[uiIndex] = WORD#0 THEN
//         xTerminated := TRUE;
//         uiLength := uiIndex;
//         EXIT;
//     END_IF;
// 
// END_FOR;
// 
// IF NOT xTerminated THEN
//     (* No terminator found within the allowed length. *)
//     parseStringSetting := FALSE;
// 
//     Data_Handling.CONFIG_STATUS_MSG :=
//         Standard.CONCAT(
//             TO_STRING(wsKey),
//             ' is longer than allowed'
//         );
// 
//     RETURN;
// END_IF;
// 
// 
// // The parsed WSTRING should contain a terminator.
// IF NOT xTerminated THEN
//     parseStringSetting := FALSE;
//     Data_Handling.CONFIG_STATUS_MSG :=
//         Standard.CONCAT(
//             TO_STRING(wsKey),
//             ' is not terminated correctly'
//         );
//     RETURN;
// END_IF;
// 
// 
// // Ensure the destination has room for the terminator.
// IF secondPass
//     AND (uiLength + 1 > uiDestinationCapacity) THEN
// 
//     parseStringSetting := FALSE;
//     Data_Handling.CONFIG_STATUS_MSG :=
//         Standard.CONCAT(
//             TO_STRING(wsKey),
//             ' does not fit in destination'
//         );
//     RETURN;
// END_IF;
// 
// 
// // Copy only the validated characters during pass two.
// IF secondPass THEN
// 
//     FOR uiIndex := 0 TO uiLength - 1 DO
// 
//         wCharacter :=
//             JSON_ELEMENT_LOCAL.value.wsValue[uiIndex];
// 
//         (* This helper supports ASCII-compatible STRING values. *)
//         IF wCharacter > 255 THEN
//             parseStringSetting := FALSE;
//             Data_Handling.CONFIG_STATUS_MSG :=
//                 Standard.CONCAT(
//                     TO_STRING(wsKey),
//                     ' contains unsupported characters'
//                 );
//             RETURN;
//         END_IF;
// 
//         pDestination[uiIndex] :=
//             TO_BYTE(wCharacter);
//     END_FOR;
// 
//     (* Add the STRING null terminator. *)
//     pDestination[uiLength] := 0;
// END_IF;