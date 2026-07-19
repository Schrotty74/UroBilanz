# Projektregeln

- Projektgedaechtnis-Dateien muessen gepflegt werden:
  - `PROJECT_CONTEXT.md` enthaelt den aktuellen Projektstand, Architektur,
    Dateistruktur, Funktionen, Designentscheidungen und bekannte Grenzen.
  - `docs/NEXT_STEPS.md` enthaelt nur offene Aufgaben, Bugs, Prioritaeten,
    geplante Verbesserungen und Zukunftsideen.
  - `docs/PROJEKTREGELN.md` enthaelt dauerhafte Datenschutz-, Build-/Release-,
    Backup-, Git-/Push- und Dev/Beta/Final-Regeln.
  - `docs/HISTORY.md` enthaelt abgeschlossene Versionen, Betas, RCs, Finals,
    technische Meilensteine und groessere abgeschlossene Aenderungen.
- Bei groesseren Aenderungen, neuen Funktionen, Refactorings oder wichtigen
  Entscheidungen diese Projektgedaechtnis-Dateien aktualisieren, bevor die
  Aufgabe als abgeschlossen gilt.
- Änderungen an UroBilanz werden nach Möglichkeit direkt in Git festgehalten.
- Zu relevanten Änderungen wird der `CHANGELOG.md` aktualisiert.
- Die oeffentlichen PDF-Handbuecher sind Teil der Produktfunktion: Bei jeder
  neuen sichtbaren Funktion, Option, Schaltflaeche, Bedienungs- oder
  Datenschutz-Aenderung muessen das deutsche und englische Handbuch unter
  `docs/output/pdf/` sowie `docs/manual/build_manuals.py` im selben Arbeitsschritt
  aktualisiert, neu erzeugt und per gerenderten Seitenbildern geprueft werden.
- Kein Beta-, Final- oder Dokumentations-Push darf neue sichtbare App-Funktionen
  enthalten, die im jeweiligen PDF-Handbuch noch fehlen oder falsch erklaert
  sind.
- Persönliche CSV-, Excel-, Backup- oder Gesundheitsdaten gehören nicht ins Repository.
- Bei jeder Final-Version wird vor der Veröffentlichung `./privacy_final_check.sh`
  ausgeführt, das Laufzeit-Netzwerkverhalten beider Apps geprüft und
  `docs/PRIVACY_CHECK.md` ergänzt. Für Betas ist dieser vollständige Check
  nicht erforderlich.
- Öffentliche Dokumentation enthält keine absoluten lokalen Benutzerpfade.
- Git-Commits und öffentliche Entwicklerangaben verwenden ausschließlich das
  Pseudonym `Schrotty74` und eine GitHub-Noreply-Adresse. Der reale Name darf
  nicht veröffentlicht werden.
- Der lokale Pre-Push-Hook und die GitHub-Actions-Prüfung müssen aktiv bleiben.
  Sie verhindern Pushes mit lokalen Pfaden, privaten Commit-Adressen,
  sensiblen Datendateien oder möglichen Zugangsdaten.
- Lokale Versionssicherungen unter `UroBilanz-Backups` werden ausschließlich
  als vollständige ZIP-Archive mit `SHA256SUMS.txt` abgelegt. Vor dem Entfernen
  einer Ausgangskopie müssen ZIP-Inhalt und Prüfsumme erfolgreich geprüft
  werden. Lose Projekt-, App-, Build-, `.venv`- oder `.git`-Ordner gelten nicht
  als fertiges Backup.
- Ab dem nächsten Build wird die macOS-App für lokale Sicherungen und
  GitHub-Releases zusätzlich zur ZIP-Datei auch als DMG bereitgestellt. Die
  Web-App bleibt als ZIP verfügbar.
- Release-Pakete werden nur noch ueber `Scripts/build-release-package.sh`
  erstellt. `apps/web/build_web.sh` bleibt ein internes Hilfsskript, damit
  Web-ZIP, macOS-ZIP, macOS-DMG und SHA256-Dateien immer gemeinsam im selben
  Zielordner landen.
- Final-Backups werden kuenftig genau zweimal aufbewahrt: eine lokale Kopie und
  eine iCloud-Kopie. Beta-, RC- und Zwischenstands-Backups werden nicht
  dauerhaft aufbewahrt. Wenn mehrere Final-Backups vorhanden sind, bleibt nur
  die neueste Final-Version erhalten.
- Vor größeren technischen Varianten wird zuerst kurz erklärt, welche Optionen es gibt.
- Optische Änderungen und Funktionsänderungen werden getrennt beschrieben, damit später klar bleibt, was sich geändert hat.
