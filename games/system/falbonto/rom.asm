;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ROM_SCREEN_OFF:               EQU 0x3E00
ROM_SCREEN_ON:                EQU 0x3F00
ROM_SET_DL_A:                 EQU 0x1C50 ; 1c544   ; 1C53
ROM_SET_GL_H:                 EQU 0x1C97
;ROM_SET_GL_A:                 EQU 0x1C78 ; 1C89
;ROM_SET_GLDL_HL:              EQU 0x1C6B ; H=GL, L=DL
ROM_PRINT_V_A:                EQU 0x0028
ROM_PRINT_A:                  EQU 0x01FC
ROM_PRINT_HEX_A:              EQU 0x01A5
ROM_PRINT_HEX_DE:             EQU 0x01A0
ROM_READ_KEY_INTO_A_CY:       EQU 0x1DB1
ROM_READ_KEY_INTO_C_CY:       EQU 0x02DD   ; Beolvassa egy billlenytű kódját pittyegés nélkül, az eredmény C-be kerül CY a lenyomott gombok bitjeiből a legalsó. Egy egyedi kód, nem ASCII
ROM_PLOT_HL_A:                EQU 0x1CEF
ROM_POINT_HL_A_CY:            EQU 0x1CC0
ROM_BEEP_HL:                  EQU 0x1D84   ; H a hang hossza, L a magassága. L minél nagyobb, annál mélyebb a hang (256*H+L)
ROM_PRINT_TEXT_HL_E:          EQU 0x06E8   ; HL címről E bájt kiírása. E=0 esetén 0. Maximum E=255. Speciális karakterek értelmezése.
;ROM_PRINT_NUMBER:             EQU 0x0874   ; DCB+1E:DCB+1F szám kiírása

SCREEN_START:                 EQU 0xC001
CLEAR_GRAPHICS:               EQU 0x1D6F
SPEAKER_OUT:                  EQU 0x3C3C
MIC_IN:                       EQU 0xE000

DCB_DL_1:                     EQU 0x4008
DCB_GL_1:                     EQU 0x4009
DCB_AL_1:                     EQU 0x400A
DCB_CURSOR_POS_2:             EQU 0x4014   ; A kurzor memóriacíme 0xC001 + Y0*40 + X0
DCB_HM_2:                     EQU 0x4016   ; Grafikus memória eleje, A stack eddig tart grafikus módban
DCB_RANDOM_4:                 EQU 0x4022
DCB_STATUS_BYTE:              EQU 0x4032   ; 5. BIT = CR
DCB_FIRST_GRAPHICS_BYTE_2:    EQU 0x4033

FREE_SPACE_START:             EQU 0x4070
