# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/misc/apps/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/misc/apps/fzf/bin"
fi

export FZF_COMPLETION_TRIGGER=',,'
export FZF_DEFAULT_COMMAND='fd --type file --color=always --max-depth 3'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--exact --multi --cycle --ansi --bind=ctrl-f:page-down,ctrl-b:page-up --color=fg+:7,bg+:1,hl+:3 --layout=reverse --height 40%"
#export FZF_DEFAULT_OPTS="--exact --multi --cycle --ansi --bind=ctrl-f:page-down,ctrl-b:page-up --color=fg+:7,bg+:1,hl+:3 --layout=reverse --height 40% --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -50'"

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/misc/apps/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/opt/misc/apps/fzf/shell/key-bindings.bash"
