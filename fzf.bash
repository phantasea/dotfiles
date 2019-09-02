# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/apps/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/apps/fzf/bin"
fi

export FZF_DEFAULT_OPTS="--exact"
export FZF_COMPLETION_TRIGGER=',,'

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/apps/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/opt/apps/fzf/shell/key-bindings.bash"
