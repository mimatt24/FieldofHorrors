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
             has("armor") and (.armor as $a | ["Light","Medium","Heavy"] | index($a) != null))
  ' FieldOfHorrors/data/classes/classes.json >/dev/null || fail "classes.json schema/range check failed"
fi

# 2) the slice's Pitcher stats match classes.json
TUNING=FieldOfHorrors/game/data/tuning.json
if [ -f "$TUNING" ] && [ -f FieldOfHorrors/data/classes/classes.json ]; then
  want=$(jq -c '.[] | select(.id=="pitcher") | [.spd,.hp,.grit]' FieldOfHorrors/data/classes/classes.json)
  have=$(jq -c '.player | [.spd,.hp,.grit]' "$TUNING")
  [ "$want" = "$have" ] || fail "tuning.json player stats $have do not match classes.json pitcher $want"
fi

# 3) docs exist
test -d FieldOfHorrors/docs || fail "docs/ missing"
echo "✅ validations passed"
