#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEB="${1:-}"
REMOTE_BASE="${REMOTE_BASE:-/tmp/showcase-deb-inspect}"

IPAD_HOST="${IPAD_HOST:-localhost}"
IPAD_PORT="${IPAD_PORT:-2222}"
IPAD_USER="${IPAD_USER:-root}"
IPAD_PASS="${IPAD_PASS:-alpine}"

if [ -z "$DEB" ]; then
  DEB="$(find "$ROOT/build" -maxdepth 1 -name '*.deb' | sort | tail -1)"
fi

if [ ! -f "$DEB" ]; then
  echo "Usage: $0 path/to/package.deb"
  exit 1
fi

SSH_OPTS=(
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/dev/null
  -p "$IPAD_PORT"
)

SCP_OPTS=(
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/dev/null
  -P "$IPAD_PORT"
)

NAME="$(basename "$DEB")"

sshpass -p "$IPAD_PASS" ssh "${SSH_OPTS[@]}" "$IPAD_USER@$IPAD_HOST" \
  "rm -rf '$REMOTE_BASE' && mkdir -p '$REMOTE_BASE'"
sshpass -p "$IPAD_PASS" scp "${SCP_OPTS[@]}" "$DEB" "$IPAD_USER@$IPAD_HOST:$REMOTE_BASE/$NAME"

sshpass -p "$IPAD_PASS" ssh "${SSH_OPTS[@]}" "$IPAD_USER@$IPAD_HOST" "
set -e
dpkg-deb -I '$REMOTE_BASE/$NAME'
echo
dpkg-deb -c '$REMOTE_BASE/$NAME'
"
