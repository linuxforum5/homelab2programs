#!/bin/sh
# Create sokoban.bas, sokoban.htp and sokoban.wav files
NAME=sokoban
cat srcs/$NAME.pre.bas > $NAME.bas
i=0
while [ $i -ne 60 ] ; do
    i=$(($i+1))
    cat srcs/levels/maze.$i.bas >> $NAME.bas
done
cat srcs/$NAME.post.bas >> $NAME.bas

h2CreateHtp -t $NAME.bas -o $NAME.htp -B $NAME.final.BAS
htp2h2wav -i $NAME.htp -o $NAME.wav
