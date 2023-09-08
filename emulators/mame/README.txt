# Mame emulátor fejlesztett Homelab2 forrás
Egyelőre még nem kész az emulátor fejlesztése, de van benne pár használható funkció:
1 - Képes több rekordos htp fájl betöltésére is a -quickload htpfajl.htp paramétert megadva
2 - Valamennyire javított grafikai képesség, az osztott képernyőt még csak korlátozásokkal kezeli.

Haználatához a mame emulátort újra kell fordítani. A letöltött forrásban a 
src/mame/homelab/
mappába kell bemásolni a homelab.cpp fájlt, majd a letöltött mappa gyökerében a 

make SUBTARGET=homelab2 SOURCES=src/mame/homelab/homelab.cpp

paranccsal fordítani.
