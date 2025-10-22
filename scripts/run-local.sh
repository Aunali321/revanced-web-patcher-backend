#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/bin" ]; then
  APP_DIR="$SCRIPT_DIR"
else
  APP_DIR="$(cd "$SCRIPT_DIR/../dist/local" && pwd)"
fi

DATA_DIR="${DATA_DIR:-$APP_DIR/data}"
mkdir -p "$DATA_DIR"

export PORT="${PORT:-3000}"

if [[ "$(uname -s)" == "Darwin" ]]; then
  AAPT2_PATH="${AAPT2_BINARY:-$APP_DIR/tools/aapt2-darwin}"
  if [ -f "$AAPT2_PATH" ]; then
    chmod +x "$AAPT2_PATH" 2>/dev/null || true
    export AAPT2_BINARY="$AAPT2_PATH"
  else
    echo "Warning: aapt2 for macOS not found at $AAPT2_PATH. Resource patches may fail." >&2
  fi
fi

cd "$APP_DIR"
exec "$APP_DIR/bin/web-patcher-service" "$@"
