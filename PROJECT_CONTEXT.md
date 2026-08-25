# UroBilanz - Projektkontext

Stand: 23.07.2026

Diese Datei beschreibt den aktuellen Projektstand. Zukunft und offene Punkte stehen in `NEXT_STEPS.md`,
dauerhafte Arbeitsregeln in `AGENTS.md` und `docs/PROJEKTREGELN.md` und abgeschlossene
Vergangenheit in `docs/HISTORY.md`.

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
- `NEXT_STEPS.md` - offene Aufgaben, Bugs, Prioritaeten und Zukunftsideen.
- `AGENTS.md` - allgemeine Arbeits-, Git- und Repository-Datenschutzregeln.
- `docs/PROJEKTREGELN.md` - dauerhafte projektspezifische Datenschutz-, Build- und Release-Regeln.
- `docs/HISTORY.md` - abgeschlossene Versions- und Projekthistorie.
- `docs/PRIVACY_CHECK.md` - chronologische Datenschutzpruefungen.
- `CHAT_TEMPLATE.md` - Arbeitshilfe fuer die Projektfortsetzung.
- `PROJECT_CONTEXT.md` - aktueller Projektstand.

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
- Aktueller Dev-/Beta-Stand `v1.7.4-beta.1` mit Build `34`.
- Discord- und GitHub-Links in den Kopfzeilen beider Apps; in der Web-App ist
  das Ueber-Fenster ueber einen gleichartigen Knopf ganz rechts erreichbar.
- Datensparsame Erststart-Hilfe bei noch leeren Apps: lokale Logos fuer
  ChatGPT, Google Gemini und Claude, eine Bestaetigung vor dem Oeffnen, ein
  fester sprachabhaengiger Schritt-fuer-Schritt-Prompt und der Link zur
  jeweiligen oeffentlichen PDF-Handbuchseite. Nutzerdaten werden dabei nie
  gelesen, kopiert oder automatisch uebertragen.
- Zweisprachige oeffentliche PDF-Handbuecher unter `docs/output/pdf/` bilden
  eine vollstaendige Bedienungsreferenz fuer beide Apps: Start, CSV, lokale
  Speicherung, Eingaben, Ansichten, Regeln, Exporte, Bericht, Themes,
  Updates, Hilfe, Datenschutz und Problemloesung anhand synthetischer
  Demo-Screenshots.

## Wichtige Designentscheidungen

- Keine medizinische Diagnose und keine medizinische Warnlogik.
- PDF-/Arztbericht bleibt neutral und unabhaengig vom aktiven Theme.
- Web-App und SwiftUI-App sollen funktional moeglichst konsistent bleiben.
- Dev, Beta und Final nutzen getrennte Bundle-IDs, damit Testdaten und
  Einstellungen nicht versehentlich Final-Zustaende beeinflussen.
- Die Erststart-Hilfe darf ausschliesslich den festen allgemeinen Prompt und
  den oeffentlichen Dokumentationslink verwenden. Ein externer Dienst wird
  nur nach einem Klick geoeffnet; das Einfuegen und Senden bleiben bei der
  nutzenden Person.
- Die deutschen und englischen PDF-Handbuecher sind bei jeder sichtbaren
  Funktions-, Options-, Bedienungs- oder Datenschutz-Aenderung gemeinsam mit
  der App zu aktualisieren, neu zu erzeugen und visuell zu pruefen.

## Bekannte Einschraenkungen Oder Probleme

- Apple-Silicon-Mac ist aktuell der primaere native macOS-Zieltyp.
- Xcode-Warnungen zu Simulator/CoreSimulator in der Codex-Sandbox sind
  Umgebungsmeldungen und keine bekannten UroBilanz-Codefehler.

## Arbeitsregeln

Die allgemeinen Arbeits-, Git-, Veröffentlichungs- und Repository-Datenschutzregeln stehen verbindlich in `AGENTS.md`. Projektspezifische Regeln stehen zusätzlich in `docs/PROJEKTREGELN.md`.

## Projektspezifischer Datenschutz

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
- Vor jedem oeffentlichen Push oder Release muss mindestens der bestehende
  statische Datenschutzcheck erfolgreich sein. Er ersetzt keine
  funktionsbezogene Datenschutzpruefung bei neuen Datenfluesen.
- Bei jeder Final-Version ist zusaetzlich die vollstaendige Final-Pruefung
  einschliesslich Git-Historie, Release-Dateien und Laufzeit-Netzwerkverhalten
  erforderlich. Fuer Betas ist dieser erweiterte Teil nicht erforderlich.
- Fuer jede finale Version wird der bestehende oeffentliche Datenschutzbericht
  um einen neuen chronologischen Pruefbericht ergaenzt. Fruehere Berichte
  bleiben erhalten und werden nicht ersetzt.
