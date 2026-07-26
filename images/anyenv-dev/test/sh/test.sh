#!/usr/bin/env bash

set -euo pipefail

image="${1:-yoshwata/anyenv-dev:noble}"

docker run --rm "$image" bash -lc 'codex --version'
docker run --rm "$image" bash -lc 'gh --version'
