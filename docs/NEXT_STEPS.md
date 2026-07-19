# UroBilanz - Naechste Schritte

Stand: 19.07.2026

Aktueller Hauptstand: `v1.7.3`

Lokaler Entwicklungsstand: `v1.7.4-beta.1`.

Release-Einordnung: `v1.7.4-beta.1` prueft die datensparsame KI-Einstiegshilfe
mit dem vollstaendigen oeffentlichen Handbuch in beiden Apps. Der Final-Stand
bleibt `v1.7.3`.

## Zweck Dieser Datei

Diese Datei enthaelt nur Zukunft und offene Punkte: offene Aufgaben, Bugs,
geplante Verbesserungen, Prioritaeten und Ideen fuer spaetere Entwicklungen.
Der aktuelle Projektstand steht in [`../PROJECT_CONTEXT.md`](../PROJECT_CONTEXT.md).
Abgeschlossene Versionen und Meilensteine stehen dauerhaft in
[`HISTORY.md`](HISTORY.md). Dauerhafte Arbeitsregeln stehen in
[`PROJEKTREGELN.md`](PROJEKTREGELN.md).

## Aktueller Stand Kurz

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
- bei leeren Datenbestaenden eine optionale KI-Einstiegs-Hilfe mit lokal
  eingebundenen Logos, Bestaetigung vor dem Oeffnen, Link zur oeffentlichen
  sprachabhaengigen PDF-Handbuchseite und einem festen, datensparsamen
  Schritt-fuer-Schritt-Prompt anbieten

Die Vollpruefung fuer `v1.7.4-beta.1` war erfolgreich:

- Web Smoke Tests
- Web Workflow Tests
- Swift Build
- Swift Smoke Tests
- Original-Urinote-CSV Import
- Tagesdaten-CSV Import
- Randfalltests fuer unvollstaendige Messtage und Wochen
- Theme-Importtests
- Uhrzeit-genaue Hinweiszuordnung
- Portabler Lauf aus einer frischen Checkout-Kopie
- Arztbericht und lokaler PDF-Export
- Technische Modulaufteilung in Web und SwiftUI
- Erweiterte Tests fuer Sprachumschaltung, Theme-Wechsel, geloeschte
  Messtage, geloeschte Eintraege und Exportbereinigung
- Xcode-Projekt mit getrennten Dev/Beta/Final-Bundle-IDs
- Einheitlicher Release-Paketbau ueber `Scripts/build-release-package.sh`

## Spaetere Idee - Optionaler Feinschliff

### Bedienung

- Sicherheitsabfragen sprachlich oder optisch weiter verbessern, falls noetig.
- Bei sehr vielen manuellen Eintraegen pruefen, ob die Tagesliste im Dialog noch
  angenehm bedienbar bleibt.
- Bei neuen sichtbaren Funktionen die deutschen und englischen PDF-Handbuecher
  unter `docs/output/pdf/` sowie `docs/manual/build_manuals.py` aktualisieren.
  Der aktuelle Referenzumfang umfasst alle sichtbaren Arbeitsablaeufe und
  Optionen der Web- und macOS-App; neue Funktionen duerfen diese Abdeckung
  nicht wieder einschraenken.

### Tabellen

- Gespeicherte Spaltenbreiten im Alltag beobachten.
- Bei der SwiftUI-App Tabellen in sehr kleinen Fenstern beobachten.

## Ideen Fuer Spaeter

- weitere Sprachen nach Deutsch und Englisch
- frei waehlbare Vergleichszeitraeume
- App-Store-Vorbereitung mit Xcode-Projekt, Ressourcenpaketen, Signierung und
  Datenschutztexten
- universeller Swift-Build fuer Intel nur falls wirklich benoetigt; aktuell
  reicht Apple Silicon fuer den Nutzer

## Arbeitsregeln

- Keine persoenlichen CSV-, Excel- oder Gesundheitsdaten ins Repository.
- Vor jeder Final-Version, nicht vor Betas, den technischen Datenschutz-Check
  mit `./privacy_final_check.sh` und einer Laufzeitpruefung beider Apps
  wiederholen und `PRIVACY_CHECK.md` ergaenzen.
- Vor groesseren Aenderungen lokales Backup erstellen.
- Keine UI- oder Code-Aenderungen ohne konkreten neuen Fehler oder ausdruecklich
  gewuenschte neue Funktion.
- Keine neuen groesseren Funktionen mehr in `v1.5`; neue Entwicklungsarbeit
  beginnt erst mit `v1.6.0-beta.1`.
- `CHANGELOG.md` bei GitHub-Releases aktualisieren.
- Ab dem naechsten Build die macOS-App sowohl als ZIP als auch als DMG
  bereitstellen; die Web-App bleibt als ZIP.
- Release-Pakete nur noch ueber `Scripts/build-release-package.sh` erstellen;
  `apps/web/build_web.sh` ist nur ein internes Hilfsskript.
- Final-Backups kuenftig genau zweimal aufbewahren: eine lokale Kopie und eine
  iCloud-Kopie. Bei mehreren Final-Backups nur die neueste Final-Version
  behalten.
- Releases nur nach erfolgreichem lokalen Test und ausdruecklicher Freigabe.
- Bei UI-Aenderungen nach Moeglichkeit Web-App und SwiftUI-App konsistent halten.
- Bei laengeren oder riskanten Aenderungen lieber in kleinen Schritten arbeiten.
- Dev-/Beta-Tests getrennt von Final-Daten halten:
  - SwiftUI bei Bedarf mit `UROBILANZ_BUILD_CHANNEL=dev` bauen.
  - Web-App bei Bedarf mit `UROBILANZ_WEB_CHANNEL=dev` starten oder
    `index.html?channel=dev` oeffnen.
  - Final-Builds duerfen keine experimentellen Defaults, Themes oder
    Tabellenbreiten aus Dev-Tests uebernehmen.
