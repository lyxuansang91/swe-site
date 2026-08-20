// Render $$...$$ (and $...$) math with KaTeX. The content repos write
// complexity expressions inline as $$O(n \log n)$$ (GitBook convention),
// so both delimiters render in inline mode.
document$.subscribe(() => {
  renderMathInElement(document.body, {
    delimiters: [
      { left: "$$", right: "$$", display: false },
      { left: "$", right: "$", display: false },
    ],
    throwOnError: false,
  });
});
