# Projektregeln

- Änderungen an UroBilanz werden nach Möglichkeit direkt in Git festgehalten.
- Zu relevanten Änderungen wird der `CHANGELOG.md` aktualisiert.
- Persönliche CSV-, Excel-, Backup- oder Gesundheitsdaten gehören nicht ins Repository.
- Bei jeder Final-Version wird vor der Veröffentlichung `./privacy_final_check.sh`
  ausgeführt, das Laufzeit-Netzwerkverhalten beider Apps geprüft und
  `docs/PRIVACY_CHECK.md` ergänzt. Für Betas ist dieser vollständige Check
  nicht erforderlich.
- Öffentliche Dokumentation enthält keine absoluten lokalen Benutzerpfade.
- Git-Commits verwenden den öffentlichen Entwicklernamen und eine
  GitHub-Noreply-Adresse.
- Der lokale Pre-Push-Hook und die GitHub-Actions-Prüfung müssen aktiv bleiben.
  Sie verhindern Pushes mit lokalen Pfaden, privaten Commit-Adressen,
  sensiblen Datendateien oder möglichen Zugangsdaten.
- Vor größeren technischen Varianten wird zuerst kurz erklärt, welche Optionen es gibt.
- Optische Änderungen und Funktionsänderungen werden getrennt beschrieben, damit später klar bleibt, was sich geändert hat.
