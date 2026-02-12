#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

OUT="docs"
mkdir -p "$OUT"

# Copy CSS
cp style.css "$OUT/style.css"

PAGES=(
  "index.md:index.html"
  "README.md:README.html"
  "step1_intro.md:step1_intro.html"
  "step2_mini_example.md:step2_mini_example.html"
  "step3_tools.md:step3_tools.html"
  "step4_systems_of_agents.md:step4_systems_of_agents.html"
  "step5_sharing_agents.md:step5_sharing_agents.html"
  "step6_new_cool_things.md:step6_new_cool_things.html"
  "step7_docker_sandboxes.md:step7_docker_sandboxes.html"
  "step8_thankyou.md:step8_thankyou.html"
)

for entry in "${PAGES[@]}"; do
  src="${entry%%:*}"
  dst="${entry##*:}"
  echo "Building $src -> $OUT/$dst"
  pandoc "$src" \
    --standalone \
    --css=style.css \
    --metadata title="cagent Workshop" \
    --template=template.html \
    -o "$OUT/$dst"
done

echo ""
echo "Done! Open $OUT/index.html in your browser."
