;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Az ütő kezelése
;;; A : up
;;; Z : down
;;; < Left Shift        Fire Space       Right Shift >
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RACKET_INIT_Y:              EQU GRAPHICS_SCREEN_HEIGHT - 33
;RACKET_ADD_LOW_LEFT_BLOCK:  EQU 0xD7
;RACKET_ADD_LOW_RIGHT_BLOCK: EQU RACKET_ADD_LOW_LEFT_BLOCK+35
RACKET_INIT_X8:             EQU 17
RACKET_WAIT_TIMES:          EQU 0
RACKET_FIRST_LINE_ROW0_INDEX: EQU 10         ;;; POS_Y_PER8
RACKET_LAST_LINE_ROW0_INDEX: EQU 22          ;;; POS_Y_PER8 Ezt az értéket a labda figyeli, nem az ütő. Ez csak egy maximális terület

INIT_RACKET:
    LD HL, (DCB_HM_2)
    LD DE, RACKET_INIT_Y*40 + RACKET_INIT_X8
    ADD HL, DE
    LD (RACKET_ADDR), HL
    LD A, 255
    LD (RACKET_FIRST_BYTE), A
    LD A, RACKET_INIT_X8
    LD (RACKET_X), A
    JP SHOW_RACKET

SHOW_RACKET:
    LD HL, (RACKET_ADDR)
    LD A, (RACKET_FIRST_BYTE)
    XOR (HL)
    LD (HL), A
    INC HL
    LD B, 3
SHOW_RACKET_LOOP:
    LD A, 255
    XOR (HL)
    LD (HL), A
    INC HL
    DJNZ SHOW_RACKET_LOOP
    LD A, (RACKET_FIRST_BYTE)
    CPL
    XOR (HL)
    LD (HL), A    
    RET

MANAGE_DEMO_RACKET:
    LD A, (RACKET_LAST_PRESSED)
    CP 0
    JR NZ, STOP_MOVING
    LD A, (POS_X_PER8)
    DEC A
    LD B, A
    LD A, (RACKET_X)
    CP B
    RET Z
    JP C, RACKET_MOVE_RIGHT
    JP RACKET_MOVE_LEFT
    RET

MANAGE_RACKET:
    LD A, (RACKET_LAST_PRESSED)
    CP 0
    JR NZ, STOP_MOVING
    LD A, 0
    LD (RACKET_LAST_DIRECTION), A
    CALL KEY_LeftShift_PRESSED_Z
    JP Z, RACKET_MOVE_LEFT
    CALL KEY_RightShift_PRESSED_Z
    JP Z, RACKET_MOVE_RIGHT
    LD HL, (RACKET_ADDR)
    LD A, 70h
    CP H
    JR NZ, RACKET_MOVE_UP_IF
RACKET_V2:
    LD HL, (RACKET_ADDR)
    LD A, 7Dh
    CP H
    JR NZ, RACKET_MOVE_DOWN_IF
    RET

RACKET_MOVE_UP_IF:
    CALL KEY_A_PRESSED_Z
    LD DE, -40
    JR Z, RACKET_MOVE_V_DE
    JR RACKET_V2

RACKET_MOVE_DOWN_IF:
    CALL KEY_Z_PRESSED_Z
    LD DE, 40
    JR Z, RACKET_MOVE_V_DE
    RET

STOP_MOVING:
    DEC A
    LD (RACKET_LAST_PRESSED), A
    RET

RACKET_V_CHECK_DE_Z: ;;; Ellenőrzi a HL címen kezdődő ütő DE elmozdulása utáni területet, hogy üres-e. Ha igen Z=1 lesz
    LD HL, (RACKET_ADDR)                   ; Az ütő bal első bájtjának címe.
    ADD HL, DE
    LD A, (RACKET_FIRST_BYTE)
    AND (HL)
    RET NZ
    INC HL
    OR (HL)
    RET NZ
    INC HL
    OR (HL)
    RET NZ
    INC HL
    OR (HL)
    RET NZ
    INC HL
    LD A, (RACKET_FIRST_BYTE)
    CPL
    AND (HL)
    RET

RACKET_MOVE_V_DE:
    LD A, RACKET_WAIT_TIMES
    LD (RACKET_LAST_PRESSED), A

    CALL RACKET_V_CHECK_DE_Z
    RET NZ

    LD HL, (RACKET_ADDR)                   ; Az ütő bal első bájtjának címe.
    LD B, 2
RACKET_MOVE_UP_LOOP:
    LD A, (RACKET_FIRST_BYTE)              ; Az első bájton lévő érték. Sosem lehet 0!!!!
    XOR (HL)
    LD (HL), A

    INC HL
    LD A, 255
    XOR (HL)
    LD (HL), A

    INC HL
    LD A, 255
    XOR (HL)
    LD (HL), A

    INC HL
    LD A, 255
    XOR (HL)
    LD (HL), A

    INC HL
    LD A, (RACKET_FIRST_BYTE)              ; Az első bájton lévő érték. Sosem lehet 0!!!!
    CPL
    XOR (HL)
    LD (HL), A

    LD HL, (RACKET_ADDR)
    ADD HL, DE
    DJNZ RACKET_MOVE_UP_LOOP
    LD HL, (RACKET_ADDR)
    ADD HL, DE
    LD (RACKET_ADDR), HL
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; HL = (RACKET_ADDR)
;;; HL-1     HL       +1       +2       +3       +4
;;; 00000000 00001111 11111111 11111111 11111111 11110000
;;; 00000000 00011111 11111111 11111111 11111111 11100000
;;; 
;;; (RACKET_ADDR)--
;;; 00000000 11111111 11111111 11111111 11111111 00000000
;;; 00000001 11111111 11111111 11111111 11111110 00000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RACKET_MOVE_LEFT:
    LD A, RACKET_WAIT_TIMES
    LD (RACKET_LAST_PRESSED), A

    LD HL, (RACKET_ADDR)                   ; Az ütő bal első bájtjának címe.
    LD A, (RACKET_FIRST_BYTE)              ; Az első bájton lévő érték. Sosem lehet 0!!!!
    LD B, A                                ; Az eredeti első bájton tárolt érték eltárolása
    SCF                                    ; Set CY
    RLA                                    ; CY <- 7. <- 0. <- CY
    JR NC, NO_ADDR_DEC                     ; Ha a CY 0, akkor bájton belül mozogtunk
    DEC HL                                 ; CY=1, tehát eggyel csökkentenünk kell a kezdőcímet
    BIT 0, (HL)                            ; Az új cím 0. bitje 1-es?
    RET NZ                                 ; Nem megyünk tovább balra, mivel új bájtba léptünk, és annak a 0. bitje 1-es
    LD (RACKET_ADDR), HL                   ; Mehetünk tovább balra, már eltárolhatjuk az ütő új kezdőcímét
    LD A, (RACKET_X)
    DEC A
    LD (RACKET_X), A
    LD A, 1                                ; Az új baloldali bájt értéke 1
    LD C, A                                ; C-be most is eltároljuk az új baloldali bájt értékét
    LD B, 0                                ; Az új bájtválzáts miatt, olyan, mintha előtte 255 lett volna
    JR RACKET_MOVE_LEFT_ENABLED            ; Mehetünk a baloldali bájt kirajzolásától tovább
NO_ADDR_DEC:                               ; A-ban az új baloldal értéke, bájton belül maradunk
    LD C, A                                ; C-ben eltárolom az új baloldali értéket
    AND (HL)                               ; Képernyővel összevetem az új biteket
    CP B                                   ; a régi értékkel
    RET NZ                                 ; A képernyőn van pixel az új bitben, befejeztük, nem mozdulunk
RACKET_MOVE_LEFT_ENABLED
    LD A, -1
    LD (RACKET_LAST_DIRECTION), A
    LD A, C                                ; A-ba az új érték
    LD (RACKET_FIRST_BYTE), A              ; El is tároljuk
    XOR B
    XOR (HL)                                ; Képernyőbitekkel összemásolom ;###;
    LD (HL), A                             ; Új képernyőbájt kiírása
    INC HL
    INC HL
    INC HL
    INC HL                                 ; HL-ben az ütő utolsó bájtja
    LD A, B                                ; A-ba az ütő eredeti első bájtja kerül
    CPL                                    ; A-ban az ütő eredeti utolsó bájtja
    LD B, A                                ; B-ben az ütő eredeti utolsó bájtja
    LD A, C                                ; A-ba az ütő új első bájtja kerül
    CPL                                    ; A-ban az ütő új utolsó bájtja
    LD C, A                                ; C-ben az ütő új utolsó bájtja
    LD A, (HL)                             ; A-ba az ütő utolsó bájtjának értéke a képernyőn
    XOR B                                  ; Kitörlöm az eredeti biteket a bájtból
    XOR C                                   ; És csak az új biteket gyújtom újra ;###;
    LD (HL), A                             ; Az új pixeleket visszaírom a képernyőre
    RET

RACKET_MOVE_RIGHT:
    LD A, RACKET_WAIT_TIMES
    LD (RACKET_LAST_PRESSED), A

    LD HL, (RACKET_ADDR)                          ; HL-ben az ütő baloldali első bájtjának a címe
    INC HL
    INC HL
    INC HL
    INC HL                                        ; HL-ben az ütő utolsó bájtjának a címe
    LD A, (RACKET_FIRST_BYTE)                     ; A-ban a baloldali első bájt értéke az ütőben
                                                  ; Ha A-ban 1 van, akkor fog léptetés után elfogyni az első bájt, és akkor kell
                                                  ; növelni a kezdőcímet
    CPL                                           ; A jobboldali utolsó bájt értéke az ütőben
    LD B, A                                       ; B-ben eltároljuk a mozgás előtti jobboldali utolsó bájt értékét
    SCF                                           ; Set CY
    RRA                                           ; CY -> 7. -> 0. -> CY
    CP 255                                        ; Ha az új érték 255, akkor az első bájt 0 lenne, ami nem lehet! INC ADDR!!!
    JR NZ, NO_ADDR_INC                            ; Ha jobbratolás utáni érték == 255, akkor címnövelés kell. Ilyenkor itt lehet ütközés
    INC HL                                        ; Címnövelés
    BIT 7, (HL)                                   ; A legfelső bit 1-es?
    RET NZ                                        ; Ha igen, akkor ütközés, nem megyünk arra
    LD A, (RACKET_X)
    INC A
    LD (RACKET_X), A
    DEC HL                                        ; Visszalépés az átugrott bájtra
    LD A, (HL)                                    ; Az átugrott bájt utolsó bitjének kigyújtása
    XOR 1
    LD (HL), A
    INC HL                                        ; Visszalépés az eredeti zárócímre
    LD A, 0                                       ; Ha nem, akkor az új jobboldali bájt értéke 128, azaz a 7. bit 1
    LD B, 0
    LD C, A                                       ; C-ben eltesszük az új bájt értékét
    JR RACKET_MOVE_RIGHT_ENABLED                  ; Innentől majd mehet a kirajzolás, és a baloldali bit törlése
NO_ADDR_INC:                                      ; Bájton belül tülunk el egy bitet
    LD  C, A                                      ; C-be bekerült az új jobboldali bájt értéke
    AND (HL)                                      ; 
    CP B
    RET NZ                                        ; Ütközés az új biten, nem megyünk arra
RACKET_MOVE_RIGHT_ENABLED:                        ; A HL címre mehet a C-ben lévő érték Or művelettel
    LD A, 1
    LD (RACKET_LAST_DIRECTION), A
    LD A, C
    XOR B
    XOR (HL)                                      ;###;
    LD (HL), A                                    ; Az új jobboldali pixel kirajzolva
    LD A, C                                       ; A-ba újra beletesszük csak a jobbszél bitjeit, majd képezzük ennek a baloldali kiegészítőjét
    CPL                                           ; A-ban az új baloldali bájt értéke
    LD (RACKET_FIRST_BYTE), A                     ; A baloldali új első bájt eltárolása
    LD C, A                                       ; C-ben az új baloldal értéke
    LD A, B                                       ; A-ba betesszük az eredeti jobboldali értéket
    CPL                                           ; A-ba kerül a baloldali eredeti érték
    LD B, A                                       ; B-ben most az eredeti baloldali érték van
    DEC HL
    DEC HL
    DEC HL
    DEC HL
    LD (RACKET_ADDR), HL                          ; A baloldali kezdőcím eltárolása
    LD A, C
    CP 255                                        ; Ha az eredeti baloldali érték 1 volt, akkor bájthatárváltás történt
    JR Z, THERE_WAS_A_RIGHT_ADDR_INC
    LD A, (HL)                                    ; Ha a baloldali érték nem volt 1, akkor bájton belül mehetünk
    XOR B
    XOR C                                         ;###;
    LD (HL), A
    RET
THERE_WAS_A_RIGHT_ADDR_INC:
    DEC HL
    LD A, (HL)
    XOR 1                                         ;###; AND 254
    LD (HL),A
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Others
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVE_RACKET_TO_INIT:
    CALL SHOW_RACKET
    CALL INIT_RACKET
    RET

RACKET_X:                DB 0
RACKET_ADDR:             DW 0
RACKET_FIRST_BYTE:       DB 0
RACKET_LAST_PRESSED:     DB 0
RACKET_LAST_DIRECTION:   DB 0
