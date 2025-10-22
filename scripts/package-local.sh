#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist/local"

cd "$ROOT_DIR"
./gradlew --no-daemon installDist

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

cp -R "$ROOT_DIR/build/install/web-patcher-service"/. "$DIST_DIR"/

cp "$ROOT_DIR/scripts/run-local.sh" "$DIST_DIR/run-local.sh"
cp "$ROOT_DIR/scripts/run-local.bat" "$DIST_DIR/run-local.bat"
chmod +x "$DIST_DIR/run-local.sh" "$DIST_DIR/bin/web-patcher-service"

if [ -d "$ROOT_DIR/scripts/tools" ]; then
  cp -R "$ROOT_DIR/scripts/tools" "$DIST_DIR/tools"
  chmod -R +x "$DIST_DIR/tools"
fi

echo "Local distribution ready at $DIST_DIR"
