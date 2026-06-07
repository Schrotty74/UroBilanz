# UroBilanz

UroBilanz ist eine lokale Auswertung fuer Urin- und Wasserprotokolle aus CSV-Dateien.

Das Projekt enthaelt zwei Apps:

- `apps/web`: portable Web-App fuer macOS, Windows und Linux im Browser.
- `apps/macos-swift`: native macOS-App mit SwiftUI fuer Apple-Silicon-Macs.

<img src="assets/icon/app-icon/urobilanz-liquid-balance-day-night.png" alt="UroBilanz App-Symbol" width="160">

Das aktuelle App-Symbol wurde fuer UroBilanz mit Unterstuetzung von OpenAI Codex
erzeugt. Falls eine unbeabsichtigte Aehnlichkeit zu einer anderen App auffaellt,
kann das Symbol jederzeit ersetzt werden.

## Wichtig

UroBilanz ist ein Protokoll- und Auswertungstool. Es ist keine medizinische Diagnose-App und gibt keine medizinischen Empfehlungen.

Die Verarbeitung findet lokal statt. CSV-Dateien werden nicht hochgeladen.

## Vorschau

Die folgenden Bilder zeigen Demo-Daten. Es sind keine echten Gesundheitsdaten.

### Web-App

![Web-App Dashboard](docs/screenshots/github/web/web-dashboard-violet-night.png)

![Web-App Tagesansicht](docs/screenshots/github/web/web-day-violet-night.png)

![Web-App Eingabe](docs/screenshots/github/web/web-entry-violet-night.png)

### SwiftUI-App

![SwiftUI-App Dashboard](docs/screenshots/github/swift/swift-dashboard-creme-salbei.png)

![SwiftUI-App Tagesansicht](docs/screenshots/github/swift/swift-day-creme-salbei.png)

![SwiftUI-App Eingabe](docs/screenshots/github/swift/swift-entry-creme-salbei.png)

## Transparenz

UroBilanz wurde als persoenliches Auswertungs- und Protokollwerkzeug gemeinsam mit OpenAI Codex entwickelt. Auch die im Projekt enthaltenen Grafiken, Symbole und App-Icons wurden fuer dieses Projekt mit Unterstuetzung von OpenAI Codex erstellt. Die medizinischen Inhalte, Grenzwerte und Darstellungen dienen nur der persoenlichen Uebersicht und ersetzen keine medizinische Beratung.

## Fehler Melden

Fehler und nachvollziehbare Problemberichte koennen an
[urobilanz@mailbox.org](mailto:urobilanz@mailbox.org) gesendet werden.
Web-App und SwiftUI-App koennen dafuer einen technischen Fehlerbericht
vorbereiten. CSV-Werte, Hinweise und Gesundheitsdaten werden nicht automatisch
aufgenommen.

## Web-App starten

Im Ordner `apps/web` kann die Datei `Start_Urinprotokoll.command` gestartet werden. Alternativ kann `index.html` direkt im Browser geoeffnet werden.

## macOS-App starten

Die gebaute App liegt hier:

`apps/macos-swift/build/UroBilanz.app`

Die Swift-App ist aktuell fuer Apple Silicon (`arm64`) und macOS 26 gebaut.

### ⚠️ Hinweis zur macOS-Sicherheitswarnung

> Beim ersten Oeffnen zeigt macOS moeglicherweise eine Warnung, da die App
> nicht mit einem kostenpflichtigen Apple Developer Account notarisiert ist.
>
> So oeffnest du die App trotzdem:
>
> 1. Rechtsklick auf die App-Datei.
> 2. **Oeffnen** waehlen.
> 3. Im erscheinenden Dialog **Trotzdem oeffnen** anklicken.
>
> Alternativ unter **Systemeinstellungen → Datenschutz & Sicherheit** ganz
> unten **Trotzdem oeffnen** bestaetigen.
>
> Diese Einschraenkung betrifft nur die macOS-App. Die Web-App laeuft im
> Browser ohne jede Signierung.

### ⚠️ macOS Security Warning

> When opening the app for the first time, macOS may display a warning because
> the app is not notarized with a paid Apple Developer account.
>
> To open the app anyway:
>
> 1. Right-click the app file.
> 2. Select **Open**.
> 3. Click **Open Anyway** in the dialog that appears.
>
> Alternatively, open **System Settings → Privacy & Security** and confirm
> **Open Anyway** at the bottom of the page.
>
> This limitation affects only the macOS app. The web app runs in the browser
> without any signing requirements.

## Eigene Themes

Ab Version `1.6.0-beta.1` koennen Web-App und SwiftUI-App eigene Themes im
JSON-Format importieren. Die Vorlage und Beispiele liegen hier:

- [Theme-Vorlage](docs/themes/urobilanz-theme-template.json)
- [Beispieltheme](docs/themes/example-custom-theme.json)
- [Theme-Dokumentation](docs/themes/README.md)

Eingebaute Themes koennen aus der App heraus als bearbeitbare JSON-Kopie
exportiert werden. Importierte Themes koennen wieder geloescht werden.

## Entwicklung pruefen

Der interne Pruefablauf baut die SwiftUI-App neu und kontrolliert beide
unterstuetzten CSV-Importwege:

```text
./verify_apps.sh
```

## Projektstruktur

```text
UroBilanz/
  apps/
    web/
      assets/js/core.js
      tests/core-smoke-test.js
    macos-swift/
      Sources/UroModels.swift
      Sources/UroCSVSupport.swift
      build_app.sh
      smoke_test.sh
  assets/
    icon/
  docs/
  verify_apps.sh
```

## Datenschutz

Echte CSV-, Excel- und Backup-Dateien mit persoenlichen Messdaten gehoeren nicht in dieses Repository. Die `.gitignore` ist so vorbereitet, dass solche Dateien nicht versehentlich aufgenommen werden.
