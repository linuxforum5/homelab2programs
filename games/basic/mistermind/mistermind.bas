10 DIM KR(3), VL(4), VZ(3), KI(3)
20 SP$=CHR$(83+128)+CHR$(80+128)+CHR$(65+128)+CHR$(67+128)+CHR$(69+128)
30 UK=115 : TK=30
40 OH = 200*256+90
50 HH = 200*256+130
60 BH = 200*256+160
70 PRINT CHR$(12);
80 GOSUB 1310
90 CO=10 : RO=3    : GOSUB 1250 : PRINT "M";CHR$(100);"STERMIND - 2023";
100 CO=0:RO=12:GOSUB 1250 : PRINT "FELKESZULTEL? A KEZDESHEZ NYOMJ ";SP$;"-T!"
110 CO=INT(RND(3.9))*10 : RO=INT(RND(5.9))
120 CO=15:RO=7
130 A=USR(0) : IF A<>32 THEN GOTO 110
140 PRINT CHR$(12);
150 GOSUB 1370
160 PT=116
170 VS=1
180 VO=0
190 RO=0:CO=4:GOSUB 1250:PRINT "????  ";CHR$( TK );" ";CHR$( UK );
200 FOR SR = 1 TO 12
210 RM=49153+SR*80-0
220 IF SR < 10 THEN POKE RM+1, 48+SR
230 IF SR >= 10 THEN POKE RM, 49, 48+SR-10
240 POKE RM+2, 46, 32, PT, PT, PT, PT
250 NEXT
260 CO=14 : RO=0    : GOSUB 1250 : PRINT "    M";CHR$(100);"STERMIND - 2023";
270 RO=RO+2 : GOSUB 1250 : PRINT "GONDOLTAM 4 BETURE. MIND";
280 RO=RO+1 : GOSUB 1250 : PRINT "LEHET ";CHR$(65+128);",";CHR$(66+128);",";CHR$(67+128);",";CHR$(68+128);",";CHR$(69+128);" VAGY ";CHR$(70+128);".";
290 RO=RO+1 : GOSUB 1250 : PRINT "TALALD KI MIRE GONDOLTAM!";
300 RO=RO+1 : GOSUB 1250 : PRINT "MAX. 12 SORBAN TIPPELHETSZ";
310 RO=RO+1 : GOSUB 1250 : PRINT "SORONKENT KIERTEKELLEK.";
320 RO=RO+2 : GOSUB 1250 : PRINT CHR$( UK );" ALATT LATOD, HANY BETU";
330 RO=RO+1 : GOSUB 1250 : PRINT "  VOLT JO, DE ROSSZ HELYEN";
340 RO=RO+1 : GOSUB 1250 : PRINT CHR$( TK );" ALATT LATOD, HANY BETU";
350 RO=RO+1 : GOSUB 1250 : PRINT "  VOLT JO ES JO HELYEN IS";
360 CO=16:RO=RO+2 : GOSUB 1250 : PRINT CHR$(193);"-";CHR$(198);" TIPPET MEGAD/MODOSIT";
370 CO=18:RO=RO+2 : GOSUB 1250 : PRINT CHR$(212);" TIPPET TOROL";
380 CO=16:RO=RO+2 : GOSUB 1250 : PRINT CHR$(139);" ";CHR$(141);" POZICIO MODOSITASA";
390 CO=14:RO=RO+2 : GOSUB 1250 : PRINT SP$+" TIPP KIEMELEST VALT";
400 CO=17:RO=RO+2 : GOSUB 1250 : PRINT CHR$(195);CHR$(210);" TIPPSOR ELLENORZESE";
410 CU=63
420 CS=3
430 LK = 0
440 CN=0
450 VL(0)=0 : VL(1)=0 : VL(2)=0 : VL(3)=0 : VL(4)=32
460 CP = 49153+8+VS*80-0
470 FL=0
480 KY=USR(255) : IF LK>0 AND KY=LK THEN FOR T=1 TO 500 : NEXT : GOTO 480
490 LK = KY
500 RM=49153+4+VO+VS*80-0
510 X=RND(255)
520 IF VO=4 AND CN=4 AND KY=13 THEN GOTO 780
530 IF VO<4 AND KY=84 AND VL(VO)>64 THEN POKE RM, PT : VL(VO)=0: CN=CN-1 : GOTO 480
540 IF VO<4 AND KY>64 AND KY<71 AND VL(VO)=0 THEN CN=CN+1
550 IF VO<4 AND KY>64 AND KY<71 THEN POKE RM, KY : VL(VO)=KY: VO=VO+1 : GOTO 480
560 IF VO<4 AND KY=32 AND VL(VO)>0 THEN VL(VO)=VL(VO)+128 : IF VL(VO)>255 THEN VL(VO)=VL(VO)-256 : GOTO 480
570 IF VO=4 AND CN<4 THEN VO=0 : RM=49153+4+VO+VS*80-0
580 BG = VL(VO) : IF BG = 0 THEN BG = PT
590 IF VO<4 AND ( KY=11 OR KY=13 ) THEN POKE RM, BG: VO=VO+1 : GOTO 480
600 IF VO>0 AND KY=10 THEN POKE RM, BG: VO=VO-1 : GOTO 480
610 IF VO=4 AND FL=1 THEN POKE CP, 32, 32 : FL = 0 : GOTO 480
620 IF VO=4 AND FL=0 AND CN<4 THEN POKE CP, 160, 32 : FL=1 : GOTO 480
630 IF VO=4 AND FL=0 AND CN=4 THEN POKE CP, 67+128, 82+128 : FL=1 : GOTO 480
640 IF KY>0 THEN GOSUB 1330
650 IF VO<4 THEN POKE CP, 32, 32
660 CU = 63
670 IF VO<4 AND VL(VO)>64 THEN CU = VL(VO)
680 IF FL = 1 THEN CU = 32
690 FL = 1 - FL
700 POKE RM, CU
710 GOTO 480
720 CS=CS-1
730 IF CS>0 THEN GOTO 480
740 CS=2
750 CU=CU+1
760 IF CU>70 THEN CU=65
770 GOTO 480
780 GOSUB 840
790 HI=INT(AT/256) : LO=AT-256*HI
800 VS=VS+1 : VO=0
810 IF VS>12 THEN GOTO 1210
820 IF OK=4 THEN GOTO 1030
830 GOTO 440
840 OK=0
850 HT=0
860 POKE RM, 32, 32, 32, 32, 32
870 FOR I=0 TO 3
880 IF VL(I)>128 THEN VL(I)=VL(I)-128
890 NEXT
900 GOSUB 1320
910 FOR I=0 TO 3
920 VZ(I)=1
930 IF VL(I)=KR(I) THEN OK=OK+1 : VZ(I)=0 : VL(I)=0 : POKE RM+2, 48+OK+128 : A=USR(OH)
940 NEXT
950 FOR I=0 TO 3
960 IF VL(I)=0 THEN GOTO 1000
970 FOR J=0 TO 3
980 IF VZ(J)=1 AND VL(I)>0 AND VL(I)=KR(J) THEN HT=HT+1 : VZ(J)=0 : VL(I)=0 : POKE RM+4, 48+HT : A=USR(HH)
990 NEXT
1000 NEXT
1010 GOSUB 1310
1020 RETURN
1030 GOSUB 1260
1040 FOR I=0 TO 3
1050 POKE RM-4+I, KR(I)+128
1060 NEXT
1070 FOR SO=(VS-1)*2+1 TO 24
1080 AT = 49153 + (SO)*40
1090 HI=INT(AT/256) : LO=AT-256*HI
1100 POKE 16404, LO, HI : PRINT CHR$(100);" GRATULALOK ";CHR$(100);
1110 KY = USR(255) : IF KY=85 THEN RUN
1120 NEXT
1130 FOR SO=(VS-1)*2+1 TO 24
1140 AT = 49153 + (SO)*40
1150 HI=INT(AT/256) : LO=AT-256*HI
1160 POKE 16404, LO, HI : PRINT "              ";
1170 KY = USR(255) : IF KY=85 THEN RUN
1180 NEXT
1190 CO=4:RO=0:GOSUB 1250:FOR I=0 TO 3 : PRINT CHR$(KR(I)+128); : NEXT
1200 GOTO 1070
1210 GOSUB 1260
1220 CO=14 : RO=19 : GOSUB 1250 : PRINT "SAJNOS NEM SIKERULT. :(";
1230 KY = USR(255) : IF KY=85 THEN RUN
1240 GOTO 1230
1250 PC = 49153 + RO*40 + CO : HI=INT(PC/256) : LO=PC-256*HI : POKE 16404, LO, HI : RETURN
1260 CO=4:RO=0:GOSUB 1250:FOR I=0 TO 3 : PRINT CHR$(KR(I)+128); : NEXT
1270 CO=14
1280 FOR RO=13 TO 23 : GOSUB 1250 : PRINT "                          "; : NEXT
1290 CO=14 : RO=13 : GOSUB 1250 : PRINT CHR$(213);" UJ FELADVANY";
1300 RETURN
1310 POKE 16384, 177, 29 : RETURN
1320 POKE 16384, 132, 29 : RETURN
1330 GOSUB 1320
1340 A=USR(BH)
1350 GOSUB 1310
1360 RETURN
1370 FOR I=0 TO 3 : KR(I)=65+INT(RND(5.9)) : NEXT : RETURN
1380 CO=15 : RO=24 : GOSUB 1250 : PRINT "CN=";CN;" VO=";VO; "FL=";FL;" ? ";
1390 FOR I=0 TO 3 : PRINT CHR$(KR(I)+128); : NEXT
1400 RETURN
