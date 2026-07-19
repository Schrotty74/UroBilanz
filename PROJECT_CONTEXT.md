# UroBilanz - Projektkontext

Stand: 19.07.2026

Diese Datei ist die primaere Wissensquelle fuer neue Chats. Sie beschreibt den
aktuellen Projektstand. Zukunft und offene Punkte stehen in
`docs/NEXT_STEPS.md`, dauerhafte Arbeitsregeln in `docs/PROJEKTREGELN.md` und
abgeschlossene Vergangenheit in `docs/HISTORY.md`.

## Projektziel Und Zweck

UroBilanz ist ein lokales Protokoll- und Auswertungstool fuer Urin- und
Fluessigkeitsprotokolle. Ziel ist eine klare organisatorische Auswertung von
Messdaten, ohne medizinische Diagnose, Cloud-Synchronisation oder externen
Daten-Backend-Dienst.

## Architektur Und Technische Entscheidungen

- Gemeinsames Repository fuer Web-App und native SwiftUI-/macOS-App.
- Web-App unter `apps/web`, ohne externe Frameworks oder CDN-Abhaengigkeiten.
- SwiftUI-App unter `apps/macos-swift/Sources`.
- Xcode-Projekt `UroBilanz.xcodeproj` mit sichtbarem Scheme `UroBilanz Dev`.
- Drei getrennte Xcode-Konfigurationen:
  - Dev: `local.schrotty74.urobilanz.dev`
  - Beta: `local.schrotty74.urobilanz.beta`
  - Final: `local.schrotty74.urobilanz`
- Xcode dient primaer zum Bauen/Testen der macOS-App.
- Release-Pakete fuer Beta/Final entstehen ueber
  `Scripts/build-release-package.sh`. Dieses Skript baut Swift-App, Web-App,
  ZIP, DMG und SHA256-Dateien gemeinsam.
- `apps/web/build_web.sh` ist nur ein internes Hilfsskript fuer den Web-Build.
- Lokale Build-/Release-Artefakte liegen unter `Backup/`, `dist/`, `.build/`
  und `.build-cache` und werden nicht in Git aufgenommen.

## Dateistruktur

- `apps/web/` - portable Web-App mit HTML, CSS, JavaScript und Web-Tests.
- `apps/macos-swift/Sources/` - native SwiftUI-App.
- `Scripts/` - neuer Build-/Release-Workflow fuer Dev, Beta und Final.
- `docs/demo/` - kuenstliche Demo- und Test-Fixtures ohne echte Nutzerdaten.
- `docs/NEXT_STEPS.md` - offene Aufgaben, Bugs, Prioritaeten und Zukunftsideen.
- `docs/PROJEKTREGELN.md` - dauerhafte Projekt-, Datenschutz-, Build- und
  Release-Regeln.
- `docs/HISTORY.md` - abgeschlossene Versions- und Projekthistorie.
- `docs/PRIVACY_CHECK.md` - chronologische Datenschutzpruefungen.
- `PROJECT_CONTEXT.md` - aktueller Projektstand fuer neue Chats.

## Aktuell Umgesetzte Funktionen

- Import von Original-Urinote-CSV und Tagesdaten-CSV.
- Manuelle Erfassung von Urin, Wasser und Hinweisen.
- Bearbeiten und Loeschen manueller Eintraege.
- Loeschen ganzer Messtage.
- Dashboard, Jahr, Monat, Woche, Tag und Notizen.
- Korrekte Messtaglogik von 06:00 bis 05:59.
- Bewertungslogik fuer `unvollstaendig`, `niedrig` und `normal`.
- Deutsch/Englisch in Web-App und SwiftUI-App.
- Theme-System mit Import, Export und Loeschen benutzerdefinierter Themes.
- Frei speicherbare Tabellenbreiten.
- Uhrzeit-genaue Hinweiszuordnung.
- Arztbericht/PDF-Bericht mit neutralem A4-Layout.
- Streak-Anzeige, Wochen-/Monats-Sparklines und JSON-Export.
- Datenschutzfreundlicher Fehlerbericht mit Kontaktadresse.
- Update-Check gegen GitHub-Releases in der SwiftUI-App.
- Automatische Web- und Swift-Smoke-Tests fuer Sprache, Themes,
  Loeschfaelle und Exportbereinigung.
- Aktueller Final-Stand `v1.7.3`.
- Discord- und GitHub-Links in den Kopfzeilen beider Apps; in der Web-App ist
  das Ueber-Fenster ueber einen eigenen Knopf erreichbar.
- Datensparsame Erststart-Hilfe bei noch leeren Apps: lokale Logos fuer
  ChatGPT, Google Gemini und Claude, ein fester sprachabhaengiger Prompt und
  der Link zum jeweiligen oeffentlichen PDF-Handbuch. Nutzerdaten
  werden dabei nie gelesen, kopiert oder automatisch uebertragen.
- Zweisprachige oeffentliche PDF-Handbuecher unter `docs/output/pdf/` erklaeren
  die Bedienung beider Apps, alle sichtbaren Schalter, Auswertungsregeln,
  Exporte und Datenschutz anhand synthetischer Demo-Screenshots.

## Wichtige Designentscheidungen

- Keine medizinische Diagnose und keine medizinische Warnlogik.
- PDF-/Arztbericht bleibt neutral und unabhaengig vom aktiven Theme.
- Web-App und SwiftUI-App sollen funktional moeglichst konsistent bleiben.
- Dev, Beta und Final nutzen getrennte Bundle-IDs, damit Testdaten und
  Einstellungen nicht versehentlich Final-Zustaende beeinflussen.
- Oeffentliche Dokumentation verwendet das Pseudonym `Schrotty74` und keine
  realen Namen oder lokalen Benutzerpfade.
- Die Erststart-Hilfe darf ausschliesslich den festen allgemeinen Prompt und
  den oeffentlichen Dokumentationslink verwenden. Ein externer Dienst wird
  nur nach einem Klick geoeffnet; das Einfuegen und Senden bleiben bei der
  nutzenden Person.

## Bekannte Einschraenkungen Oder Probleme

- Apple-Silicon-Mac ist aktuell der primaere native macOS-Zieltyp.
- Xcode-Warnungen zu Simulator/CoreSimulator in der Codex-Sandbox sind
  Umgebungsmeldungen und keine bekannten UroBilanz-Codefehler.

## Arbeitsregel fuer Codex

Der Nutzer kann nicht coden und kennt sich mit technischen Fehlermeldungen und
Logs nicht aus. Erklaerungen sollen deshalb in normaler Sprache erfolgen.

Harte Ausloese-Regel:

- Wenn der Nutzer eine Frage stellt, nur die Frage beantworten.
- Bei Fragen keine Dateien aendern.
- Bei Fragen keine Tests ausfuehren.
- Bei Fragen keinen Build starten.
- Bei Fragen keine App oeffnen.
- Bei Fragen keine sonstigen Projektaktionen ausfuehren.

Aktiv am Projekt arbeiten nur bei eindeutigen Arbeitsbefehlen, zum Beispiel:

- `fix das`
- `setz das um`
- `teste das`
- `mach dev build`
- `baue das`
- `oeffne die App`

Wenn eine Nachricht gemischt oder unklar ist, zuerst kurz nachfragen:

`Soll ich das nur erklaeren oder direkt umsetzen?`

Bei `fix das` oder `setz das um`:

- Problem selbst analysieren.
- Nur das Noetigste aendern.
- Soweit sinnvoll testen.
- Einen Dev-Build nur bauen, wenn er zum praktischen Testen noetig ist oder
  ausdruecklich verlangt wurde.
- Am Ende kurz in normaler Sprache erklaeren, was geaendert wurde.

Keine unnoetigen Umbauten, keine Designaenderungen und keine neuen Funktionen
ohne klare Anweisung. Wenn etwas riskant wird oder groessere Aenderungen noetig
waeren, vorher kurz Bescheid sagen.

## Datenschutz hat Vorrang

- Das Git-Repository und oeffentliche Builds enthalten niemals persoenliche
  Messdaten, echte CSV-/Excel-Dateien, Gesundheitsdaten, lokale Backups,
  Zugangsdaten, Tokens oder lokale Benutzerpfade.
- Neue Benutzer starten ohne persoenliche Messdaten.
- Persoenliche Messdaten liegen ausschliesslich lokal beim Benutzer, zum
  Beispiel in lokal gespeicherten CSV-Dateien, Browser-Speicher oder
  macOS-App-Speicher.
- UroBilanz hat keinen Netzwerk-Backend-Dienst fuer Messdaten. Gesundheitsdaten
  duerfen nicht automatisch an externe Server uebertragen werden.
- Fehlerberichte duerfen keine CSV-Werte, Hinweise, Messdaten oder
  Gesundheitsdaten automatisch enthalten.
- Bei jeder neuen Funktion mit Datenschutzwirkung muss diese Wirkung vor der
  Umsetzung genannt und eine datensparsame Alternative vorgeschlagen werden.
- Vor jedem Commit, Push und Release muss ein Datenschutzcheck erfolgen.
- Das umfangreiche Datenschutzaudit einschliesslich Pruefung der Git-Historie,
  Release-Dateien und Netzwerkzugriffe wird ausschliesslich bei jeder finalen
  Version durchgefuehrt, nicht bei Betas.
- Fuer jede finale Version wird der bestehende oeffentliche Datenschutzbericht
  um einen neuen chronologischen Pruefbericht ergaenzt. Fruehere Berichte
  bleiben erhalten und werden nicht ersetzt.
