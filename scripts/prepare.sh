#!/usr/bin/env bash
# Pull the content repos into docs/ and adapt them for MkDocs.
#
# Locally: uses the sibling checkouts (../leetcode-algorithms, ../swe,
# ../system-design, ../real-interview-questions). In CI: clones them from GitHub;
# override the URLs with LEETCODE_REPO / SWE_REPO / SYSTEM_DESIGN_REPO /
# REAL_INTERVIEW_REPO env vars if needed.
set -euo pipefail
cd "$(dirname -- "$0")/.."

LEETCODE_REPO="${LEETCODE_REPO:-https://github.com/software-engineer-learning/leetcode-algorithms.git}"
SWE_REPO="${SWE_REPO:-https://github.com/lyxuansang91/swe.git}"
# Upstream third-party notes; point at a fork to control when updates land.
SYSTEM_DESIGN_REPO="${SYSTEM_DESIGN_REPO:-https://github.com/liquidslr/system-design-notes.git}"
REAL_INTERVIEW_REPO="${REAL_INTERVIEW_REPO:-https://github.com/software-engineer-learning/real-interview-questions.git}"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

if [ -d ../leetcode-algorithms ] && [ -d ../swe ] && [ -d ../system-design ] \
   && [ -d ../real-interview-questions ]; then
  echo "Using local sibling checkouts"
  lc_src="$(cd ../leetcode-algorithms && pwd)"
  swe_src="$(cd ../swe && pwd)"
  sd_src="$(cd ../system-design && pwd)"
  riq_src="$(cd ../real-interview-questions && pwd)"
else
  echo "Cloning content repos"
  git clone --depth 1 "$LEETCODE_REPO" "$work/leetcode"
  git clone --depth 1 "$SWE_REPO" "$work/swe"
  git clone --depth 1 "$SYSTEM_DESIGN_REPO" "$work/system-design"
  git clone --depth 1 "$REAL_INTERVIEW_REPO" "$work/real-interview-questions"
  lc_src="$work/leetcode"
  swe_src="$work/swe"
  sd_src="$work/system-design"
  riq_src="$work/real-interview-questions"
fi

# Echo the path of a directory's readme whatever its casing.
readme_in() { find "$1" -maxdepth 1 -iname 'readme.md' -print -quit; }

rm -rf docs/leetcode docs/swe docs/system-design docs/real-interview-questions
mkdir -p docs/leetcode docs/swe docs/system-design docs/real-interview-questions

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
(cd "$swe_src" && find . -name '*.md' ! -name 'SUMMARY.md' ! -name 'CLAUDE.md' \
  ! -path './.git/*' -print0) \
  | while IFS= read -r -d '' f; do
      mkdir -p "docs/swe/$(dirname "$f")"
      cp "$swe_src/$f" "docs/swe/$f"
    done

python3 scripts/convert_summary.py "$swe_src/SUMMARY.md" > docs/swe/SUMMARY.md

# --- Real Interview Questions section: same shape as SWE, minus repo docs ---
(cd "$riq_src" && find . -name '*.md' ! -name 'SUMMARY.md' ! -name 'CLAUDE.md' \
  ! -path './.git/*' -print0) \
  | while IFS= read -r -d '' f; do
      mkdir -p "docs/real-interview-questions/$(dirname "$f")"
      cp "$riq_src/$f" "docs/real-interview-questions/$f"
    done

python3 scripts/convert_summary.py "$riq_src/SUMMARY.md" > docs/real-interview-questions/SUMMARY.md

# --- System Design section: chapter folders with their images --------------
(cd "$sd_src" && find . -mindepth 1 -maxdepth 1 -type d ! -name '.git' -print0) \
  | while IFS= read -r -d '' d; do
      cp -R "$sd_src/${d#./}" docs/system-design/
    done
cp "$(readme_in "$sd_src")" docs/system-design/README.md

# Upstream mixes `Readme.md` and `README.md`. Only an exact `README.md` is
# treated as a directory index by MkDocs, and the chapters' raw
# <img src="./images/..."> tags resolve only from that index URL — so
# normalise the casing (via a temp name, for case-insensitive filesystems).
find docs/system-design -mindepth 2 -maxdepth 2 -iname 'readme.md' -print0 \
  | while IFS= read -r -d '' f; do
      if [ "$(basename "$f")" != "README.md" ]; then
        mv "$f" "$f.tmp" && mv "$f.tmp" "$(dirname "$f")/README.md"
      fi
    done
find docs/system-design -name '.DS_Store' -delete

# Credit the upstream repo at the top of the section overview.
sd_readme="docs/system-design/README.md"
{
  echo '!!! info "Source"'
  echo '    Mirrored from [liquidslr/system-design-notes](https://github.com/liquidslr/system-design-notes),'
  echo '    notes on *System Design Interview* (Alex Xu, Vol 1 & 2). All credit to the original authors.'
  echo
  cat "$sd_readme"
} > "$sd_readme.new" && mv "$sd_readme.new" "$sd_readme"

python3 scripts/gen_nav.py docs/system-design > docs/system-design/SUMMARY.md

echo "Prepared: $(find docs/leetcode docs/swe docs/system-design docs/real-interview-questions -name '*.md' | wc -l | tr -d ' ') markdown pages"
