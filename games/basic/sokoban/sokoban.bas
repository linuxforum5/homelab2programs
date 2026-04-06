1  LV =  1 : GOTO 70 '""""""""""""""""""""
2  LV =  2 : GOTO 70 '" COPYRIGHT        "
3  LV =  3 : GOTO 70 '" PRINCZ LASZLO    "
4  LV =  4 : GOTO 70 '" HUNGARY          "
5  LV =  5 : GOTO 70 '" LASZLO@PRINCZ.HU "
6  LV =  6 : GOTO 70 '" 2023 V.: 1.0     "
7  LV =  7 : GOTO 70 '" GPL 3            "
8  LV =  8 : GOTO 70 '""""""""""""""""""""
9  LV =  9 : GOTO 70
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
90 IF LV = 1 THEN GOTO 200
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
500 KE = PEEK( 14911 ) : KK = PEEK( 14912 ) : IF HN = 1 AND TC > 1 THEN A=USR(TC)
510 TC = 0
520 IF KK = 127 THEN IF LK<>1 THEN LK=1 : NP = PL-1 : PK = PL-2 : GOTO 600
530 IF KE = 254 THEN IF LK<>2 THEN LK=2 : NP = PL+1 : PK = PL+2 : GOTO 600
540 IF KE = 253 THEN IF LK<>3 THEN LK=3 : NP = PL-40: PK = PL-80: GOTO 600
550 IF KK = 253 THEN IF LK<>4 THEN LK=4 : NP = PL+40: PK = PL+80: GOTO 600
560 IF KE = 251 THEN GOTO 100
570 IF KE = 223 THEN GOTO 1100
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
1200 
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
2001 DATA 1,22,11,"PÑY","PÍOÍY","PÍmNÍY","NÏNmÏW","NÍNmNmMÍW","ÏMÍMÏMÍQÒ","ÍOÍMÏMÓNÍ","ÍMmNmYÍ","ÑMĞMÍíĞNÍ","PÍRÏNÒ","PÔV"
2002 DATA 2,14,10,"ØN","ÍNÍQÏ","ÍNÍMmNmNÍ","ÍNÍmĞNÍ","ÍPíMÎNÍ","ÍNÍMÍNmMÎ","ÒMÎmMmMÍ","NÍMmNmMmMmMÍ","NÍPÍQÍ","NØ"
2003 DATA 3,17,10,"TÔM","TÍQíÍM","TÍMmÍmMÎM","TÍMmNmÍN","TÎmMmMÍN","ÕMmMÍMÏ","ÍNÎMmNmNÍ","ÎPmNmOÍ","ÍNÖ","ÔU"
2004 DATA 4,22,13,"ZÔ","ZÍNÍ","OØNÍ","OÍPÍNmMmOÍ","OÍMoÍmNmMÍNÍ","OÍNmQmMÍNÍ","OÍMnMÍmMmMmÔ","ĞNmMÍQÍS","ÍOÍMÕS","ÍPmNÎX","ÍMnÍnMíÍX","ÍOÍOÎX","ÕY"
2005 DATA 5,17,13,"TÑP","TÍOÑ","TÍMÍmÎNÍ","TÍQmMÍ","ÕMÏOÍ","ÍNÎMmNmÏ","ÍPmMnMÎM","ÍNÎmNmMíÍM","ÕNmNÎM","TÍMmMmNÍM","TÏMÎMÍM","VÍPÍM","VÒM"
2006 DATA 6,12,11,"ÒNÏM","ÍNÍMÎíÎ","ÍNÏOÍ","ÍQnMÍ","ÍNÍMÍMmMÍ","ÍÏMÍMmMÍ","ĞMmMÍmNÍ","OÍNmÍMmMÍ","OÍMmNmNÍ","OÍNÎOÍ","OÕ"
2007 DATA 7,13,12,"SÑM","MÓOÎ","ÎMÍMíÎMnMÍ","ÍPmRÍ","ÍNmNÏOÍ","ÏMÑmÏ","ÍMmNÏMÍM","ÍMmMmMmMÍM","ÍPÏÍM","ÍMnMÍMÍÍM","ÍNÏMÑM","ĞU"
2008 DATA 8,16,17,"NĞV","NÍN×","NÍPmOmMmMÍ","NÍMmÍMmMÍNmNÍ","NÍNmMmNÍPÍ","ÏMmÍMÍNĞMÍ","ÍíÍmMmMmNÎOÍ","ÍPmMÍmÍOÍMÍ","ÎNmPmMmMmMÍ","MĞNÕ","NÏNÏR","NÍRÍR","NÍRÍR","NÍ’ÍR","NÍ’ÍR","NÍ’ÍR","NÔR"
2009 DATA 9,17,18,"VÓ","VÍNÍ","RÑNÍ","RÍRÍ","RÍNÎNÍ","RÎMÎNÍ","QÏMÔ","QÍMoMÎP","MÑNmMmMÑ","ÎOÍmMmOÍOÍ","ÍíMmNmPmNmMÍ","ÒMnMmMÑ","QÍMmPÍP","QĞMÏP","TÍNÍQ","TÍNÍQ","TÍNÍQ","TĞQ"
2010 DATA 10,21,20,"ZĞO","UÒNÍO","UÍSÍO","UÍNĞMÏM","MÏNÑMÏPÍM","ÎíĞOoMÍPÍM","ÍMnOnMmOÍÎ","ÍNoÍPmNÍ‘Í","ÍMmOÍMnMnMÍ‘Í","ÏOÍNmPÍ‘Í","NÍOÍMmMmMmMÍ‘Í","NÍMÓMÏ‘Í","NÍOÍNmMmNÍ‘Í","NÏMÍMnMmMmÓ","PÍMÍNmRÍP","PÍMÍMoMoMÍP","PÍMÍSÍMÍP","PÍMÕMÍP","PÍWÍP","PÙP"
2011 DATA 11,19,15,"VĞQ","QĞMÍNÍQ","OÏNÏmMÍQ","NÎOíNmNÍQ","MÎNmMnÎMÎQ","MÍNÍmÎQÍQ","MÍMÍMmMnMÍMÏP","MÍOmMÍNÍMmMÑ","ĞPÍNnMÍOÍ","ĞMÎMmUÍ","ÍPÏNÔ","ÍMÍMĞS","ÍÍÍX","Í‘ÍX","ÓX"
2012 DATA 12,13,16,"NÕN","NÍ­­Í­­ÍN","NÍ­­­ÍN","NÍ­­­­ÍN","NÍ­­­ÍN","NÍ­­­­ÍN","NÏOÏN","PÍOÍP","ÒMÒ","ÍWÍ","ÍMmMmMmMmMmMÍ","ÎMmMmMmMmMÎ","MÍmMmMmMmMmÍM","MÍOmímOÍM","MÍNÑNÍM","MĞOĞM"
2013 DATA 13,20,13,"PÕS","NÏOÎNÑO","ÏRÍNÍOĞ","ÍNnMÍmMÍNÍNMÍ","ÍMÍNmÍímÎMÍMÍÍMÍ","ÍNÎMÍmNÍPMÍ","ÍMmÍPmMÍMÍMÍÍMÍ","ÍPÎNÎmMmMMÍ","ÍMmMÎOÍNÍmÍÍMÍ","ÎMnNmOmNmMÍ","MÍmNÒPÎNÍ","MÍOÍPÖ","MÑZ"
2014 DATA 14,17,13,"ÜM","ÍZÍM","ÍMÍMÒQÍM","ÍMÍNmMmMmMmÍNÍM","ÍMÍOmímOÎMÎ","ÍMÍMÍmMmMmÏÍ","ÍMÍOmMmNÎÍ","ÍMÏoMmMÎÍ","ÍQÍMÎMÎÍ","ÑOÎMÎÍ","PÑQÏ","TÍQÍN","TÓN"
2015 DATA 15,17,17,"SĞR","PĞNÍR","OÎNÍNÍR","OÍNmMmMÍR","MÏMÍmOĞO","MÍNmNÎmOÍO","MÍNÍMíMmMÍMmÍO","MÍNÍRmMĞ","MÎMĞmÎQÍ","MÍMmÍ‘ÍMÍOÍ","MÍNm­MmÍMÏ","ÎNÍ‘ÍOÍN","ÍOÏMÓN","ÍMnNÍNÍS","ÍNÍQÍS","ÒOÍS","QÑS"
2016 DATA 16,14,15,"ÑU","ÍOÎT","ÍPÍNĞN","ÍMmNĞNÍN","ÍNnMmOmÍN","ÏíMÍmPÎM","MÍNÎNmMmMÎ","MÍMmNÎMÎMÍ","MÍNÍmÎmNÍÍ","MÏOmÎÍ","NÍPÍ­Í","NÍMnMÍ‘Í","NÍNÕ","NÍNÍT","NĞT"
2017 DATA 17,18,16,"SÓP","MÓQÍP","MÍQÍMmímMÍP","MÍnMÍOÕ","MÍMÏ’ÎOÍ","MÍOm’ÎMÍMÍ","MÍMÏ’QÍ","ÎOĞMÏMÍmÎ","ÍNÍmOÍNmNÍMÍM","ÍNmMoNÍMmÎMÍM","ÍOmMmMÏnMÍMÍM","ÑQmOÍMÍM","PÏMÏOÍMÍM","RÍQÍOÍM","RÔNÍM","YĞM"
2018 DATA 18,22,13,"RØP","RÍNNÎOÍP","RÍMÍQíMÍP","MÒMÎÍMĞO","ÎNÎĞQĞ","ÍMmMÎPmMÍNmNÍ","ÍQMÎMÍMÎMÎNÍ","ĞmÏmÍMmNÍOÍMÎ","MÏNÍPÎmMnMÍMÍM","MÍOnMÍMÍMmMÍMmÎMÍM","MÍ^ÍM","MİNÍM","]ĞM"
2019 DATA 19,28,20,"TÒZ","TÍOíĞW","RÑMmOÍW","RÍOÎPĞT","RÍMmÎNÎPÍT","RÍOÍNÑMÍT","RÍMÍnMmPÍMÍT","RÍNmMmMÏMÍMÍT","RÍMÍOmNÍMÍMÍT","RÍMÍNÍmÍOÍMÍT","QÎMĞOÍMÍMÍT","QÍNmNÑMÍMÍMĞO","PÎPmQmNÏNĞ","ÑNÏMmMmÍMmMÍO‘Í","ÍQÎRÍNÎNÍ‘Í","ÍMpPÒmÎOÍÎÍ","ÎPÎZÍÍ","MÎNÛOÍ","NÍNÍYÑNÎ","NĞ]ĞM"
2020 DATA 20,20,20,"SØM","SÍ–ÍM","QÏÍÍÍÍÍM","QÍO•ÍM","QÍíMmMmMmM­­ÍM","PÓMÓM","MĞOÍPÎNÍN","ÎPmMÍPÍMmMÎM","ÍNÍmÍMÏMÏmOÎ","ÍMmNmMmOÍMmMmMmMÍ","ÍNÍMmMÎSÍmMÍ","ÍOmĞmĞmÎNÍ","ĞNÎOÍPÍNÍ","OÍmMÎOÍMÍMnNÍ","OÍOÍMmMÍNmPÍ","OÏMÍMnMÍNmMÏ","QÍMÍPÍMmMÎN","QÍMÔMÍO","QÍVÍO","QØO"
2021 DATA 21,16,14,"OÖO","OÍNÍOÍO","OÍRÍO","OÍNÍNĞM","NÓNÍNÎ","NÍXÍ","NÍNÍNÎNÍNÍ","ĞMÎNĞMÎ","ÍNmNÑMÍNÍ","ÍMÍMmNmNÍMmNÍ","ÍMímNmOÍOÎ","ĞMÎMÓM","OÍPÍS","OÒS"
2022 DATA 22,22,20,"XĞR","MØNÑN","MÍPÍNÍNmNÍOÎM","MÍMmMmMmNmMÍMmMmOÍM","MÎmMmOÍMíÍMmOmMÍM","ÏOØMÎM","ÍNmMmÍNÍ’ÍMmÍN","ÍMÍOÍNÍ’ÎMÍN","ÍNÎMÎMÍM‘ÍNÍN","ÍMÍRm’MmMÍN","ÍMÍMmMÎMÍ’ÍNÍN","ÍNmMmÍNÍ’ÍMmÍN","ÍMmOÍNÎmÑNÍN","ÍMmMmMĞMmMmNmMmÍN","ÎMÍQmMmMmMmOÏ","MÍNÒMmPmPÍ","MÍUÍMÓMÍ","MÓMÍmVÍ","SÍO×","SÑV"
2023 DATA 23,25,14,"SÓW","SÍNÍNĞT","SÍMmÍmMÍNÎS","ÔNÍNÍOÔ","ÍNÍMmÍmMÍNmÍNÍOÍ","ÍÍMÍQÍmNÍRÍ","ÍÍPmÍNÍMmPÍmNÍ","ÍMíÎNÍmMÍmNÍNÍOÍ","ÍMÎMmÍQmÔ","ÔNÍnÍmNÍS","SÍMmÍNÍNmÍS","SÍNÍNÍOÍS","SĞNÑS","VĞW"
2024 DATA 24,21,19,"OÖT","OÍ”ĞQ","OÍÍÍÍNÍQ","OÍ”nMÍQ","OÍQÏNĞN","MÕNmMÍOÍN","MÍQmOmMmNmMÍN","MÍNÍPÍNmMmÍNÍN","MÎMÑOÍNÍNÍN","MÍMmQÍOĞMÍN","ÎNmÍOÍMÎNÍNÍN","ÍPÎmÏPÍNÎM","ÍMmPmMÍNÍNÍOÍM","ÑPÍMÎMÍMÎMÎ","PÍmÍMÍNmNmMmOÍ","PÍíÍNmÍoNÍOÍ","PÏNmRÑ","RÎNÍNÍNÍP","SÖP"
2025 DATA 25,23,17,"[ĞP","VÒNÑ","PÓSÍOÍ","PÍRmMmMÎMÍMÍMÍ","PÍNĞMmNÍQÍ","PÍRmMÍMÍMÎÍÍ","PÎmĞmMmMmMÎÍÍ","PÍQÍPĞÏ","PÍMmOÒNÍÍÍ","ÒoÎRíÍÍÍ","ÍRÍPÍmÍmÏMÍ","ÍMĞMÍqPÍMÍ","ÍMÍPmQÍOÍMÍ","ÍMÍOÎMÎQÏÍ","ÍMÒmÒNÒ","ÍTÍPÍNÍQ","ÖPĞQ"
2026 DATA 26,15,15,"ÕR","ÍSÍR","ÍSĞO","ÎMĞMÍNÍO","ÎMÍíÎPÍO","ÍMoMmNnÍO","ÍNÍMÎMmNÍO","ÍNÍMÎNmMĞ","ĞNoMmÍNÍ","MÍOÎOÍ","MÍMÍOÍMÍMÍ","MÍOÍMÍMÎÍ","MÑMmNÍÍ","QÎOÑ","RÑP"
2027 DATA 27,23,13,"MİQ","MÍOÍPÍOÏO","Î‘NmÎMÍMÍMmMÍO","Í’ÍNmNÍNmNÍO","Í’ÍNÍNÍMÍMÍMÎN","ÕMmNmMÍMÍNÏ","NÍQÍmÎmMÎMÎOÍ","MÎOmPÍMmNmOÍMÍ","MÍNÎMÏMÍNÑmÍMÍ","MÍMmMnQmOmQÍ","MÍMmPmÎmMÔMÍ","MÓNíMÎRÏ","SÒV"
2028 DATA 28,15,17,"QÓO","QÍíMÍNÍO","QÍMmOÍO","PÏMÎMÍO","MĞMmNÍMÎN","MÍSÍNÎM","MÍMmMmĞMmMÍM","MÍMnMÍNÍNmÍM","MÍmNmOÍmNÍM","ÎNnÍOnMÎ","ÍMnNÍNÍNmMÍ","ÍQĞMmNÍ","ÍNÍmÎÎOÍ","ÏMÍÑ","NÍM“ÎN","NÍOÍN","N×N"
2029 DATA 29,24,11,"\ÑO","SÒMÏOĞ","OÑPÏMmMmNmMÍ","ĞNÎMÍmMmPmMÍOÍ","ÍOnMmMmNmOÍmÎ","ÍMÍMÎMÍOÏmÎMÍNÍ","ÍPÍMÏPÍPÍ","ÍPÍMÎNmNÏmMÍ","ÍÒNmNÍNĞMÎ","ĞPÍOÏPíNÍM","TÛM"
2030 DATA 30,14,20,"MÑT","MÍOÓN","MÍMmMÏOÍN","MÍMmPnMÍN","MÎMĞOÍN","ÏMÍNÍMÏN","ÍOÍNÍíÎO","ÍMnPmMÍO","ÍOÍMÍMmMĞ","ÑMÍOÍNÍ","MÍOmĞOÍ","MÍNmQmNÍ","MÎOÑMÎ","MÖNÍ","ÎÍMmNmMÍ","Í‘ÍMnÍNÍ","ÍMÍMmNmMÍ","Í‘mOÍNÍ","ÎNÖ","MĞU"
2031 DATA 31,15,12,"MÓS","MÍNÍNÑO","ÎNÍNÍÏM","ÍNmÍNÍNÍM","ÍMmMÍnMNÍM","ÍNmÍNÍMÍM","ÍOÍMmÔ","ÎmSmMmMÍ","ÎNÍNnMÍOÍ","MÒNÎníÍ","RÍRÎ","RÔM"
2032 DATA 32,18,16,"NĞX","NÍNÕP","MÎNÎMíÍOÍP","MÍNmÍMmMmOĞM","MÍmNmNÍMmMmÍNÎ","ÎNmÎMÍmMmQÍ","ÍNÍNÍMÍOoNÍ","ÍMmPmNmÎMĞ","ÍMmMmMÍmÍNÍNÍO","ÎNÏNÏmMÍO","MÍNÍQÍO","MĞ’ĞO","OÍĞR","OÍÎU","OÍÍV","OÑV"
2033 DATA 33,13,15,"RĞO","NÑNÍO","MÎQmÍO","ÎMmNÎMÏM","ÍímMmMÍMmNÍM","ĞMÎOmÍM","MÍÍmMmMÍM","MÍÍOmÍM","MÍNnMÎ","MÍMÍMmOÍ","MÒmMmNÍ","RÍOÏ","RÍmMÏM","RÍNÍO","RĞO"
2034 DATA 34,12,15,"Ø","ÎQÎNÍ","ÎOmOmMÍ","ĞMÎMnMÍ","ÍOmMÍPÍ","ÍMoMÍMĞ","ÍOÍMÍMmMÎ","ÍNÍNÍNmMÍ","ÍMmÍMmÍPÍ","ÍOÍMĞ","ĞMmMÍíÍ","Í‘ÍMmÍMÍ","ÎÍNmMÍ","ÏÎPÍ","Ø"
2035 DATA 35,20,16,"ØNÒ","ÍOÍPÍíĞÍ","ÍOnÍS‘Í","ÍOÍMÏOÎMÍ","ÎMÎMÏNÍOÍ","MÍMmMmQÍMÎMĞ","MÍNmMmÎNÍSÍ","ĞMÍNĞMÎMÎMÍ","ÍNÍMÍmOÎMÎPÍ","ÍMmNmNÍMÎMÓ","ÍMÍMmMmPÍMÍR","ÍNmMÎMÎMÍMÍR","ÍMnQnNÍR","ÎMÎMÏMmNÍR","MÍPÍMÍPÍR","MÒMÒR"
2036 DATA 36,18,19,"QĞU","OÏNÎT","ĞNmNÍT","ÍOmMmNĞQ","ÍMmOÍMmOÍMĞ","ÍNÍNÍOmMÍMÍÍ","ÎmÍmMĞmĞÍ","MÍOÑMÎMÍ","MÍmÍMÎíÎMÎNÍ","MÍMÍPmQÍ","MÍOĞMÏNÍ","MÏMÎMÍNÎMÍ","NÎmMĞmMÏÍ","NÍOÎPÍMÍÍ","MÎMnÎNmMÍMĞ","MÍQpMÍQ","MÍMmMÏPÍQ","MÍOÍMÒQ","MÑX"
2037 DATA 37,21,15,"×V","Í’OÕN","Í’OÍNÎOÍN","ÍÏMmPmQÍN","ÍMmMmMÍNÏOÍN","ÍÍmÑPÍNÍN","ÏPÍOÍmNÍMmÏ","NÍNnMmMmNmÎNmMÍ","NÍNmOÍmÍNÎPÍ","NÏMÎMÍNmMÓ","OÍNmMmMÎMÎR","OÍPmNmNÍR","OÎOÍMÍOÍR","PÑíÑR","TÏV"
2038 DATA 38,14,15,"MÕP","MÍOÎO","MÍÍÍNmMÎN","ÎÍMÍMíÎM","ÍMÍNÍNÎ","ÍQÍmMÎmMÍ","ÎMÏNmPÍ","MÍmNmMmMmÍNÍ","MÍMÍNmMmMÎMÍ","MÍNÏNÎNÍ","MÍPÎMÎMÎ","MÍNmMÍNmNÍM","MÏmMmOÏM","OÍNÑO","OĞS"
2039 DATA 39,23,18,"ZÏR","YÎÏP","YÍÍP","MÙÍP","ÎOÎQÎÑ","ÍNnÎNmMíÎPÍ","ÍRnMmÍNÍOÍ","ÍNmMÎMnMÍMÍÍNÎ","ÍNmMÎMmNÍMÎMÏNÍM","ÎMÑMÏUÍM","ÎOmNmMÑMÏNÍM","ÍMmÏNÍMÑMÍMĞM","ÍOmOÍSÍR","ÍNmMÍmMmMmÏNÍR","ÍMoÍMmOÍMĞR","ÍPÍNnMÍW","ÒOÏW","QÑY"
2040 DATA 40,11,11,"RĞM","ÓMíÍM","ÍQmNÍM","ÍOmÎMmÍM","ÎmÍÍMÍM","MÍMmNÍM","MÍMÍMÍMÎ","MÍOÍMÍmMÍ","MÍmNmPÍ","MÍNÓ","MĞR"
2041 DATA 41,20,15,"WÑP","VÎOÎO","UÎQÍO","TÎNnNÍO","SÎMnNmMÍO","SÍMmPmMÍO","ĞOÍOnMÑM","ÍNÔMÎPÍM","ÍWoíÍM","ÍÍMÓMÎOÎM","ÍÍMÓMÍmMmÏ","Í—MÍOmMÍ","ÚNmNÍ","YÎNÏ","ZĞN"
2042 DATA 42,13,18,"MÔP","MÍíÎOĞM","MÍMmOmOÍM","MÍNmMmMoÍM","MÍMnÍMÍOÍM","ÎmPmOÍM","ÍNmNqÎ","ÍMmĞMÍOÍ","ÍNmÍOÍ","ÍMÎÍnMÍ","ÍMÎOÎ","ÍOÍNÍM","ÎMÍÍnÍM","MÍMÍÍNÍM","MÍUÍM","MĞMÎmÏM","PÍPÍO","PÒO"
2043 DATA 43,17,16,"PØM","PÍVÎ","PÍNÍMÍnMmNÍ","PÍmMÍmÍNÎMíÍ","OÎMÎMÍMmMÍMÎ","OÍOmMÍmNÍMÍM","OÍOÍMmOÍMÍM","OÎMmMmOÎMÍM","OÍNÍNÎNmMÍM","OÍPÎMnÍMÍM","ÒnOÍOÍM","ÍÍNÔM","ÍÍMÎT","ÍOÍT","ÍOÍT","ÕT"
2044 DATA 44,25,19,"RÒY","OÑOÍY","OÍOÍMÍMÑU","OÍMmMÍNmPÒP","NÎmNÏMÎSÍP","ÏNnMmMmMÍNÎOÑ","ÍSmOÒMÎOÍ","ÍNÔMÍíOÍMÍNÍMÍ","ÎMÏRĞMÍmÍMÍNÍ","MÍMÏMĞMÎMÍOmMÎ","MÍNmNmNÍmÎMÍmÎNÎ","MÍNÍMÍMÍQÎMÎMmMÍ","MĞOÍMÎMÍÍPmNÍ","PÑPÍÍMÍMÍNÎ","TÒÍOÍMÎM","YÍÑNÍM","YÍSÍM","YÎNÏNÎM","ZÕN"
2045 DATA 45,19,11,"TÓP","PÑNÍNĞM","PÍOÍOmPÍM","MĞMÍnMÎMÎNÍM","ÎRÍMÍNÎMÏ","ÍNÏMmÍmNmNmNÍ","ÍPÍMÎNÍOÍ","ÍÍPíMÍMÏMÎ","ÍÍNÏNmNmNÍ","ÔMÎOÍOÍ","VÕ"
2046 DATA 46,22,17,"PÕNĞO","PÍOÎNĞNÍO","PÍOmOÍNmNÍO","PÍNÍMÎMÍQĞ","PÎMmOmMnÍMÍOÍ","PĞNÍNÍMmMmOÍ","ÑNĞPÏÍ","ÍOÍmMÍNÍMĞ‘Í","ÍRÍNÍMÍMÎ‘Í","ÒMÍNÍmOÏÍ","OÍOÎMÍMmÍOÍÍ","NÎSmNmÍMÑ","MÎMoÎNÍMmOÍP","MÍOÍNÍMÏNÏP","MÍOmNÍmMíĞR","MÑNÍOÍU","QÔU"
2047 DATA 47,19,15,"MÑY","MÍOÍY","MÍMÍMÒT","MÍRmíÒO","MÍMmMÎmMÏOÍO","MÍMĞMmPmMÍO","MÍMÑMÍNÍmMĞ","ÎNĞMÎmRÍ","ÍNmÍNmNÍMÎMÎMÍ","ÍUÍMÍÍMÍ","ÒNÏNNÍ","QĞMÍMÍÍMÍ","VÍMÏMÍMÍ","VÍSÍ","VÕ"
2048 DATA 48,16,15,"SĞQ","SÍNÎP","SÍOÎO","SÍMnMÎN","QÏmNmMÎM","NĞPmOÍM","ÏNÍMÑNÍM","ÍPÍMÍmMÍM","ÍMÍOmMÍMÍM","ÍNmMÍMÍ­ÍMÍM","ÏNĞMÏMÍM","NĞMímNÎmÎ","QÏMmQÍ","SÍNÎOÍ","SÕ"
2049 DATA 49,19,16,"RØM","QÎPÍOÍM","PÎ­MmPmMÍM","OÎ­ÍMÍMÍmMÎM","OÍ­ÍMÍMÍMmNÍM","ĞÍNÍPÍMÍM","ÍNÎMÍVÍM","ÍMímMmMÏNÍMÍMÎM","ÍMmOmOÍMÍOÍN","ÏnOÍMÍMÍMÍMÍN","NÍOmOÍMÍMÑ","NÍMmÍMÑRÍ","NÍmOÍOÍOÍNÍ","NÍNÏOÎQÍ","NÍNÍRÍPÎ","NĞRÒM"
2050 DATA 50,21,16,"QÙO","QÍPÏPÍO","QÍQmMmNĞM","OĞMÍOmMmPÍM","NÎMmNÍmĞMmMmMÍM","ÏOÍMÍOÏNmMÍM","ÍMmNmNÍNmNÍMĞM","ÍMÎmĞMÍmÍNmNÏ","ÍMÎNÏMÍMÍMÍNmNÍ","ÍPímOmOÍMmMÍMÍ","ÑNÍNÎNÍMmÍNÍ","NÍMÑmNÍNÍMÍ","NÍ“ÍMnMÍmMÍMÍ","NÍ“ÍUÍ","NÍ“ÓNÎ","NÕQĞM"
2051 DATA 51,16,14,"ÑMĞR","ÍÍMÍNĞO","ÍÏNmNÍO","ÍÎMmNmÏM","ÎÎOmNÍM","ÏMÎMmMmMÍM","ÍMÎPÍNmNÍM","ÍNÎMÍMÏMĞ","ÍMmMÍMÍmNmPÍ","ÍNmMíMmPmNÍ","ÍOÍMmMnMmMÏ","ÍNÒNÏN","ÍMÎPĞP","ÏY"
2052 DATA 52,21,14,"MĞ\","ÎNÑX","ÍSÍMÑR","ÍMmÏNÏOÍR","ÍÍNmÍMÍNÍMÍR","ÍÍRnÍMÏP","Í­ÍMÍNÍmMmPÑ","ÍÍNÎQÎmÍOÍ","Í­mNmMÍMÎNmQÍ","ÍÎNmOÍOÒ","Í­ÎmÎOÑQ","ÍNmMÑU","ÍNÍMíMÍY","ÔY"
2053 DATA 53,13,19,"OÖ","OÍNÏOÍ","OÍMmOmNÍ","OÍNĞmÎ","OÎMÍNÍNÍ","NÎNÍ­OÍ","NÍNÎÍNÍ","NÍMíMÍ­ÍMÎ","NÍMÍmÍÍmMÍ","NÍMmMÍÍNÍ","NÍMÍMÍ®ÍNÍ","NÍMmMÍÍmÎ","NÍP­ÍNÍ","MÏNÍNÍNÍ","ÎPĞNÍ","ÍNÓmÎ","ÍMmRmNÍ","ÍNÎOÍOÍ","Ù"
2054 DATA 54,23,20,"MáM","MÍOÎNÍOÍOÍOÍM","MÍMmQmOmOmOÎ","ÑMÍNÍOÏMÎmÏ","ÍOÍMÎmÒOÍOÍ","ÍMmOÍM’ÍOÍMmMÍ","ÎMÍNÍM’ÑOÍ","ÎMÕÍOÍMÏ","ÍVÍÍMmOÍN","ÍMÎMÏMÏÎMÍNÏ","ÍMÍOÍOÎÎMÏNÍ","ÍOíRmÍSÍ","ÍMÍOÍOÎNÍOÎNÍ","ÑMÚMÎ","ÍVÍOÍPmMÍ","ÍMmNÍMmMmMmOÍMÍPÍ","ÍMÍmÎMmÍNÎMÎPÍMÍ","ÍNmMnMĞMmNmMÍMÍMÍ","ÍVÍOÍRÍ","ã"
2055 DATA 55,22,15,"Má","Î_Í","ÍPmMÍRÎMÍOÍ","ÍNÒMÏNÍmÎMÎ","ÎmÍOÎmÍOÍMÍM","ÍNÍPmMÍÎMÍMÍM","ÍMmMÍMÍMÍMÍÎOÍM","ÍMmMÍnOÍÎmÍMÍM","ÍMÍMmímÎmÍÎOÍM","ÍOoOÍÍPÍM","ÍNmÍOÍMÒMmÏM","ÎNÍMÏnNmOmMÍN","ÎQÍMmNmMÎOÍN","MÑOÍOÓN","QÕT"
2056 DATA 56,14,16,"ÖP","ÍTĞM","ÍMÒMÍNÎ","ÍMÍMmMmMmNmMÍ","ÍSÍmOÍ","ÏmNnÍNÏ","NÍNÎMÍMmÎM","NÎmÍOmMíÍM","OÍNmMmMÏM","OÍMÍOmNÍM","OÍMÎOÍMÍM","NÎNÑMÍM","NÍUÍM","NÍ“ÏM","NÍ“ÍO","NÕO"
2057 DATA 57,18,11,"UĞQ","MÕNÎP","ÎNmRmMÑ","ÍOÎMÎOÎÍ","ÍMÍnMmMnÍmÎÍ","ÍMÍPíNÍOÍ","ÍNmÍMÏnOÍ","ÍMmNnNmMÎÍ","ÏmSÓ","NÍNÓR","NĞX"
2058 DATA 58,27,20,"ZÒS","VÑPÍS","VÍNÎMÍNÑO","VÍO­ÍÍOÍO","MÑMĞMmÍÍPÍO","MÍOÏNÎMÍ­ÎMÎO","MÍMmRÎMÍÍÎMÍP","ÒMÍOÍMÍ­ÑMÍP","ÍOÍMmÍmÍMÍMÍÑMÍP","ÍMmNmQÍMÍ­PÍMÍP","ÎMÎNmMÏMÍNÎNÍMÍP","MÍNmNmMÏMÑMÎMÍP","MÏmÏmÏNĞMÎMÍP","ĞMÍUÏNÍMÍP","ÍNmMÍNmĞNÏnÍíÑ","ÍRmMÍMÍNĞNÍmÍOÍ","ĞMÍNmÍMÍZÍ","OÍNmNÍMÎNÎNÔ","OÎNÏNÔS","PĞ_"
2059 DATA 59,29,20,"UĞ\","UÍNÍ\","UÍNÔU","OÓNÍRÍU","OÍOÍMÍMÍMÍMÍOÎT","OÍMmQmNÎNmMÍT","NÏMmÍMÍNÍMÍQÕ","NÍNmNÍNmÍMÍMnMÍOÍMÍNÍ","MÎMÍOÍQÏPmMÍMÍNÍ","MÍNÍmOÍMÏNÍNÍMnÍMÍNÍ","MÍPmÎMmNÍOÎMmNÍMÍMÎ","ĞmMmMÍPÎNÍOmPÍ","ÍNÍPÏMÍMmMmMÏNÏ­Í","ÍQÎNnMíNmQÎÍ","ÍNÎNÎOmNÍmÍNÎ­Í","ÎMÍNmNÍMÍMmÎNÎ­Ï","ÎMÎNmNÍMmMÍNÍ­ÏN","ÍPmMĞOÍM­ÏP","ÍOÍNÍNÍNÍN­ÏR","ÔN×T"
2060 DATA 60,26,16,"TÑY","TÍOĞV","TÍMmPĞNĞM","TÍOÍMmÍNĞNÍM","×MÍOmOÍOÍM","ÍQÍMmNĞMÍNÍNÍM","ÍmNÍOmNÍNmMÍMmMÎM","Í­ÍMÍMmMmMÎNÎPÍÍN","ÍÍmMíMÍOÎPnMÍÍN","ÍÍMmMmNmMmMÎOÎMÍN","Í­nMÍMÎOmMÍmÍMmMÍÍN","ÍÍRÎOÍQÍÍN","ÍÓNÏMÒÎM","ÍMn^­Î","ÍNŞNÍ","Ğ\Ò"
3000 DATA "BO",30852,"CI",35946," BO",30852,"CI",35946," MEG",41048,"FA",41048,"ZOTT",41048,"",1
3010 DATA "VARR",30852,"TUNK",35946," NE",30852,"KI",35946," NAD",41048,"RA",41048,"GOT",41048,"",1
3020 DATA "NEM",61506," A",56390,"KAR",51278,"TA",41048," FEL",38498,"VEN",38498,"NI",51278,"",1
3030 DATA "AGY",41048,"BA",38498," KEL",35946,"LET",30838," FEK",30852,"TET",30852,"NI",30852,"",1,"",0
