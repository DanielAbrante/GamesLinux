#!/bin/sh

about() {
	echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= "
	echo ""
	echo " |                       GamesLinux Script                           | "
	echo " |                    Download Games to Linux                        | "
	echo " |     The games will be in the user directory inside GamesLinux     | "
	echo ""
	echo "              -=+ Copyright (C) 2022 DanielAbrante +=-                 "
	echo ""
	echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= "
}

menu() {
	echo ""
	echo " [a] - All games list"
	echo " [s] - Search game"
	echo " [e] - Exit"
	printf '\n>> '
	read -r MENU_OPTION
}

loop_menu() {
	while [ "$MENU_OPTION" != "e" ]
	do
		about
		menu
		case $MENU_OPTION in 
		"a")
			get_all_list_games
			get_gameid_from_user
			get_filename_from_user
			break
			;;
		"s")
			get_searched_game
			get_all_list_games $SEARCHED_GAME
			get_gameid_from_user
			get_filename_from_user
			break
			;;
		"e")
			exit 1
			;;
		*)
			zenity --error --text='Invalid Option!' --title='Error' 
			clear
			;;
	esac 
	done
}

get_all_list_games() {
	echo ""
	echo -e "\t\t\t\t _-=+ ALL AVAILABLE GAMES +=-_"
	echo ""
	
	if [ "$1" = "" ] 
	then 
		ALL_GAMES_TITLES=`curl -s "https://yewtu.be/channel/UCrE7Vzc6G971XnrDyo53mGA" | grep -i '<p dir="auto">' | sed 's/<p dir="auto">//g'`
		NUMBER_LINES=`echo $ALL_GAMES_TITLES | sed 's/<\/p> /&\n/g' | wc -l`
	else 
		ALL_GAMES_TITLES=`curl -s "https://yewtu.be/channel/UCrE7Vzc6G971XnrDyo53mGA" | grep -i "$SEARCHED_GAME" | sed 's/<p dir="auto">//g'`
		NUMBER_LINES=`echo $ALL_GAMES_TITLES | sed 's/<\/p> /&\n/g' | wc -l`
	fi
	
	for ((i = 1; i <= $NUMBER_LINES; i++))
	do
		TITLES[$i]=`echo $ALL_GAMES_TITLES | sed 's/<\/p> /&\n/g' | sed 's/<\/p>//g' | sed ""$i'!d'""`
		echo "[ID=$i] -" ${TITLES[$i]}
	done
}

get_searched_game() {
	printf '\nType a game: '
	read -r SEARCHED_GAME
	echo ""
}

get_gameid_from_user() {
	printf '\nChoose a ID to download the game: '
	read -r GAME_ID
}

get_filename_from_user() {
	printf 'Choose the filename, (No need extension!): '
	read -r FILENAME
}

loop_menu

URL_INVIDIOUS_INSTANCE='https://yewtu.be'
GAME_TITLE=`echo ${TITLES[GAME_ID]}`
URL_VIDEO=`curl -s https://yewtu.be/channel/UCrE7Vzc6G971XnrDyo53mGA | grep -B 11 -i "${GAME_TITLE}" | grep -io '/watch?v=[a-zA-Z0-9]*'`
HTML_VIDEO=$URL_INVIDIOUS_INSTANCE$URL_VIDEO
FILEID=`curl -s $HTML_VIDEO | grep -m 1 -i 'drive' | grep -io '1[_a-zA-Z0-9-]*'`

GAMES_FOLDER=$HOME/GamesLinux
mkdir -p $GAMES_FOLDER
cd $GAMES_FOLDER

curl -s -c ./cookie -L "https://drive.google.com/uc?export=download&id=${FILEID}" > /dev/null
echo -e "\nDOWNLOADING..."
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${FILEID}" -C - -o "$GAMES_FOLDER/${FILENAME}.AppImage" --progress-bar

rm -f $GAMES_FOLDER/cookie
chmod +x $GAMES_FOLDER/$FILENAME.AppImage
