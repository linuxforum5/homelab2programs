1 LV =  1 : GOTO 70 '""""""""""""""""""""
2 LV =  2 : GOTO 70 '" COPYRIGHT        "
3 LV =  3 : GOTO 70 '" PRINCZ LASZLO    "
4 LV =  4 : GOTO 70 '" HUNGARY          "
5 LV =  5 : GOTO 70 '" LASZLO@PRINCZ.HU "
6 LV =  6 : GOTO 70 '" 2023 V.: 1.0     "
7 LV =  7 : GOTO 70 '" GPL 3            "
8 LV =  8 : GOTO 70 '""""""""""""""""""""
9 LV =  9 : GOTO 70
10 LV = 10 : GOTO 70
11 LV = 11 : GOTO 70
12 LV = 12 : GOTO 70
13 LV = 13 : GOTO 70
14 LV = 14 : GOTO 70
15 LV = 15 : GOTO 70
16 LV = 16 : GOTO 70
17 LV = 17 : GOTO 70
18 LV = 18 : GOTO 70
19 LV = 19 : GOTO 70
20 LV = 20 : GOTO 70
21 LV = 21 : GOTO 70
22 LV = 22 : GOTO 70
23 LV = 23 : GOTO 70
24 LV = 24 : GOTO 70
25 LV = 25 : GOTO 70
26 LV = 26 : GOTO 70
27 LV = 27 : GOTO 70
28 LV = 28 : GOTO 70
29 LV = 29 : GOTO 70
30 LV = 30 : GOTO 70
31 LV = 31 : GOTO 70
32 LV = 32 : GOTO 70
33 LV = 33 : GOTO 70
34 LV = 34 : GOTO 70
35 LV = 35 : GOTO 70
36 LV = 36 : GOTO 70
37 LV = 37 : GOTO 70
38 LV = 38 : GOTO 70
39 LV = 39 : GOTO 70
40 LV = 40 : GOTO 70
41 LV = 41 : GOTO 70
42 LV = 42 : GOTO 70
43 LV = 43 : GOTO 70
44 LV = 44 : GOTO 70
45 LV = 45 : GOTO 70
46 LV = 46 : GOTO 70
47 LV = 47 : GOTO 70
48 LV = 48 : GOTO 70
49 LV = 49 : GOTO 70
50 LV = 50 : GOTO 70
51 LV = 51 : GOTO 70
52 LV = 52 : GOTO 70
53 LV = 53 : GOTO 70
54 LV = 54 : GOTO 70
55 LV = 55 : GOTO 70
56 LV = 56 : GOTO 70
57 LV = 57 : GOTO 70
58 LV = 58 : GOTO 70
59 LV = 59 : GOTO 70
60 LV = 60 : GOTO 70
70 DIM KR(5) : KR(0)=32 : KR(1)=119 : KR(2)=121 : KR(3)=101 : KR(4)=251 : KR(5)=99
80 POKE 16384,132,29 : HN=1
90 IF LV = 1 THEN GOTO 200                                                           ." Ha nem az első szinttel indítunk, akkor restore
100 RESTORE
110 IF LV = 1 THEN GOTO 200
120 READ SL,SX,SY
130 FOR SS = 1 TO SY : READ SW$ : NEXT
140 IF SL < LV - 1 THEN GOTO 120
200 PRINT CHR$(12)
210 POKE 16404, 31, 192 : PRINT "SOKOBAN 60";
220 POKE 16404, 72, 192 : PRINT CHR$(97);" 2023 ";CHR$(97);
230 POKE 49467, 209
240 POKE 49507, 140
250 POKE 49543, 99, 58, 207, 139, 32, 141, 208
260 POKE 49587, 138
270 POKE 49627, 193
280 POKE 16404,  39, 194 : PRINT "EZ A SZINT";
290 POKE 16404,  79, 194 : PRINT "UJRA:";CHR$( 210 );
300 POKE 16404, 159, 194 : PRINT "UTOLSOT";
310 POKE 16404, 199, 194 : PRINT "VISSZA:";CHR$( 213 );
320 POKE 16404,  73, 195 : PRINT "TOLD (";CHR$(99);") A LADAKAT (";CHR$( 119 );") A HELYUKRE (";CHR$( 121 );")";
330 POKE 16404, 113, 195 : PRINT "/A 'RUN X' PARANCS AZ X. SZINTTOL INDIT/";
340 READ LV,X,Y
350 RM = 49152 : LC = 0
360 FOR SR=1 TO Y
370 READ LN$
380 KP = 1 : PC = 0 : ST = 0 : TC = 0 : EP = 0
390 POKE 16404, 150, 192 : PRINT LV;". SZINT";
400 DB = ASC(MID$(LN$,KP,1))-76 : CH = INT( DB / 32 ) : DB = DB - 32 * CH
410 FOR CO=1 TO DB
420 POKE RM + PC + CO, KR(CH)
430 IF CH = 5 THEN PL = RM + PC + CO
440 IF CH = 1 THEN LC = LC + 1
450 NEXT CO
460 PC = PC + DB : KP = KP + 1 : IF PC < X THEN GOTO 400
470 RM = RM + 40
480 NEXT SR
490 BG = 32 : LK = 0 : GOTO 800
500 KE = PEEK( 15087 ) : KK = PEEK( 15071 ) : KH = PEEK( 15039 ) : IF HN = 1 AND TC > 1 THEN A=USR(TC)
510 TC = 0
520 IF KK = 127 THEN IF LK<>1 THEN LK=1 : NP = PL-1 : PK = PL-2 : GOTO 600
530 IF KH = 254 THEN IF LK<>2 THEN LK=2 : NP = PL+1 : PK = PL+2 : GOTO 600
540 IF KH = 253 THEN IF LK<>3 THEN LK=3 : NP = PL-40: PK = PL-80: GOTO 600
550 IF KE = 253 THEN IF LK<>4 THEN LK=4 : NP = PL+40: PK = PL+80: GOTO 600
560 IF KH = 251 THEN GOTO 100
570 IF KH = 223 THEN GOTO 1100
580 IF KK = 254 THEN IF LK<>5 THEN LK=5 : HN = 1 - HN : GOTO 800
590 LK=0 : GOTO 500
600 NV = PEEK(NP) : VK = PEEK(PK)
610 IF NV = 251 THEN TC = 250+256*50 : GOTO 500
620 IF NV = 101 OR NV = 119 THEN GOTO 700
630 ST = ST + 1 : TC = 255
640 POKE PL, BG
650 BG = PEEK( NP )
660 EB = PEEK( NP ) : POKE NP, 99 : KB = PEEK( 2 * NP - PL ) : EP = PL : PL = NP : EC = LC
670 GOTO 800
700 IF VK <> 32 AND VK <> 121 THEN TC = 250+256*50 : GOTO 500
710 IF VK = 32 AND NV = 119 THEN EC = LC : KB = PEEK( PK ) : POKE PK, 119 : POKE PL, BG : BG=32 : EB = PEEK( NP ) : POKE NP, 99 : EP = PL : PL=NP
720 IF VK = 32 AND NV = 101 THEN EC = LC : KB = PEEK( PK ) : POKE PK, 119 : POKE PL, BG : BG=121: EB = PEEK( NP ) : POKE NP, 99 : EP = PL : PL=NP : LC = LC + 1 : GOSUB 1300
730 IF VK =121 AND NV = 119 THEN EC = LC : KB = PEEK( PK ) : POKE PK, 101 : POKE PL, BG : BG=32 : EB = PEEK( NP ) : POKE NP, 99 : EP = PL : PL=NP : LC = LC - 1 : GOSUB 1400
740 IF VK =121 AND NV = 101 THEN EC = LC : KB = PEEK( PK ) : POKE PK, 101 : POKE PL, BG : BG=121: EB = PEEK( NP ) : POKE NP, 99 : EP = PL : PL=NP
750 ST = ST + 1 : IF TC <> 1 THEN TC = 50+256*10
800 POKE 16404, 190, 192 : PRINT LC;" LADA ";
820 POKE 16404, 230, 192 : PRINT ST;" LEPES";
822 POKE 16404,  23, 195 : PRINT CHR$(200);"ANG ";
824 IF ( HN = 1 ) THEN PRINT "VAN  ";
826 IF ( HN = 0 ) THEN PRINT "NINCS";
830 IF LC > 0 THEN GOTO 500
840 IF HN = 1 THEN A=USR(30852) : A=USR(30852) : A=USR(30852) : A=USR(62562) : A=USR(56398)
850 GOSUB 1000
860 IF HN = 1 THEN A=USR(30852) : A=USR(30852) : A=USR(30852) : A=USR(62562) : A=USR(56398)
870 GOSUB 1000
880 IF HN = 1 THEN A=USR(31330) : A=USR(31330) : A=USR(41066) : A=USR(41066) : A=USR(30838) : A=USR(30838) : A=USR(61572)
885 IF LV = 60 THEN GOTO 1500
890 GOTO 200
1000 FOR I=0 TO 100 : J=I : NEXT : RETURN
1100 IF EP = 0 THEN TC = 250+256*50 : GOTO 500
1110 POKE PL, EB
1120 BG = PEEK( EP ) : POKE EP, 99
1130 POKE 2*PL-EP, KB
1140 IF LC < EC THEN GOSUB 1300
1150 IF LC > EC THEN GOSUB 1400
1160 PL = EP : EP = 0 : ST = ST-1 : LC = EC
1170 GOTO 800
1300 TC = 1 : IF HN = 1 THEN A=USR(50+256*200) : A=USR(70+256*200) : A=USR(90+256*200)
1310 RETURN
1400 TC = 1 : IF HN = 1 THEN A=USR(90+256*200) : A=USR(70+256*200) : A=USR(50+256*200)
1410 RETURN
1500 PRINT CHR$(12)
1510 PRINT "GRATULALUNK! MIND A 60 PALYAT SIKERESEN MEGOLDOTTAD!"
1520 PRINT "" : PRINT ""
1530 FOR T=0 TO 3000 : NEXT
1600 READ W$, PM
1610 IF PM = 0 THEN PRINT "" : PRINT "" : PRINT "... "; : PRINT CHR$(97) : PRINT "" : FOR T=0 TO 1000 : NEXT : GOTO 1700
1620 IF PM = 1 THEN GOSUB 1000 : PRINT "" : GOTO 1600
1630 PRINT W$; : A=USR(PM)
1640 GOTO 1600
1700 RM=RND(999)+49152
1710 POKE RM,97
1720 GOTO 1700
2001 DATA 1,22,11,"P�Y","P�O�Y","P�mN�Y","N�Nm�W","N�NmNmM�W","�M�M�M�Q�","�O�M�M�N��","�MmNmY��","�M�M���N��","P�R�N�","P�V"
2002 DATA 2,14,10,"�N","͎N�Q�","͎N�MmNmN�","͎N�m�N�","͎P�M�N�","͎N�M�NmM�","�M�mMmM�","N�MmNmMmMmM�","N�P�Q�","N�"
2003 DATA 3,17,10,"T�M","T�Q��M","T�Mm�mM�M","T�MmNm�N","T�mMmM�N","�MmM�M�","͐N�MmNmN�","ΏPmNmO�","͐N�","�U"
2004 DATA 4,22,13,"Z�","Z�N��","O�N��","O�P�NmMmO��","O�Mo�mNmM�N��","O�NmQmM�N��","O�MnM�mMmMm�","�NmM�Q�S","�O�M�S","�PmN�X","�Mn�nM��X","�O�O�X","�Y"
2005 DATA 5,17,13,"T�P","T�O�","T�M�m�N�","T�QmM�","�M�O�","͐N�MmNm�","͐PmMnM�M","͐N�mNmM��M","�NmN�M","T�MmMmN�M","T�M�M�M","V�P�M","V�M"
2006 DATA 6,12,11,"�N�M","͎N�M���","͎N�O�","͎QnM�","͎N�M�MmM�","͎�M�MmM�","�MmM�mN�","O�Nm�MmM�","O�MmNmN�","O�N�O�","O�"
2007 DATA 7,13,12,"S�M","M�O�","�M�M��MnM�","�PmR�","�NmN�O�","�M�m�","�MmN�M��M","�MmMmMmM��M","�PϏ�M","�MnM�M͏�M","�N�M�M","�U"
2008 DATA 8,16,17,"N�V","N�N�","N�PmOmMmM�","N�Mm�MmM�NmN�","N�NmMmN�P�","�Mm�M�N�M�","���mMmMmN�O�","�PmM�m�O�M�","�NmPmMmMmM�","M�N�","N�N�R","N�R�R","N�R�R","N͒�R","N͒�R","N͒�R","N�R"
2009 DATA 9,17,18,"V�","V�N��","R�N��","R�R��","R�N�N��","R�M�N��","Q�M�","Q�MoM�P","M�NmMmM�","�O�mMmO�O�","��MmNmPmNmM�","�MnMmM�","Q�MmP�P","Q�M�P","T�N�Q","T�N�Q","T�N�Q","T�Q"
2010 DATA 10,21,20,"Z�O","U�N�O","U�S�O","U�N�M�M","M�N�M�P�M","���OoM�P�M","�MnOnMmO͐�","�No�PmN͑�","�MmO�MnMnM͑�","�O�NmP͑�","N�O�MmMmMmM͑�","N�M�Mϑ�","N�O�NmMmN͑�","N�M�MnMmMm�","P�M�NmR�P","P�M�MoMoM�P","P�M�S�M�P","P�M�M�P","P�W�P","P�P"
2011 DATA 11,19,15,"V�Q","Q�M�N�Q","O�N�mM�Q","N�O�NmN�Q","M�NmMn�M�Q","M�N�m�Q�Q","M�M�MmMnM�M�P","M�OmM�N�MmM�","�P�NnM�O�","�M�MmU�","͍P�N�","͎M��M�S","͏͍�X","͑�X","�X"
2012 DATA 12,13,16,"N�N","Nͭ��ͭ���N","N͍�������N","Nͭ�������N","N͍�������N","Nͭ�������N","N�O�N","P�O�P","�M�","�W�","�MmMmMmMmMmM�","�MmMmMmMmM�","M�mMmMmMmMm�M","M�Om�mO�M","M�N�N�M","M�O�M"
2013 DATA 13,20,13,"P�S","N�O�N�O","�R�N�O�","�NnM�mM�N�N�M�","�M�Nm��m�M�M͍͍M�","�N�M�mN�P�M�","�Mm�PmM�M�M͍͍M�","�P�N�mMmM�M�","�MmM�O�N�m͍͍M�","�MnNmOmNm�M�","M�mN�P�N�","M�O�P�","M�Z"
2014 DATA 14,17,13,"�M","�Z�M","�M�M�Q�M","�M�NmMmMmMm�N�M","�M�Om�mO�M�","�M�M�mMmMmϏ�","�M�OmMmNΏ�","�M�oMmMΏ�","�Q�M�MΏ�","�O�MΏ�","P�Q�","T�Q�N","T�N"
2015 DATA 15,17,17,"S�R","P�N�R","O�N�N�R","O�NmMmM�R","M�M�mO�O","M�NmN�mO�O","M�N�M�MmM�Mm�O","M�N�RmM�","M�M�m�Q�","M�Mm͑�M�O�","M�Nm���Mm�M�","�N͑�O�N","�O�M�N","�MnN�N�S","�N�Q�S","�O�S","Q�S"
2016 DATA 16,14,15,"�U","�O�T","�P�N�N","�MmN�N�N","�NnMmOm�N","��M�mP�M","M�N�NmMmM�","M�MmN�M�M��","M�N�m�mN͍�","M�Om�΍�","N�P͍���","N�MnM͑�","N�N�","N�N�T","N�T"
2017 DATA 17,18,16,"S�P","M�Q�P","M�Q�Mm�mM�P","M�nM�O�","M�Mϒ�O�","M�Om��M�M�","M�MϒQ�","�O�M�M�m�","�N�mO�NmN�M�M","�NmMoN�Mm�M�M","�OmMmM�nM�M�M","�QmO�M�M","P�M�O�M�M","R�Q�O�M","R�N�M","Y�M"
2018 DATA 18,22,13,"R�P","R�N�N�O�P","R�M͍Q�M�P","M�MΏ�M�O","�NΏ�Q�","�MmMΏPmM�NmN�","�Q�M�M�M�M�N�","�m�m�MmN�O�M�","M�N�P�mMnM�M�M","M�OnM�M�MmM�Mm�M�M","M�^�M","M�N�M","]�M"
2019 DATA 19,28,20,"T�Z","T�O��W","R�MmO�W","R�O�P�T","R�Mm�N�P�T","R�O�N�M�T","R�M�nMmP�M�T","R�NmMmM�M�M�T","R�M�OmN�M�M�T","R�M�N�m�O�M�T","Q�M�O�M�M�T","Q�NmN�M�M�M�O","P�PmQmN�N�","�N�MmMm�MmM�O��","�Q�R�N�N͑�","�MpP�m�O͍΍�","�P�Z͐�","M�N�O��","N�N�Y�N�","N�]�M"
2020 DATA 20,20,20,"S�M","S͖�M","Qύ͍͍͍͎�M","Q�O��M","Q��MmMmMmM�����M","P�M�M","M�O�P�N�N","�PmM�P�MmM�M","�N�m�M�M�mO�","�MmNmMmO�MmMmMmM�","�N�MmM�S�mM�","�Om�m�m�N�","�N�O�P�N�","O�mM�O�M�MnN�","O�O�MmM�NmP�","O�M�MnM�NmM�","Q�M�P�MmM�N","Q�M�M�O","Q�V�O","Q�O"
2021 DATA 21,16,14,"O�O","O͎N�O�O","O͎R�O","O͎N�N�M","N�N�N�","N�X�","N�N�N�N�N�","�M�N�M�","�NmN�M�N�","�M�MmNmN�MmN�","�M�mNmO�O�","�M�M�M","O�P�S","O�S"
2022 DATA 22,22,20,"X�R","M�N�N","M�P�N�NmN�O�M","M�MmMmMmNmM�MmMmO�M","M�mMmO�M��MmOmM�M","�O�M�M","�NmMm�N͒�Mm�N","�M�O�N͒�M�N","�N�M�M�M��N�N","�M�Rm�MmM�N","�M�MmM�M͒�N�N","�NmMm�N͒�Mm�N","�MmO�N�m�N�N","�MmMmM�MmMmNmMm�N","�M�QmMmMmMmO�","M�N�MmPmP�","M�U�M�M�","M�M�mV�","S�O�","S�V"
2023 DATA 23,25,14,"S�W","S�N�N�T","S�Mm�mM�N�S","�N�N�O�","͐N�Mm�mM�Nm�N�O�","͐�M�Q�mN�R�","͎͍Pm�N�MmP�mN�","͏M��N�mM�mN�N�O�","͐M�Mm�Qm�","�N�n�mN�S","S�Mm�N�Nm�S","S�N�N�O�S","S�N�S","V�W"
2024 DATA 24,21,19,"O�T","O͔�Q","O͍͍͐�N�Q","O͔nM�Q","O�Q��N�N","M�NmM�O�N","M�QmOmMmNmM�N","M�N�P�NmMm�N�N","M�M�O�N�N�N","M�MmQ�O�M�N","�Nm�O�M�N�N�N","�P�m�P�N�M","�MmPmM�N�N�O�M","�P�M�M�M�M�","P�m�M�NmNmMmO�","P���Nm�oN�O�","P�NmR�","R�N�N�N�P","S�P"
2025 DATA 25,23,17,"[�P","V�N�","P�S�O�","P�RmMmM�M�M�M�","P�N�MmN�Q��","P�RmM�M�M΍͍�","P�m�mMmMmM΍͍�","P�Q�PЍ�","P�MmO�N͍͍�","�o�R�͍͍�","�R�P�m�mύM��","�M�M�qP�M��","�M�PmQ�O�M��","�M�O�M�QϏ�","�M�m�N�","�T�P�N�Q","�P�Q"
2026 DATA 26,15,15,"�R","�S�R","�S�O","�M�M�N�O","�M���P�O","�MoMmNn�O","�N�M�MmN�O","�N�M�NmM�","�NoMm�N�","M�O�O��","M�M�O�M͎M��","M�O�M�MΏ�","M�MmN͏�","Q�O�","R�P"
2027 DATA 27,23,13,"M�Q","M͏O�P�O�O","ΑNm�M�M�MmM�O","͒�NmN�NmN�O","͒�N�N�M�M�M�N","�MmNmM�M�N�","N�Q�m�mM�M�O�","M�OmP�MmNmO�M�","M�N�M�M�N�m�M�","M�MmMnQmOmQ�","M�MmPm�mM�M�","M�N�M�R�","S�V"
2028 DATA 28,15,17,"Q�O","Q��M�N�O","Q�MmO�O","P�M�M�O","M�MmN�M�N","M�S�N�M","M�MmMm�MmM�M","M�MnM�N�Nm�M","M�mNmO�mN�M","�Nn�OnM�","�MnN�N�NmM�","�Q�MmN�","�N�mΎ�O�","�M�͐�","N�M��N","N͐O��N","N�N"
2029 DATA 29,24,11,"\�O","S�M�O�","O�P�MmMmNmM�","�N�M�mMmPmM�O�","͐OnMmMmNmO�m�","͎M�M�M�O�m�M�N�","͐P�M�P�P�","͐P�M�NmN�mM�","͎�NmN�N�M�","�P�O�P�N�M","T�M"
2030 DATA 30,14,20,"M�T","M�O�N","M�MmM�O�N","M�MmPnM�N","M�M�O�N","�M�N�M�N","�O�N���O","�MnPmM�O","�O�M�MmM�","�M�O�N�","M�Om�O�","M�NmQmN�","M�O�M�","M�N�","ΐ�MmNmM�","͑�Mn�N�","͎M��MmNmM�","͑mO�N�","�N�","M�U"
2031 DATA 31,15,12,"M�S","M�N�N�O","�N�N͏�M","�Nm�N͏N�M","�MmM�nM�N�M","�Nm�N͏M��M","�O�Mm�","�mSmMmM�","�N�NnM�O�","M�N�n��","R�R�","R�M"
2032 DATA 32,18,16,"N�X","N�N�P","M�N�M��O�P","M�Nm�MmMmO�M","M�mNmN�MmMm�N�","�Nm�M�mMmQ�","�N�N�M�OoN�","�MmPmNm�M�","�MmMmM�m�N�N�O","�N�N�mM�O","M�N͐Q�O","MВ�O","O͐�R","O͏�U","O͏�V","O�V"
2033 DATA 33,13,15,"R�O","N�N�O","M�Qm�O","�MmN�M�M","��mMmM�MmN�M","�M�Om�M","M͐�mMmM�M","M͐�Om�M","M͐NnM�","M͏M�MmO�","M�mMmN�","R�O�","R�mM�M","R�N�O","R�O"
2034 DATA 34,12,15,"�","�Q�N�","�OmOmM�","�M�MnM�","�OmM�P�","�MoM�M�","�O�M�MmM�","�N�N�NmM�","�Mm�Mm�P�","�O��M�","ЎMmM���","͑�Mm�M�","ΐ�NmM�","ώ�P�","�"
2035 DATA 35,20,16,"�N�","�O�P��А�","�On�S��","�O�M�O�M��","�M�M�N�O��","M�MmMmQ�M�M�","M�NmMm�N�S�","�M�N�M�M�M�","�N�M�mO�M�P�","�MmNmN�M�M�","�M�MmMmP�M�R","�NmM�M�M�M�R","�MnQnN�R","�M�M�MmN�R","M�P�M�P�R","M�M�R"
2036 DATA 36,18,19,"Q�U","O�N�T","�NmN�T","�OmMmN�Q","�MmO�MmO�M�","�N�N�OmM�M͎�","�m�mM�mЎ�","M�O�M�M��","M�m�M���M�N��","M�M�PmQ��","M�O�M�N��","M�M�M�N�M��","N�mM�mMώ�","N�O�P�M͎�","M�Mn�NmM�M�","M�QpM�Q","M�MmM�P�Q","M�O�M�Q","M�X"
2037 DATA 37,21,15,"�V","͒O�N","͒O�N�O�N","͎�MmPmQ�N","͏MmMmM�N�O�N","͏�m�P�N�N","�P�O�mN�Mm�","N�NnMmMmNm�NmM�","N�NmO�m�N�P�","N�M�M�NmM�","O�NmMmM�M�R","O�PmNmN�R","O�O�M�O�R","P���R","T�V"
2038 DATA 38,14,15,"M�P","M͐O�O","M͍͍�NmM�N","ΐ�M�M��M","�M��N�N�","�Q�mM�mM�","�M�NmP�","M�mNmMmMm�N�","M�M�NmMmM�M�","M�N�N�N�","M�P�M�M�","M�NmM�NmN�M","M�mMmO�M","O�N�O","O�S"
2039 DATA 39,23,18,"Z�R","Y΍�P","Y͐�P","Mِ�P","�O�Qΐ�","�Nn�NmM�ΐP�","�RnMm�N��O�","�NmM�MnM�M͐�N�","�NmM�MmN�M�M�N�M","�M�M�U�M","�OmNmM�M�N�M","�Mm�N�M�M�M�M","�OmO�S�R","�NmM�mMmMm�N�R","�Mo�MmO�M�R","�P�NnM�W","�O�W","Q�Y"
2040 DATA 40,11,11,"R�M","�M��M","�QmN�M","�Om�Mm�M","�m͏�M�M","M�Mm�N�M","M�M͍M��M�","M�O�M�mM�","M�mNmP�","M�N�","M�R"
2041 DATA 41,20,15,"W�P","V�O�O","U�Q�O","T�NnN�O","S�MnNmM�O","S�MmPmM�O","�O�OnM�M","�N�M�P�M","͎Wo��M","͍�M�M�O�M","͍�MӍM�mMm�","͗M�OmM�","�NmN�","Y�N�","Z�N"
2042 DATA 42,13,18,"M�P","M���O�M","M�MmOmO�M","M�NmMmMo�M","M�Mn�M�O�M","�mPmO�M","�NmNq�","�Mm�M�O�","�Nm��O�","�Mΐ�nM�","�MΐO�","�O��N�M","�M͐�n�M","M�M͐�N�M","M�U�M","M�M�m�M","P�P�O","P�O"
2043 DATA 43,17,16,"P�M","P�V�","P�N�M�nMmN�","P�mM�m�N�M��","O�M�M�MmM�M�","O�OmM�mN�M�M","O�O�MmO�M�M","O�MmMmO�M�M","O�N�N�NmM�M","O�P�Mn�M�M","�nO�O�M","͐�N�M","͍͏M�T","͐O�T","͐O�T","�T"
2044 DATA 44,25,19,"R�Y","O�O�Y","O�O�M�M�U","O�MmM�NmP�P","N�mN�M�S�P","�NnMmMmM�N�O�","�SmO�M�O�","�N�M��O�M�N�M�","�M�R�M�m�M�N�","M�M�M�MΎM�OmM�","M�NmNmN�mΎM�m�N�","M�N�M�M�Q��M�MmM�","M�O�M�M͎�PmN�","P�P͎�M�M�N�","TҎ�O�M�M","Y͎�N�M","Y͎S�M","Y�N�N�M","Z�N"
2045 DATA 45,19,11,"T�P","P�N�N�M","P�O�OmP�M","M�M�nM�M�N�M","�R�M�N�M�","�N�Mm�mNmNmN�","͏P�M�N�O�","͏�P�M�M�M�","͏�N�NmNmN�","�M�O�O�","V�"
2046 DATA 46,22,17,"P�N�O","P�O�N�N�O","P�OmO�NmN�O","P�N�M�M�Q�","P�MmOmMn�M�O�","P�N�N�MmMmO�","�N�PϏ�","�O�mM�N�MБ�","�R�N�M�MΑ�","�M�N�mOϏ�","O�O�M�Mm�O͏�","N�SmNm�M�","M�Mo�N�MmO�P","M�O�N�M�N�P","M�OmN�mM��R","M�N�O�U","Q�U"
2047 DATA 47,19,15,"M�Y","M�O�Y","M�M�M�T","M�Rm��O","M�MmM�mM�O�O","M�M�MmPmM�O","M�M�M�N�mM�","�N�M�mR�","�Nm�NmN�M�M�M�","�U�M͏�M�","�N�N�N�","Q�M�M͏�M�","V�M�M�M�","V�S�","V�"
2048 DATA 48,16,15,"S�Q","S�N�P","S�O�O","S�MnM�N","Q�mNmM�M","N�PmO�M","�N�M�N�M","�P�M͐mM�M","�M�OmM��M�M","�NmM�M͍���M�M","�N�M�M�M","N�M�mN�m�","Q�MmQ�","S�N�O�","S�"
2049 DATA 49,19,16,"R�M","QΎP�O�M","PΎ�MmPmM�M","OΎ���M�M�mM�M","O͎���M�M�MmN�M","Џ�N�P�M�M","�N�M�V�M","�M�mMmM�N�M�M�M","�MmOmO�M�O�N","�nO�M�M�M�M�N","N�OmO�M�M�","N�Mm�M�R�","N�mO�O�O�N�","N�N�O�Q�","N�N�R�P�","N�R�M"
2050 DATA 50,21,16,"Q�O","Q�P�P�O","Q�QmMmN�M","O�M�OmMmP�M","N�MmN�m�MmMmM�M","�O�M�O�NmM�M","�MmNmN�NmN�M�M","�M�m�M�m�NmN�","�M�N�M�M�M�NmN�","�P�mOmO�MmM�M�","�N�N�N�Mm�N�","N͏M�mN�N�M�","N͓�MnM�mM�M�","N͓�U�","N͓�N�","N�Q�M"
2051 DATA 51,16,14,"�M�R","͏�M�N�O","͏�NmN�O","͐�MmNm�M","ΐ�OmN�M","ϏM�MmMmM�M","�M�P�NmN�M","�N�M�M�M�","�MmM�M�mNmP�","�NmM�MmPmN�","�O�MmMnMmM�","�N�N�N","�M�P�P","�Y"
2052 DATA 52,21,14,"M�\","�N�X","�S�M�R","�Mm�N�O�R","͎�Nm�M�N�M�R","͎�Rn�M�P","͍��M�N�mMmP�","͎�N�Q�m�O�","͍�mNmM�M�NmQ�","͎�NmO�O�","͍��m�O�Q","͎NmM�U","�N�M�M�Y","�Y"
2053 DATA 53,13,19,"O�","O�N�O�","O�MmOmN�","O�N�m�","O�M�N�N�","N�N͍�O�","N�NΎ�N�","N�M�M͍��M�","N�M�m͎�mM�","N�MmM͎�N�","N�M�Mͮ�N�","N�MmM͎�m�","N�P���N�","M�N�N�N�","�P�N�","�N�m�","�MmRmN�","�N�O�O�","�"
2054 DATA 54,23,20,"M�M","M�O�N�O�O�O�M","M�MmQmOmOmO�","�M�N�O�M�m�","�O�M�m�O�O�","�MmO�M��O�MmM�","�M�N�M��O�","�MՎ�O�M�","�V͎�MmO�N","�M�M�Mώ�M�N�","�M�O�OΎ�M�N�","�O�Rm��S�","�M�O�O�N�O�N�","�M�M�","�V�O�PmM�","�MmN�MmMmMmO�M�P�","�M�m�Mm�N�M�P�M�","�NmMnM�MmNmM�M�M�","�V�O�R�","�"
2055 DATA 55,22,15,"M�","�_�","�PmM�R�M�O�","�N�M�N�m�M�","�m�O�m͐O�M�M","�N�PmM͐�M�M�M","�MmM�M�M�M͐�O�M","�MmM�nO͐�m�M�M","�M�Mm�m�m͐�O�M","�OoO͐�P�M","�Nm�O�M�Mm�M","�N�M�nNmOmM�N","�Q�MmNmM�O�N","M�O�O�N","Q�T"
2056 DATA 56,14,16,"�P","�T�M","�M�M�N�","�M�MmMmMmNmM�","�S�mO�","�mNn�N�","N�N�M�Mm�M","N�m�OmM��M","O�NmMmM�M","O�M�OmN�M","O�M�O�M�M","N�N�M�M","N�U�M","N͓�M","N͓�O","N�O"
2057 DATA 57,18,11,"U�Q","M�N�P","�NmRmM�","�O�M�OΏ�","�M�nMmMn�mΏ�","�M�P�N�O��","�Nm�M�nO��","�MmNnNmMΐ�","�mS�","N�N�R","N�X"
2058 DATA 58,27,20,"Z�S","V�P�S","V�N�M�N�O","V�O��͎�O�O","M�M�Mm͍͏P�O","M�O�N�Mͭ��M�O","M�MmR�M͎͎�M�P","�M�O�Mͭ��M�P","�O�Mm�m�M�M͎�M�P","�MmNmQ�Mͭ�P�M�P","�M�NmM�M�N�N�M�P","M�NmNmM�M�M�M�P","M�m�m�N�M�M�P","�M�U�N�M�P","�NmM�Nm�N�n���","�RmM�M�N�N�m�O�","�M�Nm�M�Z�","O�NmN�M�N�N�","O�N�N�S","P�_"
2059 DATA 59,29,20,"U�\","U�N�\","U�N�U","O�N�R�U","O�O�M�M�M�M�O�T","O�MmQmN�NmM�T","N�Mm�M�N�M�Q�","N�NmN�Nm�M�MnM�O�M�N�","M�M�O�Q�PmM�M�N�","M�N�mO�M�N�N�Mn�M�N�","M�Pm�MmN�O�MmN�M�M�","�mMmM�P�N�OmP��","�N�P�M�MmMmM�Nύ��","�Q�NnM�NmQΐ�","�N�N�OmN�m�Nΐ���","�M�NmN�M�Mm�Nΐ���","�M�NmN�MmM�N͐���N","�PmM�O�M����P","�O�N�N�N�N����R","�N�T"
2060 DATA 60,26,16,"T�Y","T�O�V","T�MmP�N�M","T�O�Mm�N�N�M","�M�OmO�O�M","͎Q�MmN�M�N�N�M","͎mN�OmN�NmM�MmM��M","͍��M�MmMmM�N�P͍�N","͎�mM�M�O�PnM͍�N","͎�MmMmNmMmM�O�M��N","͍�nM�M�OmM�m�MmM͍�N","͎�R�O�Q͍�N","͎�N�Mҍ�M","�Mn^���","�N�N��","�\�"
3000 DATA "BO",30852,"CI",35946," BO",30852,"CI",35946," MEG",41048,"FA",41048,"ZOTT",41048,"",1
3010 DATA "VARR",30852,"TUNK",35946," NE",30852,"KI",35946," NAD",41048,"RA",41048,"GOT",41048,"",1
3020 DATA "NEM",61506," A",56390,"KAR",51278,"TA",41048," FEL",38498,"VEN",38498,"NI",51278,"",1
3030 DATA "AGY",41048,"BA",38498," KEL",35946,"LET",30838," FEK",30852,"TET",30852,"NI",30852,"",1,"",0
