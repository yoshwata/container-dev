# Backlog

AI作業用の課題管理バックログです。実装メモ、調査結果、作業中データはこの `.ai/` 配下に置きます。

## 運用ルール

- 課題は `Todo`、`Doing`、`Done` のいずれかに置く
- 優先度は `P0`、`P1`、`P2`、`P3` を使う
- 着手時は `Doing` に移し、完了時は結果と確認方法を追記して `Done` に移す
- 一時ファイルや調査ログを置く場合は、課題IDが分かる名前にする

## 優先度

- `P0`: すぐ対応が必要な不具合やブロッカー
- `P1`: 近いうちに対応したい主要機能や重要改善
- `P2`: 余裕があれば対応したい改善
- `P3`: アイデア、調査、保留事項

## 一覧

### Todo 一覧

| ID | 優先度 | 種別 | タイトル |
| --- | --- | --- | --- |
| AI-002 | P2 | feature | anyenv-devへのCodex CLI追加 |
| AI-003 | P2 | feature | anyenv-devへのGitHub CLI追加 |

### Doing 一覧

なし

### Done 一覧

| ID | 優先度 | 種別 | タイトル |
| --- | --- | --- | --- |
| AI-001 | P1 | chore | バックログ運用の初期化 |

## Todo

### AI-002: anyenv-devへのCodex CLI追加

- 優先度: P2
- 種別: feature
- 概要: `anyenv-dev` コンテナでCodex CLIを利用できるようにする
- 背景: 現在の `anyenv-dev` イメージにはCodex CLIが含まれておらず、コンテナ内でCodexを使った開発作業ができない
- 完了条件:
  - `anyenv-dev` イメージにCodex CLIがインストールされている
  - `anyenv-dev` コンテナ内で `codex --version` を実行し、バージョンを確認できる
  - インストール方法と利用手順がドキュメントに記載されている
- メモ:
  - 対象: `images/anyenv-dev`

### AI-003: anyenv-devへのGitHub CLI追加

- 優先度: P2
- 種別: feature
- 概要: `anyenv-dev` コンテナでGitHub CLIを利用できるようにする
- 背景: 現在の `anyenv-dev` イメージには `gh` コマンドがなく、コンテナ内でGitHubの操作ができない
- 完了条件:
  - `anyenv-dev` イメージにGitHub CLIがインストールされている
  - `anyenv-dev` コンテナ内で `gh --version` を実行し、バージョンを確認できる
  - インストール方法と利用手順がドキュメントに記載されている
- メモ:
  - 対象: `images/anyenv-dev`

## Doing

なし

## Done

### AI-001: バックログ運用の初期化

- 優先度: P1
- 種別: chore
- 概要: AI作業用ディレクトリとバックログを用意し、今後の課題を管理できる状態にした
- 完了条件:
  - `.ai/` が存在する
  - `.ai/BACKLOG.md` が存在する
  - 課題テンプレートと運用ルールが記載されている
- 確認方法:
  - `ls .ai`

## 課題テンプレート

```markdown
### AI-XXX: タイトル

- 優先度: P2
- 種別: feature | bug | chore | docs | refactor | test | research
- 概要:
- 背景:
- 完了条件:
  -
- メモ:
  -
```
