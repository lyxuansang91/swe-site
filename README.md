# swe-site

MkDocs Material site that publishes [leetcode-algorithms](https://github.com/lyxuansang91/leetcode-algorithms) and [swe](https://github.com/lyxuansang91/swe) as one site at **https://swe.springlee.dev**, deployed on Cloudflare Pages.

## How it works

- `scripts/prepare.sh` pulls both content repos into `docs/leetcode/` and `docs/swe/` (local sibling checkouts when present, `git clone` in CI), relocates GitBook assets to `_assets/`, and converts each repo's GitBook `SUMMARY.md` into mkdocs-literate-nav format via `scripts/convert_summary.py`.
- `docs/SUMMARY.md` defines the top-level tabs (Home / LeetCode Algorithms / SWE Interview); each section's nav comes from its converted SUMMARY.
- Math: content uses GitBook-style inline `$$O(...)$$`; rendered client-side by KaTeX auto-render (`docs/javascripts/katex.js`).

## Local development

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
bash scripts/prepare.sh
.venv/bin/mkdocs serve   # http://127.0.0.1:8000
```

Content changes are made in the content repos, not here — re-run `prepare.sh` to pick them up.

## CI/CD

Deploys are done by GitHub Actions (`.github/workflows/deploy.yml`), not by Cloudflare's Git integration — do **not** also connect the repo in the Cloudflare dashboard or every change would build twice. The workflow builds the site and uploads it with `wrangler pages deploy`. It runs on:

- pushes to `main` of this repo,
- `repository_dispatch` events of type `content-updated`, fired by the `trigger-site-deploy.yml` workflows in `leetcode-algorithms` and `swe` on their content pushes,
- manual runs (`workflow_dispatch`).

### One-time setup

1. Create the Pages project (Direct Upload):
   ```bash
   npx wrangler pages project create swe-site --production-branch=main
   ```
   (or Cloudflare dashboard → Workers & Pages → Create → Pages → *Direct Upload*.)
2. In **this repo's** GitHub settings → Secrets and variables → Actions, add:
   - `CLOUDFLARE_ACCOUNT_ID` — dashboard → Workers & Pages → right sidebar.
   - `CLOUDFLARE_API_TOKEN` — dashboard → My Profile → API Tokens → Create Token → "Edit Cloudflare Workers"-style custom token with **Account → Cloudflare Pages → Edit** permission.
3. In **each content repo's** GitHub settings, add secret `SITE_DISPATCH_TOKEN`: a fine-grained PAT scoped to `lyxuansang91/swe-site` with **Contents: read and write** permission (that grant is what authorizes `repository_dispatch`).
4. After the first deploy: Pages project → **Custom domains → Add** → `swe.springlee.dev`. With the `springlee.dev` zone on Cloudflare, the CNAME and TLS are automatic.

Note: `scripts/prepare.sh` clones `lyxuansang91/leetcode-algorithms` and `lyxuansang91/swe` by default; override with `LEETCODE_REPO` / `SWE_REPO` env vars in the deploy workflow if the canonical repos live elsewhere.
