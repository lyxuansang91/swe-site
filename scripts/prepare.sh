#!/usr/bin/env bash
# Pull the two content repos into docs/ and adapt them for MkDocs.
#
# Locally: uses the sibling checkouts (../leetcode-algorithms, ../swe).
# In CI (Cloudflare Pages): clones them from GitHub; override the URLs with
# LEETCODE_REPO / SWE_REPO env vars if needed.
set -euo pipefail
cd "$(dirname -- "$0")/.."

LEETCODE_REPO="${LEETCODE_REPO:-https://github.com/software-engineer-learning/leetcode-algorithms.git}"
SWE_REPO="${SWE_REPO:-https://github.com/lyxuansang91/swe.git}"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

if [ -d ../leetcode-algorithms ] && [ -d ../swe ]; then
  echo "Using local sibling checkouts"
  lc_src="$(cd ../leetcode-algorithms && pwd)"
  swe_src="$(cd ../swe && pwd)"
else
  echo "Cloning content repos"
  git clone --depth 1 "$LEETCODE_REPO" "$work/leetcode"
  git clone --depth 1 "$SWE_REPO" "$work/swe"
  lc_src="$work/leetcode"
  swe_src="$work/swe"
fi

rm -rf docs/leetcode docs/swe
mkdir -p docs/leetcode docs/swe

# --- LeetCode section: difficulty dirs + README + assets ------------------
for d in Easy Medium Hard; do
  cp -R "$lc_src/$d" docs/leetcode/
done
cp "$lc_src/README.md" docs/leetcode/README.md

# MkDocs skips dot-directories, so relocate GitBook assets and fix links.
if [ -d "$lc_src/.gitbook/assets" ]; then
  cp -R "$lc_src/.gitbook/assets" docs/leetcode/_assets
  find docs/leetcode -name '*.md' -exec grep -l 'gitbook/assets' {} + 2>/dev/null \
    | while read -r f; do
        # depth-relative: ../../.gitbook/assets -> ../../_assets ; also handle root README
        # (-i.bak works on both BSD and GNU sed)
        sed -i.bak -e 's|\.\./\.\./\.gitbook/assets|../../_assets|g' \
                   -e 's|\.gitbook/assets|_assets|g' "$f" && rm -f "$f.bak"
      done
fi

python3 scripts/convert_summary.py "$lc_src/SUMMARY.md" > docs/leetcode/SUMMARY.md

# --- SWE section: everything except repo plumbing --------------------------
(cd "$swe_src" && find . -name '*.md' ! -name 'SUMMARY.md' ! -path './.git/*' -print0) \
  | while IFS= read -r -d '' f; do
      mkdir -p "docs/swe/$(dirname "$f")"
      cp "$swe_src/$f" "docs/swe/$f"
    done

python3 scripts/convert_summary.py "$swe_src/SUMMARY.md" > docs/swe/SUMMARY.md

echo "Prepared: $(find docs/leetcode docs/swe -name '*.md' | wc -l | tr -d ' ') markdown pages"
