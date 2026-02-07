#!/bin/bash
# ~/.claude/ 配下にシンボリックリンクを作成
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="$HOME/.claude"

# ディレクトリ確保
mkdir -p "$CLAUDE_HOME/hooks"

# ファイル単位でシンボリックリンク
ln -sf "$SCRIPT_DIR/settings.json" "$CLAUDE_HOME/settings.json"

# ディレクトリ単位でシンボリックリンク（既存ディレクトリがある場合は削除してから作成）
for dir in commands skills; do
  if [ -d "$CLAUDE_HOME/$dir" ] && [ ! -L "$CLAUDE_HOME/$dir" ]; then
    rm -rf "$CLAUDE_HOME/$dir"
  fi
  ln -sfn "$SCRIPT_DIR/$dir" "$CLAUDE_HOME/$dir"
done

# hooks はスクリプト単位（debug.log と共存するため）
ln -sf "$SCRIPT_DIR/hooks/notify.sh" "$CLAUDE_HOME/hooks/notify.sh"

echo "Done: symlinks created in $CLAUDE_HOME"
