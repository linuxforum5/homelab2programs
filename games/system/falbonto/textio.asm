PRINT_AT_END_OF_GAME_POS:       EQU 0xC001 + 22 * 40;
PRINT_AT_STATUS_LINE_FIRST_POS: EQU 0xC001 + 24 * 40;

PRINT_AT_LEVEL_TEXT_POS:        EQU PRINT_AT_STATUS_LINE_FIRST_POS + 7

PRINT_AT_LEVEL_BCD_POS:         EQU PRINT_AT_STATUS_LINE_FIRST_POS + 18
PRINT_AT_POINT_BCD_POS:         EQU PRINT_AT_STATUS_LINE_FIRST_POS + 34
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Státuszsor különböző inicializációja
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear_status_line:
    PUSH AF
    PUSH BC
    PUSH DE
    PUSH HL
    LD HL, PRINT_AT_STATUS_LINE_FIRST_POS
    LD (HL), 32
    LD DE, PRINT_AT_STATUS_LINE_FIRST_POS + 1
    LD BC, 39 ; 79
    LDIR
    POP HL
    POP DE
    POP BC
    POP AF
    RET

PRINT_AT_PLAYER_LEVEL_TEXT:
    LD HL, PLAYER_LEVEL_TEXT
    LD BC, LEVEL_TEXT_LENGTH
    LD DE, PRINT_AT_LEVEL_TEXT_POS
    LDIR
    RET

PRINT_AT_DEMO_LEVEL_TEXT:
    LD HL, DEMO_LEVEL_TEXT
    LD BC, LEVEL_TEXT_LENGTH
    LD DE, PRINT_AT_LEVEL_TEXT_POS
    LDIR
    RET

PRINT_AT_TRAINING_LEVEL_TEXT:
    LD HL, TRAINING_LEVEL_TEXT
    LD BC, LEVEL_TEXT_LENGTH
    LD DE, PRINT_AT_LEVEL_TEXT_POS
    LDIR
    RET

LEVEL_TEXT_LENGTH:   EQU 20
DEMO_LEVEL_TEXT:     DB "DEMO SZINT:   ",'V'+128,":VEGE"
PLAYER_LEVEL_TEXT:   DB "     SZINT:         "
TRAINING_LEVEL_TEXT: DB " GYAKORLAS (",'V'+128,":VEGE) "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Hibakezelés ...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ERROR_A:
    PUSH HL
    LD HL, ERROR_TEXT
    LD DE, PRINT_AT_STATUS_LINE_FIRST_POS
    LD BC, ERROR_TEXT_LENGTH
    LDIR
;    call show_col2_A
;    POP HL
;    call show_col3_HL
ERROR_A_HALT:
    JP ERROR_A_HALT

ERROR_TEXT: DB "ERR A   HL         "
ERROR_TEXT_LENGTH: EQU 19

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A játék végén megjelenő 3 aoroa képernyő szövegei
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_AT_END_OF_GAME:
    LD HL, PRINT_AT_STATUS_LINE_FIRST_POS
    LD DE, PRINT_AT_END_OF_GAME_POS
    LD BC, 40
    LDIR
    LD HL, END_OF_GAME_TEXT
    LD BC, END_OF_GAME_TEXT_LENGTH
    LD DE, PRINT_AT_END_OF_GAME_POS+40
    LDIR
    RET

END_OF_GAME_TEXT_LENGTH: EQU 80
END_OF_GAME_TEXT:
    DB 127
    DS 38,146
    DB 128
;    DB 231,"MINDEN ELET ELFOGYOTT! UJ JATEK: ",83+128,80+128,65+128,67+128,69+128,238 ; 230,238
;    DB 231,":( VEGE!   UJ JATEK: ",'C'+128,'R'+128,"   GYAKORLAS: ",'G'+128,238
    DB 231,"VEGE! UJ JATEK:",'C'+128,'R'+128,", GYAKORLAS:",'G'+128, ", DEMO:",'D'+128,238

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Kiírja az életvonalat a bal felső sarokba
;;; A-ban az életek száma
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_LIVE_A:
    PUSH BC
    PUSH HL
    LD HL, PRINT_AT_STATUS_LINE_FIRST_POS
    LD B, MAX_LIVE_COUNTER
PRINT_LIVE_LOOP:
    LD C, NO_LIVE_ICON
    CP 0
    JR Z, PRINT_LIVE_SPACE
    LD C, LIVE_ICON
    DEC A
PRINT_LIVE_SPACE
    LD (HL), C
    INC HL
    DJNZ PRINT_LIVE_LOOP
    POP HL
    POP BC
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pontérték megjelenítése
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_AT_POINT_TEXT:
    LD HL, POINT_TEXT
    LD BC, POINT_TEXT_LENGTH
    LD DE, PRINT_AT_POINT_BCD_POS-POINT_TEXT_LENGTH
    LDIR
    RET

PRINT_POINT_BCD3_HL:
    LD BC, PRINT_AT_POINT_BCD_POS
    JP PRINT_BCD3_HL_BC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Szintszám megjelenítése
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_LEVEL_BCD1_A:
    PUSH HL
    PUSH BC
    LD BC, PRINT_AT_LEVEL_BCD_POS
    CALL PRINT_BCD1_BC_A
    POP BC
    POP HL
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Szöveges képernyő SPACE karakterekkel való letörlése
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TEXT_CLS:
    LD HL, 0xC001
    LD DE, 0xC002
    LD (HL), 32
    LD BC, 999
    LDIR
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Többsoros szövewg kiírása a teljes szöveges képernyőre
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_MULTILINE_TEXT_HL:
    LD DE, 0xC001
PRINT_NEXT_LINE:
    LD B, 40
PRINT_NEXT_CHAR:
    LD A, (HL)
    INC HL
    CP 0
    RET Z
    CP 13
    JR NZ, PRINT_CHARACTER
GO_TO_NEW_LINE:
    INC DE
    DJNZ GO_TO_NEW_LINE
    JR PRINT_NEXT_LINE
PRINT_CHARACTER:
    LD (DE), A
    INC DE
    DJNZ PRINT_NEXT_CHAR
    JR PRINT_NEXT_LINE
