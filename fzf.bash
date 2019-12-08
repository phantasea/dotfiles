#########################
# fzf setup
#########################
# --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -50'
# Black=0  Red=1  Green=2  Yellow=3  Blue=4  Magenta=5  Cyan=6  White=7

if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

export FZF_COMPLETION_TRIGGER=',,'

export FZF_DEFAULT_COMMAND='fd --type file --max-depth 3'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="--exact --no-multi --no-sort --cycle --reverse
                         --select-1 --prompt='$=' --height 40%
                         --bind=~:toggle-sort,ctrl-n:page-down,ctrl-p:page-up
                         --color=hl:14,fg+:7,bg+:1,hl+:14,info:13,prompt:9"

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

jj() {
    if [[ "$#" -ne 0 ]]; then
        j "$@"
        return
    fi
    cd "$(autojump -s | sort -k1gr | cut -d':' -f 2- | sed 's/^\s\+//' | egrep '^\/' | fzf +m --inline-info)"
}

fff() { cat ~/.favedirs | sed "s%\~%$HOME%" | xargs fd -a -t=f . | fzf "$@" | xargs -r fileopen ;}
ffl() { cat ~/.favedirs | sed "s%\~%$HOME%" | xargs locate | fzf "$@" | xargs -r fileopen ;}
ffv() { fd -t=f -e=mp4 . /media | fzf "$@" | sed 's/ /\\ /g' | xargs -r fileopen ;}
ffw() { fd -t=f -d=1 . ~/docs/webs | fzf "$@" | sed 's/ /\\ /g' | xargs -r fileopen ;}
ffx() { fd -t=f -d=2 -e=html . /opt/.porn/text | fzf "$@" | sed 's/ /\\ /g' | xargs -r fileopen ;}
ffe() { fd -t=f -d=3 -a -H --size=-800k . | fzf --select-1 --query="$*" | sed 's/ /\\ /g' | xargs -r fileopen ;}

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
