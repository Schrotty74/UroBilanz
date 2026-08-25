# Projektregeln

Die allgemeinen Arbeits-, Git-, Veröffentlichungs- und Repository-Datenschutzregeln stehen verbindlich in [`../AGENTS.md`](../AGENTS.md). Diese Datei enthält nur dauerhafte UroBilanz-spezifische Regeln.

- Projektgedaechtnis-Dateien muessen gepflegt werden:
  - `PROJECT_CONTEXT.md` enthaelt den aktuellen Projektstand, Architektur, Dateistruktur, Funktionen, Designentscheidungen und bekannte Grenzen.
  - `CHAT_TEMPLATE.md` ist die kurze Startvorlage fuer neue Projekt-Chats.
  - `docs/NEXT_STEPS.md` enthaelt nur offene Aufgaben, Bugs, Prioritaeten, geplante Verbesserungen und Zukunftsideen.
  - `docs/PROJEKTREGELN.md` enthaelt dauerhafte projektspezifische Datenschutz-, Build-/Release-, Backup- und Dev/Beta/Final-Regeln.
  - `docs/HISTORY.md` enthaelt abgeschlossene Versionen, Betas, RCs, Finals, technische Meilensteine und groessere abgeschlossene Aenderungen.
- Bei groesseren Aenderungen, neuen Funktionen, Refactorings oder wichtigen Entscheidungen diese Projektgedaechtnis-Dateien aktualisieren, bevor die Aufgabe als abgeschlossen gilt.
- Zu relevanten Aenderungen wird der `CHANGELOG.md` aktualisiert.
- Die oeffentlichen PDF-Handbuecher sind Teil der Produktfunktion: Bei jeder neuen sichtbaren Funktion, Option, Schaltflaeche, Bedienungs- oder Datenschutz-Aenderung muessen das deutsche und englische Handbuch unter `docs/output/pdf/` sowie `docs/manual/build_manuals.py` im selben Arbeitsschritt aktualisiert, neu erzeugt und per gerenderten Seitenbildern geprueft werden.
- Kein Beta-, Final- oder Dokumentations-Push darf neue sichtbare App-Funktionen enthalten, die im jeweiligen PDF-Handbuch noch fehlen oder falsch erklaert sind.
- Vor jedem oeffentlichen Push oder Release muss mindestens der bestehende statische Datenschutzcheck erfolgreich sein.
- Bei jeder Final-Version wird zusaetzlich `./privacy_final_check.sh` ausgefuehrt, das Laufzeit-Netzwerkverhalten beider Apps geprueft und `docs/PRIVACY_CHECK.md` ergaenzt. Fuer Betas ist dieser vollstaendige Check nicht erforderlich.
- Der lokale Pre-Push-Hook und die GitHub-Actions-Pruefung muessen aktiv bleiben. Sie verhindern Pushes mit lokalen Pfaden, privaten Commit-Adressen, sensiblen Datendateien oder moeglichen Zugangsdaten.
- Lokale Versionssicherungen unter `UroBilanz-Backups` werden ausschliesslich als vollstaendige ZIP-Archive mit `SHA256SUMS.txt` abgelegt. Vor dem Entfernen einer Ausgangskopie muessen ZIP-Inhalt und Pruefsumme erfolgreich geprueft werden. Lose Projekt-, App-, Build-, `.venv`- oder `.git`-Ordner gelten nicht als fertiges Backup.
- Die macOS-App wird fuer lokale Sicherungen und GitHub-Releases zusaetzlich zur ZIP-Datei als DMG bereitgestellt. Die Web-App bleibt als ZIP verfuegbar.
- Release-Pakete werden nur noch ueber `Scripts/build-release-package.sh` erstellt. `apps/web/build_web.sh` bleibt ein internes Hilfsskript, damit Web-ZIP, macOS-ZIP, macOS-DMG und SHA256-Dateien immer gemeinsam im selben Zielordner landen.
- Final-Backups werden genau zweimal aufbewahrt: eine lokale Kopie und eine iCloud-Kopie. Beta-, RC- und Zwischenstands-Backups werden nicht dauerhaft aufbewahrt. Wenn mehrere Final-Backups vorhanden sind, bleibt nur die neueste Final-Version erhalten.
- Dev-/Beta-Tests bleiben von Final-Daten getrennt. Final-Builds duerfen keine experimentellen Defaults, Themes oder Tabellenbreiten aus Dev-Tests uebernehmen.
- Bei UI-Aenderungen Web-App und SwiftUI-App nach Moeglichkeit funktional konsistent halten.
- Vor groesseren technischen Varianten zuerst kurz erklaeren, welche Optionen es gibt.
- Optische Aenderungen und Funktionsaenderungen getrennt beschreiben, damit spaeter klar bleibt, was sich geaendert hat.
