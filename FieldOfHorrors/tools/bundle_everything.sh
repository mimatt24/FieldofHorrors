#!/usr/bin/env bash
set -Eeuo pipefail

# Output
OUT="_bundle/ALL_TEXT_SNAPSHOT.md"
mkdir -p "_bundle"

# Size caps (to keep ChatGPT uploads sane)
MAX_FILE_BYTES=$((200 * 1024))   # 200 KB per file
MAX_TOTAL_BYTES=$((6 * 1024 * 1024)) # 6 MB overall cap

# Exclusions (dirs + binary extensions)
EXCLUDE_DIRS='(^|/)(\.git|\.github|node_modules|dist|build|bin|obj|\.venv|\.mypy_cache|__pycache__|\.idea|\.vscode|target|coverage)(/|$)'
BIN_EXT='\.(png|jpg|jpeg|gif|bmp|ico|webp|svgz|pdf|zip|tar|tgz|gz|bz2|xz|7z|rar|exe|dll|dylib|so|bin|class|jar|war|apk|aab|o|a|pyc|pyo|wasm)$'

# Start fresh
{
  echo "# Field Of Horrors — All Text Snapshot"
  echo
  echo "> Auto-generated view of repo text files (safely filtered)."
  echo "> Per-file cap: $((MAX_FILE_BYTES/1024)) KB • Total cap: $((MAX_TOTAL_BYTES/1024/1024)) MB"
} > "$OUT"

total=0
# Use git ls-files when available to respect .gitignore; fallback to find
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  MAPFILE=()
  while IFS= read -r f; do MAPFILE+=("$f"); done < <(git ls-files)
else
  mapfile -t MAPFILE < <(find . -type f -print)
fi

for f in "${MAPFILE[@]}"; do
  # Skip excluded dirs
  if [[ "$f" =~ $EXCLUDE_DIRS ]]; then
    continue
  fi
  # Skip bundle outputs themselves
  if [[ "$f" == _bundle/* || "$f" == FieldOfHorrors/docs/_bundle/* || "$f" == history/_bundle/* ]]; then
    continue
  fi
  # Skip obvious binaries by extension
  if [[ "$f" =~ $BIN_EXT ]]; then
    continue
  fi
  # Must be a regular file
  [[ -f "$f" ]] || continue

  # Quick binary sniff (portable): grep -Iq fails on binary
  if ! grep -Iq . "$f" 2>/dev/null; then
    continue
  fi

  sz=$(wc -c <"$f" | tr -d ' ')
  # Per-file cap
  if (( sz > MAX_FILE_BYTES )); then
    printf "\n---\n## %s (skipped: %d bytes > %d byte cap)\n\n" "$f" "$sz" "$MAX_FILE_BYTES" >> "$OUT"
    continue
  fi

  # Total cap guard
  if (( total + sz > MAX_TOTAL_BYTES )); then
    echo -e "\n---\n**[Truncated] Total size cap reached.**" >> "$OUT"
    break
  fi

  printf "\n---\n## %s\n\n" "$f" >> "$OUT"
  # Fence with inferred language where sensible
  ext="${f##*.}"
  case "$ext" in
    md|mmd|mdx) lang="markdown" ;;
    sh|bash)    lang="bash" ;;
    yml|yaml)   lang="yaml" ;;
    json)       lang="json" ;;
    js|cjs|mjs) lang="javascript" ;;
    ts|tsx)     lang="typescript" ;;
    py)         lang="python" ;;
    html|htm)   lang="html" ;;
    css|scss)   lang="css" ;;
    toml)       lang="toml" ;;
    ini|cfg|conf|env) lang="" ;;
    go)         lang="go" ;;
    rs)         lang="rust" ;;
    c)          lang="c" ;;
    cpp|cc|cxx|hpp|h) lang="cpp" ;;
    java|kt|swift|rb|php|lua|sql) lang="$ext" ;;
    *)          lang="" ;;
  esac
  if [[ -n "$lang" ]]; then
    echo "\`\`\`$lang" >> "$OUT"
  else
    echo "\`\`\`" >> "$OUT"
  fi
  cat "$f" >> "$OUT"
  echo -e "\n\`\`\`" >> "$OUT"

  total=$(( total + sz ))
done

echo "Wrote $OUT (approx $((total/1024)) KB)"
