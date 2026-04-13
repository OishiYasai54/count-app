#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -f .env ]; then
    echo "Error: .env が見つかりません。"
    echo "  cp .env.example .env && vi .env"
    exit 1
fi

echo "==> git pull"
git pull

echo "==> docker compose build"
docker compose build --no-cache

echo "==> docker compose up"
docker compose up -d

echo "==> Done."
