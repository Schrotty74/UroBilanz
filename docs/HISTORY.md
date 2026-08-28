# UroBilanz - Projekthistorie

Stand: 28.08.2026

Diese Datei archiviert abgeschlossene Versionen, Betas, Release Candidates,
Final-Releases und wichtige technische Meilensteine. Der detaillierte
Release-Changelog bleibt zusaetzlich in [`CHANGELOG.md`](../CHANGELOG.md)
erhalten.

## 1.7.4-beta.2 - 2026-08-28

- Web-App als installierbare PWA mit lokal eingebundenen Icons, Manifest und
  einem datensparsamen App-Shell-Cache bereitgestellt.
- Tagesansichten beider Apps erhalten eine lokale Suche nach sichtbaren Typen,
  Einzel- und Tageswerten, Uhrzeit und Hinweisen sowie einen Typfilter.
- Fehlende Filter-Uebersetzungen und eine doppelte Swift-Uebersetzung, die den
  App-Start abbrechen konnte, korrigiert.
- Web- und Swift-Smoke-Tests, Datenschutzcheck sowie die deutschen und
  englischen PDF-Handbuecher aktualisiert und geprueft.

## 2026-08-28 - Filter In Der Tagesansicht

- Web- und SwiftUI-App erhalten eine lokale Volltextsuche nach sichtbarem Typ,
  Einzel- und Tageswert, Uhrzeit und Hinweis sowie einen Filter fuer Urin,
  Wasser und Hinweise.
- Die Filter beschraenken nur die sichtbaren Messtage. Auswertungen, Berichte,
  Exporte und gespeicherte Daten bleiben unveraendert.
- Web- und Swift-Smoke-Tests pruefen die Filterlogik.

## 2026-08-27 - Installierbare Web-PWA

- Web-App um Manifest, lokale PWA-Icons und Service Worker erweitert.
- Der Service Worker speichert nur den App-Shell fuer den Offline-Start nach
  dem ersten Laden. CSV-Dateien, Exporte und persoenliche Browserdaten werden
  nicht zwischengespeichert.
- Web-Build und Smoke-Test pruefen PWA-Dateien und Offline-Schutzregeln.

## 2026-07-23 - Dokumentationsstruktur Fuer Neue Chats

- `PROJECT_CONTEXT.md` erhaelt eine feste Lesereihenfolge fuer neue Chats.
- `docs/NEXT_STEPS.md` wird auf tatsaechlich offene Punkte und realistische
  Folgeaufgaben beschraenkt; dauerhafte Regeln bleiben in
  `docs/PROJEKTREGELN.md`.
- `CHAT_TEMPLATE.md` wird als kurze Startvorlage ergaenzt. Sie enthaelt keine
  Versions-, Release-, Zugangs- oder personenbezogenen Details.

## 1.7.4-beta.1 - 2026-07-19

- Web- und SwiftUI-App zeigen bei noch leeren Datenbestaenden eine optionale
  Hilfe mit lokal eingebundenen ChatGPT-, Google-Gemini- und Claude-Logos.
- Nach einer Bestaetigung kopiert die App nur einen festen allgemeinen Prompt
  mit sprachabhaengigem Link zum oeffentlichen PDF-Handbuch und oeffnet danach
  den gewaehlten Dienst. Messwerte, Hinweise und andere Nutzerdaten bleiben
  lokal.
- Dienst-URLs, Prompt-Inhalt und deutsche/englische Dokumentationslinks sind
  durch Web- und Swift-Smoke-Tests abgesichert.
- Deutsche und englische 16-seitige PDF-Handbuecher als vollstaendige
  Bedienungsreferenz erstellt: Start, CSV-Import und Zusammenfuehren, lokale
  Speicherung, Eingabefelder, Ansichten, Auswertungsregeln, Backups,
  Arztbericht, Themes, Updates, KI-Hilfe, Datenschutz und Problemloesung.
- KI-Hilfe beider Apps verlinkt auf die oeffentlichen Seiten der
  sprachabhaengigen PDF-Handbuecher und benennt sie im kopierten Text als
  vollstaendige Referenz. Der Prompt folgt dem bewaehrten AppAtlas-Muster mit
  konkreten, UroBilanz-spezifischen Einstiegsschritten und einer Bestaetigung
  vor dem Kopieren und Oeffnen. Der Web-Ueber-
  Knopf steht ganz rechts in der Kopfzeile und verwendet die gleiche Darstellung
  wie die anderen Kopfzeilen-Schaltflaechen.

## 1.7.3 - 2026-07-18

- Final-Version auf Basis von `1.7.3-beta.2` veroeffentlicht.
- Discord-Links in beiden Kopfzeilen und der separate Web-Ueber-Knopf sind
  Teil des Final-Stands.

## 1.7.3-beta.2 - 2026-07-13

- Discord-Link in die Kopfzeilen von macOS- und Web-App integriert.
- Das Web-Ueber-Fenster ist ueber einen eigenen Knopf erreichbar.

## 2026-05-26 - Projektstart

- Projekt als privates GitHub-Repository `Schrotty74/UroBilanz` eingerichtet.
- Web-App, SwiftUI-App, Icon-Entwuerfe und Dokumentation in eine gemeinsame
  Projektstruktur gebracht.
- `.gitignore` ergaenzt, damit persoenliche CSV-, Excel- und Backup-Dateien
  nicht ins Repository gelangen.
- Datenschutz- und medizinischen Hinweis ergaenzt.

## 1.0.0 - 2026-05-26

- Erste GitHub-Release-Version vorbereitet und veroeffentlicht.
- Release-Downloads:
  - `UroBilanz-macOS-arm64-v1.0.0.zip`
  - `UroBilanz-Web-v1.0.0.zip`
- Grundstruktur:
  - portable Web-App fuer macOS, Windows und Linux.
  - native SwiftUI-App fuer Apple-Silicon-Macs.
  - lokale Auswertung von Urin- und Wasserprotokollen aus CSV-Dateien.
  - keine Cloud-Verarbeitung und keine medizinischen Empfehlungen.

## 1.5.0-beta.1 - 2026-05-27

Vorabversion mit Theme-System, neuer Optik und mehreren
Bedienungsverbesserungen fuer Web-App und SwiftUI-App.

### Themes und Darstellung

- Theme-Auswahl in beiden Apps ergaenzt.
- Neue Designs:
  - Classic Hell
  - Classic Dunkel
  - Violet Night
  - Liquid Dark
  - Medical Light
  - High Contrast
  - Sommer Look
  - Creme Salbei
- Theme-Farben auf Hintergrund, Karten, Tabellen, Diagramme, Konturen,
  Schatten und Glasflaechen erweitert.
- Diagrammfarben pro Theme ergaenzt.
- App-Symbol und In-App-Grafik im UroBilanz-Stil eingebunden.

### Web-App

- Theme-Auswahl statt reinem Light/Dark-Schalter eingebaut.
- Toolbar kompakter gestaltet.
- Tagesansicht horizontal scrollbar gemacht.
- Hinweise bleiben normale Textzellen ohne eigenen inneren Scrollbalken.
- Spaltenueberschriften stabilisiert und Urin-/Wasserbereiche farblich
  getrennt.
- Backup-CSV, Tagesdaten-CSV, CSV-Ergaenzung und manuelles Hinzufuegen
  beibehalten.
- Cache-Buster fuer CSS und JavaScript aktualisiert.

### SwiftUI-App

- Theme-Auswahl in die native App integriert.
- Theme-Menue fuer helle und dunkle Themes lesbar gemacht.
- Tabellen auf eine eigene SwiftUI-Darstellung umgestellt.
- Tabellen, Dashboard-Karten, Diagramme und Auffaelligkeiten optisch an die
  Themes angepasst.
- Jahresansicht wieder oben ausgerichtet.
- Navigation und Toolbar stabilisiert.

### Bewertung und Fehlerkorrekturen

- Auffaelligkeitslogik angepasst:
  - `niedrig` bei weniger als 800 ml Urin pro Messtag.
  - frueherer automatischer `hoch`-Wert ueber 2500 ml entfernt.
  - alle nicht niedrigen Messtage als `normal` gefuehrt.
- Dashboard von hohen auf normale Urin-Tage umgestellt.
- Medizinischen Hinweis an die neue Logik angepasst.
- Mehrere Darstellungsfehler in SwiftUI- und Web-Tabellen behoben.

### Geprueft

- Web-App JavaScript-Syntax.
- SwiftUI-App neu gebaut und signiert.
- Git-Diff und Git-Status kontrolliert.
- Keine persoenlichen Gesundheitsdaten aufgenommen.

## 1.5.0-beta.2 - 2026-05-28

- Eintragsmaske erweitert, damit Eintraege des gewaehlten Messtags sichtbar
  sind.
- Vorhandene Eintraege koennen bearbeitet oder einzeln geloescht werden.
- Schnelles Mehrfach-Erfassen mit `Hinzufuegen` und
  `Hinzufuegen & schliessen` ergaenzt.
- Tagesnotizen getrennt von Urin- und Wasserwerten als Hinweis-Eintraege
  behandelt.
- Urin, Wasser und Hinweis koennen ohne vorher geladene CSV getrennt erfasst
  werden.
- Mehrere manuelle Eintraege am selben Messtag ermoeglicht.
- Hinweise erzeugen keinen falschen 0-ml-Messtag mehr.
- Eintraege zwischen 00:00 und 05:59 bleiben dem vorherigen Messtag
  zugeordnet.
- SwiftUI-Tabellen starten bei wenigen Eintraegen wieder oben.
- Transparenzhinweis zu OpenAI Codex sowie zu Grafiken, Symbolen und App-Icons
  in der README ergaenzt.
- Dunkles Violett-Theme in `Violet Night` umbenannt.
- Web-App-Cache-Buster aktualisiert.

## 1.5.0-beta.3 - 2026-05-30

- Zuletzt verwendete Uhrzeit bleibt beim schnellen Mehrfach-Erfassen erhalten.
- Sicherheitsabfragen fuer das Loeschen einzelner Eintraege ergaenzt.
- Ganze Messtage koennen direkt in der Tagesansicht geloescht werden.
- Vor dem Loeschen eines Messtags erscheint eine Sicherheitsabfrage.
- Nach dem Loeschen werden Dashboard, Jahr, Monat, Woche, Tag und Notizen neu
  berechnet.
- SwiftUI-Jahreswerte im Filtermenue ohne Tausenderpunkt korrigiert.
- Getrennte Demo-Screenshots fuer Web-App und SwiftUI-App auf GitHub ergaenzt.

## 1.5.0-beta.4 - 2026-06-01

- Deutsch/Englisch-Lokalisierung fuer Web-App und SwiftUI-App ergaenzt.
- Sprache wird anhand der Systemsprache gewaehlt und kann manuell umgeschaltet
  werden.
- Sprachauswahl wird gespeichert.
- UI-Texte, Theme-Namen, Tabellen, Dashboard, Hinweise und Fehlermeldungen
  lokalisiert.
- Datums- und Zahlenanzeige an die gewaehlte Sprache angepasst.
- Web-Sprachdateien unter `apps/web/assets/i18n/` ergaenzt.
- SwiftUI-Eingabedialog an die aktuelle Sprache gebunden.
- Lokalisierungsfassung als neuer SwiftUI-Hauptstand uebernommen.
- Technische CSV-Struktur zur Kompatibilitaet unveraendert deutsch belassen.

## 1.5.0-beta.5 - 2026-06-02

- Auffaelligkeitsgrenze auf weniger als `700 ml` Urin pro Messtag praezisiert.
- Hinweise zur Auffaelligkeitsregel in Deutsch und Englisch aktualisiert.
- Unvollstaendige Randtage bleiben sichtbar und exportierbar, werden aber
  nicht als vollstaendige Messtage bewertet.
- Ein vollstaendiger Messtag benoetigt mindestens acht Stunden zwischen erstem
  und letztem Urin- oder Wasserwert.
- Jahr, Monat und Woche berechnen Summen, Durchschnitt und Anzahl nur aus
  vollstaendigen Messtagen.
- Neue Information `Unvollstaendige Tage` in den Zusammenfassungen ergaenzt.
- Tagesansicht und Dashboard kennzeichnen Randtage als `unvollstaendig`.
- Gemischte Zusammenfassungen zeigen beispielsweise
  `normal · 1 unvollstaendig`.

## 1.5.0-beta.6 - 2026-06-03

- Interner Aufraeum- und Refactoring-Durchgang ohne beabsichtigte
  Verhaltensaenderung.
- Web-App:
  - CSV- und Datums-Hilfen nach `assets/js/core.js` ausgelagert.
  - Diagrammzeichnung nach `assets/js/charts.js` ausgelagert.
  - Smoke- und Workflow-Tests erweitert.
- SwiftUI-App:
  - Modelle und CSV-Helfer in eigene Dateien aufgeteilt.
  - Toolbar, Tabellen und Diagramme ausgelagert.
  - Import- und Workflow-Testansicht nach `Sources/UroSmokeTests.swift`
    verschoben.
- Workflow-Tests pruefen Laden, manuelle Eingabe, Bearbeiten, einzelnes
  Loeschen, Backup-CSV und Messtag-Loeschen.
- Randfalltests fuer unvollstaendige Messtage und gemischte Wochen ergaenzt.
- Gemeinsamen Pruefablauf `verify_apps.sh` eingefuehrt.
- Beta 6 lokal gesichert und als GitHub-Pre-Release veroeffentlicht.

### Alltagstest

- Web-App und SwiftUI-App im Alltag funktional geprueft.
- Geprueft wurden:
  - manuelle Werte ohne geladene CSV.
  - mehrere Werte am selben Tag.
  - vergessene Uhrzeiten nachtragen.
  - einzelne Urin-, Wasser- und Hinweis-Eintraege bearbeiten und loeschen.
  - ganze Messtage loeschen.
  - Backup-CSV und Tagesdaten-CSV exportieren und wieder laden.
  - Deutsch/Englisch und Themes umschalten.
- Ergebnis: kein konkreter neuer Fehler und kein unmittelbarer
  Aenderungsbedarf.

## 1.5.0 Final - 2026-06-04

`v1.5.0-beta.6` wurde als Abschlusskandidat fuer `v1.5.0 Final` behandelt.
Version 1.5 wurde danach fuer neue groessere Funktionen geschlossen.

### Neu seit 1.0.0

- Lokalisierung Deutsch/Englisch.
- Manuelles Protokoll ohne CSV-Start.
- Urin, Wasser und Hinweise getrennt erfassen.
- Mehrere Werte pro Messtag.
- Einzelne Eintraege bearbeiten und loeschen.
- Ganze Messtage loeschen.
- Sicherheitsabfragen.
- Backup-CSV und Tagesdaten-CSV exportieren und wieder laden.
- Original-Urinote-CSV ergaenzend und ohne Duplikate importieren.
- Theme-Auswahl und verbesserte Themes.
- Demo-Screenshots und Projektdokumentation.

### Auswertung

- Bewertungslogik auf `unvollstaendig`, `niedrig` und `normal` umgestellt.
- Unvollstaendige Randtage aus Summen, Durchschnitt und Auffaelligkeiten
  ausgeschlossen, aber sichtbar gehalten.
- Tages-, Wochen-, Monats- und Jahresberechnung korrigiert.
- Unvollstaendige Tage in Wochen und Dashboard transparent dargestellt.
- Starre Hoch-Bewertung entfernt.

### Technik und Qualitaet

- Web-Hilfslogik und Diagrammzeichnung ausgelagert.
- SwiftUI-Modelle, CSV-Helfer, Toolbar, Tabellen, Diagramme und Tests
  aufgeteilt.
- Tests fuer Web, SwiftUI, beide CSV-Importwege, manuelle Kernablaeufe und
  Randfaelle erweitert.
- Gemeinsamen portablen Pruefablauf vorbereitet.

### Abschluss

- `CHANGELOG.md` mit zusammenfassendem Final-Eintrag ergaenzt.
- Lokale Final-Downloads unter `release/v1.5.0` erstellt.
- Lokale Projektsicherung erstellt.
- GitHub-Release `v1.5.0` nach ausdruecklicher Freigabe veroeffentlicht.

## 1.6.0-beta.1 - 2026-06-04

Benutzerdefinierte Themes wurden als erster Schwerpunkt der 1.6-Reihe
umgesetzt.

- Gemeinsames JSON-Format `urobilanz-theme` Version `1` definiert.
- Theme-Vorlage, Dokumentation und Beispielthemes unter `docs/themes/`
  ergaenzt.
- Beispielthemes `Alpen Morgen` und `Graphit Limette` hinzugefuegt.
- Web-App und SwiftUI-App koennen Theme-JSON importieren, validieren, lokal
  speichern und anwenden.
- Importierte Themes werden in der Theme-Auswahl angezeigt.
- Importierte Themes koennen als JSON exportiert werden.
- Theme-Auswahl, Import und Export in der Web-App in ein gemeinsames Menue
  zusammengefuehrt.
- Theme-Menue mit begrenztem Scrollbereich versehen.
- Schliessen und dauerhafte Anzeige der Import-/Export-Aktionen korrigiert.
- Kopfbereich-Buttons der Web-App angeglichen.
- Tests fuer gueltige und ungueltige Theme-Dateien ergaenzt.
- Import praktisch in beiden Apps geprueft.
- Planungszweig `v1.6.0-beta.1-plan` und
  `docs/THEME_IMPORT_PLAN.md` verwendet.
- Lokal gebaut, geprueft und als GitHub-Beta veroeffentlicht.

## 1.6.0-beta.2 - 2026-06-05

- Eingebaute Themes koennen als bearbeitbare JSON-Kopie exportiert werden.
- Importierte Themes koennen wieder geloescht werden; eingebaute Themes
  bleiben geschuetzt.
- Hinweise aus Urinote-CSV bleiben in der Tagesansicht an der passenden
  Urin-Uhrzeit ausgerichtet.
- Web-App verwendet lokale Messtag-Schluessel statt UTC-Schluessel fuer
  fruehe 05:xx-Eintraege.
- SwiftUI-Tagesansicht fuer fluessiges Scrollen optimiert.
- SwiftUI-Testmodus laeuft ohne AppKit-Fenster und vermeidet dadurch
  Absturzmeldungen bei automatischen Tests.
- Web- und Swift-Tests fuer die Uhrzeit-genaue Hinweiszuordnung erweitert.
- `./verify_apps.sh` erfolgreich ausgefuehrt.
- Web-App und SwiftUI-App im Alltag geprueft:
  - Theme-Export.
  - eingebaute Themes als Kopie.
  - importierte Themes loeschen.
  - Tagesansicht und Hinweise.
  - fluessiges Scrollen der SwiftUI-Tag-Ansicht.

## 1.6.0-beta.3 - 2026-06-07

- Bewertungsregeln als eigene Infoseite in beiden Apps ergaenzt.
- Theme-Vorlage und Beispieldateien auf der README-Startseite verlinkt.
- Neues Liquid-Balance-Day/Night-App-Symbol eingebunden.
- Finale randlose Icon-Variante in App, Dock, Finder und README verwendet.
- Swift-App-Bundle wird bei jedem Build frisch erstellt.
- Tabellenbreiten koennen direkt gezogen und pro Tabelle gespeichert werden.
- Beim Anpassen behalten Nachbarspalten ihre Breite und verschieben sich
  gemeinsam.
- SwiftUI-Regelboxen auf eine einheitliche Hoehe gebracht.
- `./verify_apps.sh`, Ziehgriffe und gespeicherte Web-Spaltenbreiten geprueft.
- Lokale Release-Dateien unter `release/v1.6.0-beta.3` erstellt.
- Lokale Projektsicherung fuer `v1.6.0-beta.3` erstellt.
- Vollstaendiges Projektbackup in iCloud erstellt.
- GitHub-Pre-Release `v1.6.0-beta.3` veroeffentlicht.

## 1.6.0-rc.1 - 2026-06-07

Erster Abschlusskandidat der 1.6-Reihe.

- Datenschutzfreundliche Funktion `Fehler melden` in Web-App und SwiftUI-App.
- Empfaenger: `urobilanz@mailbox.org`.
- Fehlerbeschreibung, Schritte und erwartetes Verhalten erfassbar.
- Bericht bleibt vor dem Senden sichtbar und bearbeitbar.
- Bericht als Textdatei oder E-Mail-Entwurf verfuegbar.
- Automatisch enthalten:
  - App-Version und App-Variante.
  - Ansicht, Sprache und Theme.
  - Systemumgebung.
- CSV-Werte, Hinweise und Gesundheitsdaten werden nicht automatisch
  aufgenommen.
- Offizielles GitHub-Invertocat neben dem App-Symbol verlinkt.
- Repository-Link im Fehlerbericht ergaenzt.
- Test-E-Mail erfolgreich empfangen.
- Beide Apps vollstaendig geprueft; Swift-App ohne Absturzmeldung gestartet.
- Lokale Release-Dateien unter `release/v1.6.0-rc.1` erstellt.
- Lokale Projektsicherung fuer `v1.6.0-rc.1` erstellt.
- Vollstaendiges Projektbackup in iCloud erstellt.
- GitHub-Pre-Release `v1.6.0-rc.1` veroeffentlicht.

## 1.6.0-rc.2 - 2026-06-07

Zweiter Abschlusskandidat der 1.6-Reihe.

- SwiftUI-App: klassischer Menueintrag `Ueber UroBilanz`.
- Version und Build werden dynamisch aus dem Bundle gelesen.
- Web-App: Klick auf das UroBilanz-Logo oeffnet ein zweisprachiges,
  Theme-abhaengiges Ueber-Modal.
- Entwickler in beiden Apps: Schrotty74, mit Unterstuetzung von
  OpenAI Codex.
- GPLv3, GitHub und Kontakt in beiden Ueber-Fenstern aufgefuehrt.
- README um Gatekeeper-Hinweis, Kontakt und GPLv3-Lizenz ergaenzt.
- Web-App-Starter beschleunigt und gegen einen bereits laufenden lokalen
  Server abgesichert.
- Python-Webserver bindet direkt an `127.0.0.1`.
- `verify_apps.sh` und Swift-Smoke-Test von persoenlichen absoluten
  Standardpfaden befreit.
- Kuenstliche Urinote- und Tagesdaten-Fixtures unter `docs/demo` ergaenzt.
- Portablen Pruefablauf im Projekt und aus einer frischen Checkout-Kopie unter
  `/tmp` erfolgreich ausgefuehrt.
- Vollstaendiger Release-Test fuer beide Apps erfolgreich.
- Web-Paketversion `1.6.0-rc.2`.
- macOS-App Version `1.6.0-rc.2`, Build `25`, Signatur geprueft.
- Lokale Release-Dateien unter `release/v1.6.0-rc.2` erstellt.
- Lokale Projektsicherung fuer `v1.6.0-rc.2` erstellt.
- Vollstaendiges Projektbackup in iCloud erstellt.
- GitHub-Pre-Release `v1.6.0-rc.2` veroeffentlicht.

## 1.6.0 Final - 2026-06-12

`v1.6.0-rc.2` wurde nach erfolgreicher Funktions-, Portabilitaets- und
Datenschutzpruefung als Abschlusskandidat fuer `v1.6.0 Final` uebernommen.

- Gesamte 1.6-Reihe mit benutzerdefinierten Themes abgeschlossen.
- Theme-Import, -Export und Loeschen in Web-App und SwiftUI-App enthalten.
- Bewertungsregeln, neues App-Symbol und frei speicherbare Tabellenbreiten
  enthalten.
- Hinweiszuordnung und SwiftUI-Performance korrigiert.
- Datenschutzfreundliche Fehlerberichte, GitHub-Link und Kontakt enthalten.
- Zweisprachige Ueber-Fenster mit Version, Entwickler und GPLv3 enthalten.
- Portablen Gesamtprueflauf mit kuenstlichen Repository-Fixtures etabliert.
- Projekthistorie, Zukunftsplanung und technischer Datenschutz-Check dauerhaft
  dokumentiert.
- Web-App Version `1.6.0`.
- macOS-App Version `1.6.0`, Build `26`.
- Vollstaendiger Prueflauf im Projekt und in einer frischen Checkout-Kopie
  erfolgreich.
- Release-Dateien unter `release/v1.6.0` erstellt und geprueft.
- Lokale Projektsicherung fuer `v1.6.0 Final` erstellt.
- Vollstaendiges Projektbackup in iCloud erstellt.
- GitHub-Final-Release `v1.6.0` veroeffentlicht.

## 1.7.0 Final - 2026-06-14

Abschluss der 1.7-Reihe mit Arztbericht und PDF-Ausgabe.

- Professionellen Arztbericht in Web-App und SwiftUI-App umgesetzt.
- Frei waehlbaren Zeitraum, Zusammenfassung, Tagesverlauf,
  Tagesuebersicht, optionale Tagesdetails, Hinweise und Bewertungsregeln
  aufgenommen.
- Festes neutrales A4-Layout unabhaengig vom aktiven App-Theme eingefuehrt.
- Lokalen PDF-Export in der SwiftUI-App und Druck-/PDF-Ansicht in der Web-App
  bereitgestellt.
- `Komplett-Backup` und `Tagesbackup` in einem gemeinsamen Menue
  zusammengefasst.
- Arztbericht und Theme-System der Web-App in eigene Module ausgelagert.
- SwiftUI-Code fuer Lokalisierung, Themes, Navigation und Datenmodell in
  getrennte Dateien aufgeteilt.
- Beide Apps mit dem portablen Gesamtprueflauf und der verbindlichen
  Final-Datenschutzpruefung kontrolliert.
- Web-App Version `1.7.0`.
- macOS-App Version `1.7.0`, Build `29`.

## 1.7.1 - 2026-06-15

Bugfix-Release fuer die SwiftUI-App.

- Unsichere Force-Unwraps in Messtagberechnung, PDF-Bericht und festen URLs
  entfernt.
- Datumsformatierer im Datenmodell statisch gecacht.
- macOS-App Version `1.7.1`, Build `30`.
- macOS-App erstmals als ZIP und DMG bereitgestellt.

## 1.7.2 - 2026-06-16

- Streak-Anzeige fuer aufeinanderfolgende Messtage in Web-App und SwiftUI-App
  ergaenzt.
- Wochen- und Monatsuebersicht mit Sparklines fuer Urin-Trends erweitert.
- Lokalen JSON-Export der Eintraege in Web-App und SwiftUI-App ergaenzt.
- Web-App Version `1.7.2`.
- macOS-App Version `1.7.2`, Build `31`.

## 1.7.3-beta.1 - 2026-07-06

- Sicherheitsabfragen fuer geloeschte Eintraege, geloeschte Messtage und
  importierte Themes in Web-App und SwiftUI-App praezisiert.
- Web-Smoke-Tests fuer Sprachumschaltung, Theme-Wechsel, geloeschte Eintraege,
  geloeschte Messtage und Exportbereinigung erweitert.
- Swift-Smoke-Tests fuer Lokalisierung, Theme-Auswahl, geloeschte Eintraege,
  geloeschte Messtage und Neuberechnung nach dem Loeschen erweitert.
- Beta-Release-Skript beim Erstellen des Beta-Commits korrigiert.
- Web-App Version `1.7.3-beta.1`.
- macOS-App Version `1.7.3-beta.1`, Build `32`.
- Vollstaendiger Prueflauf `./verify_apps.sh` erfolgreich.

## Groessere Technische Meilensteine

- Einheitliche Projektstruktur fuer Web-App und native SwiftUI-App.
- Projektgedaechtnis zunaechst auf vier Dateien festgelegt:
  `PROJECT_CONTEXT.md`, `docs/NEXT_STEPS.md`, `docs/PROJEKTREGELN.md` und
  `docs/HISTORY.md`.
- Lokale Verarbeitung ohne Upload persoenlicher Gesundheitsdaten.
- Kompatible Original-Urinote-CSV und Tagesdaten-CSV.
- Messtag von 06:00 bis 05:59 mit korrekter Zuordnung frueher Eintraege.
- Getrennte Urin-, Wasser- und Hinweis-Eintraege.
- Korrigierte Bewertung vollstaendiger und unvollstaendiger Messtage.
- Mehrsprachigkeit Deutsch/Englisch.
- Gemeinsames Theme-Format fuer Web und SwiftUI.
- Import, Export und Loeschen benutzerdefinierter Themes.
- Uhrzeit-genaue Zuordnung von Hinweisen.
- Persistente, frei einstellbare Tabellenbreiten.
- Automatische Web- und Swift-Smoke- sowie Workflow-Tests.
- Erweiterte automatische Tests fuer Sprache, Themes, Loeschfaelle und
  Exportbereinigung.
- Portabler Gesamtprueflauf mit Repository-Fixtures.
- Frisch gebautes, signiertes macOS-App-Bundle.
- Xcode-Projekt `UroBilanz.xcodeproj` mit sichtbarem Scheme `UroBilanz Dev`
  eingefuehrt.
- Dev, Beta und Final ueber getrennte Bundle-IDs separiert:
  `local.schrotty74.urobilanz.dev`, `local.schrotty74.urobilanz.beta` und
  `local.schrotty74.urobilanz`.
- Einheitlicher Release-Paketbau ueber `Scripts/build-release-package.sh`
  eingefuehrt; Web-ZIP, macOS-ZIP, macOS-DMG und SHA256-Dateien landen
  gemeinsam in `Backup/...` und `dist/...`.
- Datenschutzfreundlicher Fehlerbericht und Projektkontakt.
- GPLv3-Lizenzierung und transparente Codex-Unterstuetzung.
