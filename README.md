# UroBilanz

[Deutsch](README.de.md)

![Version](https://img.shields.io/badge/version-1.7.2-blue) ![License](https://img.shields.io/badge/license-GPL--3.0-green) ![Privacy](https://img.shields.io/badge/privacy-100%25%20local-brightgreen) ![No Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen) ![Web](https://img.shields.io/badge/Web--App-macOS%20%7C%20Windows%20%7C%20Linux-blue) ![JavaScript](https://img.shields.io/badge/JavaScript-ES2020-yellow?logo=javascript) ![Platform](https://img.shields.io/badge/macOS-26.0+-silver?logo=apple) ![Swift](https://img.shields.io/badge/Swift-SwiftUI-orange?logo=swift) ![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-only-black?logo=apple)

UroBilanz is a local logging and analysis tool for urine and fluid records from
CSV files. It is available as a portable web app and as a native SwiftUI macOS
app.

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

Real CSV, Excel and backup files with personal measurement data do not belong
in this repository. The `.gitignore` is prepared to prevent such files from
being added accidentally.

The local technical privacy check is documented in
[docs/PRIVACY_CHECK.md](docs/PRIVACY_CHECK.md).

## Contact

Questions, feedback and bug reports can be sent by email or created directly in
the app.

**Email:** [urobilanz@mailbox.org](mailto:urobilanz@mailbox.org)

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
