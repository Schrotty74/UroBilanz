# UroBilanz - Naechste Schritte

Stand: 03.06.2026

Speicherort: `lokaler Backup-Ordner`

## Pflegehinweis

Diese Datei ist die Aufgabenliste fuer neue Chats. Erledigte Punkte sollen
entfernt oder als abgeschlossen dokumentiert werden. Neue Bugs, geplante
Verbesserungen und wichtige Ideen werden hier ergaenzt.

## Erledigt - Beta 4 kontrolliert

Die Lokalisierungsfassung wurde als neuer Hauptstand nach
`.` uebernommen.
Sie wurde als `v1.5.0-beta.4` auf GitHub veroeffentlicht.

Der Nutzer hat die Funktionen soweit praktisch möglich geprüft. Der dabei
gefundene Fehler im englischen SwiftUI-Eingabedialog wurde behoben.

Der alte Hauptstand liegt als kompaktes Meilenstein-Backup unter:

`lokale Projektsicherung`

## Prioritaet 1 - Bekannte offene Themen

### App-Icon

Optional spaeter mit Apples Icon Composer beziehungsweise Xcode als echtes
adaptives Liquid-Glass-Icon exportieren. Das betrifft vor allem die passende
Finder-Darstellung in Hell und Dunkel.

## Prioritaet 2 - Technischer Aufraeumdurchgang

Der technische Aufraeumdurchgang ist fuer `v1.5.0-beta.6` weitgehend erledigt.
Optik und Verhalten wurden nicht bewusst veraendert.

### Erledigt - bisheriger Aufraeumstand

- Web-App: CSV- und Datums-Hilfsfunktionen nach `assets/js/core.js`
  ausgelagert
- Web-App: Diagramm-Zeichenlogik nach `assets/js/charts.js` ausgelagert
- Web-App: Smoke-Tests fuer stabile Hilfslogik sowie Import, Ergaenzen, Export,
  manuelle Eingaben, Bearbeiten und Loeschen ergaenzt
- SwiftUI-App: Datenmodelle und CSV-Hilfsfunktionen in eigene Dateien
  aufgeteilt
- SwiftUI-App: Toolbar, Tabellen und Diagramme in eigene Dateien aufgeteilt
- SwiftUI-App: Import- und Workflow-Testansicht in eigene Datei ausgelagert
- SwiftUI-App: reproduzierbaren Build-, Import- und Workflowtest ergaenzt
- gemeinsamer Pruefablauf `verify_apps.sh` ergaenzt
- Original-Urinote-CSV und Tagesdaten-CSV mit jeweils `247 Messtagen`
  erfolgreich geprueft
- Manueller SwiftUI-Workflow fuer Hinzufuegen, Bearbeiten, Eintrag-Loeschen,
  Backup-CSV und Messtag-Loeschen erfolgreich geprueft
- Randfalltests fuer unvollstaendige Messtage und gemischte Wochen in Web-App
  und SwiftUI-App ergaenzt

### Optional spaeter fortsetzen

### Web-App

- Datenmodell, UI und Speicherlogik bei Bedarf weiter trennen
- Theme- und Sprachlogik bei Bedarf sauberer strukturieren
- Rendering bei Bedarf gezielter aktualisieren

### SwiftUI-App

- Export- und Merge-Logik bei Bedarf weiter trennen
- Tabellen und Diagramme bei weiteren Aenderungen effizient halten
- nur benoetigte Assets behalten
- automatisierte Tests optional weiter ausbauen, z.B. fuer Sprache, Themes und
  weitere Import-/Export-Randfaelle

Vorher und nachher pruefen:

- CSV laden
- CSV ergaenzen
- manuellen Eintrag erstellen
- Eintrag bearbeiten und loeschen
- Messtag loeschen
- Backup exportieren
- Tagesdaten exportieren
- Filter und Ansichten

## Bugs und Beobachtungsliste

- Sehr schmale Browserfenster koennen die Toolbar enger darstellen.
- SwiftUI besitzt noch keine umfassende automatisierte Testsuite.
- Der direkte Swift-Testmodus funktioniert fuer Original-Urinote-CSV und
  Tagesdaten-CSV. Eine umfassendere automatisierte Testsuite bleibt optional.

## Ideen fuer zukuenftige Entwicklungen

- weitere Themes nach Bedarf
- weitere Sprachen nach Deutsch und Englisch
- optional bessere Verlaufsvergleiche zwischen frei waehlbaren Zeitraeumen
- optional Druck- oder PDF-Bericht fuer Arzttermine
- optional App-Store-Vorbereitung mit Xcode-Projekt, Ressourcenpaketen,
  Signierung und Datenschutztexten
- optional universeller Swift-Build fuer Intel nur falls noch wirklich
  benoetigt; derzeit reicht Apple Silicon fuer den Nutzer

## Veroeffentlichungsregel

- Nie persoenliche CSV-, Excel- oder Gesundheitsdaten hochladen.
- GitHub-Aenderungen mit aussagekraeftigem `CHANGELOG.md` pflegen.
- Releases nur nach erfolgreichem lokalen Test und ausdruecklicher Freigabe.
- Vor jedem groesseren Schritt ein lokales Backup mit kurzer Zusammenfassung
  anlegen.
- Fuer zusaetzliche reine Projektbackups im stabilen Hauptstand
  `./backup_projekt.sh` verwenden.
