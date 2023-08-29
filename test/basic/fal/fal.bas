'"! ROM rutinok :
'"! - 1D84 ( 7556 : 132, 29 ) : BEEP HL
'"! - 1DB1 ( 7601 : 177, 29 ) : READ KEY
PRINT CHR$(12);       '"! CLS
FB=127 : FK=146 : FJ=128
AB=126 : AK=153 : AJ=129
'"! FB=110 : FK=150 : FJ=109
'"! AB=108 : AK=149 : AJ=107
PRINT CHR$(127); : FOR X=0 TO 37 : PRINT CHR$(146); : NEXT : PRINT CHR$( 128 );
PRINT CHR$(231); : FOR X=0 TO 37 : PRINT CHR$(32); : NEXT : PRINT CHR$( 238 );
PRINT CHR$(231); : FOR X=0 TO 37 : PRINT CHR$(32); : NEXT : PRINT CHR$( 238 );

PRINT CHR$(127); : FOR X=0 TO 11 : PRINT CHR$(FK);CHR$(FJ);CHR$(FB); : NEXT : PRINT CHR$(FK);CHR$(FJ);CHR$(128);
PRINT CHR$(126); : FOR X=0 TO 11 : PRINT CHR$(AK);CHR$(AJ);CHR$(AB); : NEXT : PRINT CHR$(AK);CHR$(AJ);CHR$(129);

PRINT CHR$(127); : FOR X=0 TO 12 : PRINT CHR$(FB);CHR$(FK);CHR$(FJ); : NEXT
PRINT CHR$(126); : FOR X=0 TO 12 : PRINT CHR$(AB);CHR$(AK);CHR$(AJ); : NEXT

PRINT CHR$(127); : FOR X=0 TO 11 : PRINT CHR$(FJ);CHR$(FB);CHR$(FK); : NEXT : PRINT CHR$(FJ);CHR$(FB);CHR$(128);
PRINT CHR$(126); : FOR X=0 TO 11 : PRINT CHR$(AJ);CHR$(AB);CHR$(AK); : NEXT : PRINT CHR$(AJ);CHR$(AB);CHR$(129);

PRINT CHR$(127); : FOR X=0 TO 11 : PRINT CHR$(FK);CHR$(FJ);CHR$(FB); : NEXT : PRINT CHR$(FK);CHR$(FJ);CHR$(128);
PRINT CHR$(126); : FOR X=0 TO 11 : PRINT CHR$(AK);CHR$(AJ);CHR$(AB); : NEXT : PRINT CHR$(AK);CHR$(AJ);CHR$(129);

PRINT CHR$(127); : FOR X=0 TO 12 : PRINT CHR$(FB);CHR$(FK);CHR$(FJ); : NEXT
PRINT CHR$(126); : FOR X=0 TO 12 : PRINT CHR$(AB);CHR$(AK);CHR$(AJ); : NEXT

FOR I=1 TO 11
    PRINT CHR$(231); : FOR X=0 TO 37 : PRINT CHR$(32); : NEXT : PRINT CHR$( 238 );
NEXT
PRINT CHR$(231); : FOR X=0 TO 37 : PRINT CHR$(32); : NEXT '" : PRINT CHR$( 238 );

X = 20 : Y = 23 : DX=0.1 : DY=-0.3 : NP = 0
{LOOP1} OP = NP : NP = 49153 + INT(X) + INT(Y) * 40 : X = X+DX : Y=Y+DY
BG = PEEK( NP ) : POKE NP, 115
IF BG = 32 OR BG = 115 THEN GOTO {NEXTSTEP}
    '"! Nem szabad az út, valami van előtte. Kit
    IF DY > 0 THEN GOTO {LE}
        IF BG <> AK THEN GOTO {A_nemközép}                 '"! Vízszintes vonal
            POKE NP-1, 32, 32, 32
            POKE NP-41, 32, 32, 32
            DY = -DY
        {A_nemközép} IF BG <> AB THEN GOTO {A_nembal}        '"! Vízszintes bal asrok
            POKE NP, 32, 32, 32
            POKE NP-40, 32, 32, 32
            DY = -DY
        {A_nembal} IF BG <> AJ THEN GOTO {NEXTSTEP}         '"! Vízszintes jobb sarok
            POKE NP-2, 32, 32, 32
            POKE NP-42, 32, 32, 32
            DY = -DY
    {LE} IF BG <> FK THEN GOTO {F_nemközép}                 '"! Vízszintes vonal
            POKE NP-1, 32, 32, 32
            POKE NP+39, 32, 32, 32
            DY = -DY
        {F_nemközép} IF BG <> FB THEN GOTO {F_nembal}        '"! Vízszintes bal asrok
            POKE NP, 32, 32, 32
            POKE NP+40, 32, 32, 32
            DY = -DY
        {F_nembal} IF BG <> FJ THEN GOTO {NEXTSTEP}         '"! Vízszintes jobb sarok
            POKE NP-2, 32, 32, 32
            POKE NP+38, 32, 32, 32
            DY = -DY

{NEXTSTEP} if Y < 2 OR Y>23 THEN DY = -DY
IF X<1 OR X>38 THEN DX = -DX
IF OP=0 OR OP=NP THEN GOTO {LOOP1}
IF X<1 THEN POKE NP, 231
IF X>37 THEN POKE NP, 238
POKE OP, 32
GOTO {LOOP1}
