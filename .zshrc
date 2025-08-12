# ============================================================================
# PATH
# ============================================================================
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/bin:$PATH"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ============================================================================
# Environment Variables
# ============================================================================
export LANG=ja_JP.UTF-8

# ============================================================================
# Instant prompt
# ============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# Oh My Zsh Configuration
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ============================================================================
# Plugins
# ============================================================================

plugins=(
    git                      # Git aliases and completion
    zsh-autosuggestions     # Command suggestions based on history
    zsh-syntax-highlighting # Syntax highlighting for commands
)

# ============================================================================
# Oh My Zsh Initialization
# ============================================================================

source $ZSH/oh-my-zsh.sh

# Display Settings
ENABLE_CORRECTION="true"             # Enable command auto-correction
COMPLETION_WAITING_DOTS="true"       # Show dots while waiting for completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ============================================================================
# Personal Aliases
# ============================================================================

alias zshconfig="vi ~/.zshrc"
alias ohmyzsh="vi ~/.oh-my-zsh"

# python
alias python=python3
alias pip=pip3

# ============================================================================
# Functions
# ============================================================================
repo() {
  local repodir=$(ghq list | fzf -1 +m) && cd $(ghq root)/$repodir
}
