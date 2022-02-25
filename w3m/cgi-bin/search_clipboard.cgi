#!/usr/bin/env bash

clipb="$(xsel -ob)"
if [ -z "$clipb" ]; then
    printf "W3m-control: PREV\r\n"
    exit
fi

if [ "$clipb" =~ "www" ] || [ "$clipb" =~ "http" ]; then
    printf "%s\r\n" "W3m-control: GOTO $clipb";
else
    printf "%s\r\n" "W3m-control: SRCH_GG $clipb";
fi

printf "W3m-control: DELETE_PREVBUF\r\n"
