# UroBilanz - Naechste Schritte

Stand: 04.06.2026

Aktueller Hauptstand: `v1.5.0 Final`

Release-Einordnung: `v1.5.0 Final` schliesst die 1.5-Reihe ab. Version 1.5
soll nicht weiter funktional erweitert werden.

Projektordner:

`.`

Backup- und Kontextordner:

`lokaler Backup-Ordner`

## Zweck dieser Datei

Diese Datei ist die kurze Aufgabenliste fuer neue Chats. Sie soll nach groesseren
Aenderungen aktualisiert werden, damit ohne Informationsverlust weitergearbeitet
werden kann.

## Aktueller Stand

UroBilanz besteht aktuell aus zwei gepflegten Apps:

- Web-App unter `apps/web`
- SwiftUI-App unter `apps/macos-swift`

Beide Apps koennen:

- Original-Urinote-CSV laden
- Tagesdaten-CSV laden
- neue CSV ergaenzend importieren
- manuelle Urin-, Wasser- und Hinweis-Eintraege erfassen
- bestehende manuelle Eintraege bearbeiten und loeschen
- ganze Messtage aus der Tagesansicht loeschen
- Dashboard, Jahr, Monat, Woche, Tag und Notizen neu berechnen
- Backup-CSV und Tagesdaten-CSV exportieren
- Deutsch und Englisch anzeigen
- mehrere Themes nutzen

Die letzte lokale Vollpruefung fuer Beta 6 war erfolgreich:

- Web Smoke Tests
- Web Workflow Tests
- Swift Build
- Swift Smoke Tests
- Original-Urinote-CSV Import
- Tagesdaten-CSV Import
- Randfalltests fuer unvollstaendige Messtage und Wochen

## Erledigt Im Aktuellen Beta-6-Stand

- Lokalisierung Deutsch/Englisch in Web-App und SwiftUI-App ergaenzt
- englischen SwiftUI-Eingabedialog korrigiert
- leeren Start mit manueller Erfassung stabilisiert
- manuelle Eintraege koennen nachtraeglich bearbeitet und geloescht werden
- ganze Messtage koennen geloescht werden
- Sicherheitsabfragen fuer Loeschvorgaenge ergaenzt
- Tages-/Wochenbewertung fuer unvollstaendige Messtage korrigiert
- Bewertungslogik unterscheidet `unvollstaendig`, `niedrig` und `normal`
- Dashboard zeigt unvollstaendige Tage wieder als Auffaelligkeiten
- Web-App: CSV-/Datums-Hilfslogik nach `assets/js/core.js` ausgelagert
- Web-App: Diagrammzeichnung nach `assets/js/charts.js` ausgelagert
- Web-App: Smoke- und Workflow-Tests ergaenzt
- SwiftUI-App: Modelle, CSV-Helfer, Toolbar, Tabellen/Diagramme und Tests in
  eigene Dateien aufgeteilt
- gemeinsamer Pruefablauf `verify_apps.sh` ergaenzt
- Beta 6 lokal gesichert und auf GitHub als Pre-Release veroeffentlicht
- Beta 6 im Alltag funktional geprueft; aktueller Stand sieht gut aus

## Erledigt - v1.5.0 Final

`v1.5.0-beta.6` wurde als Abschlusskandidat fuer `v1.5.0 Final` behandelt.
Keine neuen groesseren Funktionen mehr in Version 1.5 aufnehmen.

Version 1.5 umfasst:

- Lokalisierung Deutsch/Englisch
- manuelles Protokoll
- Bearbeiten und Loeschen einzelner Eintraege
- Loeschen ganzer Messtage
- Bewertungskorrekturen fuer unvollstaendige Messtage
- Tests fuer Web-App und SwiftUI-App
- Refactorings in Web-App und SwiftUI-App

Final-Vorbereitung:

- `CHANGELOG.md` enthaelt einen zusammenfassenden Final-Eintrag fuer
  `v1.5.0`.
- Lokale Final-Downloads liegen unter
  `./release/v1.5.0`.
- Lokale Projektsicherung wurde erstellt.
- GitHub-Release fuer `v1.5.0` wurde nach ausdruecklicher Freigabe
  veroeffentlicht.

## Erledigt: Alltagstest Beta 6

- Web-App und SwiftUI-App wurden nach dem Beta-6-Stand im Alltag getestet.
- Funktional geprueft wurden insbesondere:
  - manuell neue Werte ohne geladene CSV erfassen
  - Werte am gleichen Tag mehrfach erfassen
  - vergessene Uhrzeiten nachtragen
  - einzelne Urin-/Wasser-/Hinweis-Eintraege bearbeiten
  - einzelne Eintraege loeschen
  - ganze Messtage loeschen
  - Backup-CSV exportieren und wieder laden
  - Tagesdaten-CSV exportieren und wieder laden
  - Deutsch/Englisch umschalten
  - Theme umschalten
- Ergebnis: aktuell kein konkreter neuer Fehler und kein unmittelbarer
  Aenderungsbedarf bekannt.

## Naechster Geplanter Schwerpunkt - Benutzerdefinierte Themes

Als neuer Entwicklungszweig `v1.6.0-beta.1` planen. Erst Format und Umfang
festlegen, nicht sofort bauen.

Ziel fuer Version 1.6:

- Theme-System erweitern, damit eigene Themes importiert werden koennen.
- Eine verstaendliche Theme-Vorlage bereitstellen.
- Web-App und SwiftUI-App moeglichst konsistent halten.
- Importformat definieren, zum Beispiel JSON fuer Farben, Glaswirkung, Schatten,
  Tabellenfarben und Diagrammfarben.
- Optional Theme-Export anbieten.
- Vor Umsetzung zuerst Format und Umfang festlegen, damit es nicht unnoetig
  kompliziert wird.

## Spaetere Idee - Optionaler Feinschliff

### Bedienung

- Eingabemaske weiter verfeinern, falls im Alltag noch Reibung auffaellt.
- Sicherheitsabfragen sprachlich oder optisch weiter verbessern, falls noetig.
- Bei sehr vielen manuellen Eintraegen pruefen, ob die Tagesliste im Dialog noch
  angenehm bedienbar bleibt.

### Tabellen

- Spaltenbreiten weiter nur nach konkretem Screenshot anpassen.
- Bei der Tag-Ansicht besonders auf `Hinweise`, `Auffaelligkeit` und `Aktion`
  achten.
- Bei der SwiftUI-App Tabellen in sehr kleinen Fenstern beobachten.

### Auswertung

- Aktuelle Regel:
  - unvollstaendige Messtage werden separat markiert
  - niedrige Werte werden nur bei vollstaendigen Messtagen bewertet
  - Wochen mit unvollstaendigen Tagen zeigen diese Information separat
- Falls gewuenscht spaeter eine kleine Infoseite ergaenzen, die diese Regeln
  in der App erklaert.

## Prioritaet 3 - Technische Verbesserungen Spaeter

### Web-App

- `app.js` bei Bedarf weiter aufteilen:
  - UI-Rendering
  - Speicherlogik
  - Import/Export
  - Sprache
  - Themes
- Automatische Tests optional erweitern fuer:
  - Sprachumschaltung
  - Theme-Wechsel
  - Import-/Export-Randfaelle
  - geloeschte Messtage
  - geloeschte Eintraege

### SwiftUI-App

- Export- und Merge-Logik bei Bedarf weiter auslagern.
- Theme- und Sprachlogik bei kuenftigen Aenderungen weiter ordnen.
- Automatische Tests optional erweitern fuer:
  - Sprachumschaltung
  - Theme-Wechsel
  - Export-Randfaelle
  - geloeschte Messtage
  - geloeschte Eintraege

## App-Icon

Optional spaeter mit Apples Icon Composer beziehungsweise Xcode als echtes
adaptives Liquid-Glass-Icon exportieren. Das betrifft vor allem die passende
Finder-Darstellung in Hell und Dunkel.

## Ideen Fuer Spaeter

- weitere Sprachen nach Deutsch und Englisch
- frei waehlbare Vergleichszeitraeume
- Druck- oder PDF-Bericht fuer Arzttermine
- App-Store-Vorbereitung mit Xcode-Projekt, Ressourcenpaketen, Signierung und
  Datenschutztexten
- universeller Swift-Build fuer Intel nur falls wirklich benoetigt; aktuell
  reicht Apple Silicon fuer den Nutzer

## Arbeitsregeln

- Keine persoenlichen CSV-, Excel- oder Gesundheitsdaten ins Repository.
- Vor groesseren Aenderungen lokales Backup erstellen.
- Keine UI- oder Code-Aenderungen ohne konkreten neuen Fehler oder ausdruecklich
  gewuenschte neue Funktion.
- Keine neuen groesseren Funktionen mehr in `v1.5`; neue Entwicklungsarbeit
  beginnt erst mit `v1.6.0-beta.1`.
- `CHANGELOG.md` bei GitHub-Releases aktualisieren.
- Releases nur nach erfolgreichem lokalen Test und ausdruecklicher Freigabe.
- Bei UI-Aenderungen nach Moeglichkeit Web-App und SwiftUI-App konsistent halten.
- Bei laengeren oder riskanten Aenderungen lieber in kleinen Schritten arbeiten.
