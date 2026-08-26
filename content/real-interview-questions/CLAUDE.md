# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Write-ups of questions actually asked in real interviews. There is no build or test
suite — the "product" is plain CommonMark markdown plus the hand-maintained
navigation file. It is one of the content repos published at
[swe.springlee.dev](https://swe.springlee.dev) (section: *Real Interview Questions*)
by the sibling `swe-site` repo.

```text
README.md            # section landing page
SUMMARY.md           # navigation — hand-maintained, GitBook format
companies/
  README.md          # company index table
  <company-slug>/
    README.md        # company overview: rounds, format, timeline
    <question-slug>.md
kafka-interview-question/
  README.md          # topic index: 22 sections, 230 questions
  NN-<section-slug>/
    README.md        # section index: numbered list of its questions
    NN-MM-<question-slug>.md
python-interview-question/
  README.md          # topic index: 11 sections, 50 questions
  NN-<section-slug>/
    README.md        # section index: its questions, in book order
    NN-<question-slug>.md
```

Two shapes live here. `companies/` is the original one — questions tied to a
specific loop, carrying the metadata block below. The `*-interview-question/`
directories are **topic banks**: bulk-imported question sets organised by subject
rather than by employer, so their pages carry no company metadata and follow their
own template. Keep the two apart; don't retrofit either template onto the other.

The banks differ in numbering. Kafka pages are renumbered per section
(`# N.M. <Question>`, files `NN-MM-<slug>.md`); Python pages keep their original
book numbers (`# N. <Question>`, files `NN-<slug>.md`), which is why a Python
section's questions are not consecutive and are not sorted by number. Either way
the nav label must match the page's own H1 and its section-index label.

## Conventions

### Naming

- Company folders: lowercase kebab-case (`grab/`, `shopee/`, `line-plus/`).
- Question files: lowercase kebab-case describing the question, not the round
  (`design-a-rate-limiter.md`, `why-is-hashmap-not-thread-safe.md`).
- Group several questions in one file only when they came from the same round and
  read as a unit; otherwise one question per file.

### Question page template

```md
# <Question as it was asked>

- **Company:** <name>
- **Round:** <phone screen | technical 1 | system design | hiring manager | onsite>
- **Role:** <e.g. Senior Backend Engineer, Java>
- **Asked:** <YYYY-MM>

## What they were probing

Why this question was asked — the signal the interviewer wanted.

## Answer

The answer, written the way you would deliver it out loud.

## Follow-ups

- <follow-up question> — <short answer>

## Notes

What went well, what to say differently next time, resources to read.
```

Keep the metadata block: it is what makes this section different from the
theory-first `swe` section. Use `_unknown_` rather than dropping a field.

### Math and code fences

Same rules as the other content repos, because the same MkDocs build renders them:

- Use `$$...$$` (KaTeX) for math, e.g. `$$O(n \log n)$$`. Single `$...$` is not
  rendered.
- Open code fences with three backticks and a bare language token, nothing else
  (`go`, not `go []`), and always close the final fence — strict CommonMark
  parsers (MkDocs/pymdown-superfences) mangle the rest of the page otherwise.

## Navigation

`SUMMARY.md` is **hand-maintained** — there are no generator scripts here (unlike
`leetcode-algorithms`). It uses GitBook format (`## Heading` sections, 2-space
nested lists) because `swe-site/scripts/convert_summary.py` converts it into
mkdocs-literate-nav format at build time.

When adding, renaming, or removing a page, update all three:

1. `SUMMARY.md` — the site navigation.
2. The area's own index — `companies/README.md` (the company table), or for a
   topic bank the section `README.md` plus the bank's own `README.md` (both carry
   per-section question counts that must stay in step).
3. `README.md` — the "Jump right in" links, if a new top-level area appears.

`SUMMARY.md` lists every topic-bank question individually, so a bulk import means a
bulk nav edit. The section READMEs are the source of truth for titles and ordering —
derive the nav entries from them rather than from the filenames, so a page's nav
label always matches its index label.

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
