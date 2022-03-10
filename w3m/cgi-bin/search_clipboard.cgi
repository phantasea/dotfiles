#!/usr/bin/env bash

clipb="$(xsel -ob)"
if [ -z "$clipb" ]; then
    tmuxbuff="$(tmux show-buffer)"
    if [[ "$tmuxbuff" = "NOTHING" ]] || [[ -z "$tmuxbuff" ]]; then
        printf "W3m-control: PREV\r\n"
        exit
    else
        if [ "$tmuxbuff" =~ "www" ] || [ "$tmuxbuff" =~ "http" ]; then
            printf "%s\r\n" "W3m-control: GOTO $(tmux paste-buffer)";
        else
            printf "%s\r\n" "W3m-control: SRCH_GG $(tmux paste-buffer)";
        fi
    fi
else
    if [ "$clipb" =~ "www" ] || [ "$clipb" =~ "http" ]; then
        printf "%s\r\n" "W3m-control: GOTO $clipb";
    else
        printf "%s\r\n" "W3m-control: SRCH_GG $clipb";
    fi
fi

printf "W3m-control: DELETE_PREVBUF\r\n"
