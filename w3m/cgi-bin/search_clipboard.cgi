#!/usr/bin/env sh

#GOTO url in clipboard in current page if the clipboard is not empty
if [ "$(xsel -ob)" = "" ]; then
    printf "W3m-control: PREV\r\n"
    exit
fi

printf "%s\r\n" "W3m-control: SRCH_GG $(xsel -ob)";
#delete the buffer (element in history) created between the current page and 
#the searched page by calling this script.
printf "W3m-control: DELETE_PREVBUF\r\n"
