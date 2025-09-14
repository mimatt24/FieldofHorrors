#!/usr/bin/env bash
set -u
DATE="${1:-$(date +%F)}"
DIR="FieldOfHorrors/history/raw_logs"
mkdir -p "$DIR"
FILE="$DIR/session_${DATE}.md"
if [ -f "$FILE" ]; then
  echo "File exists: $FILE"
else
  cat > "$FILE" <<EOF
# Session — ${DATE}
## Context
- 

## Transcript (verbatim)
- 

## Decisions / Outcomes
- 

## Follow-ups
- 
EOF
  echo "Created: $FILE"
fi
git add "$FILE"
