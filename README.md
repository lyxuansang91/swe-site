# swe-site

MkDocs Material site that publishes [leetcode-algorithms](https://github.com/software-engineer-learning/leetcode-algorithms), [swe](https://github.com/software-engineer-learning/swe), [system-design-notes](https://github.com/software-engineer-learning/system-design-notes) and [real-interview-questions](https://github.com/software-engineer-learning/real-interview-questions) as one site at **https://swe.springlee.dev**, deployed on Cloudflare Pages.

## How it works

- `scripts/prepare.sh` pulls the content repos into `docs/leetcode/`, `docs/swe/`, `docs/system-design/` and `docs/real-interview-questions/` (local sibling checkouts when present, `git clone` in CI), relocates GitBook assets to `_assets/`, and converts each repo's GitBook `SUMMARY.md` into mkdocs-literate-nav format via `scripts/convert_summary.py`.
- `docs/SUMMARY.md` defines the top-level tabs (Home / LeetCode Algorithms / SWE Interview / System Design / Real Interview Questions); each section's nav comes from its converted SUMMARY.
- `real-interview-questions` is copied the same way as `swe` — every `*.md` except `SUMMARY.md` and the repo's own `CLAUDE.md` — so repo-maintenance docs stay out of the published site.
- The system-design repo has no SUMMARY.md, so `scripts/gen_nav.py` generates one from its `NN. Chapter Name/README.md` folders, ordered by the numeric prefix and labelled with each chapter's H1. That repo also mixes `Readme.md` and `README.md` casing; `prepare.sh` normalises it, because only an exact `README.md` becomes a directory index and the chapters' raw `<img src="./images/...">` tags resolve only from that index URL.
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
- `repository_dispatch` events of type `content-updated`, fired by the `trigger-site-deploy.yml` workflows in `leetcode-algorithms`, `swe` and `real-interview-questions` on their content pushes,
- manual runs (`workflow_dispatch`).

`system-design` is a fork of a third-party repo, so it has no trigger workflow — its updates land on the next deploy from any other cause, or a manual run. Upstream changes reach the site only after the fork is synced, which is the point: it keeps third-party edits from landing unreviewed. To sync:

```bash
gh repo sync software-engineer-learning/system-design-notes --source liquidslr/system-design-notes
```

### One-time setup

1. Create the Pages project (Direct Upload):
   ```bash
   npx wrangler pages project create swe-site --production-branch=main
   ```
   (or Cloudflare dashboard → Workers & Pages → Create → Pages → _Direct Upload_.)
2. In **this repo's** GitHub settings → Secrets and variables → Actions, add:
   - `CLOUDFLARE_ACCOUNT_ID` — dashboard → Workers & Pages → right sidebar.
   - `CLOUDFLARE_API_TOKEN` — dashboard → My Profile → API Tokens → Create Token → "Edit Cloudflare Workers"-style custom token with **Account → Cloudflare Pages → Edit** permission.
3. In **each content repo's** GitHub settings, add secret `SITE_DISPATCH_TOKEN`: a fine-grained PAT scoped to `software-engineer-learning/swe-site` with **Contents: read and write** permission (that grant is what authorizes `repository_dispatch`).
4. After the first deploy: Pages project → **Custom domains → Add** → `swe.springlee.dev`. With the `springlee.dev` zone on Cloudflare, the CNAME and TLS are automatic.

Note: `scripts/prepare.sh` clones `software-engineer-learning/leetcode-algorithms`, `software-engineer-learning/swe`, `software-engineer-learning/system-design-notes` (our fork of `liquidslr/system-design-notes`) and `software-engineer-learning/real-interview-questions` by default; override with `LEETCODE_REPO` / `SWE_REPO` / `SYSTEM_DESIGN_REPO` / `REAL_INTERVIEW_REPO` env vars in the deploy workflow if the canonical repos live elsewhere.

## Adding a section

1. In `scripts/prepare.sh`: add a `<NAME>_REPO` default, a sibling-checkout/clone branch setting `<x>_src`, the `rm -rf`/`mkdir -p` entries, a copy block, and a `convert_summary.py` call writing `docs/<section>/SUMMARY.md`.
2. Add the tab to `docs/SUMMARY.md` and a bullet to `docs/index.md`.
3. Give the content repo a `.github/workflows/trigger-site-deploy.yml` (copy `swe`'s) plus the `SITE_DISPATCH_TOKEN` secret, so its pushes rebuild the site.
