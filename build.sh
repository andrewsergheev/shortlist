#!/usr/bin/env bash
# Builds the two generated artifacts:
#   1. resume-overhaul/stages/*.md — copies of the four specialist skills, so
#      the overhaul runs standalone with no sibling skills installed
#   2. dist/*.skill — the zips browser users upload to claude.ai
# The four specialist SKILL.md files are the single source of truth. Never edit
# stages/*.md by hand; edit the skill and re-run this. ./check.sh enforces it.
set -euo pipefail
cd "$(dirname "$0")"

SKILLS=plugins/shortlist/skills
STAGES=$SKILLS/resume-overhaul/stages
SPECIALISTS=(resume-diagnoser resume-recruiter resume-rewriter resume-hiring-manager)

echo "Generating stage files..."
rm -rf "$STAGES"
mkdir -p "$STAGES"
for s in "${SPECIALISTS[@]}"; do
  # Drop the YAML frontmatter: these are stage instructions inside another
  # skill, not skills in their own right, and five competing `name:` blocks in
  # one bundle would be ambiguous.
  awk 'BEGIN{fm=0} /^---$/ && fm<2 {fm++; next} fm>=2{print}' "$SKILLS/$s/SKILL.md" > "$STAGES/$s.md"
  if [ ! -s "$STAGES/$s.md" ]; then
    echo "FATAL: extracted nothing from $SKILLS/$s/SKILL.md — is the frontmatter malformed?" >&2
    exit 1
  fi
  echo "  $STAGES/$s.md"
done

echo "Packing dist/..."
rm -rf dist
mkdir -p dist
for d in "$SKILLS"/*/; do
  n=$(basename "$d")
  ( cd "$SKILLS" && zip -q -X -r "../../../dist/$n.skill" "$n" )
  echo "  dist/$n.skill"
done

echo "Done. Run ./check.sh to verify."
