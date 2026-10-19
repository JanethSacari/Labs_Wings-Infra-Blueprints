#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
LAB_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="${1:-$LAB_DIR/../docker-go-external-binary-assets}"

cd "$LAB_DIR"
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR="$(CDPATH= cd -- "$OUTPUT_DIR" && pwd)"
CGO_ENABLED=0 GOOS=linux go build \
  -trimpath \
  -ldflags="-s -w" \
  -o "$OUTPUT_DIR/runtime-helper" \
  ./tools/runtime-helper

printf 'Built external Linux binary: %s\n' "$OUTPUT_DIR/runtime-helper"
