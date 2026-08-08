#!/usr/bin/env bash
# Verifies the repo's three invariants:
#   1. resume-overhaul's bundled stage files match the skills they were copied from
#   2. the overhaul bundle actually contains every specialist's output spec
#   3. dist/*.skill contents match the skills under plugins/
# Content-level, never byte-level: zips bake in mtimes, so a binary diff of
# dist/ false-positives on every run.
set -uo pipefail
cd "$(dirname "$0")"

SKILLS=plugins/shortlist/skills
STAGES=$SKILLS/resume-overhaul/stages
SPECIALISTS=(resume-diagnoser resume-recruiter resume-rewriter resume-hiring-manager)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
fail=0

note() { printf '  %s\n' "$1"; }
bad() { printf '  FAIL: %s\n' "$1"; fail=1; }

echo "1. Bundled stage files in sync with their source skills"
for s in "${SPECIALISTS[@]}"; do
  if [ ! -f "$STAGES/$s.md" ]; then
    bad "missing $STAGES/$s.md — run ./build.sh"
    continue
  fi
  # Same transform build.sh applies: drop the YAML frontmatter.
  awk 'BEGIN{fm=0} /^---$/ && fm<2 {fm++; next} fm>=2{print}' "$SKILLS/$s/SKILL.md" > "$TMP/$s.md"
  if diff -q "$TMP/$s.md" "$STAGES/$s.md" >/dev/null; then
    note "ok  $s"
  else
    bad "$STAGES/$s.md is stale — run ./build.sh"
  fi
done

echo "2. Overhaul bundle carries every specialist's output spec"
# These phrases are the ones the 1.0.0 paraphrase silently dropped. If a
# specialist's spec changes, this list changes with it.
REQUIRED=(
  "Top 5 fixes ranked by impact"
  "before-and-after"
  "Top 15 keywords and skills"
  "Trending skills"
  "Buzzwords to remove"
  "Ranked action list"
  "Never fabricate a number"
  "Closing report"
  "hireability"
)
BUNDLE=$(cat "$SKILLS/resume-overhaul/SKILL.md" "$STAGES"/*.md 2>/dev/null)
for phrase in "${REQUIRED[@]}"; do
  if printf '%s' "$BUNDLE" | grep -qiF -- "$phrase"; then
    note "ok  \"$phrase\""
  else
    bad "overhaul bundle never mentions \"$phrase\""
  fi
done

echo "3. Overhaul references each stage file by path"
for s in "${SPECIALISTS[@]}"; do
  if grep -qF "stages/$s.md" "$SKILLS/resume-overhaul/SKILL.md"; then
    note "ok  stages/$s.md referenced"
  else
    bad "SKILL.md never points at stages/$s.md"
  fi
done

echo "4. dist/*.skill contents match plugins/"
for d in "$SKILLS"/*/; do
  n=$(basename "$d")
  z="dist/$n.skill"
  if [ ! -f "$z" ]; then
    bad "missing $z — run ./build.sh"
    continue
  fi
  rm -rf "$TMP/unz" && mkdir -p "$TMP/unz"
  unzip -qo "$z" -d "$TMP/unz"
  if diff -rq "$TMP/unz/$n" "$d" >/dev/null 2>&1; then
    note "ok  $n.skill"
  else
    bad "$z differs from $d — run ./build.sh"
  fi
done

echo
if [ "$fail" -eq 0 ]; then
  echo "PASS"
else
  echo "FAILED — see above"
fi
exit "$fail"
