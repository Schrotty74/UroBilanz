# Benutzerdefinierte UroBilanz-Themes

UroBilanz kann ab `v1.6.0-beta.1` eigene Theme-Dateien im JSON-Format lesen.
Die Datei betrifft nur die Darstellung der App. CSV-Daten, Berechnungen und
Exporte bleiben davon getrennt.

## Vorlage

Starte mit `urobilanz-theme-template.json` und passe mindestens diese Felder an:

- `id`: eindeutige technische Kennung, nur Kleinbuchstaben, Zahlen und `-`
- `name`: Anzeigename fuer Deutsch und Englisch
- `mode`: `light` oder `dark`
- `colors.text`
- `colors.background`
- `colors.panel`
- `colors.accent`
- `colors.urine`
- `colors.water`

Farben werden als Hex-Werte geschrieben, zum Beispiel `#F2BD00`.

## Import

In Web-App und SwiftUI-App wird das Theme ueber `Theme importieren` geladen.
Eingebaute Themes bleiben erhalten und koennen nicht ueberschrieben werden.

## Beispiel

Beispiele:

- `example-custom-theme.json`: dunkles Beispieltheme
- `example-alpine-morning.json`: helles, ruhiges Beispieltheme
- `example-graphite-lime.json`: dunkles, kontrastreicheres Beispieltheme
