# UroBilanz

UroBilanz ist eine lokale Auswertung fuer Urin- und Wasserprotokolle aus CSV-Dateien.

Das Projekt enthaelt zwei Apps:

- `apps/web`: portable Web-App fuer macOS, Windows und Linux im Browser.
- `apps/macos-swift`: native macOS-App mit SwiftUI fuer Apple-Silicon-Macs.

## Wichtig

UroBilanz ist ein Protokoll- und Auswertungstool. Es ist keine medizinische Diagnose-App und gibt keine medizinischen Empfehlungen.

Die Verarbeitung findet lokal statt. CSV-Dateien werden nicht hochgeladen.

## Web-App starten

Im Ordner `apps/web` kann die Datei `Start_Urinprotokoll.command` gestartet werden. Alternativ kann `index.html` direkt im Browser geoeffnet werden.

## macOS-App starten

Die gebaute App liegt hier:

`apps/macos-swift/build/UroBilanz.app`

Die Swift-App ist aktuell fuer Apple Silicon (`arm64`) und macOS 26 gebaut.

## Projektstruktur

```text
UroBilanz/
  apps/
    web/
    macos-swift/
  assets/
    icon/
  docs/
```

## Datenschutz

Echte CSV-, Excel- und Backup-Dateien mit persoenlichen Messdaten gehoeren nicht in dieses Repository. Die `.gitignore` ist so vorbereitet, dass solche Dateien nicht versehentlich aufgenommen werden.

