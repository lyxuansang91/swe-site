# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

SWE interview prep content with a Java-backend focus (Java Core, Spring, Kafka,
Redis, SQL, Hibernate, design patterns, behavioral), imported from an external
GitBook. No build or test suite — the "product" is plain CommonMark markdown. It is
one of the content repos published at [swe.springlee.dev](https://swe.springlee.dev)
(section: *SWE Interview*) by the sibling `swe-site` repo, and is also GitBook
Git-synced via `.gitbook.yaml`.

```text
README.md            # "Welcome" landing page with "Jump right in" links
SUMMARY.md           # navigation — hand-maintained, GitBook format
java-core/           # multi-page topics get a folder with its own README.md
spring/
<topic>.md           # single-page topics live at the root (kafka.md, sql.md, ...)
```

## Conventions

- One topic per file, lowercase kebab-case (`memory-management.md`,
  `tdd-bdd-ddd.md`). Promote a topic to a folder with a `README.md` index once it
  needs several pages.
- Use `$$...$$` (KaTeX) for math — single `$...$` is not rendered on the site.
- Open code fences with three backticks and a bare language token, nothing else
  (`java`, not `java []`), and always close the final fence; strict CommonMark
  parsers (MkDocs/pymdown-superfences, which builds the site) mangle the rest of
  the page otherwise.

## Navigation

`SUMMARY.md` is **hand-maintained** — there are no generator scripts here (unlike
`leetcode-algorithms`). It stays in GitBook format (`## Heading` sections, 2-space
nested lists) because both GitBook and `swe-site/scripts/convert_summary.py`
consume it.

When adding, renaming, or removing a page, update both `SUMMARY.md` and the
README's "Jump right in" list.

## Publishing

Pushes to `main` fire `.github/workflows/trigger-site-deploy.yml`, which POSTs a
`content-updated` **repository_dispatch** to `software-engineer-learning/swe-site`.
That is what `swe-site/.github/workflows/deploy.yml` listens for, and it is the
only thing that rebuilds the site: it runs `build.sh`, which clones all four
content repos, runs `scripts/prepare.sh` and `mkdocs build`, then uploads the
result with `wrangler pages deploy`.

It needs the `SITE_DISPATCH_TOKEN` secret — a classic PAT with the `repo` scope,
owned by an account that can write to `swe-site`. An organisation-level secret
covers every content repo at once, so it is rotated in one place.

**Do not swap this for a Cloudflare Pages deploy hook.** That was tried and it
silently did nothing: `swe-site` is a Direct Upload Pages project, so a hook has
no repo to clone and no build command to run — it re-serves the assets already
uploaded, returning `success: true` while the content stays stale. Deploy hooks
only build on Git-connected Pages projects, and connecting `swe-site` would make
every change build twice.

(The hook was introduced on the belief that a fine-grained PAT owned by a personal
account can never write to an org repo. That is not true — it works once the org
enables fine-grained token access, and a classic PAT with `repo` scope works
regardless. The original 403 was a token-configuration problem.)

To preview locally, run `bash scripts/prepare.sh && mkdocs serve` from the sibling
`swe-site` checkout — it picks up this working tree, not GitHub.
