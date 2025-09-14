#!/usr/bin/env bash
set -Eeuo pipefail
OUT="_bundle/ALL_TEXT_SNAPSHOT.md"
mkdir -p "_bundle"
MAX_FILE_BYTES=$((200*1024))
MAX_TOTAL_BYTES=$((6*1024*1024))
EXCLUDE_DIRS='(^|/)(\.git|\.github|node_modules|dist|build|bin|obj|\.venv|__pycache__|\.idea|\.vscode|target|coverage)(/|$)'
BIN_EXT='\.(png|jpg|jpeg|gif|bmp|ico|webp|svgz|pdf|zip|tar|tgz|gz|bz2|xz|7z|rar|exe|dll|dylib|so|bin|class|jar|war|apk|aab|o|a|pyc|pyo|wasm)$'
{
  echo "# Field Of Horrors — All Text Snapshot"
  echo
  echo "> Per-file cap: $((MAX_FILE_BYTES/1024)) KB • Total cap: $((MAX_TOTAL_BYTES/1024/1024)) MB"
} > "$OUT"
total=0
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then mapfile -t FILES < <(git ls-files); else mapfile -t FILES < <(find . -type f -print); fi
for f in "${FILES[@]}"; do
  [[ -f "$f" ]] || continue
  [[ "$f" =~ $EXCLUDE_DIRS ]] && continue
  [[ "$f" == _bundle/* || "$f" == FieldOfHorrors/docs/_bundle/* || "$f" == history/_bundle/* ]] && continue
  [[ "$f" =~ $BIN_EXT ]] && continue
  if ! grep -Iq . "$f" 2>/dev/null; then continue; fi
  sz=$(wc -c <"$f" | tr -d ' ')
  (( sz > MAX_FILE_BYTES )) && { printf "\n---\n## %s (skipped: %d bytes > cap)\n\n" "$f" "$sz" >> "$OUT"; continue; }
  (( total + sz > MAX_TOTAL_BYTES )) && { echo -e "\n---\n**[Truncated] Total size cap reached.**" >> "$OUT"; break; }
  printf "\n---\n## %s\n\n" "$f" >> "$OUT"
  ext="${f##*.}"; case "$ext" in md|mmd|mdx) lang=markdown;; sh|bash) lang=bash;; yml|yaml) lang=yaml;; json) lang=json;; js|cjs|mjs) lang=javascript;; ts|tsx) lang=typescript;; py) lang=python;; html|htm) lang=html;; css|scss) lang=css;; toml) lang=toml;; ini|cfg|conf|env) lang=;; go) lang=go;; rs) lang=rust;; c) lang=c;; cpp|cc|cxx|hpp|h) lang=cpp;; java|kt|swift|rb|php|lua|sql) lang="$ext";; *) lang=;; esac
  [[ -n "$lang" ]] && echo "\`\`\`$lang" >> "$OUT" || echo "\`\`\`" >> "$OUT"
  cat "$f" >> "$OUT"; echo -e "\n\`\`\`" >> "$OUT"
  total=$(( total + sz ))
done
echo "Wrote $OUT (~$((total/1024)) KB)"
