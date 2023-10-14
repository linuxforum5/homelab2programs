;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INIT_DEMO_BALL:
    LD A, DIRECTION_X_DEMO_START
    LD (DIRECTION_X), A
    LD A, DIRECTION_Y_DEMO_START
    LD (DIRECTION_Y), A

    LD A, POS_Y_PER8_DEMO_START
    LD (POS_Y_PER8), A
    LD A, POS_Y_MOD8_DEMO_START
    LD (POS_Y_MOD8), A

    LD A, POS_X_PER8_DEMO_START
    LD (POS_X_PER8), A
    LD A, POS_X_MOD8_DEMO_START
    LD (POS_X_MOD8), A
    CP 0
    LD B, A
    LD A, 255
    JR Z, SPRITE_DEMO_MASK_IS_OK
SPRITE_DEMO_MASK_SHIFT:
    AND A                         ; CY := 0
    RRA                           ; CY->7->0->CY
    PUSH AF
    PUSH BC
    CALL RRC_SPRITE
    POP BC
    POP AF
    DJNZ SPRITE_DEMO_MASK_SHIFT
SPRITE_DEMO_MASK_IS_OK:           ;;; Innentől mindkét ball init zaonos
    LD (SPRITE_MASK), A
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Meghatározzuk a SPRITE kezdőcímét
    LD HL, (DCB_HM_2)                               ; A grafikus terület bal felső bájtjának címe

    LD BC, POS_X_PER8_DEMO_START                         ; AZ X pozíció 8-cal osztható része a bájtok száma, amennyivel jobbra toljuk
    ADD HL, BC
    LD (SPRITE_SCREEN_ADDR), HL                            ; A SPRITE kezdőcímének az X összetevője rendben

    LD A, POS_Y_PER8_DEMO_START*8 + POS_Y_MOD8_DEMO_START     ; A-be bekrül a kiindulási Y koordináta
    CP 0
    RET Z                                           ; Ha ez 0, akkor a (SPRITE_SCREEN_ADDR) értéke rendben van

    LD B, A                                         ; Ha A > 0, akkor B számlálóba betöltjük ezt az A értéket. Ennyiszer fogunk 40-et hozzáadni a címhez
    LD DE, 40
INIT_DEMO_INC_ROW:
    ADD HL, DE
    DJNZ INIT_DEMO_INC_ROW
    LD (SPRITE_SCREEN_ADDR), HL                            ; HL most már a SPRITE valós kezdőcímét tartalmazza

    RET


INIT_BALL:
    LD HL, SPRITE8x8_INIT
    LD DE, SPRITE8x8
    LD BC, 8
    LDIR

    LD A, START_SPEED_X
    LD (MAX_SPEED_X), A
    LD (SPEED_X_CURR), A

    LD A, (GAME_MODE)
    CP GAME_MODE_DEMO
    JR Z, INIT_DEMO_BALL

    LD A, DIRECTION_X_START
    LD (DIRECTION_X), A
    LD A, DIRECTION_Y_START
    LD (DIRECTION_Y), A

    LD A, POS_Y_PER8_START
    LD (POS_Y_PER8), A
    LD A, POS_Y_MOD8_START
    LD (POS_Y_MOD8), A

    LD A, POS_X_PER8_START
    LD (POS_X_PER8), A
    LD A, POS_X_MOD8_START
    LD (POS_X_MOD8), A
    CP 0
    LD B, A
    LD A, 255
    JR Z, SPRITE_MASK_IS_OK
SPRITE_MASK_SHIFT:
    AND A                         ; CY := 0
    RRA                           ; CY->7->0->CY
    PUSH AF
    PUSH BC
    CALL RRC_SPRITE
    POP BC
    POP AF
    DJNZ SPRITE_MASK_SHIFT

SPRITE_MASK_IS_OK:           ;;; Innentől mindkét ball init zaonos
    LD (SPRITE_MASK), A
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Meghatározzuk a SPRITE kezdőcímét
    LD HL, (DCB_HM_2)                               ; A grafikus terület bal felső bájtjának címe

    LD BC, POS_X_PER8_START                         ; AZ X pozíció 8-cal osztható része a bájtok száma, amennyivel jobbra toljuk
    ADD HL, BC
    LD (SPRITE_SCREEN_ADDR), HL                            ; A SPRITE kezdőcímének az X összetevője rendben

    LD A, POS_Y_PER8_START*8 + POS_Y_MOD8_START     ; A-be bekrül a kiindulási Y koordináta
    CP 0
    RET Z                                           ; Ha ez 0, akkor a (SPRITE_SCREEN_ADDR) értéke rendben van

    LD B, A                                         ; Ha A > 0, akkor B számlálóba betöltjük ezt az A értéket. Ennyiszer fogunk 40-et hozzáadni a címhez
    LD DE, 40
INIT_INC_ROW:
    ADD HL, DE
    DJNZ INIT_INC_ROW
    LD (SPRITE_SCREEN_ADDR), HL                            ; HL most már a SPRITE valós kezdőcímét tartalmazza

    RET

SAVE_BALL_DATA:
    LD HL, (SPRITE_SCREEN_ADDR)
    LD (OLD_SPRITE_SCREEN_ADDR), HL
    LD A, (SPRITE_MASK)
    LD (OLD_SPRITE_MASK), A
    LD BC, 8
    LD HL, SPRITE8x8
    LD DE, OLD_SPRITE8x8
    LDIR
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Vízszintes elmozdulások műveletei, ütközéstől függetlenül
;;; Minden lépésben meghívódik, de a SPEED_X_CURR mindig számol visszafelé MAX_SPEED_X-től 0-ig, és csak akkor mozdul
;;; valójában, ha elérte a 0-át. Ilnyenkor mindig felveszi újra a maximális értéket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVE_H:
    LD A, (SPEED_X_CURR)
    CP 0
    RET Z
    DEC A
    JR NZ, SKIP_MOVE_H
    LD A, (MAX_SPEED_X)
    LD (SPEED_X_CURR), A
    ;;; SPEED_X rednben eltárolva
    LD A, ( DIRECTION_X )
    CP 1
    JR Z, MOVE_RIGHT
    CP -1
    JR Z, MOVE_LEFT
    RET
SKIP_MOVE_H:
    LD (SPEED_X_CURR), A
    RET

MOVE_RIGHT:
    ;;; Cell szinkron begin
    LD A, (POS_X_MOD8)              ; 0-7
    INC A
    CP 8                            ; Bájthatár?
    JR NZ, MOVE_RIGHT_IN_BYTE       ; A != 8, tehát bjáton bellül léptünk jobbra
    LD A, (POS_X_PER8)              ; A == 8, tehát új bájtba léptünk, az egészrész is növekszik
    INC A
    LD (POS_X_PER8), A
    LD A, 0                         ; A := 0, ez a maradék
MOVE_RIGHT_IN_BYTE:                 ; Rednben
    LD (POS_X_MOD8), A              ; A-ban a maradék, egészrész is rendben, A-t betöltjük a maradéktárolóba
    ;;; Cell szinkron end
    CALL RRC_SPRITE
    LD A, (SPRITE_MASK)
    AND A
    RRA                           ; CY->7->0->CY
    LD (SPRITE_MASK), A

    CP 0
    RET NZ
    LD A, 255
    LD (SPRITE_MASK), A
    LD HL, (SPRITE_SCREEN_ADDR)
    INC HL
    LD (SPRITE_SCREEN_ADDR), HL
    RET

MOVE_LEFT:
    ;;; Cell szinkron begin
    LD A, (POS_X_MOD8)
    DEC A
    CP 255
    JR NZ, MOVE_LEFT_IN_BYTE
    LD A, (POS_X_PER8)
    DEC A
    LD (POS_X_PER8), A
    LD A, 7
MOVE_LEFT_IN_BYTE:
    LD (POS_X_MOD8), A
    ;;; Cell szinkron end
    CALL RLC_SPRITE
    LD A, (SPRITE_MASK)
    SCF
    RLA                           ; CY<-7<-0<-CY
    LD (SPRITE_MASK), A

    RET NC
    LD A, 1
    LD (SPRITE_MASK), A
    LD HL, (SPRITE_SCREEN_ADDR)
    DEC HL
    LD (SPRITE_SCREEN_ADDR), HL
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Függőleges mozgás előzetes ellenőrzése
;;; Ha a Z flag 1, akkor ez az irányú elmozdulás lehetséges, nincs ütközés
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_CHECK_NEXT_V_Z:
    LD A, ( DIRECTION_Y )
    CP 1
    JP Z, SPRITE_CHECK_NEXT_DOWN_Z
    CP -1
    JP Z, SPRITE_CHECK_NEXT_UP_Z
    XOR A           ; F.Z:=1
    RET

SPRITE_BOUNCE_V:
    EX AF, AF' ; ' PUSH AF
    LD A, ( DIRECTION_Y )
    CP 1                                 ; Lefele megyünk?2
    JR NZ, SKIP_DOWN_B2_CORRECTION          ; Ha nem, akkor ugorjuk át a B' komplelemnerképzését
    EXX
    LD A, 7
    SUB B
    LD B, A
    EXX
SKIP_DOWN_B2_CORRECTION:
    EX AF, AF' ; ' POP AF
    LD C, 0
    CALL SPRITE_COLLISION_A_C
    LD A, ( DIRECTION_Y )
    NEG
    LD ( DIRECTION_Y ), A
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Lefelő történő mozgás előzetes ellenőrzése. Célszerű alulról felfelé vizsgálni. Elég lenne csak 4-et? Kihasználjuk, hogy a szélén 0
;;; Ha a Z flag 1, akkor ez az irányú elmozdulás lehetséges, nincs ütközés
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_CHECK_NEXT_DOWN_Z:
    LD HL, (SPRITE_SCREEN_ADDR)       ; Az első vizsgált képernyőbájt
    LD BC, 40*7
    ADD HL, BC                        ; A sprite elomzdulás utáni kezdőcíme
    LD DE, SPRITE8x8+7                ; A sprite adatterületének utolsó bájtjának címe
    EXX
    LD B, 7
    LD C, 0
    ;;; Első oszlop vizsgálatának megkezdése
SPRITE_CHECK_ROW_B_DOWN:
    EXX
    LD A, (SPRITE_MASK)
    CALL SPRITE_CHECK_DOWN_CURRENT_BYTE_HL_DE_A__Z       ; A HL-ben található képernyőbájt vizsgálata, lefelemozgás esetén
    RET NZ                            ; ha az eredmény nem nulla, akkor a lefelémozgánál ütközés történik
    ;;; Ha ide eljutunk, akkor nem volt ütközés. HL, DE változatlan
    ;;; Második oszlop vizsgálatának megkezdése
    EXX
    INC C
    EXX
    INC HL                            ; Második oszlopra állunk a képernyőn
    LD A, (SPRITE_MASK)
    CPL                               ; Mask invertálása a második oszlophoz
    CALL SPRITE_CHECK_DOWN_CURRENT_BYTE_HL_DE_A__Z       ; A HL-ben található képernyőbájt vizsgálata, lefelemozgás esetén
    RET NZ
    ;;; Ha ide lejutottunk, ez a sor rendben
    LD BC, -41
    ADD HL, BC
    DEC DE                            ; Az előző sprite adatsorra álltunk
    EXX
    INC C
    DJNZ SPRITE_CHECK_ROW_B_DOWN
    EXX
    XOR A                             ; Z flag 1-beállítása
    RET

SPRITE_CHECK_DOWN_CURRENT_BYTE_HL_DE_A__Z: ;;; HL: képernyőbájt címe, DE: sprite adatbájt címe, A:Mask, Z return flag
    LD B, A                           ; A mask eltárolása B-ben
    EX DE, HL
    AND (HL)                          ; A-ban a sprite második sorának első oszlopa
    EX DE, HL
    XOR (HL)                          ; Kivágjuk xoroljuk belőle a képernyőn látható második bájtot, így A-ban csak a második bájt sprite-on kívüli pontjai lesznek
    DEC DE                            ; A felette lévő sorra álunk a sprite adataiban
    LD C, A                           ; Ideiglenesen eltároljuk az A tartalmát
    LD A, B                           ; A-ba ismét a MASK kerül
    EX DE, HL
    AND (HL)                          ; A-ban a sprite előző sorának első oszlopa
    EX DE, HL
    AND C                             ; Ezt összeéseljük az előzőleg kinyert pixelekkel, és 
    INC DE                            ; Vissazálltunk a kiindulási állapotra.
    RET                               ; ha az eredmény nem nulla, akkor a lefelémozgánál ütközés történik

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Felfelé történő mozgás előzetes ellenőrzése
;;; Ha a Z flag 1, akkor ez az irányú elmozdulás lehetséges, nincs ütközés
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_CHECK_NEXT_UP_Z:
    LD HL, (SPRITE_SCREEN_ADDR)
    LD BC,  0
    ADD HL, BC                        ; A sprite elomzdulás utáni kezdőcíme
    LD DE, SPRITE8x8                ; A sprite adatterületének kezdőcíme
    EXX
    LD B, 7
    ;;; Első oszlop vizsgálatának megkezdése
SPRITE_CHECK_ROW_B_UP:
    LD C, 0
    EXX
    LD A, (SPRITE_MASK)
    CALL SPRITE_CHECK_UP_CURRENT_BYTE_HL_DE_A__Z       ; A HL-ben található képernyőbájt vizsgálata, felfeemozgás esetén
    RET NZ                            ; ha az eredmény nem nulla, akkor ütközés történik
    ;;; Ha ide eljutunk, akkor nem volt ütközés. HL, DE változatlan
    ;;; Második oszlop vizsgálatának megkezdése
    EXX
    INC C
    EXX
    INC HL                            ; Második oszlopra állunk a képernyőn
    LD A, (SPRITE_MASK)
    CPL                               ; Mask invertálása a második oszlophoz
    CALL SPRITE_CHECK_UP_CURRENT_BYTE_HL_DE_A__Z       ; A HL-ben található képernyőbájt vizsgálata, lefelemozgás esetén
    RET NZ
    LD BC, 39
    ADD HL, BC
    INC DE                            ; Következő sorra álltunk
    EXX
    DJNZ SPRITE_CHECK_ROW_B_UP
    EXX
    XOR A                             ; Z flag 1-beállítása
    RET

SPRITE_CHECK_UP_CURRENT_BYTE_HL_DE_A__Z:
    LD B, A                           ; A mask eltárolása B-ben
    EX DE, HL
    AND (HL)                          ; A-ban a sprite második sorának első oszlopa
    EX DE, HL
    XOR (HL)                          ; Kivágjuk xoroljuk belőle a képernyőn látható második bájtot, így A-ban csak a második bájt sprite-on kívüli pontjai lesznek
    INC DE                            ; A felette lévő sorra álunk a sprite adataiban
    LD C, A                           ; Ideiglenesen eltároljuk az A tartalmát
    LD A, B                           ; A-ba ismét a MASK kerül
    EX DE, HL
    AND (HL)                          ; A-ban a sprite előző sorának első oszlopa
    EX DE, HL
    AND C                             ; Ezt összeéseljük az előzőleg kinyert pixelekkel, és 
    DEC DE                            ; Vissazálltunk a kiindulási állapotra.
    RET                               ; ha az eredmény nem nulla, akkor a lefelémozgánál ütközés történik

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Vízszintes mozgás előzetes ellenőrzése
;;; Ha a Z flag 1, akkor ez az irányú elmozdulás lehetséges, nincs ütközés
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_CHECK_NEXT_H_Z:
    LD A, ( DIRECTION_X )
    CP -1
    JR Z, SPRITE_CHECK_NEXT_RIGHT_Z
    CP 1
    JR Z, SPRITE_CHECK_NEXT_LEFT_Z
    XOR A           ; F.Z:=1
    RET

SPRITE_BOUNCE_H:
;    EX AF, AF' ; '
;    LD A, ( DIRECTION_X )
;    LD C, A
;    EX AF, AF' ; '
    LD C, 1
    CALL SPRITE_COLLISION_A_C

    LD A, ( DIRECTION_X )
    NEG
    LD ( DIRECTION_X ), A
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Jobbra történő mozgás előzetes ellenőrzése. Kihasználjuk, hogy a szélén 0
;;; Ha a Z flag 1, akkor ez az irányú elmozdulás lehetséges, nincs ütközés
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_CHECK_NEXT_RIGHT_Z:
    LD HL, (SPRITE_SCREEN_ADDR)       ; Az első vizsgált képernyőbájt
    LD BC, 41
    ADD HL, BC                        ; A második sor második bájtjától, mivel az első sorról tudom, hogy üres
    LD DE, SPRITE8x8+1                ; A sprite adatterületének kezdőcíme+1 = A 2. sor adata
    EXX
    LD B, 6                           ; 6 sort vizsgálunk
    ;;; A 2. oszlop vizsgálatának megkezdése
SPRITE_CHECK_ROW_B_RIGHT:
    LD C, 1                           ; C' = oszlopindex. Ezt majd visszaadjuk, számoláshoz nem kell
    EXX                               ; Számláló elmentése
    CALL SPRITE_CHECK_RIGHT2_CURRENT_BYTE_HL_DE__Z       ; A HL-ben található képernyőbájt sorának vizsgálata, jobbramozgás esetén, jobbról balra
    RET NZ                            ; ha az eredmény nem nulla, akkor a lefelémozgánál ütközés történik
    ;;; Ha ide eljutunk, akkor nem volt ütközés és HL 1-gyel kisebb, DE változatlan
    LD BC, 41
    ADD HL, BC
    INC DE                            ; Az előző sprite adatsorra álltunk
    EXX
    DJNZ SPRITE_CHECK_ROW_B_RIGHT
    EXX
    XOR A                             ; Z flag 1-beállítása
    RET

SPRITE_CHECK_RIGHT2_CURRENT_BYTE_HL_DE__Z: ;;; HL: képernyőbájt címe, DE: sprite adatbájt címe, A:Mask, Z return flag
    LD A, (SPRITE_MASK)               ;
    CPL                               ; Mivel a második oszloptól kezdjük, először CPL
;    LD B, A                           ; 1 cycle Az inverz maszk eltárolása B-ben
    EX DE, HL                         ; DE = 55E2 (55E1 a kezdőcím)
    AND (HL)                          ; A-ban a sprite vizsgált sorának első oszlopának bájtja                        (HL) 01000000
LD (SPRITE_PIXELS), A
    EX DE, HL
    XOR (HL)                          ; 00000000 Kivágjuk - xoroljuk - belőle a képernyőn látható bájtot, így A-ban csak a bbájt sprite-on kívüli pontjai lesznek
LD B, A ; SCREEN_PIXELS
LD A, (SPRITE_PIXELS)
    AND A                             ; F.CY := 0 Ez lehet 0, mivel tudjuk, hogy a sprite széle biztosan 0. Sőt, a két bájtból a jobboldaliban biztos 2 0 oszlop is van!!!
    RLA                               ; CY<-A.7<-A.0<-CY
    RL C                              ; CY <- C.7 <- C.0 <- CY : C.0 := F.CY
    AND B                             ; A sprite maskját visszaéseljük a balramozgatott háttérre. Ha ez 0, akkor nincs üzközés
    RET NZ                            ; Ha már ez nem 0, akkor ütközés van

    EXX
    DEC C                             ; C'-ben az oszlopparitás nullázása. Csak visszaadjuk, nem használjuk.
    EXX
    DEC HL                            ; A képernyőcím egyel balramozgatása
    LD A, (SPRITE_MASK)               ; Eredeti maszk az 1. oszlophoz
;    LD B, A      ; 03                     ; Az eredeti mask eltárolása B-ben
    EX DE, HL                         ; Ezután HL-ben az adatcím, DE-ben a képernyőcím
    AND (HL)     ; (HL)=F0                     ; A-ban a sprite vizsgált sorának első oszlopának bájtja
LD (SPRITE_PIXELS), A
    EX DE, HL
    XOR (HL)     ; (HL)=FF                     ; Kivágjuk - xoroljuk - belőle a képernyőn látható bájtot, így A-ban csak a bájt sprite-on kívüli pontjai lesznek
LD B, A ; SCREEN_PIXELS
LD A, (SPRITE_PIXELS)
    RR C                              ; CY flag visszatöltve! CY := C.0
    RLA                               ; CY<-A.7<-A.0<-CY
    AND B                             ; A sprite maszkját visszaéseljük a balramozgatott háttérre. Ha ez 0, akkor nincs üzközés
    RET Z
DEBUGGG:         ; C=0x29 = 00101001
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Balra történő mozgás előzetes ellenőrzése. Kihasználjuk, hogy a szélén 0
;;; Ha a Z flag 1, akkor ez az irányú elmozdulás lehetséges, nincs ütközés
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_CHECK_NEXT_LEFT_Z:
    LD HL, (SPRITE_SCREEN_ADDR)       ; Az első vizsgált képernyőbájt
    LD BC, 40
    ADD HL, BC                        ; Második sor első bájtja
    LD DE, SPRITE8x8+1                ; A sprite adatterületének kezdőcíme + 1
    EXX
    LD B, 6                           ; 8 sort vizsgálunk
    ;;; Első oszlop vizsgálatának megkezdése
SPRITE_CHECK_ROW_B_LEFT:
    LD C, 0
    EXX                               ; Számláló elmentése
    CALL SPRITE_CHECK_LEFT2_CURRENT_BYTE_HL_DE__Z       ; A HL-ben található képernyőbájt vizsgálata, lefelemozgás esetén
    RET NZ                            ; ha az eredmény nem nulla, akkor a lefelémozgánál ütközés történik
    ;;; Ha ide eljutunk, akkor nem volt ütközés és HL 1-gyel kisebb, DE változatlan
    LD BC, 39
    ADD HL, BC
    INC DE                            ; Az előző sprite adatsorra álltunk
    EXX
    DJNZ SPRITE_CHECK_ROW_B_LEFT
    EXX
    XOR A                             ; Z flag 1-beállítása
    RET

SPRITE_CHECK_LEFT2_CURRENT_BYTE_HL_DE__Z: ;;; HL: képernyőbájt címe, DE: sprite adatbájt címe, A:Mask, Z return flag
    LD A, (SPRITE_MASK)               ;
;    LD B, A                           ; Az 1. oszlop maszkjának eltárolása B-ben
    EX DE, HL                         ;
    AND (HL)                          ; A-ban a sprite vizsgált sorának első oszlopának bájtja (itt HL=adatsor címe)
LD (SPRITE_PIXELS), A ; (4706)=5A
    EX DE, HL
    XOR (HL)                          ; Kivágjuk - xoroljuk - belőle a képernyőn látható bájtot, így A-ban csak a bájt sprite-on kívüli pontjai lesznek
LD B, A ; SCREEN_PIXELS
LD A, (SPRITE_PIXELS)
    AND A                             ; F.CY := 0 Ez lehet 0, mivel tudjuk, hogy a sprite széle biztosan 0. Sőt, a két bájtból a jobboldaliban biztos 2 0 oszlop is van!!!
    RRA                               ; CY->A.7->A.0->CY
    RR C                              ; C.0 := F.CY
    AND B                             ; A sprite maszkját visszaéseljük a balramozgatott háttérre. Ha ez 0, akkor nincs üzközés
    RET NZ                            ; Ha már ez nem 0, akkor ütközés van

    EXX
    INC C
    EXX
    INC HL
    LD A, (SPRITE_MASK)
    CPL
;    LD B, A                           ; A mask eltárolása B-ben
    EX DE, HL
    AND (HL)                          ; A-ban a sprite vizsgált sorának első oszlopának bájtja
LD (SPRITE_PIXELS), A
    EX DE, HL
    XOR (HL)                          ; Kivágjuk - xoroljuk - belőle a képernyőn látható bájtot, így A-ban csak a bbájt sprite-on kívüli pontjai lesznek
LD B, A
LD A, (SPRITE_PIXELS)
    RL C                              ; CY flag visszatöltve!
    RRA                               ; CY->A.7->A.0->CY
    AND B                             ; A sprite jobbra mozgatott maszkját visszaéseljük a háttérre. Ha ez 0, akkor nincs üzközés
    RET

SPRITE_PIXELS: DB 0
;SCREEN_PIXELS: DB 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Függőleges elmozdulások műveletei, ütközéstől függetlenül
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVE_V:
    LD A, (DIRECTION_Y)
    CP 0
    RET Z
    ;;; Cell szinkron begin
    CP 1
    JR Z, MOVE_DOWN

MOVE_UP:                         ; DE < 0
    ;;; Felfele megy
    LD A, (POS_Y_MOD8)
    DEC A
    CP 255
    JR NZ, SKIP_UP
        LD A, (POS_Y_PER8)
        DEC A
        LD (POS_Y_PER8), A
        LD A, 7
SKIP_UP:
    LD (POS_Y_MOD8), A
    LD DE, -40
    JR MOVE_V_CELL_OK_DE

MOVE_DOWN:                       ; DE > 0
    ;;; Lefele megy
    LD A, (POS_Y_MOD8)
    INC A
    CP 8
    JR NZ, SKIP_DOWN
        LD A, (POS_Y_PER8)
        INC A
        LD (POS_Y_PER8), A
        LD A, 0
SKIP_DOWN:
    LD (POS_Y_MOD8), A
    LD DE, 40

MOVE_V_CELL_OK_DE:
    ;;; Cell szinkron end
    LD HL, (SPRITE_SCREEN_ADDR)
    ADD HL, DE
    LD (SPRITE_SCREEN_ADDR), HL
    RET

RRC_SPRITE:
    LD HL, SPRITE8x8
    LD B, 8
RRC_LOOP:
    RRC (HL)
    INC HL
    DJNZ RRC_LOOP
    RET

RLC_SPRITE:
    LD HL, SPRITE8x8
    LD B, 8
RLC_LOOP:
    RLC (HL)
    INC HL
    DJNZ RLC_LOOP
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; F.Z = 1
;;; HL : Az ütközés memóriacíme alatti bájt címe, amivel a sprite ütközött ( A sprite kezdőcímét a (SPRITE_SCREEN_ADDR) tárolja
;;; Kellhet még : POS_X_MOD8, POS_Y_MOD8, POS_X_PER8, POS_Y_PER8
;;; Meg kell tartani HL, BC értékét
;;;   Bájthatárok:    xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
;;;   Cellahatárok:       cccc cccc         cccc cccc
;;;   Mask:           00011111 11100000
;;;   Üzközési érték: A
;;; Oszlopelemzés:
;;;   Oszlopindex: cellahatár
;;;   OC1 = Oszlopindex + (C' & 1)
;;;   Kiütött oszlop: Ha C' & 1 == 0 és A & 00001111, akkor az Oszlopindex        OC1
;;;                   Ha C' & 1 == 0 és A & 11110000, akkor az Oszlopindex-1      OC1-1
;;;                   Ha C' & 1 == 1 és A & 11110000, akkor az Oszlopindex        OC1-1
;;;                   Ha C' & 1 == 1 és A & 00001111, akkor az Oszlopindex+1      OC1
;;; Sorelemzést:
;;;   Kiütött oszlop: 
;;; A: az ütközési érték bitjei
;;; C: 0=függőleges, 1=vízszintes ///rxxx C: Vizszintes eltolás az X koordinátához, vízszintes irányban nem 0 Függőleges esetben ez 0 (DIRECTION_X értéke)
;;; B': Függőleges sorindex. A legfelső látható sor indexe 5, a legalsóé 0. Csak vízszintes irány esetén ez az érték, tehát ha C<>0
;;; C': Cellaindex. Utolsó bitje az oszlopindex: 0=első oszlop, 1=második oszlop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_COLLISION_A_C:
    EX AF, AF' ; '                            ; A'-be kerül az ütött érték
    LD A, (POS_Y_PER8)
    CP RACKET_FIRST_LINE_ROW0_INDEX
    JR NC, SPRITE_RACKET_COLLISION_A2_C_C2_B2 ; RACKET_LAST_LINE_ROW0_INDEX
    LD A, (POS_X_PER8)
;    ADD A, C                    ; Korrekció hozzáadása
    LD D, A                      ; D az ütközés cellájának X koordinátája (POS_X_PER8)

    EXX
    LD A, C                     ; A-ba C'
    EXX
    AND 1
    ADD A, D
    LD D, A

    EX AF, AF' ; ' ; A'-ben              ; A-ban az ütött érték
    ;POP AF
    AND 0xF0                           ; 
    JR Z, SPRITE_COLLISION_VCOL_OK    ; Ha nem nulla, akkor az első 4 bitben volt az ütközési adat, tehát a sprite oszlopában
    DEC D
SPRITE_COLLISION_VCOL_OK:

    LD A, 39                           ; Ha a 39. oszlopot akarná vizsgálni, ne tegye, ott biztos nincs 
    CP D
    JR Z, ENDDD                        ; A 39 oszlop helyett vége. Csak 0-38-ig vannak oszlopok
    LD A, -1                           ; Ha a -1. oszlopot akarná vizsgálni, ne tegye, ott biztos nincs 
    CP D
    JR Z, ENDDD                        ; Csak 0-38-ig vannak oszlopok

    LD A, (POS_Y_PER8)
    LD E, A                  ; E-ben az Y%8
    EXX
    LD A, 7
    SUB B
    LD B, A                  ; A-ban az ütközési sor index [0-7]
    EXX
    LD A, (POS_Y_MOD8)
    EXX
    ADD A, B
    EXX
    CP 8
    JR C, SPRITE_COLLISION_SKIP_INC_Y   ; Ha az A értéke most is 8 alatti, akkor ugyanabban a függőleges bájtcellában van az ütközés, mint a sprite eleje
    INC E
SPRITE_COLLISION_SKIP_INC_Y:
    LD A, E
    SUB WALL_FIRST_BRICK_LINE_ROW0_INDEX                    ; Az Y/8-ból ki kell vonni az első téglasor Y/8 értékét!!!!!!!! Ez most be van drótozva, de majd számoljuk @TODO
    CP 6
    LD E, A                  ; E-ben az ütközés függőleges bájtcella indexe INT(Y/8)
    CALL C, WALL_BRICK_CHECK_DE     ; CY = 1, ha Y > 5 : Ha 5-nél nagyobb az Y, akkor biztos nem fal, mivel fal csak 0-5 között lehet
ENDDD:
    RET

SPRITE_RACKET_COLLISION_A2_C_C2_B2: ; RACKET_LAST_LINE_ROW0_INDEX
    LD A, C
    CP 0
    RET NZ                          ; Ha C != 0, akkor vízszintes ütközés. Ebbe nem szólunk bele
    LD A, (POS_Y_PER8)
    CP RACKET_LAST_LINE_ROW0_INDEX
    RET NC                           ; Ha biztosan nem az ütőről patan, nem vizsgálunk
    PUSH AF
    PUSH BC
    CALL SOUND_RACKET
    POP BC
    POP AF
    ;;; C == 0, tehát függőleges ütközés
    LD A, (RACKET_LAST_DIRECTION)
    CP 0
    RET Z                           ; Ha az ütő nem mozog, semmi új sem történik
    NEG
    LD B, A
    LD A, (DIRECTION_X)
    CP B
    JR Z, RACKET_OPPOSITE_DIRECTION
    JR NZ, RACKET_SAME_DIRECTION

RACKET_SAME_DIRECTION:
    LD A, (MAX_SPEED_X)                 ; A meredekséget tárolja
    DEC A
    CP 0
    RET Z                               ; A legnagyobb sebessgé az 1, ezen nem tudunk növelni
    LD (MAX_SPEED_X), A
    LD (SPEED_X_CURR), A
    LD A, (RACKET_LAST_DIRECTION)
    LD (DIRECTION_X), A
    RET

RACKET_OPPOSITE_DIRECTION:
    LD A, (MAX_SPEED_X)
    INC A
    CP MAX_BALL_ANGLE_X
    JR NZ, SLOWER_SPEED_X
    LD A, 0
    LD (DIRECTION_X), A
    RET
SLOWER_SPEED_X:
    LD (MAX_SPEED_X), A
    LD (SPEED_X_CURR), A
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Sprite megjelenítése
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHOW_BALL:
    LD DE, (SPRITE_SCREEN_ADDR)
    LD HL, SPRITE8x8
    LD B, 8
SHOW_ROW:
    LD A, (SPRITE_MASK)
    AND (HL)
    LD C, A
    LD A, (DE)                        ; A sprite alatti pixelek
    XOR C
    LD (DE), A

    INC DE

    LD A, (SPRITE_MASK)
    CPL
    AND (HL)
    LD C, A
    LD A, (DE)
    XOR C
    LD (DE), A

    LD A, B
    LD BC, 39
    EX DE, HL
    ADD HL, BC
    EX DE, HL
    LD B, A
    INC HL
    DJNZ SHOW_ROW
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Az elmentett adatok alapján újrarajzolja a sprite-ot. Mivel a rajzolás XOR-ral történik, így igaziból letörli.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHOW_OLD_BALL:
    LD DE, (OLD_SPRITE_SCREEN_ADDR)
    LD A, D
    OR E
    RET Z

    LD HL, OLD_SPRITE8x8
    LD B, 8
OLD_SHOW_ROW:
    LD A, (OLD_SPRITE_MASK)
    AND (HL)
    LD C, A                          ;;; C-ben van az oszlopmask
    LD A, (DE)                       ;;; A-ban a képernyőbájt
    XOR C                            ;;;
    LD (DE), A                       ;;;

    INC DE

    LD A, (OLD_SPRITE_MASK)
    CPL
    AND (HL)
    LD C, A
    LD A, (DE)
    XOR C
    LD (DE), A

    LD A, B
    LD BC, 39
    EX DE, HL
    ADD HL, BC
    EX DE, HL
    LD B, A
    INC HL
    DJNZ OLD_SHOW_ROW

    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Others
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVE_SPRITE_TO_INIT:
    LD A, 1
    LD (MAX_SPEED_X), A          ; 45 fokos szögbe állítjuk
    LD (SPEED_X_CURR), A         ; 45 fokos szögbe állítjuk
MOVE_SPRITE_TO_INIT_LOOP:
    CALL WAIT

    CALL SHOW_OLD_BALL

    CALL MOVE_SPRITE_INIT_HORIZONTAL
    CALL MOVE_SPRITE_INIT_VERTICAL

    CALL MOVE_H
    LD A, (DIRECTION_Y)
    CP 0
    CALL NZ, MOVE_V

    CALL SHOW_BALL
    CALL SAVE_BALL_DATA

    LD A, (POS_X_PER8)
    CP POS_X_PER8_START
    JR NZ, MOVE_SPRITE_TO_INIT_LOOP

    LD A, (POS_X_MOD8)
    CP POS_X_MOD8_START
    JR NZ, MOVE_SPRITE_TO_INIT_LOOP

    LD A, (POS_Y_PER8)
    CP POS_Y_PER8_START
    JR NZ, MOVE_SPRITE_TO_INIT_LOOP

    LD A, (POS_Y_MOD8)
    CP POS_Y_MOD8_START
    JR NZ, MOVE_SPRITE_TO_INIT_LOOP

    RET

MOVE_SPRITE_INIT_HORIZONTAL:
    LD A, 0
    LD (DIRECTION_X), A

    LD A, (POS_X_PER8)
    CP POS_X_PER8_START
    JR NZ, MOVE_SPRITE_INIT_HORIZONTAL_MOVE

    LD A, (POS_X_MOD8)
    CP POS_X_MOD8_START
    JR NZ, MOVE_SPRITE_INIT_HORIZONTAL_MOVE
    RET

MOVE_SPRITE_INIT_HORIZONTAL_MOVE:
    LD A, 1
    LD (DIRECTION_X), A
    RET C
    LD A, -1
    LD (DIRECTION_X), A
    RET

MOVE_SPRITE_INIT_VERTICAL:
    LD A, 0
    LD (DIRECTION_Y), A

    LD A, (POS_Y_PER8)
    CP POS_Y_PER8_START
    JR NZ, MOVE_SPRITE_INIT_VERTICAL_MOVE

    LD A, (POS_Y_MOD8)
    CP POS_Y_MOD8_START
    JR NZ, MOVE_SPRITE_INIT_VERTICAL_MOVE
    RET

MOVE_SPRITE_INIT_VERTICAL_MOVE:
    LD A, 1
    LD (DIRECTION_Y), A
    RET C
    LD A, -1
    LD (DIRECTION_Y), A
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Data segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPEED_X_CURR: DB 0           ; A vízszintes mozgás lépésszámlálója. A valódi vízszintes elmozdulás csak akkor történik, ha ez 0. KEzdőértéke mindig a MAX_SPEED_X
MAX_SPEED_X: DB 0            ; Ez mondja meg, nánytól számoljon vissza SPEED_X_CURR. Ez minél nagyobb, a labda annál meredekebb. A függőleges értéket nem ez definiálja, hanem a DIRECTION_X=0

DIRECTION_X: DB 0        ; +/-1 vagy 0
DIRECTION_Y: DB 0        ; +/-1 

POS_X_MOD8: DB 0
POS_Y_MOD8: DB 0
POS_X_PER8: DB 0
POS_Y_PER8: DB 0

SPRITE_SCREEN_ADDR: DW SCREEN_START
SPRITE_MASK: DB 255

OLD_SPRITE_SCREEN_ADDR: DW 0
OLD_SPRITE_MASK: DB 0

SPRITE8x8_INIT0:
    DB %00111100
    DB %01100110
    DB %11000011
    DB %10000001
    DB %10000001
    DB %11000011
    DB %01100110
    DB %00111100
SPRITE8x8_INIT:
    DB %00000000
    DB %00111100
    DB %01011010
    DB %01111110
    DB %01011010
    DB %01100110
    DB %00111100
    DB %00000000
SPRITE8x8_INIT4:
    DB %00000000
    DB %00011000
    DB %00111100
    DB %01111110
    DB %00111100
    DB %00011000
    DB %00000000
    DB %00000000

SPRITE8x8: DS 8,0
OLD_SPRITE8x8: DS 8,0
CHECK_INDEX: DB 0
