;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Egy tégla műveletei:
;;; Init : Inicializálja egy tégla területét a rejtett tárban, majd meg is jeleníti azt a képernyőn.
;;; Collation : Egy tégla megütése, és az ütésre adott válaszai. Az urolsó ütésre eltűnése
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BRICK_TYPE_HALF_EMPTY:    EQU %00000000 ; ' '
BRICK_TYPE_HALF_LEFT:     EQU %00010000 ; 'L'
BRICK_TYPE_HALF_RIGHT:    EQU %00100000 ; 'R'
BRICK_TYPE_HALF_MIDDLE:   EQU %00110000 ; 'H'
BRICK_TYPE_FULL:          EQU %01000000 ; 'F'  Normál tégla. Képe: FULL_BRICK_PIXELS
BRICK_TYPE_FULL_2:        EQU %01010000 ; '2'  Normál tégla, amit 2-szer kell megütin.            Képe: FULL_BRICK_PIXELS
BRICK_TYPE_FULL_3:        EQU %01100000 ; '3'  Normál tégla, amit 3-szor kell megütin.            Képe: FULL_BRICK_PIXELS
BRICK_TYPE_FULL_4:        EQU %01110000 ; '4'  Normál tégla, amit 4-szer kell megütin.            Képe: FULL_BRICK_PIXELS
BRICK_TYPE_FULL_5:        EQU %10000000 ; '5'  Normál tégla, amit 5-szer kell megütin.            Képe: FULL_BRICK_PIXELS
BRICK_TYPE_FULL_6:        EQU %10010000 ; '6'  Normál tégla, amit 6-szer kell megütin.            Képe: FULL_BRICK_PIXELS
BRICK_TYPE_FULL_POINTS:   EQU %10100000 ; 'P'  Normál tégla, ami 6 pontot ér.                     Képe: FULL_POINTS_BRICK_PIXELS
;BRICK_TYPE_FULL_BLACK:    EQU 66 ; 'B'  Normál tégla, ami, elsőre nem látszik, 3 pontot ér, és kétszer kell megütni. Képe: FULL_BLACK_BRICK_PIXELS
BRICK_TYPE_FULL_TRAINING: EQU %10110000 ; 'T'  Normál téglatégla, ami bekacsolja a training módot egy időre. Képe: FULL_TRAINING_BRICK_PIXELS
BRICK_TYPE_FULL_EXTRA:    EQU %11000000 ; 'E'  Normál tégla, ami 3 pontot ér, de lesz extra life. Képe: FULL_EXTRA_LIFE_BRICK_PIXELS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Tömörített blokk kirajzolása
;;; A : A tömörített kód. Felső 4 bit a típus, alsó 4 bit a darab. Típus lehet 0, darab nem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INIT_BRICK_BLOCK_DE_HL_A_B:
    CP 0
    CALL Z, ERROR_A
    LD (INIT_BRICK_BLOCK_CODE), A
    AND %00001111
    LD (INIT_BRICK_BLOCK_COUNTER), A  ; A téglák száma a blokkban
    LD A, (INIT_BRICK_BLOCK_CODE)
    AND %11110000
    LD (INIT_BRICK_BLOCK_CODE), A     ; A tégla típusa
INIT_BRICK_BLOCK_LOOP:
    DEC B
    LD A, (INIT_BRICK_BLOCK_CODE)
    CALL INIT_BRICK_DE_HL_A_B
    LD A, (INIT_BRICK_BLOCK_COUNTER)  ; A téglák száma a blokkban
    DEC A
    LD (INIT_BRICK_BLOCK_COUNTER), A  ; A téglák száma a blokkban
    JR NZ, INIT_BRICK_BLOCK_LOOP
    INC B
    RET

INIT_BRICK_BLOCK_CODE: DB 0
INIT_BRICK_BLOCK_COUNTER: DB 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Egy tégla megjelenítése és inicializálása
;;; DE : Az adatterület címe, ahol a tégla adatait tárolni szeretnénk
;;;      Az adatterület szerkezete:
;;;         0 : Screen address low
;;;         1 : Screen address high
;;;         2 : Tégla típusa
;;;         3 : Felső 4 bit ütésszámláló, alsó 4 bit pontérték
;;; HL : A képernyőn a bal felső sarok bájt címe
;;; A : A tégla típusa
;;;     Féltéglák:                                                                             Szélesség Ütés Pont Tükör
;;;        - 'L' : Baloldali féltégla                                                              1      1    1
;;;        - 'R' : Jobboldali féltégla                                                             1      1    1
;;;        - 'H' : Önálló féltégla                                                                 1      1    1
;;;        - ' ' : Üres féltégla, nem jelenik meg semmi a képernyőn, és nem is jelent akadályt     1      1    1
;;;     Teljes téglák
;;;        - 'F' : Teljes normál tégla.                                                            2      1    1
;;;        - '2' : Kétszer megütendő teljes normál tégla.                                          2      2    1
;;;        - '3' : Kétszer megütendő teljes normál tégla.                                          2      3    1
;;;        - '4' : Kétszer megütendő teljes normál tégla.                                          2      4    1
;;;        - 'B' : Fekete teljes tégla                                                             2      1    1
;;;        - 'T' : Tükörtégla                                                                      2      1    1     +
;;; B : Ebből a tégla szélességénél 1-gyel kevesebbe ki kell vonnunk.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INIT_BRICK_DE_HL_A_B:
    CP BRICK_TYPE_HALF_EMPTY ; ' '
    JR Z, INIT_EMPTY_HALF_BRICK_DATA4                              ; A képernyő nem változik, az adatterület 4 darab 0 bájt
    EX AF, AF' ; ' ; A-ban megkapott típusérték eltárolása
        LD A, L
        LD (DE), A     ; 1. bájt a screen low
        INC DE
        LD A, H
        LD (DE), A     ; 2. bájt a screen high
        INC DE
        CALL INC_BRICK_COUNTER
    EX AF, AF' ; ' ;
    LD (DE), A     ; 3. bájt a típus
    INC DE

    CP BRICK_TYPE_HALF_LEFT   ; 'L'
    JP Z, INIT_LEFT_HALF_BRICK_DATA1

    CP BRICK_TYPE_HALF_RIGHT  ; 'R'
    JP Z, INIT_RIGHT_HALF_BRICK_DATA1

    CP BRICK_TYPE_HALF_MIDDLE ; 'H'
    JP Z, INIT_MIDDLE_HALF_BRICK_DATA1

    LD C, %00010011
    PUSH HL
    LD HL, FULL_BRICK_PIXELS
    LD (PIXELS_DATA_FOR_BRICK), HL
    POP HL
    CP BRICK_TYPE_FULL        ; 'F'
    JP Z, INIT_FULL_BRICK_DATA1_C

    LD C, %00100011
    CP BRICK_TYPE_FULL_2      ; '2'
    JP Z, INIT_FULL_BRICK_DATA1_C

    LD C, %00110011
    CP BRICK_TYPE_FULL_3      ; '3'
    JP Z, INIT_FULL_BRICK_DATA1_C

    LD C, %01000011
    CP BRICK_TYPE_FULL_4      ; '4'
    JR Z, INIT_FULL_BRICK_DATA1_C

    LD C, %01010011
    CP BRICK_TYPE_FULL_5      ; '5'
    JR Z, INIT_FULL_BRICK_DATA1_C

    LD C, %01100011
    CP BRICK_TYPE_FULL_6      ; '6'
    JR Z, INIT_FULL_BRICK_DATA1_C

    PUSH HL
    LD HL, FULL_POINTS_BRICK_PIXELS
    LD (PIXELS_DATA_FOR_BRICK), HL
    POP HL
    LD C, %00011111
    JR Z, INIT_FULL_BRICK_DATA1_C
    CP BRICK_TYPE_FULL_POINTS    ; 'P'
    JR Z, INIT_FULL_BRICK_DATA1_C

    PUSH HL
    LD HL, FULL_TRAINING_BRICK_PIXELS
    LD (PIXELS_DATA_FOR_BRICK), HL
    POP HL
    LD C, %00010000
    JR Z, INIT_FULL_BRICK_DATA1_C
    CP BRICK_TYPE_FULL_TRAINING    ; 'T'
    JR Z, INIT_FULL_BRICK_DATA1_C

    PUSH HL
    LD HL, FULL_EXTRA_BRICK_PIXELS
    LD (PIXELS_DATA_FOR_BRICK), HL
    POP HL
    LD C, %00010000
    JR Z, INIT_FULL_BRICK_DATA1_C
    CP BRICK_TYPE_FULL_EXTRA  ; 'E'
    JR Z, INIT_FULL_BRICK_DATA1_C

    ;;; Ide nem juthatunk, A-ban a tégla típusa
    CALL ERROR_A
    RET

INIT_EMPTY_HALF_BRICK_DATA4:
    LD A, 0
    LD (DE), A
    INC DE
    LD (DE), A
    INC DE
    LD (DE), A
    INC DE
    LD (DE), A
    INC DE
    INC HL
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DE : Az adatterület 3. bájtájnak a címe, ahol a tégla utolsó adatatát tárolni szeretnénk
;;; HL : A képernyőn a bal felső sarok bájt címe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INIT_LEFT_HALF_BRICK_DATA1:            ; Az utolsó adatbájt beállítása: 4-7=pont, 0-3=ütésszám
    LD A, %00010001
    LD (DE), A
    INC DE
    PUSH HL
    EXX
    POP HL
    LD DE, LEFT_HALF_BRICK_PIXELS
    CALL SHOW_TWO_BYTE_WITH_DE_HL
    EXX
    INC HL
    RET

INIT_RIGHT_HALF_BRICK_DATA1:            ; Az utolsó adatbájt beállítása: 4-7=pont, 0-3=ütésszám
    LD A, %00010001
    LD (DE), A
    INC DE
    PUSH HL
    EXX
    POP HL
    LD DE, RIGHT_HALF_BRICK_PIXELS
    CALL SHOW_TWO_BYTE_WITH_DE_HL
    EXX
    INC HL
    RET

INIT_MIDDLE_HALF_BRICK_DATA1:            ; Az utolsó adatbájt beállítása: 4-7=pont, 0-3=ütésszám
    LD A, %00010001
    LD (DE), A
    INC DE
    PUSH HL
    EXX
    POP HL
    LD DE, MIDDLE_HALF_BRICK_PIXELS
    CALL SHOW_TWO_BYTE_WITH_DE_HL
    EXX
    INC HL
    RET

INIT_FULL_BRICK_DATA1_C:                  ; Az utolsó adatbájt beállítása: 4-7=pont, 0-3=ütésszám
    LD A, C
    LD (DE), A
    INC DE
    ;;; Üres féltéglaadatok kitöltése
    LD A, 1
    LD (DE), A
    INC DE
    LD A, 0
    LD (DE), A
    INC DE
    LD (DE), A
    INC DE
    LD (DE), A
    INC DE
    ;;; Üres féltéglaadatok kitöltése vége
    PUSH HL
    LD A, C
    AND 240               ; A-ban most a felső 4 bit az ütési számláló
    EXX
SHOW_NEXT_IMAGE:
        LD HL, (PIXELS_DATA_FOR_BRICK)
        SUB 16            ; Egy ütést levonunk
        LD E, A
        LD D, 0
        ADD HL, DE
        EX DE, HL                 ; DE = FULL_BRICK_PIXELS + A
        POP HL                    ; HL = SCREEN FIRST BYTE ADDR, A contanis C
        PUSH AF
        PUSH HL
        CALL SHOW_TWO_BYTE_WITH_DE_HL
        POP HL
        POP AF
        JR Z, SKIP_NEXT_IMAGES_SHOW
        PUSH HL
        JR SHOW_NEXT_IMAGE
SKIP_NEXT_IMAGES_SHOW:
    EXX
    INC HL
    INC HL
    DEC B
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Egy tégla megütése, és erre a változásai, ha kell törlése a képernyőről és az adatterületéről is
;;; DE : A tégla címe a képernyőn
;;; HL : A tégla címe az adatterületén
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BRICK_COLLISION_DE_HL
    PUSH HL
    POP IX
    PUSH DE                     ; Képernyőcím eltétele
    LD A, (IX+3)                ; A 4. bájt. A felső 4 bit ütésszámláló, alsó 4 bit pontérték
    AND 15
    LD B, A                     ; Pontszám eltárolása
    CP 0
    CALL NZ, ADD_POINT_COUNTER_A ; A 0-át nem adjuk hozzá, hogy ne adjon hangot
    LD A, (IX+2)                ; A tégla típusa
    CP BRICK_TYPE_FULL_EXTRA
    PUSH AF
    CALL Z, INC_LIVE_COUNTER
    POP AF
    CP BRICK_TYPE_FULL_TRAINING
    CALL Z, TRAINING_WALL_ON
    CALL SET_HL_TO_PIXELS_ADDR_A  ; Berakja a téglához tartozó pixelkép kezdőcímét HL-be. A-ban a tégla típusa


    LD A, (IX+3)                ; A 4. bájt. A felső 4 bit ütésszámláló, alsó 4 bit pontérték
    AND 240                     ; A felső 4 bit kiemelése. Ha 0, akkor a labda törlése
    SUB 16
    OR B                        ; Pontszám visszatöltése
    LD (IX+3), A
    ;LD A, (IX+3)                ; A 4. bájt. A felső 4 bit ütésszámláló, alsó 4 bit pontérték
    AND 240                     ; A felső 4 bit kiemelése. Ha 0, akkor a labda törlése
    ;;; HL-ben a pixelek kezdőcíme, DE-ben bármi
    LD E, A
    LD D, 0
    ADD HL, DE                  ; HL-ben az eltüntetendő pixelcím
    EX DE, HL                   ; DE-ben a pixelek adatterületének kezdőcíme
    POP HL                      ; HL-be a képernyőcím
    CALL SHOW_TWO_BYTE_WITH_DE_HL
    LD A, (IX+3)                ; A 4. bájt. A felső 4 bit ütésszámláló, alsó 4 bit pontérték
    AND 240                     ; A felső 4 bit kiemelése. Ha 0, akkor a labda törlése
    CP 0
    RET NZ                      ; Ha az ütésszámláló nem 0, akkor befejeztük.
    CALL DEC_BRICK_COUNTER
    LD (IX+0), 0                ; Ha az ütésszámláló 0, akkor a képernyőn már nem látszik semmi, töröljük az adatterületet is
    LD (IX+1), 0
    LD (IX+2), 0
    LD (IX+3), 0
    LD A, (IX+4)
    CP 1
    RET NZ                      ; Ha ez nem 1, akkor egy adatcella tartozott hozzá
    LD (IX+4), 0                ; Ha kétbájtos, akkor a második cella adatterületét is törölni kell
    LD (IX+5), 0
    LD (IX+6), 0
    LD (IX+7), 0
    RET

HIDE_BRICK_LAYER_A_TYPE_B_SCREEN_DE:

SET_HL_TO_PIXELS_ADDR_A:
    LD HL, LEFT_HALF_BRICK_PIXELS
    CP BRICK_TYPE_HALF_LEFT  ; 'L'
    RET Z
    LD HL, RIGHT_HALF_BRICK_PIXELS
    CP BRICK_TYPE_HALF_RIGHT ; 'R'
    RET Z
    LD HL, MIDDLE_HALF_BRICK_PIXELS
    CP BRICK_TYPE_HALF_MIDDLE ; 'H'
    RET Z

    LD HL, FULL_BRICK_PIXELS
    CP BRICK_TYPE_FULL       ; 'F'
    RET Z
    CP BRICK_TYPE_FULL_2     ; '2'
    RET Z
    CP BRICK_TYPE_FULL_3     ; '3'
    RET Z
    CP BRICK_TYPE_FULL_4     ; '4'
    RET Z
    CP BRICK_TYPE_FULL_5     ; '5'
    RET Z
    CP BRICK_TYPE_FULL_6     ; '6'
    RET Z

    LD HL, FULL_POINTS_BRICK_PIXELS
    CP BRICK_TYPE_FULL_POINTS   ; 'P' 
    RET Z

;    LD HL, FULL_BLACK_BRICK_PIXELS
;    CP BRICK_TYPE_FULL_BLACK   ; 'B' 
;    RET Z

    LD HL, FULL_TRAINING_BRICK_PIXELS
    CP BRICK_TYPE_FULL_TRAINING   ; 'T' 
    RET Z

    LD HL, FULL_EXTRA_BRICK_PIXELS
    CP BRICK_TYPE_FULL_EXTRA ; 'E' 
    RET Z

    LD HL, 0        ; Akár 32 ' ', akár fel nem ismert, az mind space
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Egy bájt széles tégla megjeleníítése
;;; DE : Az adatterület kezdete. Egymás után 8 bájt írja le a téglát
;;; HL : A képernyőcím kezdete. 4 bittel eltoljuk a téglát.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SHOW_ONE_BYTE_WITH_DE_HL:
;    LD B, 8
;SHOW_ONE_LOOP:
;    LD A, (DE)
;    AND A
;    SRL A                  ; 0 -> .7 -> .0 .> CY
;    SRL A
;    SRL A
;    SRL A
;    XOR (HL)
;    LD (HL), A
;    INC HL
;    LD A, (DE)
;    AND A
;    SLA A                   ; CY <- .7 <- .0 <- 0
;    SLA A
;    SLA A
;    SLA A
;    XOR (HL)
;    LD (HL), A
;    INC DE
;    LD A, B
;    LD BC, 39
;    ADD HL, BC
;    LD B, A
;    DJNZ SHOW_ONE_LOOP
;    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Két bájt széles tégla megjeleníítése
;;; DE : Az adatterület kezdete. Egymás után 8 bájt írja le a téglát
;;; HL : A képernyőcím kezdete. 4 bittel eltoljuk a téglát.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHOW_TWO_BYTE_WITH_DE_HL:
    LD B, 8
SHOW_TWO_LOOP:

    LD A, (DE)
    AND A
    SRL A                  ; 0 -> .7 -> .0 .> CY
    SRL A
    SRL A
    SRL A
    XOR (HL)
    LD (HL), A
    INC HL
    LD A, (DE)
    AND A
    SLA A                   ; CY <- .7 <- .0 <- 0
    SLA A
    SLA A
    SLA A
    XOR (HL)
    LD (HL), A
    INC DE

    LD A, (DE)
    AND A
    SRL A                  ; 0 -> .7 -> .0 .> CY
    SRL A
    SRL A
    SRL A
    XOR (HL)
    LD (HL), A
    INC HL
    LD A, (DE)
    AND A
    SLA A                   ; CY <- .7 <- .0 <- 0
    SLA A
    SLA A
    SLA A
    XOR (HL)
    LD (HL), A
    INC DE

    LD A, B
    LD BC, 38
    ADD HL, BC
    LD B, A
    DJNZ SHOW_TWO_LOOP
    RET

PIXELS_DATA_FOR_BRICK: DW 0
