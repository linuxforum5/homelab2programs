'"! Globálisan használt változók és jelentésük:
'"! UNDO : tárolni kell a 
'"! - EP : játékos előző pozícióját
'"! - EB : mi volt a játékos akutális pozíciója alatt, mielőtt odaléptünk. Nem biztos, hogy BG, mert el is tolhattunk onnan valamit
'"! - KB : volt a következő alatt, mielőtt odalépett
'"! - EC : előző counter : a helyrerakott kövek előző száma
'"! ST : STep counter : A játékos lépéseinek a száma
'"! HN : Hang be = 1, ki = 0
'"! PL : A játékos pozíciója a memóriában
'"! BG : A játékos alatt lévő képernyőtartalom arra at esetre, ha a játékos lelépne róla
'"! SC : SCore : a játékos pontszáma
'"! KR : KaRakterek tömbje megjelenítéshez
'"! CH : CHaracter code - a megjelenítendő karakter kódja
'"! DB : DaraB - a megjelenítendő karakterek darabszáma
'"! TC : TICK hangmagassága. Ha <2, akkor nincs hang, különben kiadja, ha HN engedi
'"! ROM rutinok :
'"! - 1D84 ( 7556 : 132, 29 ) : BEEP HL
'"! - 1DB1 ( 7601 : 177, 29 ) : READ KEY

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

70 DIM KR(5) : KR(0)=32 : KR(1)=119 : KR(2)=121 : KR(3)=101 : KR(4)=251 : KR(5)=99   '"! A megjelenítendő karakterek: 0-üres, 1-doboz, 2-cél, 3-doboz a célon, 4-fal, 5-játékos
80 POKE 16384,132,29 : HN=1                                                          '"! USR függvényt a hangkeltésre állítjuk '"! Hang engedélyezése
90 IF LV = 1 THEN GOTO 200                                                           ." Ha nem az első szinttel indítunk, akkor restore

100 RESTORE                                                                          '"! Az aktuális szint újrakezdése, vagy a megadott szint indítáda. LV a szint értéke
110 IF LV = 1 THEN GOTO 200
120 READ SL,SX,SY                                                                    '"! SL = SKIP level, SX, SY
130 FOR SS = 1 TO SY : READ SW$ : NEXT
140 IF SL < LV - 1 THEN GOTO 120                                                     '"! Ha még van átugrandó szint

200 PRINT CHR$(12)                                                                   '"! CLS
210 POKE 16404, 31, 192 : PRINT "SOKOBAN 60";
220 POKE 16404, 72, 192 : PRINT CHR$(97);" 2023 ";CHR$(97);
230 POKE 49467, 209                                           '"! Q
240 POKE 49507, 140                                           '"! ^
250 POKE 49543, 99, 58, 207, 139, 32, 141, 208            '"! O<X>P
260 POKE 49587, 138                                           '"! V
270 POKE 49627, 193                                           '"! A
280 POKE 16404,  39, 194 : PRINT "EZ A SZINT";
290 POKE 16404,  79, 194 : PRINT "UJRA:";CHR$( 210 );
300 POKE 16404, 159, 194 : PRINT "UTOLSOT";
310 POKE 16404, 199, 194 : PRINT "VISSZA:";CHR$( 213 );
320 POKE 16404,  73, 195 : PRINT "TOLD (";CHR$(99);") A LADAKAT (";CHR$( 119 );") A HELYUKRE (";CHR$( 121 );")";
330 POKE 16404, 113, 195 : PRINT "/A 'RUN X' PARANCS AZ X. SZINTTOL INDIT/";
340 READ LV,X,Y                                                                      '"! LV=Level, X=Width, Y=Height
350 RM = 49152 : LC = 0                                                              '"! LC= láda Counter, azoknak a ládáknak a száma, amit még nem toltunk helyre
360 FOR SR=1 TO Y
370 READ LN$                                                                         '"! LN=Line adatok egy stringben
380 KP = 1 : PC = 0 : ST = 0 : TC = 0 : EP = 0                                       '"! KP = Karakter Pozicio a stringben : PC = Position Counter : a pozíció indexe a sorban 0-ától kezdve, ST=Step counter=A játékos lépéseinek a száma
390 POKE 16404, 150, 192 : PRINT LV;". SZINT";                                       '"! Statisztikai adatok megjelenítése, majd ugrás a billentyűfigyeléshez

400 DB = ASC(MID$(LN$,KP,1))-76 : CH = INT( DB / 32 ) : DB = DB - 32 * CH            '"! Adatok 1 bájton. Felső 3 bit a CH, alsó 5 bit a DB. CH=Character code, DB=hány darab jön egymás után ebben a sorban ebből a karakterből
410 FOR CO=1 TO DB
420 POKE RM + PC + CO, KR(CH)
430 IF CH = 5 THEN PL = RM + PC + CO                                                 '"! A játékos pozíciójának tárolása
440 IF CH = 1 THEN LC = LC + 1                                                       '"! Az eltolandó ládák számának növelése
450 NEXT CO
460 PC = PC + DB : KP = KP + 1 : IF PC < X THEN GOTO 400
470 RM = RM + 40
480 NEXT SR
490 BG = 32 : LK = 0 : GOTO 800                                                      '"! Pálya kirajzolásának vége. PL és LC beállítva. A játék addig tart, míg LC > 0. BG=A játékos alatt lévő kód. LK=az utolsó leütörr billentyű

500 KE = PEEK( 14911 ) : KK = PEEK( 14912 ) : IF HN = 1 AND TC > 1 THEN A=USR(TC)    '"! Lépés tick kiadása
510 TC = 0
520 IF KK = 127 THEN IF LK<>1 THEN LK=1 : NP = PL-1 : PK = PL-2 : GOTO 600           '"! Go LEFT  LK=1
530 IF KE = 254 THEN IF LK<>2 THEN LK=2 : NP = PL+1 : PK = PL+2 : GOTO 600           '"! Go RIGHT LK=2
540 IF KE = 253 THEN IF LK<>3 THEN LK=3 : NP = PL-40: PK = PL-80: GOTO 600           '"! Go UP    LK=3
550 IF KK = 253 THEN IF LK<>4 THEN LK=4 : NP = PL+40: PK = PL+80: GOTO 600           '"! Go DOWN  LK=4
560 IF KE = 251 THEN GOTO 100                                                        '"! Restart level rutin
570 IF KE = 223 THEN GOTO 1100                                                       '"! Undo rutin
580 IF KK = 254 THEN IF LK<>5 THEN LK=5 : HN = 1 - HN : GOTO 800                     '"! Hang ki/be
590 LK=0 : GOTO 500

600 NV = PEEK(NP) : VK = PEEK(PK)                                                    '"! NP-ben a játékos új memóriacíme, PK-ben a rákövetkező cím, ahová tolni lehetne bármit, ha kellene. NV és VK az új pozíciók jelenlegi tartalma
610 IF NV = 251 THEN TC = 250+256*50 : GOTO 500                                      '"! Ütközés: Ha a játékos új pozíciója FAL, akkor semmit sem csinál
620 IF NV = 101 OR NV = 119 THEN GOTO 700                                            '"! Ha a játékos új pozíciója egy láda, végleges vagy tolandó, akkor elugrink 700-ra. 101 = láda pötty fölött, 119 = láda üres felett
630 ST = ST + 1 : TC = 255 '"! 20+256*200                                            '"! Lépésszám növelése
640 POKE PL, BG                                                                      '"! Ha ideér, akkor vagy üres, vagy pötty van a játékos új helyén. Egyszerűen odaléphet. A jelenlegi helyére a BG kerül.
650 BG = PEEK( NP )                                                                  '"! BG felveszi az új hely aktuális értékét
660 EB = PEEK( NP ) : POKE NP, 99 : KB = PEEK( 2 * NP - PL ) : EP = PL : PL = NP : EC = LC                                                            '"! Az új helyre helyezzük a játékost
670 GOTO 800                                                                         '"! Innentől a statisztika megjelenítése jön

700 IF VK <> 32 AND VK <> 121 THEN TC = 250+256*50 : GOTO 500                        '"! A tolás rutinja. Ha az eltolás helyén üres vagy pötty áll, csak akkor megyünk tovább, különben semmit nem teszünk
710 IF VK = 32 AND NV = 119 THEN EC = LC : KB = PEEK( PK ) : POKE PK, 119 : POKE PL, BG : BG=32 : EB = PEEK( NP ) : POKE NP, 99 : EP = PL : PL=NP                 '"! Ha üres kockába toltuk üresről a lábát
720 IF VK = 32 AND NV = 101 THEN EC = LC : KB = PEEK( PK ) : POKE PK, 119 : POKE PL, BG : BG=121: EB = PEEK( NP ) : POKE NP, 99 : EP = PL : PL=NP : LC = LC + 1 : GOSUB 1300           '"! Ha üres kockába toltuk pöttyről a lábát. Pötty magában=121, Pöttyön láda=101
730 IF VK =121 AND NV = 119 THEN EC = LC : KB = PEEK( PK ) : POKE PK, 101 : POKE PL, BG : BG=32 : EB = PEEK( NP ) : POKE NP, 99 : EP = PL : PL=NP : LC = LC - 1 : GOSUB 1400           '"! Ha pöttyre toltuk üresről a lábát
740 IF VK =121 AND NV = 101 THEN EC = LC : KB = PEEK( PK ) : POKE PK, 101 : POKE PL, BG : BG=121: EB = PEEK( NP ) : POKE NP, 99 : EP = PL : PL=NP                 '"! Ha pöttyre toltuk pöttyről a lábát. Pötty magában=121, Pöttyön láda=101
750 ST = ST + 1 : IF TC <> 1 THEN TC = 50+256*10                                     '"! Lépésszám növelése

800 POKE 16404, 190, 192 : PRINT LC;" LADA ";                                        '"! Statisztikai adatok megjelenítése, majd ugrás a billentyűfigyeléshez
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


1000 FOR I=0 TO 100 : J=I : NEXT : RETURN                                              '"! PAUSE RUTIN

1100 IF EP = 0 THEN TC = 250+256*50 : GOTO 500
1110 POKE PL, EB
1120 BG = PEEK( EP ) : POKE EP, 99
1130 POKE 2*PL-EP, KB
1140 IF LC < EC THEN GOSUB 1300
1150 IF LC > EC THEN GOSUB 1400
1160 PL = EP : EP = 0 : ST = ST-1 : LC = EC
1170 GOTO 800

1200 

1300 TC = 1 : IF HN = 1 THEN A=USR(50+256*200) : A=USR(70+256*200) : A=USR(90+256*200)                      '"! Láda rákerült a pozíciójára, hanghatás
1310 RETURN
1400 TC = 1 : IF HN = 1 THEN A=USR(90+256*200) : A=USR(70+256*200) : A=USR(50+256*200)                      '"! Láda lekerült a pozíciókáról, hangatás
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
