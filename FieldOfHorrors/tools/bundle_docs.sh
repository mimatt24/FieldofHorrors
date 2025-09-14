#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="FieldOfHorrors/docs"
OUT="$ROOT/_bundle/ALL_DOCS.md"
mkdir -p "$ROOT/_bundle"
echo "# Field Of Horrors — Documentation Bundle" > "$OUT"
echo "" >> "$OUT"
relpath() { python - "$ROOT" "$1" <<PY
import os,sys
root=os.path.abspath(sys.argv[1]); f=os.path.abspath(sys.argv[2])
print(os.path.relpath(f, root))
PY
}
IFS=$'\n'
for f in $(find "$ROOT" -type f \( -name "*.md" -o -name "*.mmd" \) ! -path "*/_bundle/*" | sort); do
  printf "\n---\n## %s\n\n" "$(relpath "$f")" >> "$OUT"
  cat "$f" >> "$OUT"
  printf "\n" >> "$OUT"
done
echo "Wrote $OUT"
