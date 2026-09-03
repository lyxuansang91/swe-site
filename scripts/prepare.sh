#!/usr/bin/env bash
# Copy the content sources into docs/ and adapt them for MkDocs.
#
# All four sections now live under content/ in this repo:
#
#   content/leetcode-algorithms/    git submodule -> software-engineer-learning/leetcode-algorithms
#   content/swe/                    tracked here
#   content/real-interview-questions/  tracked here
#   content/system-design/          tracked here (vendored from our fork of
#                                   liquidslr/system-design-notes)
#
# Only the LeetCode section is a submodule, so it is the only source that needs
# fetching: `git submodule update --init` after cloning, or
# `git submodule update --remote content/leetcode-algorithms` to pull new solutions.
set -euo pipefail
cd "$(dirname -- "$0")/.."

lc_src="content/leetcode-algorithms"
swe_src="content/swe"
sd_src="content/system-design"
riq_src="content/real-interview-questions"

for d in "$lc_src" "$swe_src" "$sd_src" "$riq_src"; do
  [ -d "$d" ] || { echo "Missing content source: $d" >&2; exit 1; }
done

# An uninitialised submodule is an empty directory, which would silently build a
# LeetCode section with no pages.
if [ ! -f "$lc_src/SUMMARY.md" ]; then
  echo "$lc_src is empty — run: git submodule update --init --recursive" >&2
  exit 1
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

# Material's search plugin titles a page by its first h1, so a solution.md opening
# with `# Intuition` is unreachable by problem number. Give each one an h1 naming
# its problem, and cross-link description <-> solution.
python3 scripts/leetcode_titles.py docs/leetcode "$lc_src/SUMMARY.md"

python3 scripts/convert_summary.py "$lc_src/SUMMARY.md" > docs/leetcode/SUMMARY.md

# --- SWE section: everything except repo plumbing --------------------------
(cd "$swe_src" && find . -name '*.md' ! -name 'SUMMARY.md' ! -name 'CLAUDE.md' -print0) \
  | while IFS= read -r -d '' f; do
      mkdir -p "docs/swe/$(dirname "$f")"
      cp "$swe_src/$f" "docs/swe/$f"
    done

python3 scripts/convert_summary.py "$swe_src/SUMMARY.md" > docs/swe/SUMMARY.md

# --- Real Interview Questions section: same shape as SWE, minus repo docs ---
(cd "$riq_src" && find . -name '*.md' ! -name 'SUMMARY.md' ! -name 'CLAUDE.md' -print0) \
  | while IFS= read -r -d '' f; do
      mkdir -p "docs/real-interview-questions/$(dirname "$f")"
      cp "$riq_src/$f" "docs/real-interview-questions/$f"
    done

python3 scripts/convert_summary.py "$riq_src/SUMMARY.md" > docs/real-interview-questions/SUMMARY.md

# --- System Design section: chapter folders with their images --------------
(cd "$sd_src" && find . -mindepth 1 -maxdepth 1 -type d -print0) \
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

# --- Normalise GitBook-isms MkDocs cannot parse -----------------------------
python3 scripts/normalize_fences.py \
  docs/leetcode docs/swe docs/system-design docs/real-interview-questions

echo "Prepared: $(find docs/leetcode docs/swe docs/system-design docs/real-interview-questions -name '*.md' | wc -l | tr -d ' ') markdown pages"
