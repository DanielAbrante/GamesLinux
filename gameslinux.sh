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

get_games_list() {
	NUMBER_LINES=`wc -l titles.txt | grep -o "[0-9]*"`

	for ((i = 1; i <= $NUMBER_LINES; i++))
	do
		TITLES[$i]=`sed ""$i'!d'"" ./titles.txt`
	done

	for ((i = 1; i <= $NUMBER_LINES; i++))
	do
		echo "ID=$i -" ${TITLES[$i]}
	done
}

get_game_id() {
	echo ""
	echo '===================================='
	echo ' Choose the ID to download the game '
	echo ""
	printf 'ID: '
	read -r GAME_ID
}

APPLICATION="1"

about

while [ "$APPLICATION" = "1" ]
do
	echo "[a] - All games list"
	echo "[s] - Search game"
	echo "[e] - Exit"
	printf '>> '
	read -r OPTION_MENU
	
	if [ "$OPTION_MENU" = "a" ] 
	then
		curl https://yewtu.be/channel/UCrE7Vzc6G971XnrDyo53mGA | grep -A 1 -io '<p dir="auto">[- a-zA-Z0-9.á-źçã,!]*' | sed 's/<p dir="auto">//g' | sed 's/--//g' | grep -v '^[[:space:]]*$' > titles.txt
		echo ""
		get_games_list
		get_game_id
		APPLICATION="0"
	elif [ "$OPTION_MENU" = "s" ] 
	then
		echo ""
		printf 'Type a name: '
		read -r GAME
		echo ""
		echo ""
		curl https://yewtu.be/channel/UCrE7Vzc6G971XnrDyo53mGA | grep -A 1 -io "$GAME[- a-zA-Z0-9.á-źçã,]*" | sed 's/<p dir="auto">//g' | sed 's/--//g' | grep -v '^[[:space:]]*$' > titles.txt
		get_games_list
		get_game_id
		APPLICATION="0"
	elif [ "$OPTION_MENU" = "e" ]
	then
		exit 1
	else 
		`zenity --error --text='Invalid Option!' --title='Erro'` 
		clear
	fi
done

printf 'Choose the filename, (No need extension!): '
read -r FILENAME

URL_INVIDIOUS_INSTANCE='https://yewtu.be'

HTML_GAME_TITLE=`curl https://yewtu.be/channel/UCrE7Vzc6G971XnrDyo53mGA | grep -B 11 -i "${TITLES[GAME_ID]}"`

rm -f ./titles.txt

URL_GAME_TITLE=`echo $HTML_GAME_TITLE | grep -oi '/watch?v=[a-zA-Z0-9]*'`
HTML_VIDEO=$URL_INVIDIOUS_INSTANCE$URL_GAME_TITLE
FILEID=`curl $HTML_VIDEO | grep -m 1 -i 'drive' | grep -io '1[_a-zA-Z0-9-]*'`

cd $HOME
mkdir -p GamesLinux
cd GamesLinux

curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${FILEID}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${FILEID}" -o ${FILENAME}.AppImage

chmod +x $FILENAME.AppImage
rm -f cookie
