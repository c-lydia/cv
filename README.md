# Chheng Lydiya — CV

A responsive CV in the Underlight/portfolio theme, with a professional two-page
A4 PDF. `index.html` and `cv.html` both work; the existing GitHub Pages workflow
continues to publish the repository root.

- **Download CV (PDF)** downloads `Chheng-Lydiya-CV.pdf` directly, with selectable
  text and clickable links.
- **Print / Save as PDF** uses a separate white layout. Choose A4, 100% scale,
  and disable browser-added headers/footers for the intended two-page result.
- Content includes education, DCLab robotics and teaching, the SAAT internship,
  selected software/hardware projects, skills, community, and languages.
- The page remains readable without JavaScript; only the print button needs it.
- Fonts are local; their license is in `FONT-LICENSE.txt`.

## Update from the portfolio

These are generated files. Edit the portfolio's `assets/cv/profile.json` and
`tool/cv/` templates, then run from that repository:

```sh
python3 tool/build_cv.py --browser /snap/bin/chromium \
  --cv-site ../cv --interactive ../cv/interactive-src
python3 -m unittest discover -s tool/tests
```

The content is curated from the portfolio's About, experience, toolbox, and
project case studies; `profile.json` records those sources. The existing public
CV email is retained. Unspecified internship dates and unsupported achievement
claims are not added. `cv.html` is retained for existing links.

Preview with `python3 -m http.server 8788 --bind 127.0.0.1`, then open
`http://127.0.0.1:8788/`. Deploy by reviewing and pushing the changes to `main`.


## Interactive Flutter CV

The same repository also maintains `interactive-src/`, published at
https://c-lydia.github.io/cv/interactive/. The Pages workflow checks out the exact
Flutter SDK revision used for local validation, runs analysis and tests, builds
with `/cv/interactive/` as its base path, and stages both websites into a single
Pages artifact. Source files, build caches, and the SDK are excluded from the
public artifact.

For local work, run Flutter commands inside `interactive-src/`. To synchronize
future PDF/content changes from the portfolio, pass
`--cv-site ../cv --interactive ../cv/interactive-src` to `tool/build_cv.py`.
