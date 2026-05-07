# 作業フロー規約

実装タスクに取り掛かる前に、必ず以下の2ステップを順守すること。

## ステップ1: 現状調査

実装を始める前に、関連するコードベースを**詳細かつ注意深く**調査する。

- 対象ファイル、関連コンポーネント、依存関係、データフロー、既存パターンを徹底的に読み解く
- 影響範囲を正確に把握する（直接変更するファイルだけでなく、間接的に影響を受ける箇所も含む）
- 既存の型定義、テスト、マイグレーションなど関連リソースも確認する
- 調査結果をプロジェクトルートにマークダウンファイルとしてまとめる

## ステップ2: 実装計画の作成

調査結果を元に、実装計画をプロジェクトルートにマークダウンファイルとして作成する。

- 計画には以下を含めること:
  - 変更対象ファイルの一覧と各ファイルの変更概要
  - 具体的なコードスニペット（新規追加・変更するコードの実例）
  - 実装手順（ステップバイステップ）
  - 影響範囲と考慮事項
- コードスニペットは省略せず、実際に書くコードに近い形で記載する

## 利用するスキル

会話開始時、および各タスクに着手する前に、以下のスキルセットを必ず参照・適用すること。

### 共通: superpowers

- すべての会話・タスクで `superpowers` スキルセットを利用する
- 特に以下のスキルは適用条件に合致した時点で **必ず** 起動する
  - `superpowers:brainstorming` — 新機能・新コンポーネント・新規実装の前
  - `superpowers:writing-plans` — マルチステップな仕様・要件がある場合
  - `superpowers:executing-plans` / `superpowers:subagent-driven-development` — 計画を実行に移すとき
  - `superpowers:test-driven-development` — 機能実装・バグ修正のコード着手前
  - `superpowers:systematic-debugging` — バグ・テスト失敗・予期せぬ挙動に遭遇したとき
  - `superpowers:verification-before-completion` — 完了・修正済みと宣言する前
- スキルが適用されうる可能性が **1% でもある** 場合は必ず Skill ツールで起動する。「自明だから不要」「今回は軽いタスクだから」と省略しない。

### Golang プロジェクト: cc-skills-golang

プロジェクトルートに `go.mod` または任意の `*.go` ファイルが存在する場合、そのプロジェクトを Go プロジェクトとみなし、上記 superpowers に **加えて** `cc-skills-golang`（`samber` マーケットプレイス）配下のスキルを必ず利用する。

- 代表的なスキルと適用タイミング:
  - `golang-code-style` / `golang-naming` / `golang-modernize` — コード新規作成・編集時
  - `golang-error-handling` — エラー処理を追加・変更するとき
  - `golang-testing` / `golang-stretchr-testify` — テスト追加・修正時
  - `golang-concurrency` / `golang-context` — goroutine / `context.Context` を扱うとき
  - `golang-database` — DB アクセス層を変更するとき
  - `golang-performance` / `golang-benchmark` — パフォーマンス改善・計測時
  - `golang-security` / `golang-safety` — 認証・認可・入力検証など安全性に関わる変更時
  - `golang-design-patterns` / `golang-structs-interfaces` / `golang-dependency-injection` — 設計判断時
- 上記以外にも `cc-skills-golang` 配下に該当スキルがある場合は同様に参照する。
- `cc-skills-golang` プラグインが未有効の場合はユーザーに有効化を促す（`/plugin install cc-skills-golang@samber`）。

## ブランチ命名規約

新しい git ブランチを作成するときは、worktree であっても通常のブランチであっても、**必ず**以下のいずれかのプリフィックスを付けること。

- `feature/` — 新機能の追加
- `bugfix/` または `fix/` — バグ修正
- `refactor/` — 振る舞いを変えないリファクタ
- `chore/` — 雑務・設定・依存関係更新など
- `docs/` — ドキュメントのみの変更
- `test/` — テストのみの追加・修正

ルール:

- `git worktree add -b <name> ...` / `git checkout -b <name>` / `git switch -c <name>` のいずれでも、`<name>` にはプリフィックスを必ず含める（例: `feature/add-login`）
- プリフィックスなしのブランチ名（例: `add-foo`、`tmp-work`）は作成しない
- タスク種別が判別しづらい場合はユーザーに確認する
- ユーザーが明示的にプリフィックスなしのブランチ名を指示した場合のみ、その指示に従う

## 重要

- 調査と計画のステップを飛ばして実装に入ってはならない
- ユーザーが明示的に「調査不要」「計画不要」と指示した場合のみ、該当ステップを省略できる
- superpowers / cc-skills-golang のスキル起動は、ユーザー指示・CLAUDE.md・本ルールの優先順位を超えない範囲で行う（ユーザー指示が常に最優先）
- スキル利用を理由に「ステップ1: 現状調査」「ステップ2: 実装計画の作成」を省略してはならない
