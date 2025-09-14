#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
latest_meta="$(ls -1t history/raw_logs/session_*.meta 2>/dev/null | head -n1 || true)"
[ -z "$latest_meta" ] && { echo "No .meta found. Did you run start_session.sh?"; exit 1; }

base="${latest_meta%.meta}"
RAW="${base}.log"
MD="${base}.md"

[ -f "$RAW" ] || { echo "Missing raw log: $RAW"; exit 1; }

# Convert to Markdown with fenced code (lightweight, no deps)
{
  echo "# FOH Git Bash Session"
  echo ""
  echo "- **File:** $(basename "$RAW")"
  echo "- **Started:** $(grep '^started_at=' "$latest_meta" | cut -d= -f2-)"
  echo "- **Ended:** $(date -Is)"
  echo ""
  echo "## Transcript"
  echo ""
  echo '```text'
  cat "$RAW"
  echo '```'
} > "$MD"

# Update chat archive index (append newest at top)
ARCH="history/chat_archive.md"
TMP="$(mktemp)"
{
  echo "# FOH Chat & Shell Archive"
  echo ""
  echo "## Sessions (newest first)"
  echo ""
  echo "- $(date +%Y-%m-%d) — [$(basename "$MD")]($MD)  • raw: [$(basename "$RAW")]($RAW)"
  if [ -f "$ARCH" ]; then
    # Skip duplicate header lines when appending
    grep -v -E '^(# FOH Chat & Shell Archive|## Sessions)' "$ARCH" || true
  fi
} > "$TMP"
mv "$TMP" "$ARCH"

# Rebuild logs bundle
mkdir -p history/_bundle
OUT="history/_bundle/ALL_LOGS.md"
{
  echo "# Field Of Horrors — All Logs Bundle"
  echo ""
  for f in $(ls -1t history/raw_logs/session_*.md 2>/dev/null); do
    echo -e "\n---\n## $(basename "$f")\n"
    cat "$f"
    echo ""
  done
} > "$OUT"

echo "Updated:"
echo " - $MD"
echo " - $ARCH"
echo " - $OUT"
