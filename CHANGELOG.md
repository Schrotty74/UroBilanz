# Changelog

Alle wichtigen Änderungen an UroBilanz werden hier dokumentiert.

## Unveröffentlicht

- Noch keine Änderungen.

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
