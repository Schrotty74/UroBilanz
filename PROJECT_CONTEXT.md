# UroBilanz - Projektkontext

Stand: 05.09.2026

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
- Die Web-App ist seit September 2026 der primaere Entwicklungsfokus.
- Die native macOS-App bleibt als funktionsfaehige Legacy-Version im Repository,
  wird aber nicht mehr aktiv um neue Funktionen erweitert.
- Web-App unter `apps/web`, ohne externe Frameworks oder CDN-Abhaengigkeiten.
- Die Web-App ist als PWA installierbar. `manifest.webmanifest` und
  `service-worker.js` cachen ausschliesslich den App-Shell, nie CSV-, Export-
  oder Browser-Speicherdaten.
- Die PWA wird zusaetzlich ueber GitHub Pages unter
  `https://schrotty74.github.io/UroBilanz/` bereitgestellt.
- GitHub Pages liefert nur die Anwendungsdateien aus; Messdaten, importierte
  Dateien, Hinweise und Einstellungen bleiben lokal im Browser bzw. auf dem
  Geraet des Benutzers.
- SwiftUI-App unter `apps/macos-swift/Sources`.
- Xcode-Projekt `UroBilanz.xcodeproj` mit sichtbarem Scheme `UroBilanz Dev`.
- Drei getrennte Xcode-Konfigurationen fuer die bestehende native App:
  - Dev: `local.schrotty74.urobilanz.dev`
  - Beta: `local.schrotty74.urobilanz.beta`
  - Final: `local.schrotty74.urobilanz`
- Xcode dient primaer zum Bauen/Testen der Legacy-macOS-App.
- Bestehende Release-Pakete fuer Beta/Final entstehen ueber
  `Scripts/build-release-package.sh`. Dieses Skript baut Swift-App, Web-App,
  ZIP, DMG und SHA256-Dateien gemeinsam.
- `apps/web/build_web.sh` ist nur ein internes Hilfsskript fuer den Web-Build.
- `.github/workflows/pages.yml` veroeffentlicht die Web-App bei Aenderungen an
  `apps/web/**` automatisch ueber GitHub Pages.
- Lokale Build-/Release-Artefakte liegen unter `Backup/`, `dist/`, `.build/`
  und `.build-cache` und werden nicht in Git aufgenommen.

## Dateistruktur

- `apps/web/` - portable Web-App/PWA mit HTML, CSS, JavaScript und Web-Tests.
- `apps/web/mobile.css` - zusaetzliche responsive Regeln fuer kleine Displays.
- `apps/macos-swift/Sources/` - native SwiftUI-Legacy-App.
- `.github/workflows/pages.yml` - Deployment der Web-PWA auf GitHub Pages.
- `Scripts/` - bestehender Build-/Release-Workflow fuer Dev, Beta und Final.
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
- Installierbare Web-PWA mit lokalem App-Shell-Cache fuer den Offline-Start
  nach dem ersten Laden.
- Oeffentliche PWA-Bereitstellung ueber GitHub Pages.
- README-Link zum direkten Start der PWA mit transparentem Hinweis auf lokale
  Datenspeicherung und den aktuell desktop-orientierten Darstellungsstand.
- Erste mobile Optimierungen der Web-App:
  - kompakteres mobiles Kopfmenue statt vieler einzelner Header-Buttons.
  - responsive Anordnung der Ansichts-Tabs ohne abgeschnittene Schaltflaechen.
  - mobile Regeln fuer Header, Filter, Dialoge, Tabellen und kleine Displays.
- Lokale Volltextsuche nach sichtbaren Typen, Einzel- und Tagesmengen, Uhrzeit
  und Hinweis sowie Eintragstyp-Filter in den Tagesansichten beider Apps. Sie
  begrenzen nur die sichtbaren Messtage und veraendern weder Dashboard,
  Auswertung, Berichte noch Exporte.
- Datenschutzfreundlicher Fehlerbericht mit Kontaktadresse.
- Update-Check gegen GitHub-Releases in der SwiftUI-App.
- Automatische Web- und Swift-Smoke-Tests fuer Sprache, Themes,
  Loeschfaelle und Exportbereinigung.
- Aktueller Final-Stand `v1.7.4` mit Build `35`.
- Letzter Beta-Stand `v1.7.4-beta.2` mit Build `34`.
- Discord- und GitHub-Links in den Kopfzeilen beider Apps.
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
- Neue Funktionen und die weitere Produktentwicklung konzentrieren sich auf
  die Web-App; die native macOS-App bleibt als Legacy-Version erhalten.
- Bestehende Funktionen beider Varianten sollen nicht ohne Grund auseinander
  laufen, es besteht aber kein Anspruch mehr auf aktive Feature-Paritaet.
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

- Die Web-App ist historisch desktop-first entwickelt worden und derzeit vor
  allem fuer Desktop-Browser und groessere Displays optimiert.
- Smartphone- und Tablet-Nutzung ist moeglich, aber die mobile Darstellung ist
  noch nicht vollstaendig optimiert. Besonders im Hochformat koennen Diagramme,
  lange Seiten und Tabellen zusaetzliches Scrollen erfordern.
- Erste responsive Korrekturen sind umgesetzt; weitere mobile Optimierung bleibt
  ein offener UX-Schwerpunkt.
- Apple-Silicon-Mac ist aktuell der primaere native macOS-Zieltyp der Legacy-App.
- Xcode-Warnungen zu Simulator/CoreSimulator in der Codex-Sandbox sind
  Umgebungsmeldungen und keine bekannten UroBilanz-Codefehler.
- Die PWA benoetigt `localhost` oder HTTPS. Ein direkt ueber `file://`
  geoeffnetes `index.html` bleibt nutzbar, kann aber keinen Service Worker
  registrieren und ist nicht installierbar.

## Arbeitsregeln

Die allgemeinen Arbeits-, Git-, Veröffentlichungs- und Repository-Datenschutzregeln stehen verbindlich in `AGENTS.md`. Projektspezifische Regeln stehen zusätzlich in `docs/PROJEKTREGELN.md`.

## Projektspezifischer Datenschutz

- Neue Benutzer starten ohne persoenliche Messdaten.
- Persoenliche Messdaten liegen ausschliesslich lokal beim Benutzer, zum
  Beispiel in lokal gespeicherten CSV-Dateien, Browser-Speicher oder
  macOS-App-Speicher.
- UroBilanz hat keinen Netzwerk-Backend-Dienst fuer Messdaten. Gesundheitsdaten
  duerfen nicht automatisch an externe Server uebertragen werden.
- GitHub Pages dient ausschliesslich der Auslieferung der statischen PWA-Dateien
  und ist kein Backend fuer Gesundheits- oder Messdaten.
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
