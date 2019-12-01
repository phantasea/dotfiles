# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

export FZF_COMPLETION_TRIGGER=',,'
export FZF_DEFAULT_COMMAND='fd --type file --color=always --max-depth 3'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--exact --no-multi --no-sort --cycle --reverse --prompt='$=' --height 40%
                         --bind=ctrl-f:page-down,ctrl-b:page-up --color=fg+:7,bg+:1,hl+:3"
#export FZF_DEFAULT_OPTS="--exact --multi --cycle --ansi --bind=ctrl-f:page-down,ctrl-b:page-up --color=fg+:7,bg+:1,hl+:3 --layout=reverse --height 40% --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -50'"

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"
