# UroBilanz

Native macOS-Version der UroBilanz-Auswertung mit SwiftUI.

## App

Die gebaute App liegt hier:

`build/UroBilanz.app`

Neu bauen und prüfen:

```text
./build_app.sh
./smoke_test.sh
```

## Technische Aufteilung

- `UroLocalization.swift`: Sprache und Übersetzungen
- `UroThemes.swift`: eingebaute und importierte Themes
- `UroNavigation.swift`: Hauptbereiche der App
- `UroDataModel.swift`: Import, Zusammenführung, Speicherung und Auswertung
- `UroMedicalReport.swift`: Arztbericht und PDF-Erzeugung
- `UrinprotokollSwiftUI.swift`: App-Einstieg und Hauptoberfläche

## Funktionen

- CSV laden
- Originale Urinote-CSV und Tagesdaten-CSV lesen
- Daten beim nächsten Start merken
- Daten löschen
- Backup-CSV exportieren
- Tagesdaten-CSV exportieren
- Arztbericht fuer einen waehlbaren Zeitraum als lokale PDF-Datei exportieren
- Dashboard, Jahr, Monat, Woche, Tag und Notizen
- Jahr- und Monatsfilter

## Design

Die App nutzt SwiftUI und auf macOS 26 die neue `glassEffect`-Darstellung. Auf älteren macOS-Versionen fällt sie auf systemnahes Material-Design zurück.

Das App-Symbol wird als geprüftes PNG und als fertige ICNS-Ressource geführt.
Der Build muss es daher nicht bei jedem Lauf erneut mit `iconutil` umwandeln.
