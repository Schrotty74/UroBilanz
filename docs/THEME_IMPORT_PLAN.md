# UroBilanz v1.6.0-beta.1 - Planung Benutzerdefinierte Themes

Stand: 04.06.2026

Umsetzungsstand: Die erste Umsetzung fuer `v1.6.0-beta.1` ist lokal gebaut und
geprueft. Web-App und SwiftUI-App koennen eigene Theme-JSON-Dateien importieren
und importierte Themes wieder exportieren.

## Ziel

Version `v1.6.0-beta.1` soll benutzerdefinierte Themes vorbereiten und spaeter
umsetzen. Eigene Themes sollen als Datei importiert werden koennen, ohne CSV-
Daten, Berechnungen, Exporte oder bestehende eingebaute Themes zu beeinflussen.

Wichtig fuer den Start: zuerst Format und Umfang festlegen, dann erst bauen.
Dieser Schritt ist abgeschlossen; die erste Implementierung folgt dem unten
beschriebenen kleinen Umfang.

## Grundentscheidung

Web-App und SwiftUI-App sollen dasselbe JSON-Format lesen. Das Format bleibt
bewusst klein und bildet nur Werte ab, die beide Apps sinnvoll darstellen
koennen.

Nicht Ziel fuer `v1.6.0-beta.1`:

- kein visueller Theme-Editor
- keine Synchronisierung zwischen Geraeten
- keine Aenderung an CSV-Import, Export oder Bewertungslogik
- keine Aenderung am App-Icon
- keine frei programmierbaren CSS- oder SwiftUI-Fragmente

## Formatentwurf

Dateiendung: `.json`

```json
{
  "format": "urobilanz-theme",
  "version": 1,
  "id": "example-custom-theme",
  "name": {
    "de": "Beispiel Theme",
    "en": "Example Theme"
  },
  "mode": "dark",
  "colors": {
    "text": "#F5F7FA",
    "mutedText": "#B7C1C9",
    "background": "#101418",
    "backgroundAlt": "#182128",
    "panel": "#1E2930",
    "panelSoft": "#26343D",
    "border": "#40515C",
    "accent": "#F2BD00",
    "accentText": "#201B0A",
    "urine": "#FFD447",
    "urineSoft": "#4B3915",
    "water": "#35AAFF",
    "waterSoft": "#17364C",
    "low": "#5C252B",
    "rowOdd": "#17252B",
    "rowEven": "#111A1F",
    "chartUrine": "#FFD447",
    "chartWater": "#35AAFF"
  },
  "effects": {
    "glassOpacity": 0.72,
    "glassBorderOpacity": 0.24,
    "shadowOpacity": 0.32
  }
}
```

## Pflichtfelder

- `format`: muss `urobilanz-theme` sein
- `version`: aktuell `1`
- `id`: technische Kennung, klein geschrieben, eindeutig, keine Leerzeichen
- `name`: Anzeigename, mindestens `de` oder `en`
- `mode`: `light` oder `dark`
- `colors.text`
- `colors.background`
- `colors.panel`
- `colors.accent`
- `colors.urine`
- `colors.water`

## Optionale Felder

Alle anderen Farb- und Effektwerte sind optional. Wenn sie fehlen, erzeugt die
App sichere Ersatzwerte aus den Pflichtfarben oder nutzt neutrale Standards.

Empfohlene optionale Felder:

- `mutedText`
- `backgroundAlt`
- `panelSoft`
- `border`
- `accentText`
- `urineSoft`
- `waterSoft`
- `low`
- `rowOdd`
- `rowEven`
- `chartUrine`
- `chartWater`
- `glassOpacity`
- `glassBorderOpacity`
- `shadowOpacity`

## Validierungsregeln

- JSON muss gueltig sein.
- `format` und `version` muessen bekannt sein.
- `id` darf keine eingebaute Theme-ID ueberschreiben.
- `id` darf nur `a-z`, `0-9` und Bindestriche enthalten.
- Farben muessen als Hex-Werte im Format `#RRGGBB` angegeben werden.
- `mode` muss `light` oder `dark` sein.
- Effektwerte muessen Zahlen zwischen `0` und `1` sein.
- Fehlerhafte Dateien werden abgelehnt und erklaeren den Grund verstaendlich.
- Unbekannte Felder werden ignoriert, damit das Format spaeter wachsen kann.

## Aktuelle Theme-Felder In Der Web-App

Die Web-App arbeitet aktuell mit CSS-Variablen, unter anderem:

- `--ink`
- `--muted`
- `--line`
- `--teal`
- `--teal-dark`
- `--accent`
- `--accent-ink`
- `--urine`
- `--urine-strong`
- `--water`
- `--water-strong`
- `--soft`
- `--paper`
- `--panel`
- `--panel-soft`
- `--glass-bg`
- `--glass-line`
- `--glass-shadow`
- `--chart-urine`
- `--chart-water`
- `--low`
- `--body-bg`
- `--row-odd`
- `--row-even`

Plan: importierte JSON-Felder werden auf diese CSS-Variablen abgebildet. Die
Web-App speichert importierte Themes lokal im Browser.

## Aktuelle Theme-Felder In Der SwiftUI-App

Die SwiftUI-App nutzt aktuell `AppTheme` mit festen Varianten und berechnet
daraus:

- Anzeigename
- helles oder dunkles Farbschema
- Akzentfarbe
- Urinfarbe
- Wasserfarbe
- Hintergrundverlauf
- Bedienfeld-Hintergrund
- Bedienfeld-Text
- Bedienfeld-Rahmen
- Tabellen-Hintergrund
- Tabellen-Zeilenfarbe

Plan: eingebaute Themes bleiben als feste Themes erhalten. Importierte Themes
werden als eigenes Datenmodell daneben gespeichert und in denselben
Darstellungswerten aufgeloest.

## Bedienungsidee

### Web-App

- Im Theme-Menue zusaetzliche Aktion `Theme importieren`.
- JSON-Datei per Dateiauswahl laden.
- Theme validieren.
- Theme lokal speichern.
- Theme direkt in der bestehenden Theme-Auswahl anzeigen.
- Importiertes Theme auswaehlen und beim naechsten Start wiederherstellen.

### SwiftUI-App

- Im Theme-Menue zusaetzliche Aktion `Theme importieren`.
- JSON-Datei mit macOS-Dateidialog laden.
- Theme validieren.
- Theme lokal speichern.
- Theme direkt in der bestehenden Theme-Auswahl anzeigen.
- Importiertes Theme auswaehlen und beim naechsten Start wiederherstellen.

## Speicheridee

Web-App:

- `localStorage` fuer importierte Theme-Definitionen
- vorhandene Einstellung `urinTheme` kann weiter die aktive Theme-ID speichern

SwiftUI-App:

- `AppStorage` fuer aktive Theme-ID
- importierte Theme-Definitionen als JSON in Application Support oder als
  gespeicherter String, je nachdem was bei der Umsetzung einfacher und robuster
  ist

## Dokumentation Und Vorlage

Geplante Dateien:

- `docs/themes/urobilanz-theme-template.json`
- `docs/themes/example-custom-theme.json`
- `docs/themes/README.md`

Die Vorlage soll kurz erklaeren:

- welche Felder Pflicht sind
- welche Felder optional sind
- wie Farben geschrieben werden
- wie ein Theme importiert wird
- dass echte Gesundheitsdaten nichts mit Theme-Dateien zu tun haben

## Tests Fuer Die Umsetzung

- Eingebaute Themes funktionieren unveraendert.
- Gueltiges Beispiel-Theme laesst sich in Web-App importieren.
- Dasselbe Beispiel-Theme laesst sich in SwiftUI-App importieren.
- Ungueltiges JSON wird abgelehnt.
- Falsches `format` wird abgelehnt.
- Falsche `version` wird abgelehnt.
- Doppelte eingebaute Theme-ID wird abgelehnt.
- Ungueltige Farbwerte werden abgelehnt.
- Nach Neustart bleibt das importierte Theme waehlbar.
- CSV laden, CSV ergaenzen, manuelle Eintraege, Loeschen, Filter und Exporte
  funktionieren unveraendert.

## Getroffene Entscheidungen Fuer beta.1

- `name` wird als Objekt mit optionalem `de` und `en` verwendet. Mindestens eine
  Sprache muss vorhanden sein.
- Importierte Themes koennen eingebaute Theme-IDs nicht ueberschreiben.
- Bereits importierte eigene Themes mit gleicher ID werden beim erneuten Import
  ersetzt.
- `Theme exportieren` ist fuer importierte Themes enthalten.
- SwiftUI speichert importierte Themes gesammelt als JSON in `AppStorage`.
- Das Minimalformat benoetigt sechs Pflichtfarben plus Metadaten.

## Offene Entscheidungen Nach beta.1

- Soll ein importiertes Theme geloescht werden koennen?
- Soll es eine kleine Verwaltungsansicht fuer importierte Themes geben?

## Empfohlener Kleiner Umfang Fuer beta.1

1. JSON-Format final festlegen.
2. Vorlage und Beispieltheme dokumentieren.
3. Import in der Web-App umsetzen.
4. Import in der SwiftUI-App umsetzen.
5. Tests fuer gueltige und ungueltige Theme-Dateien ergaenzen.
6. Importierte Themes exportieren.
