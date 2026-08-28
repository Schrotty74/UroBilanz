# Projektregeln

Die allgemeinen Arbeits-, Git-, Veröffentlichungs- und Repository-Datenschutzregeln stehen verbindlich in `AGENTS.md`. Diese Datei enthält nur zusätzliche UroBilanz-spezifische Regeln.

## Projektgedächtnis und Dokumentation

- Projektgedächtnis-Dateien müssen gepflegt werden:
  - `PROJECT_CONTEXT.md` enthält den aktuellen Projektstand, Architektur, Dateistruktur, Funktionen, Designentscheidungen und bekannte Grenzen.
  - `CHAT_TEMPLATE.md` ist die kurze Startvorlage für neue Projekt-Chats und verweist auf die vollständigen Projektgedächtnis-Dateien.
  - `NEXT_STEPS.md` enthält nur offene Aufgaben, Bugs, Prioritäten, geplante Verbesserungen und Zukunftsideen.
  - `docs/PROJEKTREGELN.md` enthält die zusätzlichen dauerhaften UroBilanz-Regeln.
  - `docs/HISTORY.md` enthält abgeschlossene Versionen, Betas, RCs, Finals, technische Meilensteine und größere abgeschlossene Änderungen.
- Bei größeren Änderungen, neuen Funktionen, Refactorings oder wichtigen Entscheidungen die betroffenen Projektgedächtnis-Dateien auf den tatsächlichen Stand bringen.
- Zu relevanten öffentlichen Änderungen wird der `CHANGELOG.md` aktualisiert.
- Die öffentlichen PDF-Handbücher sind Teil der Produktdokumentation: Bei jeder neuen sichtbaren Funktion, Option, Schaltfläche, Bedienungs- oder Datenschutz-Änderung müssen das deutsche und englische Handbuch unter `docs/output/pdf/` sowie `docs/manual/build_manuals.py` im selben Arbeitsschritt aktualisiert, neu erzeugt und per gerenderten Seitenbildern geprüft werden.
- Kein Beta-, Final- oder Dokumentations-Push darf neue sichtbare App-Funktionen enthalten, die im jeweiligen PDF-Handbuch noch fehlen oder falsch erklärt sind.

## Projektspezifische Datenschutzprüfung

- Vor jedem öffentlichen Push oder Release muss mindestens der bestehende statische Datenschutzcheck erfolgreich sein.
- Bei jeder Final-Version wird zusätzlich `./privacy_final_check.sh` ausgeführt, das Laufzeit-Netzwerkverhalten beider Apps geprüft und `docs/PRIVACY_CHECK.md` ergänzt. Für Betas ist dieser vollständige Check nicht erforderlich.
- Der lokale Pre-Push-Hook und die GitHub-Actions-Prüfung müssen aktiv bleiben. Sie sollen unter anderem lokale Pfade, private Commit-Adressen, sensible Datendateien und mögliche Zugangsdaten vor einer Veröffentlichung erkennen.
- Für alle Repository-Inhalte und öffentlichen Materialien gelten zusätzlich die Datenschutz- und Namensregeln aus `AGENTS.md`.

## Backup- und Release-Besonderheiten

- Lokale Versionssicherungen unter `UroBilanz-Backups` werden ausschließlich als vollständige ZIP-Archive mit `SHA256SUMS.txt` abgelegt. Vor dem Entfernen einer Ausgangskopie müssen ZIP-Inhalt und Prüfsumme erfolgreich geprüft werden. Lose Projekt-, App-, Build-, `.venv`- oder `.git`-Ordner gelten nicht als fertiges Backup.
- Die macOS-App wird für lokale Sicherungen und GitHub-Releases zusätzlich zur ZIP-Datei als DMG bereitgestellt. Die Web-App bleibt als ZIP verfügbar.
- Release-Pakete werden nur über `Scripts/build-release-package.sh` erstellt. `apps/web/build_web.sh` bleibt ein internes Hilfsskript, damit Web-ZIP, macOS-ZIP, macOS-DMG und SHA256-Dateien immer gemeinsam im selben Zielordner landen.
- Final-Backups werden gemäß dem dokumentierten UroBilanz-Backup-Ablauf aufbewahrt: eine lokale Kopie und eine iCloud-Kopie. Beta-, RC- und Zwischenstands-Backups werden nicht dauerhaft aufbewahrt. Wenn mehrere Final-Backups vorhanden sind, bleibt nur die neueste Final-Version erhalten.
