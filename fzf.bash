# Setup fzf
# --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -50'
# Black=0  Red=1  Green=2  Yellow=3  Blue=4  Magenta=5  Cyan=6  White=7
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

export FZF_COMPLETION_TRIGGER=',,'

export FZF_DEFAULT_COMMAND='fd --type file --max-depth 3'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="--exact --no-multi --no-sort --cycle --reverse --prompt='$=' --height 40%
                         --bind=ctrl-f:page-down,ctrl-b:page-up --color=hl:14,fg+:7,bg+:1,hl+:14,info:13,prompt:9"

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"
