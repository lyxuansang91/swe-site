#!/usr/bin/env bash
# Cloudflare Pages build entry point.
#   Build command:          bash build.sh
#   Build output directory: site
set -euo pipefail
cd "$(dirname -- "$0")"

# Silence the MkDocs 2.0 advisories (MkDocs' own, and Material's banner);
# requirements.txt pins mkdocs<2, so v2 cannot land here unannounced.
export DISABLE_MKDOCS_2_WARNING=true NO_MKDOCS_2_WARNING=true

pip install -r requirements.txt
bash scripts/prepare.sh
mkdocs build
