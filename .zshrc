
# コマンド履歴で過去の重複は削除 / 別セッションと履歴を共有
setopt histignorealldups sharehistory
# 永続化する履歴ファイルのパスを指定
HISTFILE=~/.zsh_history
# シェル実行中にメモリへ保存するコマンド履歴の最大数
HISTSIZE=1000
# .zsh_historyに書きこまれるコマンド履歴の最大数
SAVEHIST=1000

# 高度な補完 (compinit は oh-my-zsh に任せる)
zstyle ':completion:*' completer _expand _complete _correct _approximate
# 大文字小文字や各種記号をfuzzyに考慮して補完
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# ドットファイルを.はじまりでなくても補完
setopt globdots

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# compaudit のセキュリティチェックをスキップ (起動高速化)
ZSH_DISABLE_COMPFIX=true

# node.js
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# lazygit configuration
export XDG_CONFIG_HOME="$HOME/.config"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    # mise
)
source $ZSH/oh-my-zsh.sh

# eza
alias ll="eza -l"
alias la="eza -la"

# bat
alias cat="bat"

# neovim
alias vi=nvim


# bun completions
[ -s "/Users/akito-ito/.bun/_bun" ] && source "/Users/akito-ito/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"

eval "$(~/.local/bin/mise activate zsh)"

# zoxide
eval "$(zoxide init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

bindkey -v

# miive develop
alias connect-dev-db="aws ssm start-session --target i-07b079032f51c31fc --profile miive-dev --document-name AWS-StartPortForwardingSession --parameters 'portNumber=3306,localPortNumber=13306'"

# miive develop
alias connect-stg-db="aws ssm start-session --target i-0f5e974a8ea7fa1bf --profile miive-stg --document-name AWS-StartPortForwardingSession --parameters 'portNumber=3306,localPortNumber=13305'"

# miive production
alias connect-prod-db="aws ssm start-session --target i-0b46b0329af150319 --profile miive-prod --document-name AWS-StartPortForwardingSession --parameters 'portNumber=3306,localPortNumber=13307'"

export CLAUDE_CODE_EFFORT_LEVEL=high
