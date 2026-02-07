---
allowed-tools: Bash(git checkout --branch:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(gh pr create:*)
description: Commit, push, and open a PR following Conventional Commits
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Conventional Commits ルール

コミットメッセージは以下のフォーマットに**必ず**従うこと：

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### type（必須）

変更内容に最も適したものを選択する：

| type | 用途 |
|------|------|
| `feat` | 新機能の追加 |
| `fix` | バグ修正 |
| `docs` | ドキュメントのみの変更 |
| `style` | コードの意味に影響しない変更（空白、フォーマット、セミコロン等） |
| `refactor` | バグ修正でも機能追加でもないコード変更 |
| `perf` | パフォーマンス改善 |
| `test` | テストの追加・修正 |
| `chore` | ビルドプロセスやツール、ライブラリの変更 |

### scope（任意）

変更対象のスコープを括弧内に記述する。例：`feat(auth):`, `fix(api):`

### description（必須）

- typeの直後にコロンとスペースを置き、簡潔な説明を記述
- 日本語で記述する
- 先頭を大文字にしない（日本語の場合は該当しない）
- 末尾にピリオドを付けない

### body（任意）

変更の動機や背景を補足する場合に記述する。

### BREAKING CHANGE

破壊的変更がある場合は、フッターに BREAKING CHANGE: <説明> を記述するか、type の後に ! を付ける。

## Your task

Based on the above changes:

1. Create a new branch if on main
2. Create a single commit with an appropriate message following the Conventional Commits format
3. Push the branch to origin
4. Create a pull request using `gh pr create`
5. You have the capability to call multiple tools in a single response. You MUST do all of the above in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
