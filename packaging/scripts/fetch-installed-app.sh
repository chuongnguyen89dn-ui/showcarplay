#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PAYLOAD="$ROOT/payload/Applications"

IPAD_HOST="${IPAD_HOST:-localhost}"
IPAD_PORT="${IPAD_PORT:-2222}"
IPAD_USER="${IPAD_USER:-root}"
IPAD_PASS="${IPAD_PASS:-alpine}"
REMOTE_APP="${REMOTE_APP:-/Applications/Showcase.app}"

SSH_OPTS=(
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/dev/null
  -p "$IPAD_PORT"
)

SCP_OPTS=(
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/dev/null
  -P "$IPAD_PORT"
  -rp
)

mkdir -p "$PAYLOAD"
rm -rf "$PAYLOAD/Showcase.app"

sshpass -p "$IPAD_PASS" ssh "${SSH_OPTS[@]}" "$IPAD_USER@$IPAD_HOST" \
  "test -d '$REMOTE_APP' && test -x '$REMOTE_APP/Showcase' && test -x '$REMOTE_APP/carplay_bt' && test -x '$REMOTE_APP/carplay_services'"

sshpass -p "$IPAD_PASS" scp "${SCP_OPTS[@]}" \
  "$IPAD_USER@$IPAD_HOST:$REMOTE_APP" \
  "$PAYLOAD/"

find "$PAYLOAD/Showcase.app" -name '.DS_Store' -delete

echo "Fetched signed app payload into $PAYLOAD/Showcase.app"
