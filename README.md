# UroBilanz

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

---

# UroBilanz

UroBilanz ist eine lokale Auswertung fuer Urin- und Wasserprotokolle aus
CSV-Dateien. Das Projekt enthaelt eine portable Web-App und eine native
SwiftUI-App fuer macOS.

<img src="assets/icon/app-icon/urobilanz-liquid-balance-day-night.png" alt="UroBilanz App-Symbol" width="160">

Das aktuelle App-Symbol wurde fuer UroBilanz mit Unterstuetzung von OpenAI Codex
erzeugt. Falls eine unbeabsichtigte Aehnlichkeit zu einer anderen App auffaellt,
kann das Symbol jederzeit ersetzt werden.

## Wichtig

UroBilanz ist ein Protokoll- und Auswertungstool. Es ist keine medizinische
Diagnose-App und gibt keine medizinischen Empfehlungen.

## Funktionen

- Urin-, Wasser- und Hinweis-Eintraege aus Urinote-CSV importieren,
  zusammenfuehren und manuell ergaenzen.
- Dashboard, Tages-, Wochen-, Monats- und Jahresansichten mit Summen,
  Durchschnitt, Auffaelligkeiten und Streak-Anzeige.
- Hinweise bleiben der passenden Uhrzeit zugeordnet; allgemeine Hinweise
  bleiben separat sichtbar.
- Tabellenbreiten koennen direkt angepasst und lokal gespeichert werden.
- Themes koennen importiert, exportiert und geloescht werden.
- Arztbericht mit frei waehlbarem Zeitraum, Zusammenfassung, Tagesverlauf,
  Tagesdetails, Hinweisen und Bewertungsregeln.
- Export als Komplett-Backup, Tagesdaten-CSV, JSON und macOS-PDF-Bericht.
- Web-App und native SwiftUI-App arbeiten lokal ohne automatische
  Datenuebertragung an externe Server.

## Screenshots

Die folgenden Bilder zeigen Demo-Daten. Es sind keine echten Gesundheitsdaten.

### Web-App

![Web-App Dashboard](docs/screenshots/github/web/web-dashboard-violet-night.png)

![Web-App Tagesansicht](docs/screenshots/github/web/web-day-violet-night.png)

![Web-App Eingabe](docs/screenshots/github/web/web-entry-violet-night.png)

### SwiftUI-App

![SwiftUI-App Dashboard](docs/screenshots/github/swift/swift-dashboard-creme-salbei.png)

![SwiftUI-App Tagesansicht](docs/screenshots/github/swift/swift-day-creme-salbei.png)

![SwiftUI-App Eingabe](docs/screenshots/github/swift/swift-entry-creme-salbei.png)

## Voraussetzungen

- Web-App: moderner Browser auf macOS, Windows oder Linux.
- macOS-App: Apple Silicon (`arm64`), aktuell fuer macOS 26 gebaut.

## Start / Build

### Web-App

Im Ordner `apps/web` kann die Datei `Start_Urinprotokoll.command` gestartet
werden. Alternativ kann `index.html` direkt im Browser geoeffnet werden.

### macOS-App

Die gebaute App liegt hier:

`apps/macos-swift/build/UroBilanz.app`

Die macOS-App kann neu gebaut werden mit:

```bash
apps/macos-swift/build_app.sh
```

### macOS-Sicherheitswarnung

> Beim ersten Oeffnen zeigt macOS moeglicherweise eine Warnung, da die App
> nicht mit einem kostenpflichtigen Apple Developer Account notarisiert ist.
>
> So oeffnest du die App trotzdem:
>
> 1. Rechtsklick auf die App-Datei.
> 2. **Oeffnen** waehlen.
> 3. Im erscheinenden Dialog **Trotzdem oeffnen** anklicken.
>
> Alternativ unter **Systemeinstellungen -> Datenschutz & Sicherheit** ganz
> unten **Trotzdem oeffnen** bestaetigen.
>
> Diese Einschraenkung betrifft nur die macOS-App. Die Web-App laeuft im
> Browser ohne jede Signierung.

## Eigene Themes

Web-App und SwiftUI-App koennen eigene Themes im JSON-Format importieren. Die
Vorlage, ein Beispiel und die Dokumentation liegen hier:

- [Theme-Vorlage](docs/themes/urobilanz-theme-template.json)
- [Beispieltheme](docs/themes/example-custom-theme.json)
- [Theme-Dokumentation](docs/themes/README.md)

Eingebaute Themes koennen aus der App heraus als bearbeitbare JSON-Kopie
exportiert werden. Importierte Themes koennen wieder geloescht werden.

## Entwicklung pruefen

Der portable Pruefablauf baut die SwiftUI-App neu und kontrolliert beide
unterstuetzten CSV-Importwege. Ohne Parameter verwendet er ausschliesslich die
kuenstlichen Testdaten aus `docs/demo`:

```bash
./verify_apps.sh
```

Optional koennen zwei eigene Testdateien angegeben werden:

```bash
./verify_apps.sh /pfad/urinote.csv /pfad/tagesdaten.csv
```

Persoenliche Messdaten werden nicht fuer die Standardpruefung benoetigt und
gehoeren weiterhin nicht ins Repository.

## Projektstruktur

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

## Datenschutz

UroBilanz verarbeitet Messdaten ausschliesslich lokal auf dem Geraet. Es werden
keine Gesundheitsdaten an externe Server uebertragen.

Echte CSV-, Excel- und Backup-Dateien mit persoenlichen Messdaten gehoeren
nicht in dieses Repository. Die `.gitignore` ist so vorbereitet, dass solche
Dateien nicht versehentlich aufgenommen werden.

Der lokale technische Datenschutz-Check ist unter
[docs/PRIVACY_CHECK.md](docs/PRIVACY_CHECK.md) dokumentiert.

## Kontakt

Fragen, Feedback und Fehlerberichte koennen per E-Mail gesendet oder direkt in
der App erstellt werden.

**E-Mail:** [urobilanz@mailbox.org](mailto:urobilanz@mailbox.org)

## Lizenz

UroBilanz steht unter der GNU General Public License Version 3 (GPLv3).

**Lizenz:** [GNU GPLv3](LICENSE)

## Transparenz

UroBilanz wurde als persoenliches Auswertungs- und Protokollwerkzeug gemeinsam
mit OpenAI Codex entwickelt. Auch die im Projekt enthaltenen Grafiken, Symbole
und App-Icons wurden fuer dieses Projekt mit Unterstuetzung von OpenAI Codex
erstellt. Die medizinischen Inhalte, Grenzwerte und Darstellungen dienen nur
der persoenlichen Uebersicht und ersetzen keine medizinische Beratung.
