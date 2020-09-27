# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# disable ctrl+s/ctrl-q (stty -ixon ixoff ixany)
stty stop undef
stty start undef

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth:erasedups

HISTIGNORE="cd:ls:ll:l:f:fmfe:mus:e:g:tig:t:w:ww:em:j"

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

shopt -s nocaseglob
#shopt -s nocasematch

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

rightprompt()
{
    printf "%*s" $COLUMNS $(date +%Y-%m-%d/%H:%M:%S)
}

# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
PS1='\[\e[07;32m\]\u\[\e[07;37m\]@\[\e[07;35m\]\h\[\e[07;37m\]:\[\e[07;36m\]\w\[\e[07;31m\]\$\[\e[00;37m\] '

# for ranger/vifm specific shell prompt indicator
#if [ -n "$RANGER_LEVEL" ]; then export PS1="[ranger]$PS1"; fi
#if [ -n "$VIFM" ]; then export PS1="[vifm]$PS1"; fi
#if tmux list-windows | grep active | grep -q vifm; then
if [ -n "$VIFM" ] || [ -n "$RANGER_LEVEL" ]; then
    PS1='\[$(tput sc; rightprompt; tput rc)\[\e[07;32m\]\u\[\e[07;37m\]@\[\e[07;35m\]\h\[\e[07;37m\]:\[\e[07;36m\]\w\[\e[07;31m\]\$\[\e[00;37m\] '
fi

# add /opt/util into PATH
export PATH="/opt/util:$PATH"
export PATH="/opt/util/misc:$PATH"

# find alternative apps if it is installed on your system
find_alt() { for i;do which "$i" >/dev/null && { echo "$i"; return 0; };done;return 1; }

# Use the first program that it detects in the array as the default app
export OPENER=$(find_alt xdg-open exo-open gnome-open)
export XBROWSER=$(find_alt firefox vimb chromium chromium-browser google-chrome $OPENER)
if x-is-run; then
    export BROWSER=elinks
else
    export BROWSER=w3m
fi

unset  MAILCHECK
export PAGER="/bin/sh -c \"col -b | view -c 'set ts=8 nomod nolist nonu noma' -\""
export MANPAGER="/bin/sh -c \"col -b | view --noplugin -c 'set ft=man ts=8 nomod nolist nonu noma titlestring=MANPAGE' -\""
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export EDITOR=vim
export VISUAL=vim
export LANG=en_US.UTF-8
export WWW_HOME='www.baidu.com'
export VIDIR_EDITOR_ARGS='-c :set nolist | :set ft=vidir-ls'
export W3MIMGDISPLAY_PATH="/opt/util/w3mimgdisplay"
export RANGER_LOAD_DEFAULT_RC=FALSE
export MPD_PORT=6609
export _Z_CMD=J
export FZ_CMD=j
export FZ_SUBDIR_CMD=jj
export FZ_CASE_INSENSITIVE=1
export _Z_DATA="$HOME/.config/z.data"

export PSTOGGLE=1
pstoggle() {
    if [ $PSTOGGLE -eq 0 ]; then
        PS1='\[\e[07;32m\]\u\[\e[07;37m\]@\[\e[07;35m\]\h\[\e[07;37m\]:\[\e[07;36m\]\w\[\e[07;31m\]\$\[\e[00;37m\] '
        export PSTOGGLE=1
    else
        PS1='\[$(tput sc; rightprompt; tput rc)\[\e[07;32m\]\u\[\e[07;37m\]@\[\e[07;35m\]\h\[\e[07;37m\]:\[\e[07;36m\]\w\[\e[07;31m\]\$\[\e[00;37m\] '
        export PSTOGGLE=0
    fi
}

# remove bash history duplicates
rmhistdups() {
  awk '!visited[$0]++' "$HOME/.bash_history" > /tmp/.bash_history.tmp;
  mv -f /tmp/.bash_history.tmp "$HOME/.bash_history"
}

# timer
countdown() {
    total=$1
    for ((i=total; i>0; i--)); do sleep 1; printf "Time remaining $i secs \r"; done
    echo -e "\a"
}

up() {
    times=$1
    while [ "$times" -gt "0" ]; do
        cd ..
        times=$(($times - 1))
    done
}

gac() {
    git add -f $1
    shift
    git commit -m "$*"
}

gcd() {
    topdir=$(git rev-parse --show-toplevel)
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    cd "${topdir}/${1}"
}

ytdl_music() {
    youtube-dl --output ~/temp/"$2.%(ext)s" --extract-audio --audio-format mp3 --audio-quality 0 "$1" --add-metadata -x
}

ytdl_video() {
    youtube-dl --output ~/temp/"$2.%(ext)s" "$1"
}

# Alias definitions.
if [ -f ~/.alias ]; then
    . ~/.alias
fi

[ -f /opt/conf/forgit.bash ] && source /opt/conf/forgit.bash
[ -f /opt/conf/fzf.bash ]    && source /opt/conf/fzf.bash
[ -f /opt/conf/z.sh ]        && source /opt/conf/z.sh
[ -f /opt/conf/fz.sh ]       && source /opt/conf/fz.sh

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[[ -s /usr/share/doc/tmux/examples/bash_completion_tmux.sh ]] &&
    source /usr/share/doc/tmux/examples/bash_completion_tmux.sh

[ -f /opt/conf/misc/buku-completion.bash ]    && source /opt/conf/misc/buku-completion.bash
[ -f /opt/conf/misc/ddgr-completion.bash ]    && source /opt/conf/misc/ddgr-completion.bash
[ -f /opt/conf/misc/googler-completion.bash ] && source /opt/conf/misc/googler-completion.bash
[ -f /opt/conf/misc/googler.alias ]           && source /opt/conf/misc/googler.alias

#type fbtmux > /dev/null 2>&1 && fbtmux
command -v fbtmux > /dev/null 2>&1 && fbtmux
#if x-is-run; then
#    tmux set status on
#fi
