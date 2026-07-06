# UroBilanz - Naechste Schritte

Stand: 06.07.2026

Aktueller Hauptstand: `v1.7.3-beta.1`

Lokaler Entwicklungsstand: `v1.7.3-beta.1`.

Release-Einordnung: `v1.7.3-beta.1` ist ein kleines Wartungs-Beta der
1.7-Reihe mit klareren Sicherheitsabfragen und erweiterten Tests. Version 1.8
bleibt fuer Koerperdaten und die gemeinsame Koerper-/Fluessigkeitsanalyse
reserviert.

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

Die Vollpruefung von `v1.7.3-beta.1` war erfolgreich:

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

### Tabellen

- Gespeicherte Spaltenbreiten im Alltag beobachten.
- Bei der SwiftUI-App Tabellen in sehr kleinen Fenstern beobachten.

## Geplanter Neuer Schwerpunkt - v1.8.0-beta.1 Koerperdaten Und Gemeinsame Analyse

Version 1.8 ist als groesserer Schritt nach der PDF-/Berichtsfunktion in
Version 1.7 gedacht. Ziel ist eine klare Erweiterung von UroBilanz von einer
Fluessigkeitsanalyse zu einer kombinierten Koerper- und Fluessigkeitsanalyse,
ohne daraus eine allgemeine Gesundheits-App zu machen.

Leitprinzip:

- Getrennte Datenerfassung, gemeinsame Analyse.

Grundidee:

- Koerperdaten werden als eigener Hauptbereich innerhalb von UroBilanz
  umgesetzt, nicht als separate App.
- Erfassung und Verwaltung bleiben getrennt:
  - Fluessigkeit, Urin und Wasser.
  - Koerperdaten.
- Die Auswertung darf Daten gemeinsam darstellen, weil genau dort der Mehrwert
  entsteht.
- Bestehende Urin-/Wasserlogik darf nicht beschaedigt oder vermischt werden.

Geplanter Bereich Koerperdaten:

- Gewicht.
- BMI.
- Koerperfett.
- Koerperwasser beziehungsweise Wasseranteil.
- Muskelmasse oder magere Koerpermasse, falls sinnvoll verfuegbar.
- Messdatum und Uhrzeit.
- Optionale Notiz.

Datenquelle:

- Langfristig idealerweise Apple Health, weil Waagen-Apps wie Beurer ihre Daten
  bereits an Apple Health uebertragen koennen.
- Nicht direkt gegen die Beurer-App entwickeln.
- Apple Health als zentrale Datenquelle betrachten, damit UroBilanz unabhaengig
  vom Waagenhersteller bleibt.

Technischer Ansatz:

- Fuer die Web-App zunaechst keinen direkten Apple-Health-Zugriff einplanen.
- Fuer die SwiftUI-/macOS-App vor Umsetzung pruefen:
  - HealthKit beziehungsweise Apple Health als Datenquelle.
  - Ob HealthKit-Zugriff in der vorhandenen macOS-App moeglich und praktikabel
    ist.
  - Berechtigungen klar und verstaendlich erklaeren.
  - Nur lokal lesen.
  - Keine Cloud-Uebertragung.
  - Keine medizinischen Empfehlungen.
  - Datenschutz-Hinweise beibehalten.
- Falls HealthKit auf macOS nicht sinnvoll oder nicht verfuegbar nutzbar ist,
  zuerst einen CSV-Import fuer Koerperdaten vorbereiten.

Gemeinsame Analyse:

- Koerperdaten nicht in die bestehende Urin-/Wasser-Eingabe mischen.
- Eigener Bereich fuer Koerperdaten.
- Gemeinsame Auswertung in Diagrammen und Tabellen.
- Beispiel fuer kombinierte Tagesauswertung:

```text
Tag         Gewicht   Urin gesamt   Wasser getrunken
01.05.2026  82,4 kg      1.850 ml          2.200 ml
02.05.2026  83,1 kg      1.200 ml          2.100 ml
```

Muster, die neutral sichtbar gemacht werden koennen:

- Gewicht steigt, waehrend Urinmenge sinkt.
- Gewicht faellt, waehrend Urinmenge steigt.
- Trinkmenge bleibt gleich, aber Ausscheidung veraendert sich deutlich.

Keine Diagnose und keine medizinische Warnlogik:

- Nur neutrale Darstellung und Auswertung.
- Keine medizinische Bewertung oder Empfehlung.

Vor Umsetzung pruefen:

- Welche Koerperdaten Apple Health tatsaechlich liefert.
- Welche davon UroBilanz sinnvoll darstellen soll.
- Ob HealthKit-Zugriff in der vorhandenen SwiftUI-/macOS-App moeglich und
  praktikabel ist.
- Welche CSV-Struktur als Fallback fuer Web-App und manuelle Importe sinnvoll
  waere.
- Wie die neue Datenstruktur gespeichert wird, ohne bestehende Urin-/
  Wasserdaten zu veraendern.
- Welche Tests und Demo-Fixtures fuer Koerperdaten noetig sind.

Umsetzungsregeln fuer 1.8:

- Datenmodell vorab pruefen.
- Import-/Export-Kompatibilitaet sichern.
- Demo-Fixtures erstellen.
- Tests erweitern.
- README und Changelog aktualisieren.
- `verify_apps.sh` portabel halten.

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
