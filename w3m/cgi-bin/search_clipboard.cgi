#!/usr/bin/env sh
###  __      _ _                             
### / _| ___| (_)_ __   ___  ___  __ _  __ _ 
###| |_ / _ \ | | '_ \ / _ \/ __|/ _` |/ _` |
###|  _|  __/ | | |_) |  __/\__ \ (_| | (_| |
###|_|  \___|_|_| .__/ \___||___/\__,_|\__,_|
###             |_|                          
###       https://github.com/felipesaa
###
### Author          : felipesaa
### Name            : goto_clipboard.cgi
### Version         : 0.1
### Date            : 2018-09-30
### Description     : paste and go feature for w3m web browser using system clipboard (aka ctrl+v)
### Depends On      : w3m  xsel
### Video Demo      : https://youtu.be/p5NZb8f8AHA
### Source          : https://github.com/felipesaa/A-vim-like-firefox-like-configuration-for-w3m
### Install         : put this script in /usr/lib/w3m/cgi-bin/

#GOTO url in clipboard in current page if the clipboard is not empty
if [ "$(xsel -ob)" = "" ]; then
    printf "W3m-control: PREV\r\n"
    exit
fi

printf "%s\r\n" "W3m-control: SRCH_GG $(xsel -ob)";
#delete the buffer (element in history) created between the current page and 
#the searched page by calling this script.
printf "W3m-control: DELETE_PREVBUF\r\n"
