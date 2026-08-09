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
| AI-005 | P2 | feature | anyenv-devでnpmのmin-release-ageを初期設定 |
| AI-004 | P1 | bug | Codex sandbox向けuser namespaceの有効化 |

### Doing 一覧

なし

### Done 一覧

| ID | 優先度 | 種別 | タイトル |
| --- | --- | --- | --- |
| AI-003 | P2 | feature | anyenv-devへのGitHub CLI追加 |
| AI-002 | P2 | feature | anyenv-devへのCodex CLI追加 |
| AI-001 | P1 | chore | バックログ運用の初期化 |

## Todo

### AI-005: anyenv-devでnpmのmin-release-ageを初期設定

- 優先度: P2
- 種別: feature
- 概要: `anyenv-dev` コンテナで、npmパッケージ公開直後のバージョンをインストール対象から除外する `min-release-age` を最初から有効にする
- 背景: npmパッケージのサプライチェーン攻撃対策として、公開直後のバージョンを自動的に取得するリスクを減らしたい。コンテナ作成後に利用者が個別設定しなくても既定で適用される状態にする
- 完了条件:
  - `anyenv-dev` イメージ内のnpmで `min-release-age` が既定値として設定されている
  - 設定値と設定箇所が明示され、新規作成したコンテナと通常ユーザーのシェルで有効になる
  - 利用者がプロジェクトまたはユーザー単位の設定で上書きできる
  - 設定の目的、既定値、確認方法、必要に応じた変更・無効化方法が `images/anyenv-dev/readme.md` に記載されている
  - イメージのテストで `npm config get min-release-age` の値を検証している
- メモ:
  - npmの対応バージョンを確認し、`anyenv-dev` で導入されるnpmとの互換性を担保する
  - 既定の待機期間は実装時に決定し、Dockerfileや設定ファイル内で意図が分かるようにする
- 確認方法:
  - `docker build -t container-dev-anyenv:test images/anyenv-dev`
  - `docker run --rm container-dev-anyenv:test bash -lc 'npm config get min-release-age'`

### AI-004: Codex sandbox向けuser namespaceの有効化

- 優先度: P1
- 種別: bug
- 概要: `container-dev` 内でCodexがBubblewrapによるsandboxを起動できるようにする
- 背景: Codexから通常のコマンドを実行すると `bwrap: No permissions to create a new namespace` で失敗し、読み取りを含むワークスペース内操作にも隔離外実行の承認が頻繁に必要になる。`user.max_user_namespaces = 63436` である一方、`unshare --user --map-root-user true` は `Operation not permitted` となるため、上位コンテナのseccompまたは同等の実行制限が原因と考えられる
- 完了条件:
  - `container-dev` 内で `unshare --user --map-root-user true` が成功する
  - CodexからBubblewrap sandbox内で通常の読み取り・書き込みコマンドを実行できる
  - namespace作成に必要な権限だけを許可し、不要に `--privileged` を常用しない
  - Docker Composeおよび関連する起動方法へ必要な設定が反映されている
  - 制約、セキュリティ上のトレードオフ、確認手順がREADMEへ記載されている
- メモ:
  - `kernel.unprivileged_userns_clone` と `kernel.apparmor_restrict_unprivileged_userns` はこの環境には存在しなかった
  - `security_opt: [seccomp=unconfined]` で原因を切り分け、可能なら必要なシステムコールだけを許可するseccompプロファイルを採用する
  - ホストまたは上位コンテナ側の制限である場合、コンテナ内部のsysctl変更だけでは解消しない
- 確認方法:
  - `cat /proc/sys/user/max_user_namespaces`
  - `unshare --user --map-root-user true`
  - Codexからsandbox内で `rg --files` などの読み取りコマンドを実行する

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
