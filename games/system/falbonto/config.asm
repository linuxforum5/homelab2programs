;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INTRO_SCROLL_SPEED: EQU 512        ; Az intro szövegsebessége. Minél nagyobb, annál lassabb
MAX_LIVE_COUNTER:   EQU 6
START_LIVE_COUNTER: EQU 3  ; Gyakorló modban mindig 1

;;;; Labda indítása X (0,2) - (38,6)
POS_X_PER8_START:    EQU 19
POS_X_MOD8_START:    EQU 2
POS_Y_PER8_START:    EQU 12           ; 18
POS_Y_MOD8_START:    EQU 4
DIRECTION_X_START:   EQU 0 ; 1            ; -1=left vagy 1=right, 0=függőleges csak        0
START_SPEED_X:       EQU MAX_BALL_ANGLE_X ; vízszintes irányú sebesség a függőlegeshez képest
DIRECTION_Y_START:   EQU -1           ; 1/-1 : 1=down vagy -1=up                       1
MAX_BALL_ANGLE_X:    EQU 6                ; Maximális vízszintes irányú sebesség értéke, azaz a dőlésszög

POS_X_PER8_DEMO_START:    EQU 19
POS_X_MOD8_DEMO_START:    EQU 2
POS_Y_PER8_DEMO_START:    EQU 12
POS_Y_MOD8_DEMO_START:    EQU 4
DIRECTION_X_DEMO_START:   EQU 0
DIRECTION_Y_DEMO_START:   EQU 1

BALL_SPEED:            EQU 7              ; A labda induló sebessége. Minél nagyobb, annál lassabb
TICK_LENGTH_FOR_SPEED: EQU 10             ; A várakozási ciklus egy tick-jének az értéke. A teljes várakozás két lépés között TICK*BALL_SPEED + persze a teljes lépés műveletideje

TRAINING_BRICK_COUNTDOWN_CYCLE_COUNTER: EQU 10240 ; Minimum 0x2800 = 10240
