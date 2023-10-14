;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; BCD műveletek
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Egy 3 bájtos BCD szám megjelenítése
;;; HL : A BCD szám első bájtjának címe. A legmagasabb helyiérték van legelöl.
;;; BC : A BCD szám első számjegyének megjelenítési kezdőcíme. Mivel bevezető 0-ák is látszanak, a hossza minidig 6 számjegy lesz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_BCD3_HL_BC:
    LD A, (HL)
    LD (BCD_TEMP+2), A
    INC HL
    LD A, (HL)
    LD (BCD_TEMP+1), A
    INC HL
    LD A, (HL)
    LD (BCD_TEMP+0), A

    LD HL, BCD_TEMP
    CALL PRINT_BCD0_BC_HL
    INC HL
    CALL PRINT_BCD0_BC_HL
    INC HL
    JR PRINT_BCD0_BC_HL

PRINT_BCD0_BC_HL:             ; A vezető 0-ákat is kiírja
    LD A, 48
    RLD
    LD (BC), A
    INC BC
    RLD
    LD (BC), A
    INC BC
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Kiír egy BCD bájtot a képernyőre
;;; BC : A képernyőcím, ahová ki kell írni a számot
;;; HL : Az ideiglenes memóriacím ami a kiírandó bájtot tárolja
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_BCD1_BC_A:
    LD HL, BCD_TEMP
    LD (HL), A
    LD A, 48
    RLD
    CP 48
    JR NZ, PRINT_BCD1_SHOW_FIRST_NUMBER
    LD A, 32
    LD (BC), A                ; Az első számjegy 0 helyett szóköz
    LD A, 48
    JR PRINT_BCD1_SHOW_SECOND_NUMBER
PRINT_BCD1_SHOW_FIRST_NUMBER:
    LD (BC), A
PRINT_BCD1_SHOW_SECOND_NUMBER:
    INC BC
    RLD
    LD (BC), A
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Data segment
;;; 4 bytes for bcd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BCD_TEMP: DS 4, 0
