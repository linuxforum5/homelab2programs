;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Intro music
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXX_INTRO_MUSIC_INIT:
    EXX
    LD DE, 0
    LD BC, 0
    EXX
    RET

EXX_INTRO_MUSIC_NEXT:
    EXX
    ;INC BC
    INC C
    INC DE
    LD A, C
    AND D
    AND %11111100
    EXX
    JR Z, EXX_INTRO_PLAY_BIT_0
    JR EXX_INTRO_PLAY_BIT_1

EXX_INTRO_PLAY_BIT_0
    LD A, 255
    LD (0000), A
    NOP
    ADD IY,IY
    RET

EXX_INTRO_PLAY_BIT_1
    LD A, 255
    LD (SPEAKER_OUT), A
;    NOP
    ADD IY,IY
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; effect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BALL_GO_OUT_MUSIC:
    LD A, 1
    LD B, 130
BALL_GO_OUT_LOOP
    PUSH HL
    PUSH AF
    CALL TOGGLE_LIVE_ICON
    POP AF
    POP HL
    PUSH BC
    LD B, 7
    CALL BEEP_A_B
    POP BC
    INC A
    DJNZ BALL_GO_OUT_LOOP
    RET

SOUND_RACKET:
    LD HL, 0x1055
    CALL ROM_BEEP_HL
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Egy pontszám hangja
;;; A : A pontszám
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SOUND_POINT_A:
    PUSH IX
    PUSH BC
    LD B, 5 ; 20
    CPL
    AND 15         ; CY=0
    RLA
    RLA
    ADD A, 50
    CALL BEEP_A_B
    POP BC
    POP IX
    RET

BEEP_A
    LD B, 1
BEEP_A_B:             ; A: hagnmagasság, B: hanghossz
    LD C, B
    LD B, A
BEEP_A_LOOP_ON:
    LD (SPEAKER_OUT), A
    DJNZ BEEP_A_LOOP_ON
    LD B, A
BEEP_A_LOOP_OFF:
    ADD IY,IY
    DJNZ BEEP_A_LOOP_OFF
    LD B, C
    DJNZ BEEP_A_B
    RET
    
SOUND_ZAJ1:
    EXX
    LD B, 20
SOUND_ZAJ1_LOOP
    ;LD A, R
    CALL GET_RANDOM_A
    LD H, 0
    LD L, A
    LD A, (HL)
    BIT 6, A
    JR Z, SKIP_ZAJ1
    LD (SPEAKER_OUT), A
SKIP_ZAJ1:
    DJNZ SOUND_ZAJ1_LOOP
    EXX
    RET

SOUND_ZAJ2:
    EXX
    LD B, 20
SOUND_ZAJ2_LOOP
    LD A, R
    LD H, 0
    LD L, A
    LD A, (HL)
    BIT 2, A
    JR Z, SKIP_ZAJ2
    LD (SPEAKER_OUT), A
SKIP_ZAJ2:
    DJNZ SOUND_ZAJ2_LOOP
    EXX
    RET

SOUND_TRAINING_WALL_ON:
    PUSH HL
    LD HL, SOUND_WALL_ON_MUSIC
    CALL SOUND_PLAY_MUSIC_HL
    POP HL
    RET

SOUND_TRAINING_WALL_OFF:
    PUSH HL
    LD HL, SOUND_WALL_OFF_MUSIC
    CALL SOUND_PLAY_MUSIC_HL
    POP HL
    RET

SOUND_INC_LIVE_COUNTER_MAX:
    PUSH AF
    PUSH HL
    PUSH BC
    LD HL, SOUND_INC_LIVE_COUNTER_MAX_MUSIC
    CALL SOUND_PLAY_MUSIC_HL
    POP BC
    POP HL
    POP AF
    RET

SOUND_INC_LIVE_COUNTER:
    LD B, 40 ; 155
LOOP1:
    PUSH BC
    LD A, B
    RLA
    RLA
    CALL BEEP_A
    POP BC
    DJNZ LOOP1
    RET

SOUND_PLAY_MUSIC_HL:
    LD A, (HL)
    LD B, A
SOUND_PLAY_MUSIC_HL_LOOP:
    INC HL
    LD A, (HL)
    CP 0
    RET Z
    PUSH BC
    CALL BEEP_A_B
    POP BC
    JR SOUND_PLAY_MUSIC_HL_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pályák előtti 5 sípszó
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PAUSE_1S: EQU 65535
SOUND_LEVEL_START_A1: EQU 40
SOUND_LEVEL_START_B1: EQU 100
SOUND_LEVEL_START_A2: EQU 20
SOUND_LEVEL_START_B2: EQU 255

SOUND_LEVEL_START:
    LD A, SOUND_LEVEL_START_A1
    LD B, SOUND_LEVEL_START_B1
    CALL BEEP_A_B
    LD BC, PAUSE_1S
    CALL PAUSE_BC
    LD A, SOUND_LEVEL_START_A1
    LD B, SOUND_LEVEL_START_B1
    CALL BEEP_A_B
    LD BC, PAUSE_1S
    CALL PAUSE_BC
    LD A, SOUND_LEVEL_START_A1
    LD B, SOUND_LEVEL_START_B1
    CALL BEEP_A_B
    LD BC, PAUSE_1S
    CALL PAUSE_BC
    LD A, SOUND_LEVEL_START_A1
    LD B, SOUND_LEVEL_START_B1
    CALL BEEP_A_B
    LD BC, PAUSE_1S
    CALL PAUSE_BC
    LD A, SOUND_LEVEL_START_A2
    LD B, SOUND_LEVEL_START_B2
    CALL BEEP_A_B
    LD A, SOUND_LEVEL_START_A2
    LD B, SOUND_LEVEL_START_B2
    CALL BEEP_A_B
    RET

PAUSE_BC:
    DEC BC
    LD A, B
    OR C
    JR NZ, PAUSE_BC
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pályák utáni math effekt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SOUND_LEVEL_FINISH:
    CALL EXX_INTRO_MUSIC_INIT
    LD BC, %1000000000000000
SOUND_LEVEL_FINISH_LOOP:
    CALL EXX_INTRO_MUSIC_NEXT
    DEC BC
    LD A, B
    OR C
    JR NZ, SOUND_LEVEL_FINISH_LOOP
    RET

SOUND_WALL_ON_MUSIC: DB 20,40,60,80,100,0
SOUND_WALL_OFF_MUSIC: DB 20,100,80,60,40,0
SOUND_INC_LIVE_COUNTER_MAX_MUSIC: DB 20,40,80,40,0

SND1: EQU 80
SND2: EQU 60
SND3: EQU 48
