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
if tmux list-windows | grep active | grep -q vifm; then
    PS1='\[\e[07;32m\]\u\[\e[07;37m\]@\[\e[07;35m\]\h\[\e[07;37m\]:\[\e[07;36m\]\w\[\e[07;31m\]\$\[\e[00;37m\] '
else
    PS1='\[$(tput sc; rightprompt; tput rc)\[\e[07;32m\]\u\[\e[07;37m\]@\[\e[07;35m\]\h\[\e[07;37m\]:\[\e[07;36m\]\w\[\e[07;31m\]\$\[\e[00;37m\] '
fi

# add /opt/util into PATH
export PATH="/opt/util:$PATH"

unset  MAILCHECK
export PAGER="/bin/sh -c \"col -b | view -c 'set ts=8 nomod nolist nonu noma' -\""
export MANPAGER="/bin/sh -c \"col -b | view --noplugin -c 'set ft=man ts=8 nomod nolist nonu noma titlestring=MANPAGE' -\""
export RANGER_LOAD_DEFAULT_RC=FALSE
export EDITOR=vim
export VISUAL=vim
export LANG=en_US.UTF-8
export PHO_ARGS=-p
export WWW_HOME='www.baidu.com'
export VIDIR_EDITOR_ARGS='-c :set nolist | :set ft=vidir-ls'

# zx - archive extractor
zx() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar Jxf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via zx()" ;;
    esac
  else
    echo "'$1' is not a valid file"
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

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh

[[ -s /usr/share/doc/tmux/examples/bash_completion_tmux.sh ]] && source /usr/share/doc/tmux/examples/bash_completion_tmux.sh

[ -f ~/.hhighlighter.sh ] && source ~/.hhighlighter.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[ -f ~/.forgit.bash ] && source ~/.forgit.bash

#type fbtmux > /dev/null 2>&1 && fbtmux
command -v fbtmux > /dev/null 2>&1 && fbtmux
