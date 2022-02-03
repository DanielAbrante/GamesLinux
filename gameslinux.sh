#!/bin/bash

# This is a script to download games from youtube channel GameLinux

about() {
	echo ""
	echo " ========================================================= "
	echo " \                   GamesLinux Script                   / "
	echo " \                 Download Games to Linux               / "
	echo " \                Created by DanielAbrante               / "
	echo " ========================================================= "
	echo ""
	echo " [!] - The GamesLinux folder will be create in your $HOME to save games "
	echo ""
	echo "           -=+ Copyright (C) 2022 DanielAbrante +=-        "
	echo ""
}

about

printf 'Type a game: '
read -r GAME
echo ""

URL_INVIDIOUS_INSTANCE='https://yewtu.be'

HTML_GAME_TITLE=`curl https://yewtu.be/channel/UCrE7Vzc6G971XnrDyo53mGA | grep -B 11 -i $GAME`
URL_GAME_TITLE=`echo $HTML_GAME_TITLE | grep -oi '/watch?v=[a-zA-Z0-9]*'`
HTML_VIDEO=$URL_INVIDIOUS_INSTANCE$URL_GAME_TITLE
FILEID=`curl $HTML_VIDEO | grep -m 1 -i 'drive' | grep -io '1[_a-zA-Z0-9-]*'`

cd $HOME
mkdir -p GamesLinux
cd GamesLinux

curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${FILEID}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${FILEID}" -o ${GAME}.AppImage

chmod +x $GAME.AppImage
rm -f cookie
