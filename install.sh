#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ---------------------------------------------------------------------------
# ヘルパー関数
# ---------------------------------------------------------------------------
info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$1"; }
ok()   { printf '\033[1;32m[OK]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$1"; }

link_file() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    ok "already linked: $dst"
    return
  fi
  ln -sf "$src" "$dst"
  ok "linked: $dst -> $src"
}

link_dir() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    ok "already linked: $dst"
    return
  fi
  if [ -d "$dst" ] && [ ! -L "$dst" ]; then
    local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
    warn "backing up existing directory: $dst -> $backup"
    mv "$dst" "$backup"
  fi
  ln -sfn "$src" "$dst"
  ok "linked: $dst -> $src"
}

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
setup_homebrew() {
  info "Homebrew をセットアップ中..."
  if command -v brew &>/dev/null; then
    ok "Homebrew は既にインストール済み"
  else
    info "Homebrew をインストール中..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon の場合 PATH を通す
    if [ -f /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    ok "Homebrew をインストールしました"
  fi
}

# ---------------------------------------------------------------------------
# 2. Homebrew パッケージ
# ---------------------------------------------------------------------------
setup_brew_packages() {
  info "Homebrew パッケージをインストール中..."

  local casks=(wezterm font-fira-code-nerd-font docker)
  local formulae=(neovim mise)

  for cask in "${casks[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
      ok "already installed (cask): $cask"
    else
      info "installing cask: $cask"
      brew install --cask "$cask"
    fi
  done

  for formula in "${formulae[@]}"; do
    if brew list "$formula" &>/dev/null; then
      ok "already installed: $formula"
    else
      info "installing: $formula"
      brew install "$formula"
    fi
  done
}

# ---------------------------------------------------------------------------
# 3. oh-my-zsh + プラグイン
# ---------------------------------------------------------------------------
setup_ohmyzsh() {
  info "oh-my-zsh をセットアップ中..."

  if [ -d "$HOME/.oh-my-zsh" ]; then
    ok "oh-my-zsh は既にインストール済み"
  else
    info "oh-my-zsh をインストール中..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "oh-my-zsh をインストールしました"
  fi

  local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  local plugins=(
    "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting"
  )

  for entry in "${plugins[@]}"; do
    local name="${entry%% *}"
    local url="${entry#* }"
    local dest="$ZSH_CUSTOM/plugins/$name"
    if [ -d "$dest" ]; then
      ok "already installed: $name"
    else
      info "installing: $name"
      git clone "$url" "$dest"
      ok "installed: $name"
    fi
  done
}

# ---------------------------------------------------------------------------
# 4. mise
# ---------------------------------------------------------------------------
setup_mise() {
  info "mise でツール群をインストール中..."
  if ! command -v mise &>/dev/null; then
    warn "mise が見つかりません。Homebrew パッケージのインストールを確認してください"
    return 1
  fi
  mise install -y
  ok "mise ツール群をインストールしました"
}

# ---------------------------------------------------------------------------
# 5. シンボリックリンク
# ---------------------------------------------------------------------------
setup_symlinks() {
  info "シンボリックリンクを作成中..."

  mkdir -p "$HOME/.config"

  # ファイル
  link_file "$DOTFILES_DIR/.zshrc"              "$HOME/.zshrc"
  link_file "$DOTFILES_DIR/.wezterm.lua"         "$HOME/.wezterm.lua"
  link_file "$DOTFILES_DIR/.luarc.json"          "$HOME/.luarc.json"
  link_file "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

  # ディレクトリ
  link_dir "$DOTFILES_DIR/.config/nvim"     "$HOME/.config/nvim"
  link_dir "$DOTFILES_DIR/.config/lazygit"  "$HOME/.config/lazygit"
  link_dir "$DOTFILES_DIR/.config/mise"     "$HOME/.config/mise"
}

# ---------------------------------------------------------------------------
# 6. Claude Code セットアップ
# ---------------------------------------------------------------------------
setup_claude() {
  info "Claude Code をセットアップ中..."

  local claude_home="$HOME/.claude"
  local claude_src="$DOTFILES_DIR/.claude-home"

  mkdir -p "$claude_home/hooks"

  # ファイル
  link_file "$claude_src/settings.json" "$claude_home/settings.json"

  # ディレクトリ
  link_dir "$claude_src/commands" "$claude_home/commands"
  link_dir "$claude_src/skills"   "$claude_home/skills"

  # hooks（debug.log と共存するためスクリプト単位）
  link_file "$claude_src/hooks/notify.sh" "$claude_home/hooks/notify.sh"

  # プラグインインストール（--no-plugins でスキップ可能）
  if [[ "${1:-}" != "--no-plugins" ]]; then
    if [ -x "$claude_src/setup-plugins.sh" ]; then
      "$claude_src/setup-plugins.sh"
    fi
  else
    info "プラグインインストールをスキップしました (--no-plugins)"
  fi
}

# ---------------------------------------------------------------------------
# メイン
# ---------------------------------------------------------------------------
main() {
  info "dotfiles セットアップを開始します..."
  echo ""

  setup_homebrew
  setup_brew_packages
  setup_ohmyzsh
  setup_mise
  setup_symlinks
  setup_claude "$@"

  echo ""
  ok "セットアップ完了！"
}

main "$@"
