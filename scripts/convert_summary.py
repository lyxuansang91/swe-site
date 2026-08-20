#!/usr/bin/env python3
"""Convert a GitBook SUMMARY.md into mkdocs-literate-nav format.

Differences handled:
- GitBook groups pages under `## Heading`; literate-nav only reads nested
  lists, so each heading becomes a top-level list item and the items that
  follow it are pushed one level deeper.
- GitBook nests with 2-space indents; Python-Markdown (used by literate-nav)
  needs 4 spaces per level, so indentation is re-normalized.
- Plain-text section titles like `* 155. Min Stack` would be parsed as an
  ordered-list marker; the dot is escaped.

Usage: convert_summary.py <gitbook-SUMMARY.md>   (writes result to stdout)
"""
import re
import sys
from pathlib import Path
from urllib.parse import unquote

LIST_ITEM = re.compile(r"^(\s*)([*-]) (.*)$")
ORDERED_MARKER = re.compile(r"^(\d+)\. ")
LINK = re.compile(r"\[([^\]]*)\]\(([^)]*)\)")


def convert(text: str) -> str:
    out = []
    in_section = False
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("# "):  # "# Table of contents"
            continue
        if stripped.startswith("## "):
            out.append(f"* {stripped[3:].strip()}")
            in_section = True
            continue
        m = LIST_ITEM.match(line)
        if not m:
            continue
        indent, _, content = m.groups()
        level = len(indent) // 2 + (1 if in_section else 0)
        content = ORDERED_MARKER.sub(r"\1\\. ", content)
        # GitBook URL-encodes spaces in targets; literate-nav wants raw
        # filesystem paths wrapped in <> when they contain spaces.
        content = LINK.sub(
            lambda m: f"[{m.group(1)}](<{unquote(m.group(2))}>)"
            if "%" in m.group(2)
            else m.group(0),
            content,
        )
        out.append("    " * level + "* " + content)
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    sys.stdout.write(convert(Path(sys.argv[1]).read_text(encoding="utf-8")))
