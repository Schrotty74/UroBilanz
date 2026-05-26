# UroBilanz

Native macOS-Version der UroBilanz-Auswertung mit SwiftUI.

## App

Die gebaute App liegt hier:

`build/UroBilanz.app`

## Funktionen

- CSV laden
- Originale Urinote-CSV und Tagesdaten-CSV lesen
- Daten beim nächsten Start merken
- Daten löschen
- Backup-CSV exportieren
- Tagesdaten-CSV exportieren
- Dashboard, Jahr, Monat, Woche, Tag und Notizen
- Jahr- und Monatsfilter

## Design

Die App nutzt SwiftUI und auf macOS 26 die neue `glassEffect`-Darstellung. Auf älteren macOS-Versionen fällt sie auf systemnahes Material-Design zurück.

Das App-Symbol basiert auf dem Entwurf `21B`: Liquid-Glass-Messbecher mit stärkerem Füllstand, Urin-/Wasserfarben und ruhigem Plus. Die vorbereiteten Light/Dark-Layer für Icon Composer liegen unter:

`../../assets/icon/liquid-glass-21B`

Solange Icon Composer/Xcode auf diesem Mac nicht installiert ist, nutzt die gebaute App die normale `.icns` als kompatiblen Fallback.
