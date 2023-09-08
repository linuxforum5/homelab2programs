org 0x5200

BASIC:                   EQU 0x40A0
SCREEN:                  EQU 0xC001 + 8*40
FIRST_BIT:               EQU 64
LAST_BIT:                EQU 2
ZERO_BIT_CHARACTER_CODE: EQU 121;251;32
ONE_BIT_CHARACTER_CODE:  EQU 160

;   u8 graphics_back_index = m_GL - graphics_line0 - 7 + 8;
;   u16 RAM_offset = 0x4000 - m_cols * graphics_back_index + 39; // A látható grafikus terület kezdőcíme

;LD HL, 0xC001
;LD (HL), 255
;LD DE, 0xC002
;LD BC,999
;LDIR
;XXX: JR XXX

    LD HL, BASIC
    LD A, 0x22              ; "
SEARCH:
    CP (HL)
    INC HL
    JR NZ, SEARCH

;LD DE, 0xC001
;LD BC, 10
;LDIR
;XXX: JR XXX

    LD (TEXT), HL
    LD (CURSOR), HL
    LD A, FIRST_BIT
    LD (BIT), A

LOOP:

    LD B, 0
WAIT2: LD C,B
WAIT: NOP
    NOP
    NOP
    DJNZ WAIT
    LD B,C
    DJNZ WAIT2
    


    CALL SHOW_BIT
    AND A                   ; Clear CY
    LD A, (BIT)
    CP LAST_BIT
    RRA                     ; A=A/2
    LD (BIT), A
    JR NZ, LOOP
;    JR NC, LOOP             ; A=0
    LD A, FIRST_BIT
    LD (BIT), A
    LD HL, (CURSOR)
    INC HL
    LD (CURSOR), HL
    LD A, (HL)
    CP 0x22
    JR NZ, LOOP
    LD HL, (TEXT)
    LD (CURSOR), HL
    JR LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A képernyő jobb szélén megjeleníti a (CURSOR) által megcímzett karakter (BIT). bitjén lévő pixeleket egymás alatt
;;; Miközben a képernyőt egy karakterrel balra mozgatja
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHOW_BIT:
    LD HL, (CURSOR)
    LD C, (HL)                 ; Az aktuális character
    LD B, 0
    LD HL, ROM-256
    ADD HL, BC
    EX DE, HL                  ; DE tárolja a karakterkészlet aktruális karakterének aktuális sorának a címét. Ez most a legfelső sorára mutat

    LD A, 9
    LD (ROW_COUNTER), A

    LD HL, SCREEN
    LD BC, 39
    ADD HL, BC


SCROLL:
    LD C, ZERO_BIT_CHARACTER_CODE          ; 0 eseén ez a karakter jelenik meg
    CP 9
    JR Z, SKIP_CHAR
    PUSH HL
    CALL GET_PIXEL_TO_C
    POP HL
SKIP_CHAR:
    LD B, 39
SCROLL_ROW_LEFT:                ; Egy sort egy pixellel balra mozgat
    LD A, (HL)
    LD (HL), C
    LD C, A
    DEC HL
    DJNZ SCROLL_ROW_LEFT
    LD A, (ROW_COUNTER)
    DEC A
    RET Z
    LD (ROW_COUNTER), A

    EX DE, HL
    LD BC, 256
    ADD HL, BC
    EX DE, HL

    LD BC, 79
    ADD HL, BC
    
    JR SCROLL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A (CURSOR) caracter akurális sorának (BIT). bitjének lekérdezése
;;; Az aktuális sor a (CHARSET_ROW) memóriától kezdődő 256 bájt
GET_PIXEL_TO_C:
    EX DE, HL
    LD C, (HL)             ; C-ben az aktuális pixelsor
    EX DE, HL
    LD A, (BIT)
    AND C
    LD C, ZERO_BIT_CHARACTER_CODE          ; 0 eseén ez a karakter jelenik meg
    RET Z
    LD C, ONE_BIT_CHARACTER_CODE          ; 1 eseén ez a karakter jelenik meg
    RET

TEXT:         DW 0               ; A szöveg kezdőcíme a memóriában
CURSOR:       DW 0               ; Az aktuális szövegkarakter címe a memóriában    
BIT:          DB 0               ; Az aktuális karakter éppen olvasott bitjének értéke
ROW_COUNTER:  DB 0               ;
ROM:
incbin 'rom/Chr_gen.rom';
