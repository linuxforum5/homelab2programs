BRICK_HEIGHT:       EQU 8                      ;;; Egy sor tégla magassága
SPACE_CELL_TOP:     EQU 6                      ;;; A téglák feletti tér mérete cellákban
HALFBRICKS_DATA:    EQU $C000                  ;;; A féltéglák adatai innentől tárolódnak. Egy féltégla 4 bájt. Első két bájt: kezdőcím, a legfelső bit pedig a hossza. Ha ez 0, akkor nincs ott tégla. 2 bájt szabad 
WALL_FIRST_BRICK_LINE_ROW0_INDEX: EQU 4         ;;; POS_Y_PER8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A téglávalütközés vizsgálata
;;; D - Az ütközés X irányú bájtindexe
;;; E - Az ütközés Y irányú bájtindexe, pixel/8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WALL_BRICK_CHECK_DE:
    BIT 7, D
    RET NZ                                 ; Ha D első bitje 1, akkor ez egy negatív érték, bitos nem tégla
    LD A, 38
    CP D
    RET C                                  ; Ha D > 38, akkor is passz
    LD HL, HALFBRICKS_DATA                 ; HL = Start
    LD C, D
    LD B, 0
    AND A                                  ; CY = 0
    RL C                                   ; CY <- .7 <- .0 <- CY
    RL B
    RL C
    RL B                                   ; BC = 4 * D = 4 * X
    ADD HL, BC                             ; HL = HL + X*4
    LD BC, 39*4                            ; Egy sor 39*4 bájt, mivel egy sorban 39 féltégla van
    LD A, E
WALL_BRICK_CHECK_ADDR_LOOP:
    CP 0
    JR Z, WALL_BRICK_CHECK_ADDR_OK
    ADD HL, BC                             ; HL = HL + 40
    DEC A
    JR WALL_BRICK_CHECK_ADDR_LOOP
WALL_BRICK_CHECK_ADDR_OK:
    ;;; Most HL-ben már az adatcella acíme van, ahol az érintett tégla adatai szerepelnek
    LD A, 0
    LD E, (HL)
    OR E
    INC HL
    LD D, (HL)
    DEC HL                              ; HL-t visszaállítjuk az adatterület elejére
    OR D
    RET Z                               ; Ha a féltégla címbájtja 0, akkor ott már nincs tégla
    CP 1
    JR NZ, SKIP_BACK_STEP               ; Ha a féltégla címbájtja 1 ( azaz 0001 vagy 0100 ) akkor ez egy kétbájtos tégla második bájtja. MEnjünk vissza az elsőre
    DEC HL
    DEC HL
    DEC HL
    LD D, (HL)
    DEC HL
    LD E, (HL)                          ; Itt DE már nem lehet se 0 sem 1
SKIP_BACK_STEP:                         ; DE a tégla bal felső sarkára mutat a képernyőn, HL az adatterület elejére
    JP BRICK_COLLISION_DE_HL            ; A tégla megütése, ha kell törlés a képernyőről és az adatterületről is.. DE-ben a tégla képernyőcíme, HL-ben az adatterület kezdőcíme van.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Brick data műveletek
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CLEAR_BRICKS_DATA_AREA:
;    LD HL, HALFBRICKS_DATA-1
;    LD (HL), 0
;    LD DE, HALFBRICKS_DATA
;    INC DE
;    LD BC, 961                  ; 40*6*4-1+2
;    LDIR
;    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Kirajzol egy pályát, azaz falat a megadott címen tárolt réglákkal
;;; HL: A pálya adatainak a címe
;;; Adatformátum: 
;;;   - felső 4 bit téglatípus, lehet 0
;;;   - alsó 4 bit téglaszám, nem lehet 0
;;; Return HL a pályaadatok utáni első szabad bájt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHOW_WALL_HL:
    PUSH HL
    LD A, 0
    LD (BRICK_COUNTER), A

    LD B, SPACE_CELL_TOP
    LD C, 0

    LD HL, (DCB_HM_2)                    ;;; A grafikus terület kezdete
    LD DE, SPACE_CELL_TOP*5*40+80
    ADD HL, DE
    LD (FIRST_BRICK_ADDRESS), HL         ;;; A felső sor kezdőcíme a képernyőn
    POP BC                               ;;; Innen olvassuk az adatokat az inicializáláshoz
    LD DE, HALFBRICKS_DATA               ;;; Ezt az adatterületet akarjuk inicializálni
    CALL SHOW_WALL_LINE_BC_DE_HL
    CALL SHOW_WALL_LINE_BC_DE_HL
    CALL SHOW_WALL_LINE_BC_DE_HL
    CALL SHOW_WALL_LINE_BC_DE_HL
    CALL SHOW_WALL_LINE_BC_DE_HL
    CALL SHOW_WALL_LINE_BC_DE_HL
    PUSH BC
    POP HL                               ;;; Visszaadjuk  HL-ben a következő pálya első bájtjának címét
    LD A, (HL)
    CP 0
    CALL NZ, ERROR_A
    INC HL
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; BC : a téglasor adatforrása
;;; DE : a terület, amit inicializálni akarunk
;;; HL : az első képernyőbájt, ahová ki kell írnunk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHOW_WALL_LINE_BC_DE_HL:
    PUSH BC
    EXX
        POP BC                     ; BC'-be is betesszük BC értékét
    EXX
    LD B, 39
SHOW_WALL_LINE_LOOP:
        EXX
            LD A, (BC)
            INC BC
            PUSH BC
        EXX
        CALL INIT_BRICK_BLOCK_DE_HL_A_B ; Az A-ban tárol téglablokkok kitétele, B annyival  csökken, ahány féltéglányi helyet elfoglal
        EXX
            POP BC
        EXX
    DJNZ SHOW_WALL_LINE_LOOP

    EXX
        PUSH BC
    EXX
    POP BC
    PUSH DE
    LD DE, 7*40+1
    ADD HL, DE
    POP DE
    RET

FIRST_BRICK_ADDRESS: DW 0

;include 'bricks/full.asm'
;include 'bricks/half.asm'
include 'bricks/brick.asm'
include 'bricks/pixels.asm'
