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

## Cloudflare Pages setup (one-time)

1. Push this repo to GitHub (`lyxuansang91/swe-site`).
2. Cloudflare dashboard → **Workers & Pages → Create → Pages → Connect to Git** → select `swe-site`.
3. Build settings:
   - Build command: `bash build.sh`
   - Build output directory: `site`
   - Environment variable: `PYTHON_VERSION` = `3.12`
4. Deploy, then **Custom domains → Add** → `swe.springlee.dev`. With the `springlee.dev` zone on Cloudflare, the CNAME record is created automatically and TLS is immediate.

## Rebuilding when content repos change

Cloudflare only rebuilds on pushes to *this* repo. To rebuild on content pushes, create a **Deploy Hook** (Pages project → Settings → Builds & deployments → Deploy hooks), save its URL as a secret named `CLOUDFLARE_DEPLOY_HOOK_URL` in each content repo, and add this workflow to both repos as `.github/workflows/deploy-site.yml`:

```yaml
name: Trigger site deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: curl -sX POST "$DEPLOY_HOOK"
        env:
          DEPLOY_HOOK: ${{ secrets.CLOUDFLARE_DEPLOY_HOOK_URL }}
```
