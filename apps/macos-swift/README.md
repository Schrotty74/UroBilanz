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

DMG fuer Weitergabe erstellen:

```text
./build_dmg.sh
```

Die DMG enthaelt die App und einen `Applications`-Alias zum direkten
Hinueberziehen.

Development-Build mit getrennten lokalen Einstellungen bauen:

```text
UROBILANZ_BUILD_CHANNEL=dev ./build_app.sh
```

Dadurch entsteht `build/UroBilanz Dev.app` mit eigener Bundle-ID und eigenen
UserDefaults. Testdaten, Themes und Tabellenbreiten beeinflussen die normale App
nicht.

Beta-Build mit eigener Bundle-ID bauen:

```text
UROBILANZ_BUILD_CHANNEL=beta ./build_app.sh
```

Fuer Xcode gibt es das geteilte Scheme `UroBilanz Dev`. Beta und Final werden
ueber die Skripte im Projektordner erzeugt:

```text
Scripts/create-beta-from-dev.sh 1.8.0-beta.1
Scripts/publish-beta-as-final.sh 1.8.0
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
