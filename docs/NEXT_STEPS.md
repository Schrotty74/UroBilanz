# UroBilanz - Naechste Schritte

Stand: 13.06.2026

Aktueller Hauptstand: `v1.6.0 Final`

Lokaler Entwicklungsstand: `v1.7.0-beta.1`, noch nicht veroeffentlicht.

Release-Einordnung: `v1.6.0` ist die abgeschlossene Final-Version der
1.6-Reihe mit benutzerdefinierten Themes. Neue groessere Funktionen beginnen
erst mit Version 1.7.

## Zweck dieser Datei

Diese Datei ist die kurze Aufgabenliste fuer neue Chats. Sie soll nach groesseren
Aenderungen aktualisiert werden, damit ohne Informationsverlust weitergearbeitet
werden kann. Abgeschlossene Versionen und Meilensteine stehen dauerhaft in
[`HISTORY.md`](HISTORY.md).

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

Die letzte Vollpruefung fuer `v1.6.0 Final` war erfolgreich:

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

Sinnvoll als eigener Entwicklungszweig nach der abgeschlossenen 1.6-Reihe.

Lokal begonnen:

- Erste gute Web-Variante des Arztberichts mit Zeitraumwahl.
- Festes neutrales A4-Berichtslayout unabhaengig vom aktiven Theme.
- Zusammenfassung, Tagesverlauf, Tagesuebersicht, optionale Tagesdetails,
  Hinweise und Bewertungsregeln.
- Bericht als eigenes Web-Modul mit Smoke-Test.

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
- Vor jeder Final-Version, nicht vor Betas, den technischen Datenschutz-Check
  mit `./privacy_final_check.sh` und einer Laufzeitpruefung beider Apps
  wiederholen und `PRIVACY_CHECK.md` ergaenzen.
- Vor groesseren Aenderungen lokales Backup erstellen.
- Keine UI- oder Code-Aenderungen ohne konkreten neuen Fehler oder ausdruecklich
  gewuenschte neue Funktion.
- Keine neuen groesseren Funktionen mehr in `v1.5`; neue Entwicklungsarbeit
  beginnt erst mit `v1.6.0-beta.1`.
- `CHANGELOG.md` bei GitHub-Releases aktualisieren.
- Releases nur nach erfolgreichem lokalen Test und ausdruecklicher Freigabe.
- Bei UI-Aenderungen nach Moeglichkeit Web-App und SwiftUI-App konsistent halten.
- Bei laengeren oder riskanten Aenderungen lieber in kleinen Schritten arbeiten.
