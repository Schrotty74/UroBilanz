# UroBilanz - Projektkontext

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
