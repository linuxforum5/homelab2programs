DEBUG_FIRST_ADDR: EQU 24*40

show_col1_BC:
    PUSH DE
    LD D, B
    LD E, C
    CALL show_col1_DE
    POP DE
    RET

show_col2_BC:
    PUSH DE
    LD D, B
    LD E, C
    CALL show_col2_DE
    POP DE
    RET

show_col3_BC:
    PUSH DE
    LD D, B
    LD E, C
    CALL show_col3_DE
    POP DE
    RET

show_col4_BC:
    PUSH DE
    LD D, B
    LD E, C
    CALL show_col4_DE
    POP DE
    RET

show_col5_BC:
    PUSH DE
    LD D, B
    LD E, C
    CALL show_col5_DE
    POP DE
    RET

show_col6_BC:
    PUSH DE
    LD D, B
    LD E, C
    CALL show_col6_DE
    POP DE
    RET

show_col7_BC:
    PUSH DE
    LD D, B
    LD E, C
    CALL show_col7_DE
    POP DE
    RET

show_col8_BC:
    PUSH DE
    LD D, B
    LD E, C
    CALL show_col8_DE
    POP DE
    RET


show_col1_HL:
    EX DE, HL
    CALL show_col1_DE
    EX DE, HL
    RET

show_col2_HL:
    EX DE, HL
    CALL show_col2_DE
    EX DE, HL
    RET

show_col3_HL:
    EX DE, HL
    CALL show_col3_DE
    EX DE, HL
    RET

show_col4_HL:
    EX DE, HL
    CALL show_col4_DE
    EX DE, HL
    RET

show_col5_HL:
    EX DE, HL
    CALL show_col5_DE
    EX DE, HL
    RET

show_col6_HL:
    EX DE, HL
    CALL show_col6_DE
    EX DE, HL
    RET

show_col7_HL:
    EX DE, HL
    CALL show_col7_DE
    EX DE, HL
    RET

show_col8_HL:
    EX DE, HL
    CALL show_col8_DE
    EX DE, HL
    RET

show_col1_DE:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR
    CALL show_num2_BC_DE
    POP BC
    RET

show_col2_DE:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR+5
    CALL show_num2_BC_DE
    POP BC
    RET

show_col3_DE:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR+10
    CALL show_num2_BC_DE
    POP BC
    RET

show_col4_DE:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR+15
    CALL show_num2_BC_DE
    POP BC
    RET

show_col5_DE:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR+20
    CALL show_num2_BC_DE
    POP BC
    RET

show_col6_DE:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR+25
    CALL show_num2_BC_DE
    POP BC
    RET

show_col7_DE:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR+30
    CALL show_num2_BC_DE
    POP BC
    RET
show_col8_DE:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR+35
    CALL show_num2_BC_DE
    POP BC
    RET

show_col1_A:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR
    CALL show_num1_BC_A
    POP BC
    RET

show_col2_A:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR + 5
    CALL show_num1_BC_A
    POP BC
    RET

show_col3_A:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR + 10
    CALL show_num1_BC_A
    POP BC
    RET

show_col4_A:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR + 15
    CALL show_num1_BC_A
    POP BC
    RET

show_col5_A:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR + 20
    CALL show_num1_BC_A
    POP BC
    RET

show_col6_A:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR + 25
    CALL show_num1_BC_A
    POP BC
    RET

show_col7_A:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR + 30
    CALL show_num1_BC_A
    POP BC
    RET

show_col8_A:
    PUSH BC
    LD BC, DEBUG_FIRST_ADDR + 35
    CALL show_num1_BC_A
    POP BC
    RET

show_num2_BC_DE:
    EXX
    PUSH BC
    PUSH DE
    PUSH HL
    PUSH AF
    EXX
    PUSH DE
    PUSH HL
    PUSH AF
    LD HL, 0xC001
    ADD HL, BC
    LD (DCB_CURSOR_POS_2), HL
    CALL ROM_PRINT_HEX_DE
    POP AF
    POP HL
    POP DE
    EXX
    POP AF
    POP HL
    POP DE
    POP BC
    EXX
    RET

show_num1_BC_A:
    EXX
    PUSH BC
    PUSH DE
    PUSH HL
    PUSH AF
    EXX
    PUSH DE
    PUSH HL
    PUSH AF
    LD HL, 0xC001
    ADD HL, BC
    LD (DCB_CURSOR_POS_2), HL
    CALL ROM_PRINT_HEX_A
    POP AF
    POP HL
    POP DE
    EXX
    POP AF
    POP HL
    POP DE
    POP BC
    EXX
    RET
