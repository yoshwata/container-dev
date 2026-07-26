# anyenv-dev

anyenvでNode.jsとGoの実行環境を管理する開発用イメージです。Codex CLIとGitHub CLIもインストールされています。

## ビルド

リポジトリのルートから実行します。

```bash
docker build -t yoshwata/anyenv-dev:noble images/anyenv-dev
```

## バージョン確認

```bash
docker run --rm yoshwata/anyenv-dev:noble bash -lc \
  'codex --version && gh --version'
```

## Codex CLI

コンテナ内でCodexを起動し、画面の案内に従って認証します。

```bash
codex
```

APIキーを使う場合は、コンテナ起動時に環境変数として渡します。

```bash
docker run --rm -it \
  -e OPENAI_API_KEY \
  -v "$PWD:/workspace" \
  -w /workspace \
  yoshwata/anyenv-dev:noble \
  codex
```

Codex CLIは、nodenvで管理しているNode.jsへ `npm install --global @openai/codex` でインストールしています。

## GitHub CLI

コンテナ内で認証してから利用します。

```bash
gh auth login --web
gh auth status
```

トークンを環境変数で渡す場合は、`GH_TOKEN` を設定します。

```bash
docker run --rm -it \
  -e GH_TOKEN \
  -v "$PWD:/workspace" \
  -w /workspace \
  yoshwata/anyenv-dev:noble \
  gh auth status
```

認証情報をコンテナの再作成後も保持したい場合は、`$HOME/.codex` と `$HOME/.config/gh` をボリュームへ保存してください。秘密情報や認証情報はイメージへ含めないでください。
