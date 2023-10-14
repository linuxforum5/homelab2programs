;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; RAM
MAX_X:               EQU 39
MAX_Y:               EQU 192
GAME_MODE_PLAYER:    EQU 0
GAME_MODE_TRAINING:  EQU 1
GAME_MODE_DEMO:      EQU 2

GRAPHICS_SCREEN_HEIGHT: EQU 192
BORDER_HEIGHT: EQU GRAPHICS_SCREEN_HEIGHT-4

    org 0x4100
    CALL SET_GRAPHMODE_192
    DI
    CALL INTRO_SCREEN

RESTART_FULL_GAME:                    ;;; Innentől GAME_MODE szerint fut
    CALL SET_GRAPHMODE_192
    CALL CLS_GR_SCREEN
    CALL SHOW_BORDER

    LD A, (GAME_MODE)
    CP GAME_MODE_TRAINING
    CALL Z, SHOW_TRAINING_BORDER

    CALL INIT_LEVEL

GAME_LOOP:
    CALL SOUND_LEVEL_START                      ; A pálya kezdetén a SPACE-re vár

LEVEL_LOOP:
        CALL KEY_P_PRESSED_Z                  ; Pasue for debug
        CALL Z, WAIT_FOR_SPACE                ; Pause for debug
        ;CALL KEY_R_PRESSED_Z                  ; Pasue for debug
        ;JR Z, RESTART_FULL_GAME
    CALL KEY_V_PRESSED_Z                  ; Vege a jateknak
    JP Z, END_OF_GAME

    LD A, (GAME_MODE)
    CP GAME_MODE_DEMO
    CALL NZ, MANAGE_RACKET
    LD A, (GAME_MODE)
    CP GAME_MODE_DEMO
    CALL Z, MANAGE_DEMO_RACKET
    CALL TRAINING_COUNTDOWN
;    LD A, (GAME_MODE)
;    CP GAME_MODE_DEMO
;    CALL NZ, WAIT
    CALL WAIT

    LD A, (LEVEL_LOOP_ROUND)
    INC A
    LD (LEVEL_LOOP_ROUND), A
    BIT 0, A
    JR Z, BALL_MOVE_VERTICAL
BALL_MOVE_HORIZONTAL:
    ;;;;;;;;;;;;;;;;;;; vízszintes mozgás:
    CALL SPRITE_CHECK_NEXT_H_Z                  ; Függőleges elmozdulás. Z=1, ha nem volt ütközés
    CALL NZ, SPRITE_BOUNCE_H                    ; Függőleges irányt vált
    CALL MOVE_H
    JR BALL_MOVE_FINISHED
BALL_MOVE_VERTICAL:
    ;;;;;;;;;;;;;;;;;;; függőleges mozgás:
    CALL SPRITE_CHECK_NEXT_V_Z                  ; Függőleges elmozdulás. Z=1, ha nem volt ütközés
    CALL NZ, SPRITE_BOUNCE_V                    ; Függőleges irányt vált
    CALL MOVE_V
    ;;; Check ball out
    LD A, (SPRITE_SCREEN_ADDR+1)                ; Addr high byte
    CP 0x7E
    JR Z, BALL_GO_OUT
    CALL KEY_K_PRESSED_Z                        ; Next level in demo mode
    JR Z, BALL_GO_OUT
BALL_MOVE_FINISHED:

    CALL SHOW_OLD_BALL                        ; Hide sprite saved data
    CALL SHOW_BALL
    CALL SAVE_BALL_DATA

    LD A, (BRICK_COUNTER)
    CP 0
    JR NZ, LEVEL_LOOP
    CALL SOUND_LEVEL_FINISH
    JP FINISH_LEVEL
JR GAME_LOOP

BALL_GO_OUT:
    CALL SHOW_OLD_BALL                        ; Hide sprite saved data
    CALL DEC_LIVE_COUNTER
    CALL BALL_GO_OUT_MUSIC

    LD A, (GAME_MODE)
    CP GAME_MODE_DEMO
    JP Z, DEMO_SKIP_LEVEL

    LD A, (LIVE_COUNTER)
    CP 0
    JR Z, END_OF_GAME
    CALL MOVE_RACKET_TO_INIT
    CALL INIT_BALL
    CALL SHOW_BALL
    CALL SAVE_BALL_DATA
    JP GAME_LOOP

END_OF_GAME:
    CALL PRINT_AT_END_OF_GAME
    CALL SET_GRAPHMODE_176
    CALL WAIT_FOR_G_OR_D_OR_CR
    JP RESTART_FULL_GAME

TMP1: DB 0
TMP2: DB 0

WAIT_FOR_G_OR_D_OR_CR:
    ;CALL SCROLL_TEXT_NEXT_STEP
    CALL ANY_KEY_PRESSED_NZ_A_B1          ; A_ban az adat B-ben a címindex 1-től HL-ben az olvasott teljes cím
    JR Z, WAIT_FOR_G_OR_D_OR_CR
    LD (TMP1), A
    LD A, B
    LD (TMP2), A
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Training mode
    LD A, GAME_MODE_TRAINING
    LD (GAME_MODE), A
    LD A, (TMP2)
    LD B, A
    LD A, (TMP1)
    CALL KEY_G_CHECK_A_B_Z
    JP Z, RESTART_FULL_GAME

    LD A, GAME_MODE_DEMO
    LD (GAME_MODE), A
    LD A, (TMP2)
    LD B, A
    LD A, (TMP1)
    CALL KEY_D_CHECK_A_B_Z
    JP Z, RESTART_FULL_GAME

    LD A, GAME_MODE_PLAYER
    LD (GAME_MODE), A
    LD A, (TMP2)
    LD B, A
    LD A, (TMP1)
    CALL KEY_CR_CHECK_A_B_Z
    JP Z, RESTART_FULL_GAME

    JR WAIT_FOR_G_OR_D_OR_CR

;WAIT_BIG:  ; A demo palya elejkén
;    LD B, 255
;WAIT_BIG_LOOP:
;    LD A, 3
;WAIT_BIG_LOOP2: DEC A
;    PUSH AF
;    PUSH BC
;    LD A, B
;    CALL BEEP_A
;    POP BC
;    POP AF
;    JR NZ, WAIT_BIG_LOOP2
;    DJNZ WAIT_BIG_LOOP
;    ;CALL TRAINING_WALL_ON
;    RET
;

WAIT: LD B, TICK_LENGTH_FOR_SPEED
WAITLOOP: LD A, BALL_SPEED
WAITLOOP2: DEC A
    NOP
    JR NZ, WAITLOOP2
    DJNZ WAITLOOP
    RET

include 'config.asm';
include 'data-segment.asm';
include 'sound.asm';
include 'keyboard.asm';
include 'bcd.asm';
include 'textio.asm';
include 'ball.asm';
include 'rom.asm';
include 'math.asm';
include 'wall.asm';
include 'racket.asm';
include 'levels/levels.asm';
include 'graphics.asm';
include 'border.asm';
include 'intro/main.asm';

;include 'debug.asm';
;include 'teszt.asm';

END_OF_CODE:
