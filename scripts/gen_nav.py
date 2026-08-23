#!/usr/bin/env python3
"""Generate an mkdocs-literate-nav SUMMARY.md for a folder-per-chapter section.

The system-design content repo has no SUMMARY.md — it is a flat set of
`NN. Chapter Name/README.md` folders. Entries are ordered by the numeric
folder prefix and labelled with each chapter's H1 (e.g. "Chapter 1: Scale
from Zero to Millions of Users"), falling back to the folder name.

Run against the *prepared* docs directory so the emitted paths are exactly
what MkDocs will see (i.e. after README casing is normalised).

Usage: gen_nav.py <prepared-section-dir>   (writes result to stdout)
"""
import re
import sys
from pathlib import Path

LEADING_NUM = re.compile(r"^(\d+)")
MD_LINK = re.compile(r"\[([^\]]*)\]\([^)]*\)")


def title_of(readme: Path, fallback: str) -> str:
    for line in readme.read_text(encoding="utf-8", errors="replace").splitlines():
        stripped = line.strip()
        if stripped.startswith("# "):
            # An H1 may itself be a link: "# [Title](url)" -> "Title".
            title = MD_LINK.sub(r"\1", stripped[2:]).strip()
            if title:
                return title
    return fallback


def main(root: Path) -> str:
    entries = []
    for d in sorted(root.iterdir()):
        readme = d / "README.md"
        if not d.is_dir() or not readme.exists():
            continue
        m = LEADING_NUM.match(d.name)
        order = int(m.group(1)) if m else 10**6
        entries.append((order, d.name, title_of(readme, d.name)))
    entries.sort(key=lambda e: (e[0], e[1]))

    lines = ["* [Overview](README.md)"]
    # Paths need <> wrapping: every chapter folder name contains spaces.
    lines += [f"* [{title}](<{name}/README.md>)" for _, name, title in entries]
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    sys.stdout.write(main(Path(sys.argv[1])))
