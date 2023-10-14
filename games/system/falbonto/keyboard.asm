;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Keyboard: 0x3A00 - 0x3AFF
;;;       D0  D1  D2  D3  D4  D5  D6  D7
;;; A0 - SHL                  SHR
;;; A1 - SPC  v^      <>      CR      RUN/BRK
;;; A2 -  0   1   2   3   4   5   6   7
;;; A3 -  8   9   :   ;   <   =   >   ?
;;; A4 -      A   B   C   D   E   F   G
;;; A5 -  H   I   J   K   L   M   N   O
;;; A6 -  P   Q   R   S   T   U   V   W
;;; A7 -  X   Y   Z           ^        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P - STOP (DEBUG)
;;; Q - ENABLED (DEBUG)
;;; Left Shift - LEFT
;;; Right Shift - LEFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
KEYBOARD_A0: EQU %0011101011111110
KEYBOARD_A1: EQU %0011101011111101
KEYBOARD_A2: EQU %0011101011111011
KEYBOARD_A3: EQU %0011101011110111
KEYBOARD_A4: EQU %0011101011101111
KEYBOARD_A5: EQU %0011101011011111
KEYBOARD_A6: EQU %0011101010111111
KEYBOARD_A7: EQU %0011101001111111

KEYBOARD_D0: EQU %00000001
KEYBOARD_D1: EQU %00000010
KEYBOARD_D2: EQU %00000100
KEYBOARD_D3: EQU %00001000
KEYBOARD_D4: EQU %00010000
KEYBOARD_D5: EQU %00100000
KEYBOARD_D6: EQU %01000000
KEYBOARD_D7: EQU %10000000

KEYBOARD_DATA_I:             EQU KEYBOARD_D1
KEYBOARD_ADDRESS_INDEX1_I:   EQU 6

KEYBOARD_DATA_G:             EQU KEYBOARD_D7
KEYBOARD_ADDRESS_INDEX1_G:   EQU 5

KEYBOARD_DATA_D:             EQU KEYBOARD_D4
KEYBOARD_ADDRESS_INDEX1_D:   EQU 5

KEYBOARD_DATA_CR:            EQU KEYBOARD_D5
KEYBOARD_ADDRESS_INDEX1_CR:  EQU 2

KEY_P_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A6 )
    AND KEYBOARD_D0
    RET

KEY_Q_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A6 )
    AND KEYBOARD_D1
    RET

KEY_R_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A6 )
    AND KEYBOARD_D2
    RET

KEY_LeftShift_PRESSED_Z:          ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A0 )
    AND KEYBOARD_D0
    RET

KEY_RightShift_PRESSED_Z:          ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A0 )
    AND KEYBOARD_D5
    RET

KEY_Space_PRESSED_Z:               ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A1 )
    AND KEYBOARD_D0
    RET

KEY_RubBrk_PRESSED_Z:               ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A1 )
    AND KEYBOARD_D7
    RET

KEY_A_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A4 )
    AND KEYBOARD_D1
    RET

KEY_V_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A6 )
    AND KEYBOARD_D6
    RET

KEY_Z_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A7 )
    AND KEYBOARD_D2
    RET

KEY_T_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A6 )
    AND KEYBOARD_D4
    RET

KEY_N_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A5 )
    AND KEYBOARD_D6
    RET

KEY_K_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A5 )
    AND KEYBOARD_D3
    RET

KEY_G_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A4 )
    AND KEYBOARD_D7
    RET

KEY_D_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A4 )
    AND KEYBOARD_D4
    RET

KEY_CR_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A1 )
    AND KEYBOARD_D5
    RET

KEY_I_PRESSED_Z:                  ; Z flag = 1, ha le van nyomva
    LD A, ( KEYBOARD_A5 )
    AND KEYBOARD_D1
    RET

ANY_KEY_PRESSED_NZ_A_B1              ; Z flag = 0, ha van legalább 1 lenyomozz billentyű. A=lenyomott addat, B=AddressIndex 1-8, C=Data)
    LD B, 8
    LD A, 0
    LD HL, %0011101001111111         ; Address vonal: A7
KEY_LOOP:
    LD A, ( HL )
    CP 0xFF                          ; FF = nincs lenyomva semmi ezen a címen
    RET NZ
    SCF
    RR L                             ; CY -> 7. -> 0. -> CY
    DJNZ KEY_LOOP
    CP 0xFF
    RET

WAIT_FOR_SPACE:
    CALL KEY_Space_PRESSED_Z               ; Z flag = 1, ha le van nyomva
    JR NZ, WAIT_FOR_SPACE
    RET

KEY_G_CHECK_A_B_Z:       ; A_ban az adat B-ben a címindex 1-től HL-ben az olvasott teljes cím Z=1, ha le van nyomva
    AND KEYBOARD_DATA_G
    RET NZ
    LD A, B
    CP KEYBOARD_ADDRESS_INDEX1_G
    RET

KEY_D_CHECK_A_B_Z:       ; A_ban az adat B-ben a címindex 1-től HL-ben az olvasott teljes cím Z=1, ha le van nyomva
    AND KEYBOARD_DATA_D
    RET NZ
    LD A, B
    CP KEYBOARD_ADDRESS_INDEX1_D
    RET

KEY_CR_CHECK_A_B_Z:       ; A_ban az adat B-ben a címindex 1-től HL-ben az olvasott teljes cím Z=1, ha le van nyomva
    AND KEYBOARD_DATA_CR
    RET NZ
    LD A, B
    CP KEYBOARD_ADDRESS_INDEX1_CR
    RET
