;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A játék állapotát, státuszát kezelő objektum
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LIVE_ICON:          EQU 15
NO_LIVE_ICON:       EQU 121

INIT_STATUS:
    ;;; Pontaszám nullázása
    LD A, 0
    LD ( POINT_COUNTER_BCD ), A
    LD ( POINT_COUNTER_BCD + 1 ), A
    LD ( POINT_COUNTER_BCD + 2 ), A
    ;;; 
    LD A, (GAME_MODE)
    CP GAME_MODE_PLAYER
    CALL PRINT_AT_PLAYER_LEVEL_TEXT       ;;; A nem változik!
    CP GAME_MODE_DEMO
    CALL Z, PRINT_AT_DEMO_LEVEL_TEXT      ;;; A nem változik!
    CP GAME_MODE_TRAINING
    CALL Z, PRINT_AT_TRAINING_LEVEL_TEXT  ;;; A nem változik!
    JR NZ, INIT_NON_TRAINING_MODE         ;;; Demo or player
    LD A, 1                               ;;; Training mód: LIVE_COUNTER := 1
    JR TOVABB
INIT_NON_TRAINING_MODE:                   ;;; Demo or player mode
    LD A, (LEVEL_COUNTER_BCD)
    CALL PRINT_LEVEL_BCD1_A
    LD A, START_LIVE_COUNTER              ;;; LIVE_COUNTER normal
TOVABB:
    LD (LIVE_COUNTER), A
    CALL PRINT_LIVE_A

    LD HL, PRINT_AT_STATUS_LINE_FIRST_POS + START_LIVE_COUNTER
    LD (LIVE_COUNTER_ADDRESS), HL


    CALL PRINT_AT_POINT_TEXT
    LD HL, POINT_COUNTER_BCD
    CALL PRINT_POINT_BCD3_HL

    RET

DEMO_SKIP_LEVEL:
    CALL CLS_GR_SCREEN
    LD HL, 0
    LD (TRAINING_COUNTDOWN_DATA), HL
    CALL SHOW_BORDER
    CALL SHOW_OLD_BALL
    LD A, (LIVE_COUNTER)
    CP 0
    CALL Z, INC_LIVE_COUNTER
    CALL SHOW_RACKET
    JP FINISH_LEVEL
    ;CALL SOUND_LEVEL_FINISH
    ;RET

INC_LIVE_COUNTER:
    LD A, (LIVE_COUNTER)
    CP MAX_LIVE_COUNTER
    JP Z, SOUND_INC_LIVE_COUNTER_MAX
    INC A
    LD (LIVE_COUNTER), A
    CALL PRINT_LIVE_A
    PUSH HL
    LD HL, (LIVE_COUNTER_ADDRESS)
    INC HL
    LD (LIVE_COUNTER_ADDRESS), HL
    CALL SOUND_INC_LIVE_COUNTER
    POP HL
    RET

DEC_LIVE_COUNTER:
    PUSH AF
    LD A, (LIVE_COUNTER)
    CP 0
    RET Z
    DEC A
    LD (LIVE_COUNTER), A
    CALL PRINT_LIVE_A
    POP AF
    PUSH HL
    LD HL, (LIVE_COUNTER_ADDRESS)
    DEC HL
    LD (LIVE_COUNTER_ADDRESS), HL
    POP HL
    RET

TOGGLE_LIVE_ICON:
    LD HL, (LIVE_COUNTER_ADDRESS)
    LD A, (HL)
    CP LIVE_ICON
    JR Z, SHOW_NO_LIVE
    LD (HL), LIVE_ICON
    RET
SHOW_NO_LIVE:
    LD (HL), NO_LIVE_ICON
    RET

INIT_LEVEL_COUNTER:
    LD A, 1
    LD (LEVEL_COUNTER_BCD), A
    CALL PRINT_LEVEL_BCD1_A
    RET

INC_LEVEL_COUNTER:
    LD A, (LEVEL_COUNTER_BCD)
    INC A
    DAA
    LD (LEVEL_COUNTER_BCD), A
    CALL PRINT_LEVEL_BCD1_A
    RET

INC_POINT_COUNTER:
    PUSH AF
    LD A, 1
    LD B, A
    LD A, ( POINT_COUNTER_BCD )
    ADD A, B
    DAA
    LD ( POINT_COUNTER_BCD ), A
    JR NC, INC_POINT_SKIP

    AND A
    LD A, ( POINT_COUNTER_BCD + 1 )
    INC A
    DAA
    LD ( POINT_COUNTER_BCD + 1 ), A
    CP 0
    JR NZ, INC_POINT_SKIP

    LD A, ( POINT_COUNTER_BCD + 2 )
    INC A
    DAA
    LD ( POINT_COUNTER_BCD + 2 ), A
INC_POINT_SKIP:
    LD HL, POINT_COUNTER_BCD
    CALL PRINT_POINT_BCD3_HL
    POP AF
    RET

ADD_POINT_COUNTER_A:
    CP 0
    RET Z
    PUSH BC
    PUSH DE
    PUSH HL
ADD_POINT_COUNTER_LOOP:
    CALL INC_POINT_COUNTER
    PUSH AF
    CALL SOUND_POINT_A
    POP AF
    DEC A
    JR NZ, ADD_POINT_COUNTER_LOOP
    POP HL
    POP DE
    POP BC
    RET

DEC_BRICK_COUNTER:
    LD A, (BRICK_COUNTER)
    DEC A
    LD (BRICK_COUNTER), A
    RET

INC_BRICK_COUNTER:
    LD A, (BRICK_COUNTER)
    INC A
    LD (BRICK_COUNTER), A
    RET

LIVE_COUNTER: DB 0
LIVE_COUNTER_ADDRESS: DW 0  ; Az aktuális live ikon kezdőcíme a képernyőn
LEVEL_COUNTER_BCD: DB 0
BRICK_COUNTER: DB 0
POINT_COUNTER_BCD: DS 3,0

POINT_TEXT_LENGTH: EQU 6
POINT_TEXT: DB "PONT: "

BRICK_TEXT_LENGTH: EQU 4
BRICK_TEXT: DB 160,160, ": "

GAME_MODE: DB 0       ; 0=Player, 1=Training, 2=Demo

LEVEL_LOOP_ROUND: DB 0          ; A körszámláló a paritáshoz
