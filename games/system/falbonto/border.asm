
SHOW_BORDER:
    LD A, 255
    LD HL, (DCB_HM_2)
    LD DE, (DCB_HM_2)
    LD BC, 39 ; 79
    INC DE
    LD (HL), A
    LDIR
    ;;; LEFT BORDER
    LD B, BORDER_HEIGHT
    LD HL, (DCB_HM_2)
    LD DE, 40
    ADD HL, DE
    LD A, 128
    CALL DRAW_V_LINE_HL_A_B
    ;;; LEFT BORDER 2
    LD B, BORDER_HEIGHT-15
    LD HL, (DCB_HM_2)
    LD DE, 40*16
    ADD HL, DE
    LD A, 192
    CALL DRAW_V_LINE_HL_A_B
    ;;; LEFT BORDER 3
    LD B, BORDER_HEIGHT-31
    LD HL, (DCB_HM_2)
    LD DE, 40*32 
    ADD HL, DE
    LD A, 224
    CALL DRAW_V_LINE_HL_A_B
    ;;; RIGHT BORDER
    LD B, BORDER_HEIGHT
    LD HL, (DCB_HM_2)
    LD DE, 79 ; 119
    ADD HL, DE
    LD A, 1 ; 3
    CALL DRAW_V_LINE_HL_A_B
    ;;; RIGHT BORDER 2
    LD B, BORDER_HEIGHT-15
    LD HL, (DCB_HM_2)
    LD DE, 39 + 40*16
    ADD HL, DE
    LD A, 3
    CALL DRAW_V_LINE_HL_A_B
    ;;; RIGHT BORDER 3
    LD B, BORDER_HEIGHT-31
    LD HL, (DCB_HM_2)
    LD DE, 39 + 40*32
    ADD HL, DE
    LD A, 7
    CALL DRAW_V_LINE_HL_A_B

    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Rajzol egy függőleges vonalat
;;; HL : A kezdő bájt
;;; A : A kirajzolandó érték a bájtokba
;;; B : A vonal magassága
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_V_LINE_HL_A_B:
    LD (HL), A
    LD DE, 40
    ADD HL, DE
    DJNZ DRAW_V_LINE_HL_A_B
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Training fal műveletei
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TRAINING_WALL_BOTTOM: EQU 5               ; A training fal magassága
TRAINING_BORDER_FIRST_BYTE_ADDRESS: EQU 0x8000 - 80 - 1 - TRAINING_WALL_BOTTOM * 40
TRAINING_BORDER_TIMELINE_FIRST_BYTE_ADDRESS: EQU TRAINING_BORDER_FIRST_BYTE_ADDRESS + 120
TIMELINE_MAX_ITEM_COUNTER: EQU 40

SHOW_TRAINING_BORDER:
    LD HL, TRAINING_BORDER_FIRST_BYTE_ADDRESS
    LD B, 40
SHOW_TRAINING_BORDER_LINE1:
    LD A, (HL)
    XOR %10101010
    LD (HL), A
    INC HL
    DJNZ SHOW_TRAINING_BORDER_LINE1
    LD B, 40
SHOW_TRAINING_BORDER_LINE2:
    LD A, (HL)
    XOR %01010101
    LD (HL), A
    INC HL
    DJNZ SHOW_TRAINING_BORDER_LINE2
    RET

TRAINING_WALL_ON:
    PUSH AF
    LD A, (GAME_MODE)
    CP GAME_MODE_TRAINING
    JR Z, WALL_ALREADY_SHOWED
    PUSH HL
    PUSH DE
    PUSH BC
    LD HL, (TRAINING_COUNTDOWN_DATA)
    LD A, H
    OR L
    CALL Z, SHOW_TRAINING_BORDER ; Csak akkor rajzoljuk ki, ha még nincs kirajzolva
    CALL SOUND_TRAINING_WALL_ON
    ;;; show timeline begin
    LD HL, TRAINING_BORDER_TIMELINE_FIRST_BYTE_ADDRESS
    LD DE, TRAINING_BORDER_TIMELINE_FIRST_BYTE_ADDRESS+1
    LD BC, TIMELINE_MAX_ITEM_COUNTER-1
    LD (HL), 255
    LDIR
    ;;; show timeline end
    LD HL, (TRAINING_COUNTDOWN_DATA)
    LD DE, TRAINING_BRICK_COUNTDOWN_CYCLE_COUNTER
    ADD HL, DE
    LD (TRAINING_COUNTDOWN_DATA), HL
    POP BC
    POP DE
    POP HL
WALL_ALREADY_SHOWED:
    POP AF
    RET

CLEAR_TIMELINE:
    LD HL, TRAINING_BORDER_TIMELINE_FIRST_BYTE_ADDRESS
    LD DE, TRAINING_BORDER_TIMELINE_FIRST_BYTE_ADDRESS+1
    LD B, 39
    LD (HL), 0
    LDIR
    RET

TRAINING_COUNTDOWN:
    LD HL, (TRAINING_COUNTDOWN_DATA)
    LD A, H
    OR L
    RET Z
    LD A, H
    CP TIMELINE_MAX_ITEM_COUNTER
    JR NC, SKIP_TIMLELINE
    PUSH DE
    PUSH HL
    LD E, A
    LD D, 0
    LD HL, TRAINING_BORDER_TIMELINE_FIRST_BYTE_ADDRESS
    ADD HL, DE
    LD (HL), 0
    POP HL
    POP DE
SKIP_TIMLELINE:
    DEC HL
    LD (TRAINING_COUNTDOWN_DATA), HL
    LD A, H
    OR L
    RET NZ
    CALL SOUND_TRAINING_WALL_OFF
    CALL SHOW_TRAINING_BORDER
    RET

TRAINING_COUNTDOWN_DATA: DW 0
