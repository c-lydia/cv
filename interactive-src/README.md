# Chheng Lydiya — Interactive CV

Flutter CV using the Underlight and portfolio palette. The responsive page
includes profile/contact links, experience, education, technical skills,
selected projects, community, and languages. Section navigation works on desktop
and mobile; the theme toggle supports dark and light modes.

**Download CV (PDF)** exports the bundled professional two-page A4 document.
On the web, it downloads in the browser. On desktop, it opens the system save
dialog; cancellation is harmless and failures leave the button available to
retry. The PDF has selectable text and clickable links, and uses a white print
layout independent of the active theme. No external PDF service is used.

## Run and verify

```sh
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
flutter build web --release
```

Run commands from this directory. This is the published Flutter CV source;
GitHub Pages serves its compiled output at `/cv/interactive/`.

## Content and PDF source

The portfolio owns `assets/cv/profile.json` and its print templates. From the
sibling portfolio checkout, regenerate and synchronize the content and PDF:

```sh
python3 tool/build_cv.py --browser /snap/bin/chromium \
  --cv-site ../cv --interactive ../cv/interactive-src
```

This copies `assets/cv/profile.json`, `assets/cv/Chheng-Lydiya-CV.pdf`, and the
licensed Ubuntu Sans font. The same PDF is downloaded by the portfolio and
public CV site. Keep the bundled assets checked in; running the Flutter app
needs no browser-based PDF generation. Sources and editorial limits are recorded
in the profile JSON. Tests cover narrow/desktop layouts, section navigation,
theme switching, actual PDF bytes, save cancellation, and export errors.
