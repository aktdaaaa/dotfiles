
# コマンド履歴で過去の重複は削除 / 別セッションと履歴を共有
setopt histignorealldups sharehistory
# 永続化する履歴ファイルのパスを指定
HISTFILE=~/.zsh_history
# シェル実行中にメモリへ保存するコマンド履歴の最大数
HISTSIZE=1000
# .zsh_historyに書きこまれるコマンド履歴の最大数
SAVEHIST=1000

autoload -Uz compinit
compinit

# 高度な補完
zstyle ':completion:*' completer _expand _complete _correct _approximate
# 大文字小文字や各種記号をfuzzyに考慮して補完
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# ドットファイルを.はじまりでなくても補完
setopt globdots

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# node.js
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# lazygit configuration
export XDG_CONFIG_HOME="$HOME/.config"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="jonathan"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    mise
)

source $ZSH/oh-my-zsh.sh


# eza
alias ll="eza -l"
alias la="eza -la"

# bat
alias cat="bat"

# gitui
alias gu=gitui

# neovim
alias vi=nvim


# ZSH_THEME="robbyrussell"

# bun completions
[ -s "/Users/akito-ito/.bun/_bun" ] && source "/Users/akito-ito/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"

eval "$(~/.local/bin/mise activate zsh)"

# zoxide
eval "$(zoxide init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# starship
eval "$(starship init zsh)"


