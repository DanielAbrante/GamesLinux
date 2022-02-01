#!/bin/bash

# This is a script to download games from youtube channel GameLinux
# Will be create a directory in your user home called, GameLinux, there will be puted games then you have choosed

about() {
	echo ""
	echo " ========================================================= "
	echo " \                   GamesLinux Script                   / "
	echo " \                 Download Games to Linux               / "
	echo " \                Created by DanielAbrante               / "
	echo " ========================================================= "
	echo ""
	echo " [!] - A pasta GamesLinux será criada na sua HOME para salvar os games "
	echo ""
	echo "           -=+ Copyright (C) 2022 DanielAbrante +=-        "
	echo ""
}

get_game_from_user() {
	read -p "Digite o nome do Jogo: " GAME
}

about

URL_YOUTUBE_CHANNEL="https://yewtu.be/channel/UCrE7Vzc6G971XnrDyo53mGA"
URL_INVIDIOUS_INSTANCE="https://yewtu.be"

get_game_from_user


HTML_VIDEO=`curl $URL_YOUTUBE_CHANNEL | grep -B 11 -i $GAME`
SUFFIX_URL_VIDEO=`less $HTML_VIDEO | grep -oi '/watch?v=[a-zA-Z0-9]*' `
WHOLE_URL_VIDEO="$URL_INVIDIOUS_INSTANCE$SUFFIX_URL_VIDEO"
URL_GOOGLE_DRIVE_GAME=`curl $WHOLE_URL_VIDEO | grep -m 1 -i "drive"`
FILEID=`less $URL_GOOGLE_DRIVE_GAME | grep -io '1[a-zA-Z0-9- _]*' `

cd $HOME
mkdir -p GameLinux
cd GameLinux

wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$FILEID" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$FILEID" -O $GAME.AppImage && rm -rf /tmp/cookies.txt

chmod +x ./$GAME.AppImage
