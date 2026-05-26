# UroBilanz Liquid Glass Icon 21B

Diese Mappe ist die saubere Quelle fuer das finale UroBilanz-App-Icon.

## Inhalt

- `light/composite.svg` und `dark/composite.svg`: fertige Vorschau fuer Light/Dark.
- `light/01-...` bis `light/06-...`: getrennte Light-Ebenen.
- `dark/01-...` bis `dark/06-...`: getrennte Dark-Ebenen.
- `preview.html`: schnelle Ansicht im Browser.

## Warum Ebenen?

macOS 26 / Liquid Glass lebt von getrennten Motiv-, Glas-, Licht- und Hintergrundebenen. Diese Dateien sind deshalb nicht nur ein flaches Bild, sondern als Import-Vorlage fuer Icon Composer vorbereitet.

## Aktueller App-Stand

Auf diesem Mac ist kein Icon Composer/Xcode-Werkzeug installiert. Deshalb bleibt in der gebauten App vorerst die normale `.icns`-Datei als kompatibler Fallback aktiv. Sobald Icon Composer verfuegbar ist, koennen diese SVG-Ebenen importiert und als echtes Liquid-Glass-App-Icon exportiert werden.
