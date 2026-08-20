#!/usr/bin/env bash
# Cloudflare Pages build entry point.
#   Build command:          bash build.sh
#   Build output directory: site
set -euo pipefail
cd "$(dirname -- "$0")"

pip install -r requirements.txt
bash scripts/prepare.sh
mkdocs build
