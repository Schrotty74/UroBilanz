# UroBilanz - Naechste Schritte

Stand: 07.06.2026

Aktueller Hauptstand: `v1.6.0-rc.2`

Release-Einordnung: `v1.6.0-rc.2` ist der zweite Abschlusskandidat der
1.6-Reihe mit benutzerdefinierten Themes. Version 1.5 bleibt abgeschlossen.

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

## Erledigt - v1.6.0-beta.1 Benutzerdefinierte Themes

`v1.6.0-beta.1` wurde vorbereitet und als Beta veroeffentlicht.

Planungsstand:

- Entwicklungszweig: `v1.6.0-beta.1-plan`
- Planungsdatei im Projekt:
  `./docs/THEME_IMPORT_PLAN.md`
- Umsetzung fuer `v1.6.0-beta.1` lokal gebaut und geprueft.
- GitHub-Release fuer `v1.6.0-beta.1` veroeffentlicht.

Ziel fuer Version 1.6:

- Theme-System erweitern, damit eigene Themes importiert werden koennen.
- Eine verstaendliche Theme-Vorlage bereitstellen.
- Web-App und SwiftUI-App moeglichst konsistent halten.
- Importformat definieren, zum Beispiel JSON fuer Farben, Glaswirkung, Schatten,
  Tabellenfarben und Diagrammfarben.
- Optional Theme-Export anbieten.
- Vor Umsetzung zuerst Format und Umfang festlegen, damit es nicht unnoetig
  kompliziert wird.

Umgesetzt:

- Gemeinsames JSON-Format `urobilanz-theme` Version `1`.
- Theme-Vorlage und Beispielthemes unter `docs/themes/`.
- Web-App: Theme-JSON importieren, validieren, lokal speichern und anwenden.
- SwiftUI-App: Theme-JSON importieren, validieren, lokal speichern und anwenden.
- Web-App und SwiftUI-App: importierte Themes als JSON exportieren.
- Web-App und SwiftUI-App: eingebaute Themes als bearbeitbare JSON-Kopie
  exportieren.
- Web-App und SwiftUI-App: importierte Themes wieder loeschen.
- Web-App: Theme-Auswahl, Import und Export in ein gemeinsames Theme-Menue
  zusammengefuehrt.
- Tests fuer gueltige und ungueltige Theme-Dateien ergaenzt.
- Praktischer Importtest in Web-App und SwiftUI-App erfolgreich.

## Erledigt - v1.6.0-beta.2 Theme-Export Und Hinweis-Fixes

`v1.6.0-beta.2` wurde nach Alltagstest vorbereitet.

Umgesetzt:

- Web-App und SwiftUI-App: eingebaute Themes koennen als bearbeitbare
  JSON-Kopie exportiert werden.
- Web-App und SwiftUI-App: importierte Themes koennen wieder geloescht werden.
- Web-App und SwiftUI-App: Hinweise aus Urinote-CSV bleiben in der Tagesansicht
  an der passenden Urin-Uhrzeit ausgerichtet.
- Web-App: lokale Messtag-Schluessel statt UTC-Schluessel fuer stabile
  Zuordnung von fruehen 05:xx-Eintraegen.
- SwiftUI-App: Tagesansicht performanter gemacht; Scrollen mit dem Balken ist
  wieder fluessig.
- SwiftUI-App: Import-/Workflow-Testmodus startet ohne SwiftUI/AppKit-Fenster,
  damit automatische Tests keine macOS-Absturzmeldungen mehr erzeugen.
- Web- und Swift-Tests fuer die Uhrzeit-genaue Hinweis-Zuordnung erweitert.

Geprueft:

- `./verify_apps.sh` erfolgreich.
- Web-App und SwiftUI-App im Alltag kurz geprueft; erster Blick sieht gut aus.
- Alltagstest fuer `v1.6.0-beta.2` erledigt:
  - Web-App und SwiftUI-App normal benutzt.
  - Theme-Export geprueft.
  - eingebaute Themes als bearbeitbare Kopie exportiert.
  - importierte Themes geloescht.
  - Tagesansicht mit Hinweisen in Web-App und SwiftUI-App beobachtet.
  - SwiftUI-Tag-Ansicht scrollt wieder fluessig.
- Web-App und SwiftUI-App: Infoseite `Regeln` zu Bewertungsregeln ergaenzt.
- Web-App und SwiftUI-App: neues Liquid-Balance-Day/Night-App-Symbol
  eingebunden.
- Web-App und SwiftUI-App: Spaltenbreiten koennen direkt in den Tabellen
  angepasst werden; die persoenlichen Breiten bleiben automatisch gespeichert.
- Web-App und SwiftUI-App: Nachbarspalten behalten beim Anpassen ihre Breite
  und werden nur gemeinsam verschoben.
- SwiftUI-App: Infoboxen der Bewertungsregeln einheitlich hoch dargestellt.

## Erledigt - v1.6.0-beta.3 Regeln, App-Symbol Und Tabellenbreiten

`v1.6.0-beta.3` wurde am 07.06.2026 vorbereitet und als Beta veroeffentlicht.

Umgesetzt:

- Bewertungsregeln als eigene Infoseite in Web-App und SwiftUI-App.
- Theme-Vorlage und Beispieldateien auf der Projektstartseite direkt verlinkt.
- Neues Day/Night-App-Symbol in Web-App, SwiftUI-App, Dock, Finder und README.
- Swift-App-Bundle wird bei jedem Build frisch erstellt.
- Tabellenbreiten koennen in Web-App und SwiftUI-App direkt gezogen werden.
- Persoenliche Spaltenbreiten werden pro Tabelle automatisch gespeichert.
- Nur die gezogene Spalte aendert ihre Breite; Nachbarspalten behalten ihre
  Breite.
- SwiftUI-Regelboxen auf eine einheitliche Hoehe gebracht.

Geprueft:

- `./verify_apps.sh` erfolgreich.
- Web-App: Ziehgriff und gespeicherte Spaltenbreite praktisch geprueft.
- Lokale Release-Dateien unter `release/v1.6.0-beta.3` erstellt.
- Lokale Projektsicherung unter
  `lokale Projektsicherung`
  erstellt.
- Vollstaendiges Projektbackup in iCloud erstellt.
- GitHub-Pre-Release `v1.6.0-beta.3` veroeffentlicht.

## Erledigt - v1.6.0-rc.1 Fehlerberichte Und Kontakt

`v1.6.0-rc.1` wurde am 07.06.2026 als erster Abschlusskandidat der
1.6-Reihe vorbereitet.

- Web-App und SwiftUI-App: Funktion `Fehler melden` ergaenzt.
- Empfaenger: `urobilanz@mailbox.org`.
- Nutzer koennen Fehlerbeschreibung, Schritte zum Nachstellen und erwartetes
  Verhalten erfassen.
- Der automatisch vorbereitete Bericht bleibt vor dem Senden sichtbar und
  bearbeitbar.
- Bericht kann als Textdatei gespeichert oder als E-Mail-Entwurf vorbereitet
  werden.
- Automatisch enthalten sind nur App-Version, App-Variante, Ansicht, Sprache,
  Theme und Systemumgebung.
- CSV-Werte, Hinweise und Gesundheitsdaten werden nicht automatisch in den
  Bericht aufgenommen.
- Offizielles GitHub-Invertocat neben dem App-Symbol verlinkt das
  UroBilanz-Repository; der Repository-Link steht auch im Fehlerbericht.
- Test-E-Mail an `urobilanz@mailbox.org` erfolgreich empfangen.
- Beide Apps vollstaendig geprueft; Swift-App ohne Fehler oder Absturzmeldung
  gestartet.
- Lokale Release-Dateien unter `release/v1.6.0-rc.1` erstellt.
- Lokale Projektsicherung unter
  `lokale Projektsicherung`
  erstellt.
- Vollstaendiges Projektbackup in iCloud erstellt.
- GitHub-Pre-Release `v1.6.0-rc.1` veroeffentlicht.

## Erledigt - v1.6.0-rc.2 Ueber-Fenster Und Portable Pruefung

`v1.6.0-rc.2` wurde am 07.06.2026 als zweiter Abschlusskandidat der
1.6-Reihe vorbereitet.

- SwiftUI-App: klassischen Menueintrag `Ueber UroBilanz` mit dynamischer
  Bundle-Version, Entwickler, GPLv3, GitHub und Kontakt ergaenzt.
- Web-App: UroBilanz-Logo oeffnet ein zweisprachiges, Theme-abhaengiges
  Ueber-Modal mit denselben Projektinformationen.
- Entwicklername in beiden Apps: Schrotty74.
- README um Gatekeeper-Hinweis, Kontakt und GPLv3-Lizenz ergaenzt.
- Web-App-Starter beschleunigt und fuer einen bereits laufenden lokalen Server
  abgesichert.
- `verify_apps.sh` und Swift-Smoke-Test von persoenlichen absoluten Pfaden
  befreit.
- Kuenstliche Urinote- und Tagesdaten-Fixtures unter `docs/demo` ergaenzt.
- Portabler Pruefablauf sowohl im Projekt als auch aus einer frischen
  Checkout-Kopie erfolgreich ausgefuehrt.
- Vollstaendiger Release-Test fuer Web-App und SwiftUI-App erfolgreich.
- Lokale Release-Dateien unter `release/v1.6.0-rc.2` erstellt.
- Lokale Projektsicherung unter
  `lokale Projektsicherung`
  erstellt.
- Vollstaendiges Projektbackup in iCloud erstellt.
- GitHub-Pre-Release `v1.6.0-rc.2` veroeffentlicht.

## Spaetere Idee - Optionaler Feinschliff

### Bedienung

- Sicherheitsabfragen sprachlich oder optisch weiter verbessern, falls noetig.
- Bei sehr vielen manuellen Eintraegen pruefen, ob die Tagesliste im Dialog noch
  angenehm bedienbar bleibt.

### Tabellen

- Gespeicherte Spaltenbreiten im Alltag beobachten.
- Bei der SwiftUI-App Tabellen in sehr kleinen Fenstern beobachten.

## Prioritaet 3 - Technische Verbesserungen Spaeter

### Web-App

- Automatische Tests optional erweitern fuer:
  - Sprachumschaltung
  - Theme-Wechsel
  - Import-/Export-Randfaelle
  - geloeschte Messtage
  - geloeschte Eintraege

### SwiftUI-App

- Automatische Tests optional erweitern fuer:
  - Sprachumschaltung
  - Theme-Wechsel
  - Export-Randfaelle
  - geloeschte Messtage
  - geloeschte Eintraege

## Geplanter Neuer Schwerpunkt - v1.7.0-beta.1 PDF-Bericht

Sinnvoll als eigener Entwicklungszweig nach der 1.6-Reihe, nicht als
Feinschliff fuer `v1.6.0-rc.2`.

Zielidee:

- Gute Variante eines PDF- oder Druckberichts fuer Arzttermine vorbereiten,
  nicht nur einen einfachen Tabellenexport.
- Zeitraum auswaehlbar machen.
- Zusammenfassung mit Summen, Durchschnitt, Auffaelligkeiten und
  unvollstaendigen Messtagen darstellen.
- Tagesdetails mit Urin, Wasser und Hinweisen aufnehmen.
- Bewertungsregeln kurz erklaeren, damit `unvollstaendig`, `niedrig` und
  `normal` nachvollziehbar sind.
- Diagramme einbinden, wenn das Layout stabil und drucktauglich bleibt.
- Bericht mit klarer Struktur planen, zum Beispiel Deckbereich, kurze
  Zusammenfassung, Diagramme, Tagesdetails und Hinweise.

Gestaltung - strukturiert mit dezentem UroBilanz-Branding:

- Der Bericht soll professionell und medizinisch serioes wirken, aber klar als
  UroBilanz-Dokument erkennbar sein.
- Deckbereich:
  - UroBilanz-Logo und App-Name oben links oder zentriert.
  - Darunter Berichtstitel, gewaehlter Zeitraum und Erstellungsdatum.
  - Im restlichen Bericht kein weiteres Branding.
- Farben:
  - Grundsaetzlich schwarzweiss fuer maximale Druckkompatibilitaet.
  - Tabellen-Header nur in hellem Grau oder sehr dezentem Blau.
  - Niedrige Messtage dezent gelb/orange hinterlegen oder mit einer ruhigen
    farbigen Markierung kennzeichnen.
  - Unvollstaendige Messtage klar, aber unaufdringlich kennzeichnen.
  - Keine Theme-Farben verwenden. Das PDF sieht unabhaengig vom aktiven
    App-Theme immer gleich aus.
- Typografie:
  - Klare serifenlose Schrift, zum Beispiel `system-ui` oder Helvetica.
  - Gute Lesbarkeit sowohl beim A4-Ausdruck als auch in der PDF-Ansicht.
- Ziel:
  - Ein Arzt soll den Bericht ohne zusaetzliche Erklaerung lesen und verstehen
    koennen.
  - Das UroBilanz-Branding zeigt die Herkunft, ohne vom medizinischen Inhalt
    abzulenken.

Umsetzung zuerst planen:

- Wahrscheinlich zuerst in der Web-App starten, weil Browser-Druck/PDF dafuer
  einfacher ist.
- Web-App im Zuge der PDF-Umsetzung weiter aufteilen:
  - UI-Rendering
  - Speicherlogik
  - Import/Export und PDF-Bericht
  - Sprache
  - Themes
- SwiftUI-App im Zuge der spaeteren PDF-Umsetzung weiter ordnen:
  - Export- und Merge-Logik auslagern
  - Theme- und Sprachlogik klarer trennen
- Vor Umsetzung Layout und Umfang festlegen, damit der Bericht fuer Arzttermine
  gut lesbar bleibt und lange Tabellen/Hinweise sauber umbrechen.
- SwiftUI-PDF erst danach bewerten, damit die Funktion nicht unnoetig gross
  wird.

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
- Vor groesseren Aenderungen lokales Backup erstellen.
- Keine UI- oder Code-Aenderungen ohne konkreten neuen Fehler oder ausdruecklich
  gewuenschte neue Funktion.
- Keine neuen groesseren Funktionen mehr in `v1.5`; neue Entwicklungsarbeit
  beginnt erst mit `v1.6.0-beta.1`.
- `CHANGELOG.md` bei GitHub-Releases aktualisieren.
- Releases nur nach erfolgreichem lokalen Test und ausdruecklicher Freigabe.
- Bei UI-Aenderungen nach Moeglichkeit Web-App und SwiftUI-App konsistent halten.
- Bei laengeren oder riskanten Aenderungen lieber in kleinen Schritten arbeiten.
