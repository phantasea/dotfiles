# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/misc/apps/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/misc/apps/fzf/bin"
fi

export FZF_DEFAULT_OPTS="--exact --multi --cycle --bind=ctrl-f:page-down,ctrl-b:page-up --color=fg+:7,bg+:1,hl+:3"
export FZF_COMPLETION_TRIGGER=',,'

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/misc/apps/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/opt/misc/apps/fzf/shell/key-bindings.bash"
