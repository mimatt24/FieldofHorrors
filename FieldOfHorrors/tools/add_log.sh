#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: tools/add_log.sh <YYYY-MM-DD> <USER|ASSISTANT>"
  exit 1
fi

DATE="$1"
ROLE="$2"
FILE="history/raw_logs/session_${DATE}.md"

if [ ! -f "$FILE" ]; then
  mkdir -p history/raw_logs
  cat > "$FILE" <<EOF2
# Session ${DATE} – Field of Horrors (Raw Log)

## Context / Goal
- (initially empty)

---

## Log
EOF2
fi

echo -e "\n---\n\n### ${ROLE}\n" >> "$FILE"
echo "(paste here, then save/commit)" >> "$FILE"
echo "Appended to $FILE"
