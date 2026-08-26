#!/usr/bin/env python3
"""Normalise code-fence info strings for MkDocs/pymdown-superfences.

The content repos come from GitBook, which is lenient about what follows the
opening ```. SuperFences is not: it only accepts a single language token
(optionally followed by a {...} option block). Anything else stops the line
from being recognised as a fence at all, so the block leaks into the page as
paragraph text and the closing ``` opens a *new* block — everything after it
renders wrong.

Three shapes are rewritten:

    ```go []              -> ```go            (LeetCode editorial annotation)
    ```class Solution {   -> ```              (code glued onto the fence line;
                                               the text is kept as code)
    unterminated fence    -> closed at EOF    (GitBook closes it implicitly)

The content repos have been cleaned up, so this should normally be a no-op —
it stays in the build as a guard against re-imports reintroducing the pattern.

Usage: normalize_fences.py DIR [DIR ...]
"""
import re
import sys
from pathlib import Path

FENCE = re.compile(r"^(?P<indent>\s*)(?P<marker>`{3,}|~{3,})[ \t]*(?P<info>.*?)[ \t]*$")
LANG = re.compile(r"^[A-Za-z0-9+#._-]+$")
LANG_WITH_ANNOTATION = re.compile(r"^(?P<lang>[A-Za-z0-9+#._-]+)[ \t]+\[[^\]]*\][ \t]*$")


def normalize(text: str) -> str:
    out, changed = [], False
    open_marker = None  # set while inside a fenced block
    open_indent = ""

    for line in text.split("\n"):
        m = FENCE.match(line)
        if not m:
            out.append(line)
            continue

        indent, marker, info = m.group("indent"), m.group("marker"), m.group("info")

        # Inside a block: only a bare, long-enough marker of the same kind closes it.
        if open_marker:
            if marker[0] == open_marker[0] and len(marker) >= len(open_marker) and not info:
                open_marker = None
            out.append(line)
            continue

        if not info:  # plain opening fence
            open_marker, open_indent = marker, indent
            out.append(line)
            continue

        open_marker, open_indent = marker, indent

        if LANG.match(info) or info.startswith("{"):
            out.append(f"{indent}{marker}{info}")  # already valid; just tidy spacing
            continue

        annotated = LANG_WITH_ANNOTATION.match(info)
        if annotated:
            out.append(f"{indent}{marker}{annotated.group('lang')}")
        else:
            # Unrecognised info string: drop it from the fence but keep the text,
            # which is code that lost its newline.
            out.append(f"{indent}{marker}")
            out.append(f"{indent}{info}")
        changed = True

    if open_marker:  # unterminated fence; GitBook closes it implicitly, we do it here
        trailing = []
        while out and not out[-1].strip():
            trailing.append(out.pop())
        out.append(f"{open_indent}{open_marker}")
        out.extend(trailing)
        changed = True

    return "\n".join(out) if changed else text


def main(dirs: list[str]) -> int:
    fixed = 0
    for d in dirs:
        for path in sorted(Path(d).rglob("*.md")):
            original = path.read_text(encoding="utf-8")
            updated = normalize(original)
            if updated != original:
                path.write_text(updated, encoding="utf-8")
                fixed += 1
    print(f"Normalised code fences in {fixed} markdown page(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:] or ["docs"]))
