#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
LAB_DIR="$(dirname "$SCRIPT_DIR")"

mkdir -p "$LAB_DIR/binaries"
CGO_ENABLED=0 GOOS=linux go build \
  -trimpath \
  -ldflags="-s -w" \
  -o "$LAB_DIR/binaries/server" \
  "$LAB_DIR/src"

printf 'Built Linux binary: %s\n' "$LAB_DIR/binaries/server"
