#!/bin/bash
# Claude Code プラグインの再インストール
plugins=(
  context7 sentry code-review commit-commands
  gopls-lsp lua-lsp typescript-lsp
  feature-dev security-guidance
  Notion slack example-skills
)
for p in "${plugins[@]}"; do
  echo "Installing $p..."
  claude plugin install "$p" 2>/dev/null || echo "  → skipped ($p)"
done
