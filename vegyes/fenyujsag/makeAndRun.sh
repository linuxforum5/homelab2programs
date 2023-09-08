#!/bin/sh
NAME=fenyujsag
#h2CreateHtp -t $NAME.bas -o $NAME.htp -B $NAME.final.BAS
z80asm $NAME.asm -o $NAME.bin
X=$?
if [ "$X" = "0" ] ; then
    h2CreateHtp -t $NAME.txt -b $NAME.bin -L 20992 -o $NAME.htp -B $NAME.bas
    X=$?
fi
if [ "$?" = "0" ] ; then
    htp2h2wav -i $NAME.htp -o $NAME.wav
fi
if [ "$X" = "0" ] ; then
    ../mame-mame0257/homelab2 homelab2 -quickload $NAME.htp -autoboot_command " RUN"
    # -debug
fi
