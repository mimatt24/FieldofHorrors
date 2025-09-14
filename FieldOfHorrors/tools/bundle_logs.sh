#!/usr/bin/env bash
set -euo pipefail
mkdir -p history/_bundle history/raw_logs
OUT="history/_bundle/ALL_LOGS.md"
echo "# Field Of Horrors — All Logs Bundle" > "$OUT"
echo "" >> "$OUT"
# Include any markdown sessions and cap size if needed later
for f in $(ls -1t history/raw_logs/session_*.md 2>/dev/null || true); do
  echo -e "\n---\n## $(basename "$f")\n" >> "$OUT"
  cat "$f" >> "$OUT"
  printf "\n" >> "$OUT"
done
echo "Wrote $OUT"
