#!/usr/bin/env bash

#vim ~/.w3m/keymap
#keymap  xs  COMMAND  "SHELL ~/.w3m/cgi-bin/fzf_surfraw.cgi ; GOTO     /usr/local/libexec/w3m/cgi-bin/goto_clipboard_primary.cgi"
#keymap  XS  COMMAND  "SHELL ~/.w3m/cgi-bin/fzf_surfraw.cgi ; TAB_GOTO /usr/local/libexec/w3m/cgi-bin/goto_clipboard_primary.cgi"
#keymap  xs  COMMAND  "SHELL ~/.w3m/cgi-bin/fzf_surfraw.cgi ; GOTO     /usr/local/libexec/w3m/cgi-bin/goto_clipboard.cgi"
#keymap  XS  COMMAND  "SHELL ~/.w3m/cgi-bin/fzf_surfraw.cgi ; TAB_GOTO /usr/local/libexec/w3m/cgi-bin/goto_clipboard.cgi"

clear

# select your elvi
PREFIX=$(surfraw -elvi | grep -v 'LOCAL\|GLOBAL'| fzf -e --height=0 | awk '{print $1}')

# exit script if no elvi is selected (e.g hit ESC)
if [ "$PREFIX" = "" ]; then
    xsel -c
    exit
fi

# get user input
read -r -e -p "  $PREFIX >> Search Keyword: " INPUT

# print proper url and copy to primary clipboard (aka highlighted clipboard) and tmux clipboard
surfraw -browser=echo "$PREFIX" "$INPUT" | xsel -p
# pidof tmux >/dev/null && tmux set-buffer "$(surfraw -browser=echo "$PREFIX" "$INPUT")"
