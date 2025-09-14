#!/usr/bin/env bash
set -euo pipefail
fail(){ echo "❌ $*"; exit 1; }

# 1) classes.json sanity (ids, numeric ranges)
if [ -f FieldOfHorrors/data/classes/classes.json ]; then
  command -v jq >/dev/null || fail "jq missing"
  jq -e '
    type=="array" and length>=1 and
    all(.[]; has("id") and (.id|type=="string" and length>0) and
             has("spd") and (.spd|type=="number" and .>0 and .<20) and
             has("hp") and (.hp|type=="number" and .>0 and .<10000) and
             has("grit") and (.grit|type=="number" and .>=0 and .<1000) and
             has("armor") and (.armor|inside(["Light","Medium","Heavy"])))
  ' FieldOfHorrors/data/classes/classes.json >/dev/null || fail "classes.json schema/range check failed"
fi

# 2) docs exist
test -d FieldOfHorrors/docs || fail "docs/ missing"
echo "✅ validations passed"
