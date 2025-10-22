#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-dev}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
LOCAL_DIR="$DIST_DIR/local"
RELEASE_DIR="$DIST_DIR/release"

chmod +x "$ROOT_DIR/scripts/run-local.sh"
chmod +x "$ROOT_DIR/scripts/package-local.sh"

"$ROOT_DIR/scripts/package-local.sh"

rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

ARCHIVE_DIR="$RELEASE_DIR/revanced-web-patcher-$VERSION"
cp -R "$LOCAL_DIR" "$ARCHIVE_DIR"

pushd "$RELEASE_DIR" > /dev/null
zip -rq "revanced-web-patcher-$VERSION.zip" "revanced-web-patcher-$VERSION"
popd > /dev/null

rm -rf "$ARCHIVE_DIR"

echo "Release artifact ready: $RELEASE_DIR/revanced-web-patcher-$VERSION.zip"
