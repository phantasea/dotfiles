# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
#HISTCONTROL=ignoredups
#HISTCONTROL=erasedups

#HISTTIMEFORMAT='%F %T '
HISTIGNORE="cd:ls:ll:l:web:fim:"

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\[\033[01;33m\]\u\[\033[00m\]:\[\033[01;36m\]\w\[\033[00;31m\]\$\[\033[00;37m\]'
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
# if [ -x /usr/bin/dircolors ]; then
#     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#     alias ls='ls --color=auto -F'
#     #alias dir='dir --color=auto'
#     #alias vdir='vdir --color=auto'
# 
#     alias grep='grep --color=auto'
#     alias fgrep='fgrep --color=auto'
#     alias egrep='egrep --color=auto'
# fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.alias ]; then
    . ~/.alias
fi

source ~/.tmux/bash_completion_tmux.sh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# source autojump
if [ -f /usr/share/autojump/autojump.bash ]; then
    . /usr/share/autojump/autojump.bash
fi

#set -o vi
unset  MAILCHECK
export PAGER="/bin/sh -c \"col -b | view -c 'set ts=8 nomod nolist nonu noma' -\""
export MANPAGER="/bin/sh -c \"col -b | view --noplugin -c 'set ft=man ts=8 nomod nolist nonu noma titlestring=MANPAGE' -\""
export RANGER_LOAD_DEFAULT_RC=FALSE
export EDITOR=vim
export VISUAL=vim
export LANG=en_US.UTF-8
export VIDIR_EDITOR_ARGS='-c :set nolist | :set ft=vidir-ls'
export WWW_HOME='www.baidu.com'
export LYNX_CFG='~/.etc/lynx.cfg'
export PYTHONSTARTUP='~/.pystartup'

if [ -d "$HOME/.util" ]; then
    export PATH="$HOME/.util:$PATH"
fi

#fbterm -- tmux

