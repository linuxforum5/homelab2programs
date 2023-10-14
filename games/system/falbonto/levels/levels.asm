;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A játék állapotát, státuszát kezelő objektum
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAX_LEVEL_COUNTER: EQU 10

; Inicializálja a szintet. Ezt csak a játék elején kell megtenni. Utána már csak növelni kell
INIT_LEVEL:
    call clear_status_line
    CALL INIT_LEVEL_COUNTER
    LD HL, 0
    LD (TRAINING_COUNTDOWN_DATA), HL

    LD HL, PALYA0
    LD A, (GAME_MODE)
    CP GAME_MODE_TRAINING
    JR NZ, SKIP_TRAINING_PALYA
    LD HL, PALYA_TRAINING
SKIP_TRAINING_PALYA:
    CALL SHOW_WALL_HL                     ; 4D16 : SP=61F1
                                          ; 4917 : SP=61EF ( 194D ) ok
                                          ; 492F :               ( 425E ) = 01
    LD (NEXT_PALYA_START_ADDR), HL
    CALL INIT_STATUS
    CALL INIT_RACKET

    CALL INIT_BALL
    CALL SHOW_BALL
    CALL SAVE_BALL_DATA

    RET

FINISH_LEVEL:
    ;CALL SOUND_LEVEL_FINISH
    LD A, (GAME_MODE)
    CP GAME_MODE_TRAINING
    JP Z, END_OF_GAME
    CALL MOVE_SPRITE_TO_INIT
    CALL MOVE_RACKET_TO_INIT

    CALL INC_LEVEL_COUNTER

    LD HL, (NEXT_PALYA_START_ADDR)
    LD A, 0
    CP (HL)                           ; Ha a pálya első bájtja 0, akkor kezdi előről
    JR NZ, HL_OK_FOR_NEXT_LEVEL
    LD HL, PALYA0
HL_OK_FOR_NEXT_LEVEL:
    CALL SHOW_WALL_HL
    LD (NEXT_PALYA_START_ADDR), HL

    CALL INIT_BALL

    JP GAME_LOOP
;    XXX: JP XXX

NEXT_PALYA_START_ADDR: DW 0

PALYA_TRAINING:
    incbin 'levels/level_training_data.bin';
PALYA0:
    incbin 'levels/levels_data.bin';
