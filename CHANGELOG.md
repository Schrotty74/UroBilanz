# Changelog

Alle wichtigen Änderungen an UroBilanz werden hier dokumentiert.

## Unveröffentlicht

- Noch keine Änderungen.

## 1.7.3 - 2026-07-18

- Final-Version der Wartungsreihe 1.7.3 auf Basis von `1.7.3-beta.2`.
- Die nicht weiterverfolgte Planung fuer Koerperdaten aus dem Projektgedaechtnis
  entfernt.

## 1.7.3-beta.2 - 2026-07-13

- Das funktionslose App-Symbol in den Kopfzeilen von macOS- und Web-App durch
  einen direkten Link zur UroBilanz-Community auf Discord ersetzt. Das
  Ueber-Fenster der Web-App ist nun ueber einen eigenen Knopf erreichbar.

## 1.7.3-beta.1 - 2026-07-06

- Sicherheitsabfragen fuer geloeschte Eintraege, geloeschte Messtage und
  importierte Themes sprachlich praezisiert.
- Web- und Swift-Smoke-Tests fuer Sprachumschaltung, Theme-Wechsel,
  geloeschte Eintraege, geloeschte Messtage und Exportbereinigung erweitert.
- Beta-Release-Skript gegen einen geleerten Shell-Suchpfad beim Erstellen des
  Beta-Commits korrigiert.

## 1.7.2 - 2026-06-16

- Streak-Anzeige fuer Erfassungs-Kontinuitaet in Web-App und SwiftUI-App
  ergaenzt.
- Sparklines fuer Wochen- und Monatstrends in Web-App und SwiftUI-App
  ergaenzt.
- JSON-Export fuer Eintraege in Web-App und SwiftUI-App ergaenzt.

## 1.7.1 - 2026-06-15

Bugfix-Release fuer die SwiftUI-App:

- Moeglichen Absturz bei der Berechnung frueher 05:xx-Messtage durch sicheren
  Datums-Fallback verhindert.
- Force-Unwraps beim Erzeugen des PDF-Arztberichts entfernt.
- Wiederholt erzeugte Datumsformatierer als statische Caches umgesetzt.
- Force-Unwraps der festen Links im Ueber-Fenster entfernt.
- macOS-App erstmals zusaetzlich zur ZIP-Datei als DMG bereitgestellt.

## 1.7.0 Final - 2026-06-14

Finale Version der 1.7-Reihe. Sie fasst die Aenderungen aus
`1.7.0-beta.1` und `1.7.0-beta.2` zusammen und baut auf `1.6.0` auf.

### Arztbericht und PDF

- Web-App und SwiftUI-App um einen professionellen Arztbericht erweitert.
- Zeitraum fuer den Bericht frei waehlbar.
- Festes neutrales A4-Layout mit dezentem UroBilanz-Branding, unabhaengig vom
  aktiven App-Theme.
- Zusammenfassung, Tagesverlauf, Tagesuebersicht und Bewertungsregeln
  enthalten.
- Tagesdetails und Hinweise koennen optional ein- oder ausgeblendet werden.
- SwiftUI-App exportiert den Bericht direkt als lokale PDF-Datei.
- Web-App bietet eine entsprechende Druck- und PDF-Ansicht.
- Tagesverlaufsbalken in beiden Apps inhaltlich angeglichen und im Swift-PDF
  ohne instabilen AppKit-Bildkontext umgesetzt.
- Swift-PDF verwendet einen festen weissen Seitenhintergrund und bleibt damit
  auch bei aktivem macOS-Dunkelmodus gut lesbar.

### Bedienung und Backups

- `Komplett-Backup` und `Tagesbackup` in Web-App und SwiftUI-App in einem
  gemeinsamen Backup-Menue zusammengefasst.
- Web-App erhaelt wie die SwiftUI-App einen eigenen lokalen Build-Ordner.

### Technik und Tests

- Arztbericht als eigenes Web-Modul ausgelagert und mit Smoke-Tests
  abgesichert.
- Web-Theme-System aus `app.js` in ein eigenes getestetes Modul ausgelagert.
- SwiftUI-Lokalisierung, Themes, Navigation und Datenmodell in getrennte
  Dateien aufgeteilt.
- Swift-Build verwendet das gepruefte ICNS-App-Symbol direkt.
- Portabler Pruefablauf findet eine systemweite oder die mit Codex gelieferte
  Node.js-Laufzeit.
- Arztbericht, Backups, Hinweiszuordnung, Themes, CSV-Importe und bestehende
  Kernablaeufe gemeinsam in beiden Apps geprueft.

## 1.7.0-beta.2 - 2026-06-13

- Web-Theme-System aus `app.js` in ein eigenes, separat getestetes Modul
  ausgelagert.
- SwiftUI-Code fuer Lokalisierung, Themes, Navigation und Datenmodell aus der
  Hauptdatei in klar getrennte Dateien verschoben.
- Swift-Build verwendet das gepruefte ICNS-App-Symbol direkt und ist dadurch
  nicht mehr von einer erneuten `iconutil`-Konvertierung abhaengig.
- Portabler Pruefablauf findet neben einer systemweiten Node.js-Installation
  auch die mit Codex gelieferte Node-Laufzeit.
- Tagesverlaufsbalken im Swift-PDF ohne AppKit-Bildkontext umgesetzt, damit
  der Bericht auch in automatisierten Prueflaeufen stabil erzeugt wird.

## 1.7.0-beta.1 - 2026-06-13

- Web-App: erste gute Variante des Arztberichts umgesetzt.
- SwiftUI-App: nativen Arztbericht mit Zeitraumwahl und lokalem PDF-Export
  umgesetzt.
- Zeitraum fuer den Bericht frei waehlbar.
- Tagesdetails und Hinweise koennen fuer den Bericht ein- oder ausgeschaltet
  werden.
- Druckfertiges A4-Layout mit dezentem UroBilanz-Branding, Zusammenfassung,
  Tagesverlauf, Tagesuebersicht, optionalen Tagesdetails und
  Bewertungsregeln ergaenzt.
- SwiftUI-Arztbericht zeigt den Tagesverlauf wie der Web-Bericht mit gemeinsam
  skalierten Urin- und Wasserbalken.
- SwiftUI-PDF verwendet einen festen weissen Seitenhintergrund und bleibt
  dadurch auch in macOS-Vorschau im Dunkelmodus gut lesbar.
- Bericht verwendet feste neutrale Druckfarben und ist unabhaengig vom
  aktiven App-Theme.
- Beide Apps bieten Tagesdetails und Hinweise als optionale Berichtsinhalte.
- Arztbericht als eigenes Web-Modul ausgelagert und mit einem Smoke-Test
  abgesichert.
- Swift-Smoke-Test prueft ausdruecklich, dass der Tagesverlauf im
  Arztbericht enthalten ist.
- Backup und Tagesdaten in beiden Apps zu einem gemeinsamen Backup-Menue mit
  `Komplett-Backup` und `Tagesbackup` zusammengefasst.
- Web-App erhaelt wie die SwiftUI-App einen eigenen lokalen Build-Ordner.
- Arztbericht, Backups, Hinweiszuordnung, Themes und bestehende Kernablaeufe
  mit dem vollstaendigen Pruefablauf getestet.

## 1.6.0 Final - 2026-06-12

Finale Version der 1.6-Reihe. Sie fasst die Aenderungen aus
`1.6.0-beta.1` bis `1.6.0-rc.2` zusammen und baut auf `1.5.0` auf.

### Themes

- Benutzerdefinierte Themes koennen in Web-App und SwiftUI-App als JSON
  importiert, lokal gespeichert und angewendet werden.
- Gemeinsames Format `urobilanz-theme` Version `1` eingefuehrt.
- Theme-Vorlage, Dokumentation und Beispielthemes bereitgestellt.
- Eingebaute Themes koennen als bearbeitbare JSON-Kopie exportiert werden.
- Importierte Themes koennen exportiert und wieder geloescht werden.
- Theme-Menues, Scrollverhalten und Aktionsdarstellung in beiden Apps
  vereinheitlicht und stabilisiert.

### Darstellung und Bedienung

- Bewertungsregeln als eigene zweisprachige Infoseite ergaenzt.
- Neues Liquid-Balance-Day/Night-App-Symbol in Web-App, SwiftUI-App, Dock,
  Finder und README eingebunden.
- Tabellenbreiten koennen direkt angepasst und pro Tabelle lokal gespeichert
  werden; Nachbarspalten behalten dabei ihre Breite.
- SwiftUI-Regelboxen vereinheitlicht.
- Web-App-Starter beschleunigt und lokal an `127.0.0.1` gebunden.

### Daten und Auswertung

- Hinweise aus Urinote-CSV werden in Web-App und SwiftUI-App an der passenden
  Urin-Uhrzeit dargestellt.
- Fruehe 05:xx-Eintraege bleiben durch lokale Messtag-Schluessel korrekt dem
  Vortag zugeordnet.
- SwiftUI-Tagesansicht fuer fluessiges Scrollen optimiert.
- Bestehende Urin-, Wasser-, Hinweis-, Bewertungs- und Exportlogik aus Version
  1.5 unveraendert kompatibel gehalten.

### Projektinformationen und Kontakt

- Datenschutzfreundliche Fehlerberichte in beiden Apps ergaenzt.
- Berichte enthalten technische Angaben, aber keine automatisch uebernommenen
  CSV-Werte, Hinweise oder Gesundheitsdaten.
- Fehlerberichte koennen lokal gespeichert oder als bearbeitbarer
  E-Mail-Entwurf an `urobilanz@mailbox.org` vorbereitet werden.
- GitHub-Link und offizielles Invertocat neben dem App-Symbol ergaenzt.
- `Ueber UroBilanz` in der SwiftUI-App und als Web-Modal ergaenzt.
- Entwickler, Version, GPLv3, GitHub und Kontakt werden zweisprachig
  dargestellt.
- README um Gatekeeper-Hinweis, Kontakt, GPLv3 und den lokalen
  Datenschutzgrundsatz ergaenzt.

### Technik, Tests und Dokumentation

- Portablen Pruefablauf ohne persoenliche Standardpfade eingefuehrt.
- Kuenstliche Urinote- und Tagesdaten-Fixtures im Repository ergaenzt.
- Web- und Swift-Tests fuer Theme-Import, Hinweiszuordnung, Bewertung und
  manuelle Kernablaeufe erweitert.
- Projektgeschichte nach `docs/HISTORY.md` ausgelagert und
  `docs/NEXT_STEPS.md` auf aktuellen Stand und Zukunft reduziert.
- Technischen Datenschutz-Check unter `docs/PRIVACY_CHECK.md` dokumentiert.
- `.gitignore` fuer CSV-, Tabellen-, Backup-, Tagesdaten- und typische
  Gesundheitsdateien gehaertet.

### Geprueft

- Vollstaendiger Lauf von `./verify_apps.sh`.
- Web Smoke Tests und Workflow Tests.
- Swift Build, Signierung und Workflow Tests.
- Original-Urinote-CSV und Tagesdaten-CSV.
- Bewertungs-, Hinweis- und Theme-Randfaelle.
- Portabler Lauf aus einer frischen Checkout-Kopie.
- Lokaler Netzwerk-, Bundle-, Entitlement- und Abhaengigkeitscheck.

## 1.6.0-rc.2 - 2026-06-07

- SwiftUI-App: klassischen macOS-Menüeintrag `Über UroBilanz` mit einem
  zweisprachigen, zum aktiven Theme passenden Infofenster ergänzt. Version und
  Build werden dynamisch aus dem App-Bundle gelesen; Entwickler, GPLv3,
  GitHub und Kontakt sind direkt aufgeführt.
- Web-App: Klick auf das unveränderte UroBilanz-Logo öffnet ein
  zweisprachiges, zum aktiven Theme passendes Über-Modal mit zentral gepflegter
  Versionsnummer, Entwickler, GPLv3, GitHub und Kontakt.
- Prüfablauf portabel gemacht: `verify_apps.sh` und der Swift-Smoke-Test
  verwenden standardmäßig künstliche CSV-Fixtures aus dem Repository statt
  persönlicher absoluter Pfade. Optional angegebene fehlende Dateien führen zu
  einer verständlichen Fehlermeldung.
- Web-App-Starter beschleunigt und gegen einen bereits belegten lokalen Port
  abgesichert. Der Python-Webserver bindet direkt an `127.0.0.1`, wodurch die
  Oberfläche ohne die zuvor beobachtete Startverzögerung erscheint.
- README um zweisprachige Hinweise zur macOS-Gatekeeper-Warnung, Kontakt und
  GPLv3-Lizenz ergänzt.

## 1.6.0-rc.1 - 2026-06-07

- Web-App und SwiftUI-App: datenschutzfreundlichen Fehlerbericht ergaenzt.
  Nutzer koennen Problem, Schritte und erwartetes Verhalten beschreiben, den
  technischen Bericht vor dem Senden bearbeiten, als Textdatei speichern oder
  als E-Mail-Entwurf an `urobilanz@mailbox.org` vorbereiten.
- Fehlerberichte enthalten App-Version, App-Variante, Ansicht, Sprache, Theme
  und Systemumgebung, aber keine CSV-Werte, Hinweise oder Gesundheitsdaten.
- Web-App und SwiftUI-App: offizielles GitHub-Invertocat als Link zum
  UroBilanz-Repository neben dem App-Symbol ergaenzt; Repository-Link ebenfalls
  in Fehlerberichte aufgenommen.

## 1.6.0-beta.3 - 2026-06-07

- README-Startseite um direkte Links zur Theme-Vorlage, zum Beispieltheme und
  zur Theme-Dokumentation ergaenzt.
- Web-App und SwiftUI-App: Infoseite zu Bewertungsregeln ergaenzt. Die Seite
  erklaert Messtag, vollstaendige Tage, `niedrig`, `normal`,
  `unvollstaendig`, Wasserwerte und Hinweise.
- Web-App und SwiftUI-App: neues Liquid-Balance-Day/Night-App-Symbol
  eingebunden.
- App-Symbol: finale randlose Day/Night-Variante ohne separaten Aussenbereich
  eingebunden.
- SwiftUI-App: App-Bundle wird beim Bauen frisch erstellt, damit Finder und
  Dock keine alten Icon-/Versionsreste aus vorherigen Builds behalten.
- Web-App und SwiftUI-App: Tabellenbreiten lassen sich direkt am rechten Rand
  der Spaltenkoepfe anpassen und werden pro Tabelle automatisch gespeichert.
- Beim Anpassen einer Spalte behalten alle Nachbarspalten ihre Breite und
  verschieben sich wie in einer Tabellenkalkulation gemeinsam nach links oder
  rechts.
- SwiftUI-App: Infoboxen der Bewertungsregeln auf eine einheitliche Hoehe
  gebracht.

## 1.6.0-beta.2 - 2026-06-05

- Web-App und SwiftUI-App: eingebaute Themes koennen jetzt als bearbeitbare
  JSON-Kopie exportiert werden.
- Web-App und SwiftUI-App: importierte Themes koennen wieder geloescht werden;
  eingebaute Themes bleiben geschuetzt.
- Web-App und SwiftUI-App: Hinweis-Texte aus der Urinote-CSV bleiben in der
  Tagesansicht wieder an der passenden Urin-Uhrzeit ausgerichtet.
- Web-App: Messtage werden konsequent lokal statt per UTC-Schluessel
  zugeordnet, damit fruehe 05:xx-Eintraege korrekt beim Vortag bleiben.
- SwiftUI-App: Tagesansicht performanter gemacht; das Scrollen mit dem
  Scrollbalken ruckelt nicht mehr durch wiederholte Hinweis-Berechnungen.
- SwiftUI-App: Testmodus startet Import- und Workflow-Pruefungen ohne
  SwiftUI/AppKit-Fenster, damit die automatischen Tests keine macOS-
  Absturzmeldungen mehr ausloesen.
- Web-App: Workflow-Test fuer die Uhrzeit-genaue Hinweis-Zuordnung erweitert.
- SwiftUI-App: Smoke-Test fuer die Uhrzeit-genaue Hinweis-Zuordnung erweitert.

## 1.6.0-beta.1 - 2026-06-04

- Web-App und SwiftUI-App: benutzerdefinierte Themes als JSON-Datei importieren.
- Gemeinsames Theme-Format `urobilanz-theme` in Version `1` eingeführt.
- Theme-Vorlage, Beispieltheme und kurze Theme-Dokumentation unter
  `docs/themes/` ergänzt.
- Zwei zusätzliche Beispielthemes ergänzt: `Alpen Morgen` und
  `Graphit Limette`.
- Web-App: importierte Themes werden lokal im Browser gespeichert, in der
  Theme-Auswahl angezeigt und über CSS-Variablen angewendet.
- SwiftUI-App: importierte Themes werden lokal gespeichert, in der Theme-Auswahl
  angezeigt und über dieselbe Darstellungslogik wie eingebaute Themes
  angewendet.
- Web-App und SwiftUI-App: aktuell ausgewählte importierte Themes können wieder
  als JSON-Datei exportiert werden.
- Web-App: Theme-Auswahl, Theme-Import und Theme-Export in ein gemeinsames
  Dropdown-Menü zusammengeführt.
- Web-App: Theme-Menü bekommt einen eigenen begrenzten Scrollbereich, damit das
  Seitenfenster beim Scrollen nicht mitwandert.
- Web-App: Theme-Menü schliesst wieder zuverlässig und zeigt Import/Export
  dauerhaft unterhalb der scrollbaren Theme-Liste.
- Web-App: CSS-Regel ergänzt, damit das geschlossene Theme-Menü wirklich
  ausgeblendet wird.
- Web-App: Kopfbereich-Buttons angeglichen, damit `Eintrag` nicht deutlich
  kleiner als die CSV-Aktionen wirkt.
- Web- und Swift-Tests um gültige und ungültige Theme-Dateien erweitert.
- Importierte Themes in Web-App und SwiftUI-App praktisch geprüft.

## 1.5.0 Final - 2026-06-04

Finale Version der 1.5-Reihe. Diese Version fasst die Änderungen aus
`1.5.0-beta.1` bis `1.5.0-beta.6` zusammen und baut auf `1.0.0` auf.

### Neu seit 1.0.0

- Web-App und SwiftUI-App um Deutsch/Englisch-Lokalisierung ergänzt.
- Sprache wird automatisch anhand der Systemsprache gewählt und kann manuell
  zwischen Deutsch und Englisch umgeschaltet werden.
- Manuelles Protokoll ohne vorher geladenen CSV-Start ergänzt.
- Urin-, Wasser- und Hinweis-Einträge können getrennt erfasst werden.
- Mehrere Werte am selben Messtag können nacheinander erfasst werden.
- Bestehende Urin-, Wasser- und Hinweis-Einträge können bearbeitet und gelöscht
  werden.
- Ganze Messtage können aus der Tagesansicht gelöscht werden.
- Sicherheitsabfragen für das Löschen einzelner Einträge und ganzer Messtage
  ergänzt.
- Backup-CSV und Tagesdaten-CSV können exportiert und wieder geladen werden.
- Original-Urinote-CSV-Dateien können ergänzend importiert werden, ohne bereits
  vorhandene Einträge doppelt aufzunehmen.
- Theme-Auswahl in Web-App und SwiftUI-App ergänzt und die vorhandenen Themes
  optisch verbessert.
- Demo-Screenshots und Projektdokumentation ergänzt.

### Auswertung und Bewertung

- Bewertungslogik auf `unvollständig`, `niedrig` und `normal` umgestellt.
- Unvollständige Randtage bleiben in Tagesansicht und Exporten erhalten, werden
  aber nicht mehr als vollständige Messtage in Summen, Durchschnitt und
  Auffälligkeiten bewertet.
- Tages-, Wochen-, Monats- und Jahresberechnung korrigiert, damit nur
  vollständige Messtage in die Auswertung einfließen.
- Wochen mit unvollständigen Tagen zeigen diese Information separat an.
- Dashboard-Auffälligkeiten zeigen unvollständige Tage wieder transparent an.
- Die frühere starre Hoch-Bewertung wurde entfernt; nicht niedrige vollständige
  Messtage werden als `normal` geführt.

### Technik und Qualität

- Web-App: CSV- und Datums-Hilfslogik nach `assets/js/core.js` ausgelagert.
- Web-App: Diagrammzeichnung nach `assets/js/charts.js` ausgelagert.
- SwiftUI-App: Modelle, CSV-Helfer, Toolbar, Tabellen, Diagramme und
  Testansichten in eigene Dateien aufgeteilt.
- Tests erweitert für CSV-Hilfslogik, Web-Workflow, SwiftUI-Build,
  SwiftUI-Workflow, Original-Urinote-CSV-Import, Tagesdaten-CSV-Import und
  Randfälle mit unvollständigen Messtagen.
- Gemeinsamer Prüfablauf `verify_apps.sh` ergänzt.

### Geprüft

- Web Smoke Tests.
- Web Workflow Tests.
- Swift Build und Signierung.
- Swift Smoke Tests.
- Original-Urinote-CSV Import.
- Tagesdaten-CSV Import.
- Manuelle Kernabläufe mit Hinzufügen, Bearbeiten, Löschen und Messtag-Löschen.
- Randfalltests für unvollständige Messtage und Wochen.
- Funktionaler Alltagstest des Abschlusskandidaten `1.5.0-beta.6`.

## 1.5.0-beta.6 - 2026-06-03

- Interner Aufräumdurchgang ohne beabsichtigte Änderungen an Optik oder
  Verhalten fortgesetzt.
- Web-App: CSV- und Datums-Hilfsfunktionen nach `assets/js/core.js`
  ausgelagert.
- Web-App: Diagramm-Zeichenlogik nach `assets/js/charts.js` ausgelagert.
- Web-App: Smoke-Tests erweitert. Geprüft werden jetzt zusätzlich
  CSV-Ergänzung ohne Duplikate, manuelle Eingabe, Bearbeiten, Löschen,
  Backup-CSV und Tagesdaten-Import.
- SwiftUI-App: Datenmodelle und CSV-Hilfsfunktionen in eigene Quelldateien
  aufgeteilt.
- SwiftUI-App: Toolbar sowie Tabellen- und Diagramm-Ansichten in eigene
  Quelldateien ausgelagert.
- SwiftUI-App: Import- und Workflow-Testansicht nach `Sources/UroSmokeTests.swift`
  ausgelagert.
- SwiftUI-App: Workflow-Test ergänzt. Geprüft werden Laden, manuelle Eingabe,
  Bearbeiten, einzelnes Löschen, Backup-CSV und Messtag-Löschen.
- Web-App und SwiftUI-App: Randfalltests für unvollständige Messtage ergänzt.
  Geprüft wird, dass unvollständige Tage Summen und Durchschnitt nicht
  verfälschen und gemischte Wochen korrekt als `niedrig · unvollständig`
  gekennzeichnet werden.
- Gemeinsamen Prüfablauf `verify_apps.sh` ergänzt. Er prüft Web-Hilfslogik,
  JavaScript-Syntax, SwiftUI-Build, Signierung sowie den Import von
  Original-Urinote-CSV, Tagesdaten-CSV und die manuellen Kernabläufe.

## 1.5.0-beta.5 - 2026-06-02

- Web-App und SwiftUI-App: Auffälligkeitsregel präzisiert. Ein Messtag wird als
  `niedrig` markiert, wenn innerhalb des Messtags weniger als `700 ml` Urin
  erfasst wurden.
- Web-App und SwiftUI-App: Hinweise zur Auffälligkeitsregel in Deutsch und
  Englisch aktualisiert.
- Web-App und SwiftUI-App: Unvollständige Randtage einer Messreihe bleiben in
  Protokollansichten und Exporten erhalten, werden aber nicht mehr als
  vollständige 24-Stunden-Messtage in Dashboard-Kennzahlen, Diagrammen und
  Auffälligkeiten bewertet. Als vollständiger Messtag gilt ein Zeitraum mit
  mindestens acht Stunden Abstand zwischen erstem und letztem Eintrag.
- Web-App und SwiftUI-App: Jahr, Monat und Woche berechnen Summen,
  Durchschnitt und Anzahl nur noch aus vollständigen Messtagen. Eine neue
  Spalte `Unvollständige Tage` macht nicht bewertete Randtage transparent.
- Web-App und SwiftUI-App: Tagesansicht und Dashboard-Auffälligkeiten zeigen
  unvollständige Randtage ausdrücklich als `unvollständig` an.
- Web-App und SwiftUI-App: Zusammenfassungen mit vollständigen und
  unvollständigen Tagen kennzeichnen beide Informationen gemeinsam, zum
  Beispiel als `normal · 1 unvollständig`.

## 1.5.0-beta.4 - 2026-06-01

- Web-App und SwiftUI-App: Deutsch/Englisch-Lokalisierung ergänzt.
- Web-App und SwiftUI-App: Sprache wird automatisch anhand der Systemsprache gewählt und kann manuell zwischen Deutsch und Englisch umgeschaltet werden.
- Web-App und SwiftUI-App: Sprachauswahl wird gespeichert.
- Web-App und SwiftUI-App: UI-Texte, Theme-Namen, Tabellenüberschriften, Dashboard-Texte, Hinweise und Fehlermeldungen lokalisiert.
- Web-App und SwiftUI-App: Datums- und Zahlenanzeige an die gewählte Sprache angepasst.
- Web-App: Sprachdateien unter `apps/web/assets/i18n/` ergänzt.
- SwiftUI-App: Eingabedialog übernimmt die aktuell gewählte Sprache zuverlässig.
- SwiftUI-App: Lokalisierungsfassung als neuer Hauptstand übernommen.
- Technische CSV-Struktur bleibt unverändert deutsch, damit bestehende Backups und Importe kompatibel bleiben.

## 1.5.0-beta.3 - 2026-05-30

- Web-App und SwiftUI-App: Beim schnellen Mehrfach-Erfassen bleibt die zuletzt verwendete Uhrzeit nach `Hinzufügen` erhalten. Beim Öffnen der Eingabemaske wird weiterhin die aktuelle Uhrzeit eingesetzt.
- Web-App und SwiftUI-App: Einzelne Urin-, Wasser- und Hinweis-Einträge können im Eingabe-Menü nur nach Sicherheitsabfrage gelöscht werden.
- Web-App und SwiftUI-App: Ganze Messtage können direkt in der Tagesansicht gelöscht werden.
- Web-App und SwiftUI-App: Vor dem Löschen eines Messtags erscheint eine klare Sicherheitsabfrage.
- Web-App und SwiftUI-App: Nach dem Löschen eines Messtags werden Dashboard, Jahr, Monat, Woche, Tag und Notizen neu berechnet.
- SwiftUI-App: Jahreswerte im Filtermenü werden wieder korrekt als `2024`, `2025` und `2026` ohne Tausenderpunkt angezeigt.
- GitHub-Dokumentation: getrennte Demo-Screenshots für Web-App und SwiftUI-App ergänzt und auf der Startseite eingebunden. Die Bilder enthalten ausschließlich Demo-Daten.

## 1.5.0-beta.2 - 2026-05-28

- Web-App und SwiftUI-App: Eintragsmaske erweitert, damit Einträge am gewählten Messtag sichtbar sind.
- Web-App und SwiftUI-App: vorhandene Einträge können aus der Eingabemaske heraus bearbeitet oder einzeln gelöscht werden.
- Web-App und SwiftUI-App: schnelles Mehrfach-Erfassen ergänzt; `Hinzufügen` bleibt offen, `Hinzufügen & schließen` beendet die Eingabe.
- Web-App und SwiftUI-App: Tagesnotizen/Hinweise werden getrennt von Urin- und Wasserwerten als eigene Hinweis-Einträge behandelt.
- Transparenzhinweis im README ergänzt: UroBilanz wurde gemeinsam mit OpenAI Codex entwickelt.
- Transparenzhinweis erweitert: Grafiken, Symbole und App-Icons wurden für dieses Projekt mit Unterstützung von OpenAI Codex erstellt.
- Dunkles Violett-Theme in `Violet Night` umbenannt und technische Theme-Kennung entsprechend angepasst.
- Manuelle Eingabe erweitert: Urin, Wasser und Hinweis können getrennt erfasst werden, auch wenn vorher keine CSV geladen wurde.
- Manuelle Web-Einträge werden zuverlässig angehängt und nicht mehr durch den Dubletten-Filter für CSV-Ergänzungen blockiert.
- Manuelle SwiftUI-Einträge verhalten sich jetzt wie in der Web-App und erlauben mehrere Einträge am selben Messtag.
- Hinweis-Einträge werden als Hinweis geführt und erzeugen keinen eigenen falschen 0-ml-Messtag mehr.
- Einträge zwischen 00:00 und 05:59 bleiben beim manuellen Hinzufügen korrekt dem vorherigen Messtag zugeordnet.
- SwiftUI-Tabellen in Monat, Woche und Tag starten bei wenigen Einträgen wieder oben statt mittig im freien Bereich.
- Web-App JavaScript-Cache-Buster aktualisiert, damit Browser die neue manuelle Eingabelogik sicher laden.

## 1.5.0-beta.1 - 2026-05-27

Vorabversion mit Theme-System, neuer Optik und mehreren Bedien-Verbesserungen für Web-App und SwiftUI-App.

### Neu

- Theme-Auswahl in beiden Apps ergänzt.
- Neue Designs ergänzt:
  - Classic Hell
  - Classic Dunkel
  - Violet Night
  - Liquid Dark
  - Medical Light
  - High Contrast
  - Sommer Look
  - Creme Salbei
- Creme-Salbei-Design auf Basis der gewünschten warmen Creme-, Salbei- und Braunwerte ergänzt.
- Sommer-Look wärmer, frischer und weniger weiß gestaltet.
- Theme-Farben wirken jetzt nicht nur auf den Hintergrund, sondern auch auf Karten, Tabellen, Diagramme, Konturen, Schatten und Glasflächen.
- Diagrammfarben pro Theme ergänzt, damit Urin und Wasser besser unterscheidbar bleiben.
- App-Symbol und In-App-Grafik im UroBilanz-Stil mit Glas-Kachel-Darstellung eingebunden.

### Web-App

- Theme-Auswahl statt reinem Light/Dark-Schalter eingebaut.
- Web-App-Design stärker an die zuletzt bevorzugte UroBilanz-Darstellung angepasst.
- Toolbar kompakter gemacht: Navigation, Status, Filter, Export und Speicheroptionen nehmen weniger Höhe ein.
- Tagesansicht überarbeitet:
  - Tabelle kann horizontal gescrollt werden.
  - Hinweise bleiben normale Textzellen und bekommen keinen eigenen inneren Scrollbalken.
  - Spaltenüberschriften bleiben einzeilig und werden nicht mehr unschön zweizeilig.
  - Urin- und Wasserbereiche bleiben farblich getrennt.
- Backup-CSV und Tagesdaten-CSV bleiben direkt erreichbar.
- CSV-Ergänzung bleibt erhalten, damit aus einer neueren Original-Urinote-CSV nur neue Einträge übernommen werden können.
- Manuelles Hinzufügen einzelner Urin- oder Wasserwerte bleibt erhalten.
- Cache-Buster für CSS und JavaScript aktualisiert, damit der Browser nach Änderungen zuverlässig die neue Version lädt.

### SwiftUI-App

- Theme-Auswahl in die native App integriert.
- Theme-Menü sichtbar und lesbar gemacht, unabhängig davon ob ein helles oder dunkles Theme aktiv ist.
- Tabellen auf eine eigene SwiftUI-Darstellung umgestellt, damit Farben, Zeilen und Kontraste passend zum Theme bleiben.
- Tabellen in Jahr, Monat, Woche, Tag, Notizen und Dashboard optisch an die jeweiligen Themes angepasst.
- Jahresansicht wieder oben ausgerichtet.
- Navigation und Toolbar stabilisiert, nachdem frühere Layout-Anpassungen in einzelnen Ansichten zu falscher Ausrichtung führen konnten.
- Wochenansicht und gruppierte Tabellen zeigen Auffälligkeiten jetzt einheitlich.
- Dashboard-Karten, Diagramme und Auffälligkeiten optisch kompakter und konsistenter gemacht.
- App-Icon in der Kopfzeile größer und sauberer mit Glas-Kachel-Effekt dargestellt.

### Geändert

- Auffälligkeitslogik angepasst:
  - `niedrig` bleibt bei weniger als 800 ml Urin pro Messtag.
  - Der frühere automatische `hoch`-Wert über 2500 ml wurde entfernt.
  - Alle nicht niedrigen Messtage werden als `normal` geführt.
- Grund: Die historischen Protokolle nutzen nicht durchgehend denselben Messzeitraum. Ältere Werte wurden zeitweise anders gezählt als die spätere 06:00-bis-05:59-Messung, daher wäre eine starre Hoch-Grenze über alle Jahre hinweg irreführend.
- Dashboard-Kennzahl von hohen Urin-Tagen auf normale Urin-Tage umgestellt.
- Medizinischer Hinweis in der Web-App an die neue Logik angepasst.

### Behoben

- SwiftUI: Theme-Auswahl war bei manchen Themes kaum lesbar.
- SwiftUI: Tabellen wirkten bei hellen und dunklen Themes farblich uneinheitlich.
- SwiftUI: Wochenansicht konnte nach Theme-Experimenten Navigation und Bedienung verlieren.
- SwiftUI: Jahresansicht war mittig statt oben ausgerichtet.
- Web-App: Tagesansicht konnte Hinweise am rechten Rand abschneiden.
- Web-App: Einzelne Spaltenüberschriften wurden durch zu enge Breiten unsauber getrennt.
- Web-App und SwiftUI-App: Diagrammfarben im Creme-Salbei-Theme wurden stärker getrennt.

### Geprüft

- Web-App JavaScript-Syntaxprüfung.
- SwiftUI-App neu gebaut und signiert.
- Git-Diff auf Leerzeichen-/Patchfehler geprüft.
- Git-Status geprüft, damit keine persönlichen CSV-, Excel- oder Gesundheitsdaten ins Repository aufgenommen werden.

## 1.0.0 - 2026-05-26

- Erste GitHub-Release-Version vorbereitet.
- Release-Downloads:
  - `UroBilanz-macOS-arm64-v1.0.0.zip`
  - `UroBilanz-Web-v1.0.0.zip`

## 2026-05-26

- Projekt als privates GitHub-Repository `Schrotty74/UroBilanz` eingerichtet.
- Web-App, SwiftUI-App, Icon-Entwürfe und Dokumentation in eine gemeinsame Projektstruktur gebracht.
- `.gitignore` ergänzt, damit persönliche CSV-/Excel-/Backup-Dateien nicht ins Repository gelangen.
- Datenschutz- und medizinischen Hinweis ergänzt.
