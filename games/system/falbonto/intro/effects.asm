;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Futószöveg megjelenítése
;;; HL : A szöveg címe a memóriában. A végén lezáró 0
;;; DE : A futás sebessége. Minél nagyobb, annál lassabb.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCROLL_TEXT_INIT_HL_DE:
    LD (SCROLL_TEXT_START_ADDR), HL   ; A teljes szöveg kezdőcíme
    LD (SCROLL_LINE_START_ADDR), HL   ; A megjelenített sor kezdőcíme
    EX DE, HL
    LD (SCROLL_WAIT_TIME), HL
    LD A, 1
    LD (SCROLL_ELASPED_TIME), A
    RET

SCROLL_TEXT_NEXT_STEP:
    LD HL, (SCROLL_ELASPED_TIME)
    DEC HL
    LD (SCROLL_ELASPED_TIME), HL
    LD A, H
    OR L
    RET NZ
    LD HL,(SCROLL_WAIT_TIME)
    LD (SCROLL_ELASPED_TIME), HL
    ;;; Jöhet egy lépés a futásban
    LD DE, 0xC001+24*40               ; Itt fogunk megjeleníteni
    LD B, 40                          ; Ennyi karaktert
    LD HL, (SCROLL_LINE_START_ADDR)
    INC HL
    LD (SCROLL_LINE_START_ADDR), HL
    DEC HL
SCROLL_TEXT_LINE_LOOP:
    LD A, (HL)
    CP 0
    JR NZ, SCROLL_TEXT_CHAR_OK
        LD HL, (SCROLL_TEXT_START_ADDR)
        LD A, B
        CP 40
        JR NZ, SKIP_STORE_START_ADDR
        LD (SCROLL_LINE_START_ADDR), HL
SKIP_STORE_START_ADDR:
        LD A, (HL)
SCROLL_TEXT_CHAR_OK:
    LD (DE), A
    INC DE
    INC HL
    DJNZ SCROLL_TEXT_LINE_LOOP
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CLS1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CLS1:                               ; 6200 = 0110001000000000
;    AND A
;    LD A, 255
;    LD B, 8
;CLS1_LOOP:
;    RRA
;    RRA
;    CALL CLEAR_PIXEL
;    DJNZ CLS1_LOOP
;    RET
;
;CLEAR_PIXEL:
;    PUSH AF
;    PUSH BC
;    LD HL, (DCB_HM_2)
;    LD BC, 192*40
;    LD D, A
;CLEAR_PIXEL_LOOP:
;    LD A, D
;    AND (HL)
;    LD (HL), A
;    INC HL
;    DEC BC
;    LD A, C
;    OR B
;    JR NZ, CLEAR_PIXEL_LOOP
;    POP BC
;    POP AF
;    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CLS2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLS2:
    LD HL, CLS2_RANDOM_480
    LD BC, 480
CLS2_LOOP:
    LD E, (HL)
    INC HL
    LD D, (HL)
    INC HL
    CALL CLEAR_BRICK_DE        ; A DE címen lévő tégla(lap) törlése 8*2 byte, 8*16 px
;    EXX
;    CALL WAIT
;    EXX
    DEC BC
    LD A, B
    OR C
    JR NZ, CLS2_LOOP
    RET                      ; Z=1, ha vége

CLEAR_BRICK_DE:
    PUSH HL
    LD HL, (DCB_HM_2)
    ADD HL, DE
    LD A, 170
    CALL CLEAR_BRICK_HL_A
    LD A, 136
    CALL CLEAR_BRICK_HL_A
    LD A, 8
    CALL CLEAR_BRICK_HL_A
    LD A, 0
    CALL CLEAR_BRICK_HL_A
    POP HL
    RET

CLEAR_BRICK_HL_A:
    PUSH HL
    PUSH BC
    PUSH DE
    LD DE, 39
    LD B, 8
CLEAR_BRICK_LOOP:
    LD (HL), A
    INC HL
    LD (HL), A
    ADD HL, DE
    DJNZ CLEAR_BRICK_LOOP
    POP DE
    POP BC
    POP HL
    RET

CLS2_RANDOM_480: incbin 'intro/rnd480.bin'

;CLEAR_BRICK_FRONT_A:
;    PUSH HL
;    PUSH BC
;    LD H, 0
;    LD L, A
;    LD D, 0
;    LD E, A
;    ADD HL, DE
;    EX DE, HL
;    LD HL, (DCB_HM_2)
;    ADD HL, DE
;    CALL CLEAR_BRICK_HL
;    POP BC
;    POP HL
;    RET
;
;CLEAR_BRICK_BACK_A:
;    PUSH HL
;    PUSH BC
;    LD H, 0
;    LD L, A
;    LD D, 0
;    LD E, A
;    ADD HL, DE
;    EX DE, HL                 ; DE = 2XA
;    LD HL, 40*192-1
;    AND A
;    SBC HL, DE
;    EX DE, HL                 ; DE = 33*192-1 - 2xA
;    LD HL, (DCB_HM_2)
;    ADD HL, DE
;    CALL CLEAR_BRICK_HL
;    POP BC
;    POP HL
;    RET
;
;CLEAR_BRICK_HL:
;    LD A, 0
;    JR CLEAR_BRICK_HL_A

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 11 00 11 00 00 00 00 00 00 00 00 00 00 00 00 00 
;;; 00 11 00 11 00 00 00 00
;;; 00 00 00 00 11 11 11 11
;;; 00 00 00 00 11 11 11 11
;;; 00 00 00 00 00 00 00 00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CLEAR_BRICK8_HL:
;    PUSH HL
;    PUSH BC
;    PUSH DE
;    CALL CLEAR_BRICK4_HL
;    LD DE, 8*40+1
;    ADD HL, DE
;    CALL CLEAR_BRICK4_HL
;    DEC HL
;    CALL CLEAR_BRICK4_HL
;    LD DE, -8*40+1
;    ADD HL, DE
;    CALL CLEAR_BRICK4_HL
;    POP DE
;    POP BC
;    POP HL
;    RET
;
;CLEAR_BRICK4_HL:
;    PUSH HL
;    PUSH BC
;    PUSH DE
;    CALL CLEAR_BRICK2_TL_HL
;;    CALL CLEAR_BRICK2_BR_HL
;;    CALL CLEAR_BRICK2_BL_HL
;;    CALL CLEAR_BRICK2_TR_HL
;    POP DE
;    POP BC
;    POP HL
;    RET
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 0000 1111
;;;; 0000 1111
;;;; 1111 1111
;;;; 1111 1111
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CLEAR_BRICK2_TL_HL:
;    PUSH HL
;    PUSH BC
;    PUSH DE
;;    CALL CLEAR_BRICK2_TL_HL
;;    CALL CLEAR_BRICK2_BR_HL
;;    CALL CLEAR_BRICK2_BL_HL
;;    CALL CLEAR_BRICK2_TR_HL
;    POP DE
;    POP BC
;    POP HL
;    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Remegés
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REMEGES:
    CALL REMEGES1
    CALL REMEGES1
    RET

REMEGES1:
    LD HL, 0x6200
    LD A, (HL)
    INC HL

    LD DE, 0x6200
    LD BC, 192*40-1
    LDIR                 ; 6201 -> 6200

    LD BC, 10
    CALL WAIT_BC1

    EX DE, HL
    LD BC, 192*40-1
    LDDR
    LD HL, 0x6200
    LD (HL), A
    RET

WAIT_BC1:
    EX AF, AF' ; '
WAIT_BC_LOOP:
    CALL SOUND_ZAJ1
    DEC BC
    LD A, B
    OR C
    JR NZ, WAIT_BC_LOOP
    EX AF, AF' ; '
    RET

SCROLL_TEXT_START_ADDR: DW 0
SCROLL_LINE_START_ADDR: DW 0
SCROLL_WAIT_TIME:       DW 0
SCROLL_ELASPED_TIME:    DW 0
