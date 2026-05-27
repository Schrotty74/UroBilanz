# Changelog

Alle wichtigen Änderungen an UroBilanz werden hier dokumentiert.

## Unveröffentlicht

- Transparenzhinweis im README ergänzt: UroBilanz wurde gemeinsam mit OpenAI Codex entwickelt.

## 1.5.0-beta.1 - 2026-05-27

Vorabversion mit Theme-System, neuer Optik und mehreren Bedien-Verbesserungen für Web-App und SwiftUI-App.

### Neu

- Theme-Auswahl in beiden Apps ergänzt.
- Neue Designs ergänzt:
  - Classic Hell
  - Classic Dunkel
  - Dracula Night
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
