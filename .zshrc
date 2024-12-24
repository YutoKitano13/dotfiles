eval "$(/opt/homebrew/bin/brew shellenv)"

alias python="python3"
alias vim="nvim"

export PATH="/Library/PostgreSQL/15/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/condy/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/condy/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/condy/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/condy/google-cloud-sdk/completion.zsh.inc'; fi

# ghcup-env
[ -f "/Users/condy/.ghcup/env" ] && . "/Users/condy/.ghcup/env"

# tmux 分割用
ide() {
  tmux split-window -v -p 30 # ウィンドウを垂直に分割し、新しいペインを作成
  tmux split-window -h -p 50 # さらに水平に分割
}

# starshipの設定
eval "$(starship init zsh)"

