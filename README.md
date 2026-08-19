# UroBilanz – Private Urine & Fluid Balance Tracker for macOS and Web

[Deutsch](README.de.md)

[![Privacy Check](https://github.com/Schrotty74/UroBilanz/actions/workflows/privacy-check.yml/badge.svg)](https://github.com/Schrotty74/UroBilanz/actions/workflows/privacy-check.yml)
[![Latest Release](https://img.shields.io/github/v/release/Schrotty74/UroBilanz)](https://github.com/Schrotty74/UroBilanz/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/Schrotty74/UroBilanz/total)](https://github.com/Schrotty74/UroBilanz/releases)

![Version](https://img.shields.io/badge/version-1.7.4--beta.1-blue) ![License](https://img.shields.io/badge/license-GPL--3.0-green) ![Privacy](https://img.shields.io/badge/privacy-100%25%20local-brightgreen) ![No Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen) ![Web](https://img.shields.io/badge/Web--App-macOS%20%7C%20Windows%20%7C%20Linux-blue) ![JavaScript](https://img.shields.io/badge/JavaScript-ES2020-yellow?logo=javascript) ![Platform](https://img.shields.io/badge/macOS-26.0+-silver?logo=apple) ![Swift](https://img.shields.io/badge/Swift-SwiftUI-orange?logo=swift) ![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-only-black?logo=apple) [![Discord](https://img.shields.io/badge/Discord-Join%20Community-5865F2?logo=discord&logoColor=white)](https://discord.gg/RbsvqRCPQ)

UroBilanz is a private fluid balance tracker and urine diary for local logging and analysis of urine output, fluid intake and notes from CSV files. It is available as a portable web app and as a native SwiftUI macOS app.

<img src="assets/icon/app-icon/urobilanz-liquid-balance-day-night.png" alt="UroBilanz app icon" width="160">

The current app icon was created for UroBilanz with support from OpenAI Codex.
If an unintended similarity to another app becomes noticeable, the icon can be
replaced at any time.

## Important

UroBilanz is a logging and analysis tool. It is not a medical diagnosis app and
does not provide medical recommendations.

## Features

- Import, merge and manually add urine, water and note entries from Urinote CSV
  files.
- Dashboard, day, week, month and year views with totals, averages, flags and
  streak tracking.
- Notes remain assigned to the matching time; general notes stay visible
  separately.
- Column widths can be adjusted directly and saved locally.
- Themes can be imported, exported and deleted.
- Medical report with selectable period, summary, daily progress, daily
  details, notes and evaluation rules.
- Export as complete backup, daily-data CSV, JSON and macOS PDF report.
- Web app and native SwiftUI app work locally without automatic data transfer
  to external servers.

## Screenshots

The following screenshots use demo data. They do not contain real health data.

### Web App

![Web App Dashboard](docs/screenshots/github/web/web-dashboard-violet-night.png)

![Web App Day View](docs/screenshots/github/web/web-day-violet-night.png)

![Web App Entry](docs/screenshots/github/web/web-entry-violet-night.png)

### SwiftUI App

![SwiftUI App Dashboard](docs/screenshots/github/swift/swift-dashboard-creme-salbei.png)

![SwiftUI App Day View](docs/screenshots/github/swift/swift-day-creme-salbei.png)

![SwiftUI App Entry](docs/screenshots/github/swift/swift-entry-creme-salbei.png)

## Manual

- [UroBilanz User Manual (English, PDF)](docs/output/pdf/UroBilanz-User-Manual-EN.pdf)
- [UroBilanz Handbuch (Deutsch, PDF)](docs/output/pdf/UroBilanz-Handbuch-DE.pdf)

## Requirements

- Web app: modern browser on macOS, Windows or Linux.
- macOS app: Apple Silicon (`arm64`), currently built for macOS 26.

## Start / Build

### Web App

Start `Start_Urinprotokoll.command` in `apps/web`, or open `index.html`
directly in a browser.

### macOS App

The built app is located here:

`apps/macos-swift/build/UroBilanz.app`

The macOS app can be rebuilt with:

```bash
apps/macos-swift/build_app.sh
```

Development builds can be built with a separate bundle identifier, so test
settings, table widths, imported themes and remembered data do not affect the
normal app:

```bash
UROBILANZ_BUILD_CHANNEL=dev apps/macos-swift/build_app.sh
```

This creates `apps/macos-swift/build/UroBilanz Dev.app`.

The native app can also be opened directly in Xcode:

```bash
open UroBilanz.xcodeproj
```

Use the shared `UroBilanz Dev` scheme for daily local development. Dev, Beta
and Final use separate bundle identifiers:

- Dev: `local.schrotty74.urobilanz.dev`
- Beta: `local.schrotty74.urobilanz.beta`
- Final: `local.schrotty74.urobilanz`

Beta and Final packages are created by scripts, not by separate visible Xcode
schemes:

```bash
Scripts/create-beta-from-dev.sh 1.8.0-beta.1
Scripts/publish-beta-as-final.sh 1.8.0
```

The scripts create ZIP, DMG and SHA256 files under `Backup/releases/...` and
copy the unpacked app to `dist/releases/...`. GitHub push and release upload
only happen when `UROBILANZ_ALLOW_PUSH=YES` is set. Release packages should be
created through `Scripts/build-release-package.sh`; `apps/web/build_web.sh` is
only an internal helper for the web bundle.

### macOS Security Warning

> When opening the app for the first time, macOS may display a warning because
> the app is not notarized with a paid Apple Developer account.
>
> To open the app anyway:
>
> 1. Right-click the app file.
> 2. Select **Open**.
> 3. Click **Open Anyway** in the dialog that appears.
>
> Alternatively, open **System Settings -> Privacy & Security** and confirm
> **Open Anyway** at the bottom of the page.
>
> This limitation affects only the macOS app. The web app runs in the browser
> without any signing requirements.

## Custom Themes

Web app and SwiftUI app can import custom themes in JSON format. Template,
example and documentation are available here:

- [Theme template](docs/themes/urobilanz-theme-template.json)
- [Example theme](docs/themes/example-custom-theme.json)
- [Theme documentation](docs/themes/README.md)

Built-in themes can be exported from the app as editable JSON copies. Imported
themes can be deleted again.

## Verification

The portable verification script rebuilds the SwiftUI app and checks both
supported CSV import paths. Without parameters it uses only synthetic test data
from `docs/demo`:

```bash
./verify_apps.sh
```

Optional test files can be provided:

```bash
./verify_apps.sh /path/urinote.csv /path/daily-data.csv
```

Personal measurement data is not required for the default verification and must
not be committed to the repository.

## Project Structure

```text
UroBilanz/
  apps/
    web/
      assets/js/core.js
      assets/js/medical-report.js
      assets/js/themes.js
      tests/core-smoke-test.js
    macos-swift/
      Sources/UroDataModel.swift
      Sources/UroMedicalReport.swift
      Sources/UroModels.swift
      Sources/UroCSVSupport.swift
      build_app.sh
      smoke_test.sh
  assets/
    icon/
  docs/
    HISTORY.md
    NEXT_STEPS.md
  verify_apps.sh
```

## Privacy

UroBilanz processes measurement data exclusively locally on the device. No
health data is transmitted to external servers.

### First-start help

While there are no personal entries yet, the start view can open the
[German UroBilanz manual](docs/output/pdf/UroBilanz-Handbuch-DE.pdf)
or the [English UroBilanz User Manual](docs/output/pdf/UroBilanz-User-Manual-EN.pdf)
or copy a fixed step-by-step onboarding question for ChatGPT, Google Gemini,
or Claude to the clipboard. After explicit confirmation, UroBilanz opens the
chosen website. The question contains only general operating steps and this
public PDF manual link, never measurement values, notes, files, or other user
data. The person must paste it with `Cmd+V` and deliberately send it in the
selected service.

The manuals explain the first start, all visible areas, controls, exports,
evaluation rules, and privacy in the web and macOS apps.

Real CSV, Excel and backup files with personal measurement data do not belong
in this repository. The `.gitignore` is prepared to prevent such files from
being added accidentally.

The local technical privacy check is documented in
[docs/PRIVACY_CHECK.md](docs/PRIVACY_CHECK.md).

## Contact

Questions, feedback and bug reports can be sent by email, created directly in
the app or discussed on [Discord](https://discord.gg/RbsvqRCPQ).

**Email:** [urobilanz@mailbox.org](mailto:urobilanz@mailbox.org)

## Repo activity

![Repobeats analytics image](https://repobeats.axiom.co/api/embed/5a5c6d9b88a92a7575dad45cbb36fe2015dcc2d1.svg "Repobeats analytics image")

## License

UroBilanz is licensed under the GNU General Public License Version 3 (GPLv3).

**License:** [GNU GPLv3](LICENSE)

## Transparency

UroBilanz was developed as a personal logging and analysis tool together with
OpenAI Codex. The graphics, symbols and app icons included in the project were
also created for this project with support from OpenAI Codex. The medical
content, thresholds and visualizations are intended only for personal overview
and do not replace medical advice.

<a href="https://www.buymeacoffee.com/ShelbyGT74"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=ShelbyGT74&button_colour=FF5F5F&font_colour=ffffff&font_family=Cookie&outline_colour=000000&coffee_colour=FFDD00" /></a>
