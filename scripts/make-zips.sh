#!/usr/bin/env bash
# Builds one upload-ready zip per skill into dist/ (for claude.ai: Settings > Capabilities > Skills > Upload skill).
# Run from the repo root after editing any SKILL.md:  ./scripts/make-zips.sh
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
rm -f dist/*.zip
cd plugins/study-engine/skills
for d in */; do
  name="${d%/}"
  zip -qr "../../../dist/${name}.zip" "$name"
  echo "built dist/${name}.zip"
done
