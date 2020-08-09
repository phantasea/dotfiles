#########################
# fzf setup
#########################
# --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -50'

if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

export FZF_COMPLETION_TRIGGER=',,'

export FZF_DEFAULT_COMMAND='fd --type file --max-depth 3'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Black=0  Red=1  Green=2  Yellow=3  Blue=4  Magenta=5  Cyan=6  White=7
export FZF_DEFAULT_OPTS="--exact --no-multi --no-sort --cycle --reverse
                         --select-1 --prompt='$=' --height=40% --info=inline --marker='+' --pointer='x'
                         --bind change:top,ctrl-s:toggle-sort,ctrl-v:toggle-preview,ctrl-g:top
                         --bind ctrl-n:page-down,ctrl-p:page-up,ctrl-y:backward-word
                         --preview-window=:hidden
                         --preview '([[ -f {} ]] && (bat --style=auto --color=always {} || cat {}))
                           || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
                         --color=hl:14,fg+:7,bg+:1,hl+:6,info:7,prompt:1,gutter:0,pointer:3,marker:3"

export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_ALT_C_OPTS="$FZF_DEFAULT_OPTS"

# Auto-completion
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
source "$HOME/.fzf/shell/key-bindings.bash"

#########################
# fzf related functions
#########################

# fcd - cd into the directory of the selected file
fcd() {
   local file dir
   file=$(fzf +m -1 -q "$*") && dir=$(dirname "$file") && cd "$dir"
}

ffcd() {
   local dir
   dir=$(fd -t=d -d=3 -H -E .git 2>/dev/null | fzf -1 -0 -q "$*") && cd "$dir"
}

ffloc() {
    locate -b -i "$1" | fzf
}

ffenv() {
    local out
    out=$(env | fzf)
    echo $(echo $out)
}

ffj() { cd "$(cat ~/.config/z.data | cut -d'|' -f 1 | fzf +m --inline-info)" ; }
ffs() { surfraw "$(cat ~/.config/surfraw/bookmarks | sed '/^$/d' | sort -n | fzf -e -i)" ; }
fff() { cat ~/.favedirs | sed "s%\~%$HOME%" | xargs fd -a -t=f -t=l . | fzf "$@" | xargs -r fileopen ;}
ffl() { cat ~/.favedirs | sed "s%\~%$HOME%" | xargs locate | fzf "$@" | xargs -r fileopen ;}
ffa() { fd -t=f -e=mp3 . ~/auds/auds | fzf "$@" | sed 's/ /\\ /g' | xargs -r fileopen ;}
ffv() { fd -t=f -e=mp4 . /media | fzf "$@" | sed 's/ /\\ /g' | xargs -r fileopen ;}
ffw() { fd -t=f -d=1 . ~/docs/webs | fzf "$@" | sed 's/ /\\ /g' | xargs -r fileopen ;}
ffx() { fd -t=f -d=2 -e=html . /opt/.porn/text | fzf "$@" | sed 's/ /\\ /g' | xargs -r fileopen ;}
ffe() { fd -t=f -t=l -d=3 -a -H --size=-800k . | fzf --select-1 --query="$*" | sed 's/ /\\ /g' | xargs -r fileopen ;}
ffo() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && fileopen "${files[@]}"
}

ffO() {
    local out file key
    IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
    key=${out[0]}
    file=${out[1]}
    if [ -n "$file" ]; then
        [ "$key" = ctrl-o ] && fileopen "$file" || vimux "$file"
    fi
}

ffcp() { cp -vi "$1" "$(cat ~/.vifm/bookmark | egrep -v 'bmark|^$' | awk '{print $3}' | grep -v -e '^/$' | fzf | sed "s|~|$HOME|")" ;}

ffpk() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

# fuzzy grep open via ag
ffag() {
  local file

  file="$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1}')"

  if [[ -n $file ]]
  then
      fileopen $file
  fi
}

# git commit browser
ffgshow() {
    git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --tiebreak=index --toggle-sort=\~ --bind "ctrl-m:execute:
        echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
        xargs -I % sh -c 'git show --color=always % | less -R'"
}

# mpd/mpc
ffmpc() {
    local song_position
    song_position=$(mpc -f "%file%" playlist | \
        fzf-tmux --query="$1" --reverse --select-1 --exit-0 | \
        sed -n 's/^\([0-9]\+\)).*/\1/p') || return 1
    [ -n "$song_position" ] && mpc -q play $song_position
}

# ffgrep <SEARCH_TERM>
ffgrep() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!";
    return 1;
  fi

  rg --files-with-matches --no-messages "$1" | fzf --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# z.sh with fzf
ffz() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}
