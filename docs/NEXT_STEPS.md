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
[`HISTORY.md`](HISTORY.md). Dauerhafte projektspezifische Regeln stehen in
[`PROJEKTREGELN.md`](PROJEKTREGELN.md); die allgemeinen Arbeits-, Git-,
Veroeffentlichungs- und Repository-Datenschutzregeln stehen in
[`../AGENTS.md`](../AGENTS.md).

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
- bei leeren Datenbestaenden eine optionale KI-Einstiegs-Hilfe mit lokal eingebundenen Logos, Bestaetigung vor dem Oeffnen, Link zur oeffentlichen sprachabhaengigen PDF-Handbuchseite und einem festen, datensparsamen Schritt-fuer-Schritt-Prompt anbieten

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
- Erweiterte Tests fuer Sprachumschaltung, Theme-Wechsel, geloeschte Messtage, geloeschte Eintraege und Exportbereinigung
- Xcode-Projekt mit getrennten Dev/Beta/Final-Bundle-IDs
- Einheitlicher Release-Paketbau ueber `Scripts/build-release-package.sh`

## Spaetere Idee - Optionaler Feinschliff

### Bedienung

- Sicherheitsabfragen sprachlich oder optisch weiter verbessern, falls noetig.
- Bei sehr vielen manuellen Eintraegen pruefen, ob die Tagesliste im Dialog noch angenehm bedienbar bleibt.
- Bei neuen sichtbaren Funktionen die deutschen und englischen PDF-Handbuecher unter `docs/output/pdf/` sowie `docs/manual/build_manuals.py` aktualisieren. Der aktuelle Referenzumfang umfasst alle sichtbaren Arbeitsablaeufe und Optionen der Web- und macOS-App; neue Funktionen duerfen diese Abdeckung nicht wieder einschraenken.

### Tabellen

- Gespeicherte Spaltenbreiten im Alltag beobachten.
- Bei der SwiftUI-App Tabellen in sehr kleinen Fenstern beobachten.

## Ideen Fuer Spaeter

- weitere Sprachen nach Deutsch und Englisch
- frei waehlbare Vergleichszeitraeume
- App-Store-Vorbereitung mit Xcode-Projekt, Ressourcenpaketen, Signierung und Datenschutztexten
- universeller Swift-Build fuer Intel nur falls wirklich benoetigt; aktuell ist Apple Silicon der dokumentierte native Zieltyp

## Pflege

Bei groesseren Aenderungen diese Datei zusammen mit `../PROJECT_CONTEXT.md`, `PROJEKTREGELN.md` und `HISTORY.md` aktualisieren. Erledigte Punkte entfernen oder nach `HISTORY.md` verschieben.
