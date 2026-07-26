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

なし

### Doing 一覧

なし

### Done 一覧

| ID | 優先度 | 種別 | タイトル |
| --- | --- | --- | --- |
| AI-003 | P2 | feature | anyenv-devへのGitHub CLI追加 |
| AI-002 | P2 | feature | anyenv-devへのCodex CLI追加 |
| AI-001 | P1 | chore | バックログ運用の初期化 |

## Todo

なし

## Doing

なし

## Done

### AI-003: anyenv-devへのGitHub CLI追加

- 優先度: P2
- 種別: feature
- 概要: `anyenv-dev` コンテナでGitHub CLIを利用できるようにした
- 背景: `anyenv-dev` イメージには `gh` コマンドがなく、コンテナ内でGitHubの操作ができなかった
- 完了条件:
  - `anyenv-dev` イメージにGitHub CLIがインストールされている
  - `anyenv-dev` コンテナ内で `gh --version` を実行し、バージョンを確認できる
  - インストール方法と利用手順がドキュメントに記載されている
- 実装メモ:
  - Ubuntuのパッケージから `gh` をインストール
  - `images/anyenv-dev/readme.md` に認証、トークン利用、認証情報の永続化方法を記載
  - `images/anyenv-dev/test/sh/test.sh` にバージョン確認を追加
- 確認方法:
  - `docker build -t container-dev-anyenv:test images/anyenv-dev`
  - `docker run --rm container-dev-anyenv:test bash -lc 'gh --version'`

### AI-002: anyenv-devへのCodex CLI追加

- 優先度: P2
- 種別: feature
- 概要: `anyenv-dev` コンテナでCodex CLIを利用できるようにした
- 背景: `anyenv-dev` イメージにはCodex CLIが含まれておらず、コンテナ内でCodexを使った開発作業ができなかった
- 完了条件:
  - `anyenv-dev` イメージにCodex CLIがインストールされている
  - `anyenv-dev` コンテナ内で `codex --version` を実行し、バージョンを確認できる
  - インストール方法と利用手順がドキュメントに記載されている
- 実装メモ:
  - nodenvで管理しているNode.jsへ `npm install --global @openai/codex` でインストール
  - nodenvのshimをPATHへ明示し、非対話シェルからも `codex` を実行可能にした
  - `images/anyenv-dev/readme.md` に認証、APIキー利用、認証情報の永続化方法を記載
  - `images/anyenv-dev/test/sh/test.sh` にバージョン確認を追加
- 確認方法:
  - `docker build -t container-dev-anyenv:test images/anyenv-dev`
  - `docker run --rm container-dev-anyenv:test bash -lc 'codex --version'`

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
