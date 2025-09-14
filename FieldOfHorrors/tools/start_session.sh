#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
mkdir -p history/raw_logs history/_bundle

STAMP="$(date +%Y-%m-%d_%H%M%S)"
RAW="history/raw_logs/session_${STAMP}.log"
MD="history/raw_logs/session_${STAMP}.md"
META="history/raw_logs/session_${STAMP}.meta"
echo "started_at=$(date -Is)" > "$META"

echo "[FOH] Logging to: $RAW"
# Prefer util-linux 'script' if available (captures full TTY IO)
if command -v script >/dev/null 2>&1; then
  # Windows Git Bash often needs winpty for proper TTY
  if command -v winpty >/dev/null 2>&1; then
    winpty script -q -a "$RAW"
  else
    script -q -a "$RAW"
  fi
else
  # Fallback: simple tee of a subshell (captures output, not keystrokes)
  echo "[FOH] 'script' not found. Using fallback logger."
  bash -i |& tee -a "$RAW"
fi

# On normal exit, leave a marker
echo "ended_at=$(date -Is)" >> "$META"
