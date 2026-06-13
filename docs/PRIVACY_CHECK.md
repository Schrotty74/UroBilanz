# Technischer Datenschutz-Check

Stand: 13.06.2026

Gepruefter Stand: `v1.6.0 Final`.

## Ergebnis

Die README-Aussage ist fuer den geprueften Stand technisch nachvollziehbar:

> UroBilanz verarbeitet Messdaten ausschliesslich lokal auf dem Geraet. Es
> werden keine Gesundheitsdaten an externe Server uebertragen.

Es wurden keine automatischen Uploads, Tracking-, Analytics-, Telemetrie-,
Crash-Reporting- oder Cloud-Dienste gefunden.

## 1. Netzwerk- und Tracking-Code

Das gesamte Projekt wurde unter anderem nach folgenden Begriffen und APIs
durchsucht:

```text
https://
http://
fetch(
XMLHttpRequest
URLSession
analytics
telemetry
firebase
sentry
crash
tracking
upload
server
remote
```

Gefundene Netzwerkadressen:

- GitHub-Repository und GPLv3-Lizenz.
- Kontaktadresse als `mailto:`-Link.
- Lokale Web-App-Adresse `http://localhost:4174`.
- XML-/SVG-Namensraeume und Lizenztexte ohne Netzwerkzugriff.

Nicht gefunden:

- `fetch`, `XMLHttpRequest`, WebSocket oder `sendBeacon`.
- `URLSession`, `NSURLConnection` oder Network-Framework-Nutzung.
- Analytics-, Telemetrie-, Firebase-, Sentry- oder Tracking-SDKs.
- Automatische Update-, Upload- oder Cloud-Schnittstellen.

## 2. Web-App

- Alle Skripte, Stylesheets, Bilder und Sprachdateien werden relativ aus
  `apps/web` geladen.
- Keine CDNs, externen Skripte, Webfonts oder externen Bildressourcen.
- Der lokale Starter bindet den Python-Webserver ausschliesslich an
  `127.0.0.1`.
- Beim lokalen Start wurden nur Ressourcen von `localhost:4174` angefordert.
- Externe GitHub- und Lizenzadressen sind normale sichtbare Links und werden
  erst durch einen Klick geoeffnet.
- Messdaten koennen optional im lokalen Browser-Speicher gespeichert werden.
- CSV- und Theme-Exporte werden lokal als Blob/Datei erzeugt.

## 3. SwiftUI-/macOS-App

- Keine Netzwerk-API im Quellcode gefunden.
- Messdaten werden aus lokalen Dateien gelesen.
- Optional gespeicherte Messdaten liegen lokal in `UserDefaults`.
- Exporte verwenden lokale macOS-Speicherdialoge.
- GitHub-, Lizenz- und Kontaktlinks werden nur nach Benutzeraktion ueber
  `NSWorkspace` beziehungsweise einen `mailto:`-Link geoeffnet.
- Bei zehn Laufzeitmessungen nach dem App-Start wurden mit `lsof` keine offenen
  IPv4- oder IPv6-Verbindungen der App gefunden.
- `nettop` zeigte fuer den App-Prozess keinen ein- oder ausgehenden
  Datenverkehr.

## 4. Fehlerberichte

Automatisch enthalten sind nur:

- App-Version und App-Variante.
- aktuelle Ansicht.
- Sprache und Theme.
- Betriebssystem beziehungsweise Browserkennung.
- Fenstergroesse in der Web-App.
- GitHub-Projektadresse.

Die Berichtsfunktionen lesen keine CSV-Zeilen, Messwerte, Hinweise,
Tagesdaten oder gespeicherten Gesundheitsdaten.

Der Bericht bleibt vor dem Speichern oder Vorbereiten einer E-Mail sichtbar
und bearbeitbar. `E-Mail vorbereiten` versendet nicht selbst, sondern oeffnet
einen Entwurf im lokalen Standard-Mailprogramm.

Wichtig: Nutzer koennen selbst Gesundheitsdaten in die Freitextfelder
schreiben. Werden solche Inhalte anschliessend bewusst per E-Mail versendet,
ist das eine vom Nutzer ausgeloeste externe Uebertragung ausserhalb der
automatischen App-Verarbeitung.

## 5. Git-Ausschlussregeln

`.gitignore` schliesst insbesondere aus:

- CSV und TSV.
- Excel-, Numbers- und ODS-Dateien.
- Dateien mit `backup`, `tagesdaten`, `gesundheit` oder `health` im Namen.
- Gross- und Kleinschreibungsvarianten dieser Endungen und Begriffe.
- Build-, Release-, App-, Log- und temporaere Dateien.

Nur die zwei ausdruecklich kuenstlichen Test-Fixtures unter `docs/demo` sind
als Ausnahmen zugelassen.

Die Regeln wurden mit Testdateien fuer alle genannten Formate und
Namensvarianten ueber `git check-ignore` praktisch geprueft.

## 6. macOS-App-Bundle

Geprueft wurden das lokal gebaute Bundle und sein ausfuehrbares Programm:

- Version `1.6.0`, Build `26`.
- Ad-hoc-Signatur gueltig.
- Keine App-Entitlements vorhanden.
- Keine Network-Client- oder Network-Server-Entitlements.
- Keine eingebetteten Frameworks, Plug-ins oder XPC-Dienste.
- Keine Paketmanager-Manifeste oder Drittanbieter-Abhaengigkeiten.
- Verknuepft sind nur Apple-Systemframeworks und Swift-Systembibliotheken,
  insbesondere SwiftUI, AppKit, Foundation, Combine, CoreFoundation und
  CoreGraphics.
- Keine App-Transport-Security-Ausnahmen im `Info.plist`.

Hinweis: Die App ist nicht sandboxed. Das Fehlen eines Netzwerk-Entitlements
ist daher allein kein technisches Netzwerkverbot. Die Aussage stuetzt sich
zusaetzlich auf Quellcode-, Bundle- und Laufzeitpruefung.

## Verwendete Werkzeuge

Die Pruefung erfolgte unter anderem mit:

- `grep`
- `lsof`
- `nettop`
- `codesign`
- `otool`
- `git check-ignore`

## Fazit

Im geprueften Stand verarbeitet UroBilanz Messdaten lokal. Es gibt keine
automatische Uebertragung von CSV-, Mess-, Hinweis- oder Gesundheitsdaten an
externe Server.

Externe Kommunikation entsteht nur nach einer sichtbaren Benutzeraktion:

- GitHub- oder Lizenzlink im Browser oeffnen.
- E-Mail-Entwurf im lokalen Mailprogramm vorbereiten und dort selbst senden.

Der Check ist eine technische Bestandsaufnahme des genannten Projektstands und
keine rechtliche Datenschutzbewertung.

## Ergaenzende Vollpruefung - 13.06.2026

Die ergaenzende Pruefung umfasste erstmals nicht nur den aktuellen Quellstand,
die App-Bundles und das Laufzeitverhalten, sondern auch die vollstaendige
veroeffentlichte Git-Historie einschliesslich Commit-Metadaten.

### Gefundene und bereinigte Altlasten

- In aelteren Commits standen absolute lokale Benutzerpfade und Namen lokal
  verwendeter CSV-Dateien. CSV-Inhalte oder persoenliche Messwerte waren nicht
  Bestandteil der Git-Historie.
- Fruehere Commits verwendeten eine automatisch aus dem lokalen Rechnernamen
  erzeugte `.fritz.box`-Absenderadresse.
- Der aktuelle Dokumentstand, alle frueheren Commits und alle Tags wurden
  bereinigt. Die Commit-Metadaten verwenden nun eine GitHub-Noreply-Adresse.
- Vor der Historienbereinigung wurde eine vollstaendige lokale
  Sicherheitskopie des bisherigen Repository-Zustands erstellt.

### Zusaetzlich geprueft

- Vollstaendige Git-Historie und alle veroeffentlichten Tags.
- Alle von Git verfolgten Dateinamen und historischen Objektnamen.
- Aktueller Quellstand auf moegliche Zugangsdaten, private Schluessel,
  Lizenzschluessel und lokale Benutzerpfade.
- Finale Web- und macOS-Downloadpakete auf sensible Dateien, Git-Metadaten und
  lokale Datendateien.
- Kuenstliche Demo-CSV-Dateien auf ausschliesslich erfundene Testwerte.
- `.gitignore` praktisch mit CSV-, Excel-, Numbers-, Backup-, Gesundheits-,
  Build-, Release- und Log-Dateien.
- SwiftUI-App waehrend eines normalen Starts mit `lsof` und `nettop`.
- Lokaler Webserver waehrend eines Abrufs mit `lsof`.

### Ergebnis der ergaenzenden Pruefung

- Keine persoenlichen CSV-, Mess-, Hinweis- oder Gesundheitsdaten in der
  bereinigten Git-Historie oder den finalen Downloadpaketen.
- Keine Zugangsdaten, privaten Schluessel oder Lizenzschluessel gefunden.
- Keine absoluten lokalen Benutzerpfade oder privaten Commit-Adressen in der
  bereinigten Git-Historie.
- Die SwiftUI-App oeffnete beim geprueften Start keine TCP- oder
  UDP-Verbindung.
- Der Webserver lauschte ausschliesslich lokal auf `127.0.0.1`.
- Externe Kommunikation bleibt auf sichtbare, vom Nutzer ausgeloeste Aktionen
  wie GitHub-/Lizenzlinks und das Vorbereiten eines E-Mail-Entwurfs begrenzt.

Eine absolute Garantie fuer jedes zukuenftige Verhalten ist technisch nicht
serioes moeglich. Fuer den vollstaendig geprueften und bereinigten Stand wurden
jedoch keine unbeabsichtigt veroeffentlichten lokalen Daten und keine
automatische Uebertragung von Gesundheitsdaten gefunden.

## Verbindliche Final-Pruefung

Ab jetzt gilt fuer jede Final-Version, nicht fuer Betas:

1. `./privacy_final_check.sh` muss erfolgreich durchlaufen.
2. Beide Apps werden auf unerwartete Netzwerkverbindungen geprueft.
3. Finale Downloadpakete werden auf sensible oder lokale Dateien geprueft.
4. Das Ergebnis wird in diesem Bericht ergaenzt.

Zusaetzliche Schutzmechanismen:

- Ein lokaler Pre-Push-Hook fuehrt die statische Datenschutzpruefung vor jedem
  Push aus.
- GitHub Actions fuehrt dieselbe Pruefung bei jedem Push und Pull Request mit
  vollstaendiger Git-Historie aus.
- Die Pruefung blockiert lokale Benutzerpfade, private Commit-Adressen,
  unerlaubte Datendateien, moegliche Zugangsdaten und Netzwerk-APIs.
