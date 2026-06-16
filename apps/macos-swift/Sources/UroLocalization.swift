import SwiftUI


enum AppLanguage: String, CaseIterable, Identifiable {
    case de
    case en

    var id: String { rawValue }
    var label: String { rawValue.uppercased() }

    static var systemDefault: AppLanguage {
        Locale.preferredLanguages.first?.lowercased().hasPrefix("de") == true ? .de : .en
    }
}

private let translations: [AppLanguage: [String: String]] = [
    .de: [
        "dashboard": "Dashboard", "year": "Jahr", "month": "Monat", "week": "Woche", "day": "Tag", "notes": "Regeln",
        "language": "Sprache", "import_theme": "Theme importieren", "export_theme": "Theme exportieren", "delete_theme": "Theme löschen", "delete_theme_confirm": "Importiertes Theme wirklich löschen?", "remember_data": "Daten merken", "entry": "Eintrag", "merge_csv": "CSV ergänzen", "load_csv": "CSV laden",
        "delete": "Löschen", "backup": "Backup", "complete_backup": "Komplett-Backup", "daily_backup": "Tagesbackup", "json_export": "Als JSON exportieren", "daily_data": "Tagesdaten", "no_data": "Keine Daten geladen",
        "no_data_help": "Lade einen CSV-Export aus Urinote oder eine Tagesdaten-CSV.", "csv_error": "CSV konnte nicht geladen werden",
        "entry_add": "Eintrag hinzufügen", "entry_edit": "Eintrag bearbeiten", "date": "Datum", "urine_time": "Urin Uhrzeit",
        "urine_ml": "Urin ml", "water_time": "Wasser Uhrzeit", "water_ml": "Wasser ml", "note": "Hinweis", "close": "Schließen",
        "new": "Neu", "add": "Hinzufügen", "add_close": "Hinzufügen & schließen", "entry_delete": "Eintrag löschen?",
        "cancel": "Abbrechen", "entry_delete_confirm": "Diesen Eintrag wirklich löschen?", "entries_day": "Einträge an diesem Messtag",
        "no_entries_day": "Für diesen Messtag gibt es noch keine Einträge.", "edit": "Bearbeiten", "all_years": "Alle Jahre",
        "all_months": "Alle Monate", "measurement_days": "Messtage", "urine_total": "Urin gesamt ml", "urine_average": "Urin Ø ml/Tag",
        "water_total": "Wasser gesamt ml", "low_days": "Niedrige Urin-Tage", "normal_days": "Normale Urin-Tage",
        "daily_progress": "Tagesverlauf", "monthly_comparison": "Monatsvergleich", "urine": "Urin", "water": "Wasser",
        "flags": "Auffälligkeiten", "flag": "Auffälligkeit", "trend": "Trend", "streak_days": "Tage in Folge", "low": "niedrig", "normal": "normal", "incomplete": "unvollständig", "low_with_incomplete": "niedrig · {count} unvollständig", "normal_with_incomplete": "normal · {count} unvollständig", "days": "Tage", "incomplete_days": "Unvollständige Tage",
        "urine_count": "Urin Anzahl", "week_short": "KW", "urine_times": "Urin Zeiten", "urine_sum": "Urin Summe",
        "water_times": "Wasser Zeiten", "water_sum": "Wasser Summe", "hints": "Hinweise", "action": "Aktion", "delete_day": "Tag löschen",
        "delete_measurement_day": "Messtag löschen?", "delete_day_detail": "Alle Urin-, Wasser- und Hinweis-Einträge dieses Messtags werden gelöscht.",
        "delete_day_confirm": "Messtag {date} wirklich löschen?\n\nAlle Urin-, Wasser- und Hinweis-Einträge dieses Messtags werden gelöscht.",
        "medical_notes": "Bewertungsregeln", "note_intro": "Diese Regeln beschreiben nur die organisatorische Auswertung in UroBilanz. Sie ersetzen keine medizinische Bewertung.",
        "rule_day_title": "Messtag", "rule_day_text": "Ein Messtag läuft von 06:00 bis 05:59. Einträge zwischen 00:00 und 05:59 werden dem Vortag zugerechnet, die Uhrzeit selbst bleibt erhalten.",
        "rule_complete_title": "Vollständig", "rule_complete_text": "Ein Messtag wird für Summen, Durchschnitt und Bewertung nur ausgewertet, wenn zwischen erstem und letztem Urin- oder Wasserwert mindestens acht Stunden liegen.",
        "rule_low_title": "Niedrig", "rule_low_text": "Ein vollständiger Messtag gilt als niedrig, wenn die Urin-Gesamtmenge unter 700 ml liegt.",
        "rule_normal_title": "Normal", "rule_normal_text": "Ein vollständiger Messtag ab 700 ml Urin wird als normal geführt. Eine automatische Hoch-Bewertung gibt es nicht.",
        "rule_incomplete_title": "Unvollständig", "rule_incomplete_text": "Unvollständige Randtage bleiben in der Tagesansicht sichtbar, werden aber nicht in Summen, Durchschnitt oder niedrig/normal-Bewertung eingerechnet.",
        "rule_water_title": "Wasser und Hinweise", "rule_water_text": "Wasser wird separat geführt und nicht mit Urin vermischt. Hinweise bleiben als Kontext sichtbar und verändern keine Bewertung.",
        "no_valid_entries": "Keine gültigen Einträge gefunden.", "merge_original_only": "Ergänzen ist nur mit der originalen Urinote-CSV möglich, nicht mit der Tagesdaten-CSV.",
        "no_new_entries": "Keine gültigen neuen Einträge gefunden.", "encoding_error": "Die Textkodierung wurde nicht erkannt.",
        "invalid_daily_data": "Tagesdaten-Format erkannt, aber keine Messtage gefunden.", "already_present": "Eintrag war bereits vorhanden",
        "entry_added": "Eintrag hinzugefügt", "entry_deleted": "Eintrag gelöscht", "day_deleted": "Messtag gelöscht",
        "no_entry_created": "Kein Eintrag erstellt", "to": "bis", "new_entries": "neue Einträge ergänzt", "existing_entries": "bereits vorhanden",
        "added": "hinzugefügt", "updated": "aktualisiert",
        "report_bug": "Fehler melden", "bug_report_title": "Fehlerbericht",
        "medical_report": "Arztbericht", "medical_report_intro": "Erstellt einen strukturierten PDF-Bericht für Arzttermine.",
        "period_from": "Zeitraum von", "period_to": "Zeitraum bis", "include_daily_details": "Tagesdetails aufnehmen",
        "include_notes": "Hinweise aufnehmen", "medical_report_note": "Der Bericht verwendet immer ein neutrales, druckfreundliches Layout und keine Theme-Farben.",
        "create_pdf": "PDF erstellen", "report_no_days": "Im gewählten Zeitraum sind keine Messtage vorhanden.",
        "report_save_error": "Der PDF-Bericht konnte nicht gespeichert werden.", "selected_period": "Gewählter Zeitraum",
        "created": "Erstellt", "report_summary": "Zusammenfassung", "evaluated_days": "Ausgewertete Tage",
        "urine_total_report": "Urin gesamt", "urine_average_report": "Urin-Durchschnitt je ausgewertetem Tag",
        "water_total_report": "Wasser gesamt", "daily_overview": "Tagesübersicht", "evaluation": "Bewertung",
        "daily_details": "Tagesdetails", "time": "Uhrzeit", "type": "Typ", "amount": "Menge",
        "general_notes": "Allgemeine Hinweise", "evaluation_rules": "Bewertungsregeln",
        "report_rule_text": "Ein Messtag läuft von 06:00 bis 05:59. Nur vollständige Tage mit mindestens acht Stunden zwischen erstem und letztem Urin- oder Wasserwert werden in Summen, Durchschnitt und niedrig/normal-Bewertung einbezogen. Vollständige Tage unter 700 ml Urin gelten als niedrig, alle anderen vollständigen Tage als normal. Diese organisatorische Bewertung ist keine medizinische Diagnose.",
        "report_privacy": "Lokal mit UroBilanz erstellt. Dieser Bericht enthält keine medizinische Empfehlung.",
        "bug_report_privacy": "CSV-Werte, Hinweise und Gesundheitsdaten werden nicht automatisch in den Bericht aufgenommen.",
        "bug_description": "Was ist passiert?", "bug_steps": "Schritte zum Nachstellen",
        "bug_expected": "Was sollte stattdessen passieren?",
        "bug_report_preview": "Bericht vor dem Senden prüfen und bei Bedarf bearbeiten",
        "save_report": "Bericht speichern", "prepare_email": "E-Mail vorbereiten",
        "about_menu": "Über UroBilanz", "about_description": "Lokales Protokoll- und Auswertungstool für Urin- und Flüssigkeitsprotokolle.",
        "about_developer": "Entwickler", "about_developer_value": "Schrotty74, mit Unterstützung von OpenAI Codex",
        "about_license": "Lizenz", "about_github": "GitHub", "about_contact": "Kontakt"
    ],
    .en: [
        "dashboard": "Dashboard", "year": "Year", "month": "Month", "week": "Week", "day": "Day", "notes": "Rules",
        "language": "Language", "import_theme": "Import theme", "export_theme": "Export theme", "delete_theme": "Delete theme", "delete_theme_confirm": "Delete imported theme?", "remember_data": "Remember data", "entry": "Entry", "merge_csv": "Merge CSV", "load_csv": "Load CSV",
        "delete": "Delete", "backup": "Backup", "complete_backup": "Complete backup", "daily_backup": "Daily backup", "json_export": "Export as JSON", "daily_data": "Daily data", "no_data": "No data loaded",
        "no_data_help": "Load an Urinote CSV export or a daily data CSV.", "csv_error": "CSV could not be loaded",
        "entry_add": "Add entry", "entry_edit": "Edit entry", "date": "Date", "urine_time": "Urine time",
        "urine_ml": "Urine ml", "water_time": "Water time", "water_ml": "Water ml", "note": "Note", "close": "Close",
        "new": "New", "add": "Add", "add_close": "Add & close", "entry_delete": "Delete entry?",
        "cancel": "Cancel", "entry_delete_confirm": "Delete this entry?", "entries_day": "Entries for this day",
        "no_entries_day": "There are no entries for this day yet.", "edit": "Edit", "all_years": "All years",
        "all_months": "All months", "measurement_days": "Days", "urine_total": "Urine total ml", "urine_average": "Urine avg ml/day",
        "water_total": "Water total ml", "low_days": "Low urine days", "normal_days": "Normal urine days",
        "daily_progress": "Daily progress", "monthly_comparison": "Monthly comparison", "urine": "Urine", "water": "Water",
        "flags": "Flags", "flag": "Flag", "trend": "Trend", "streak_days": "Days in a row", "low": "low", "normal": "normal", "incomplete": "incomplete", "low_with_incomplete": "low · {count} incomplete", "normal_with_incomplete": "normal · {count} incomplete", "days": "Days", "incomplete_days": "Incomplete days",
        "urine_count": "Urine count", "week_short": "Week", "urine_times": "Urine times", "urine_sum": "Urine total",
        "water_times": "Water times", "water_sum": "Water total", "hints": "Notes", "action": "Action", "delete_day": "Delete day",
        "delete_measurement_day": "Delete measurement day?", "delete_day_detail": "All urine, water and note entries for this day will be deleted.",
        "delete_day_confirm": "Delete measurement day {date}?\n\nAll urine, water and note entries for this day will be deleted.",
        "medical_notes": "Evaluation rules", "note_intro": "These rules describe only the organizational analysis in UroBilanz. They do not replace medical assessment.",
        "rule_day_title": "Measurement day", "rule_day_text": "A measurement day runs from 06:00 to 05:59. Entries between 00:00 and 05:59 are assigned to the previous day; the actual time remains unchanged.",
        "rule_complete_title": "Complete", "rule_complete_text": "A measurement day is included in totals, averages and evaluation only if there are at least eight hours between the first and last urine or water value.",
        "rule_low_title": "Low", "rule_low_text": "A complete measurement day is marked low when the urine total is below 700 ml.",
        "rule_normal_title": "Normal", "rule_normal_text": "A complete measurement day from 700 ml urine upward is marked normal. There is no automatic high evaluation.",
        "rule_incomplete_title": "Incomplete", "rule_incomplete_text": "Incomplete boundary days remain visible in the daily view, but are not included in totals, averages or low/normal evaluation.",
        "rule_water_title": "Water and notes", "rule_water_text": "Water is tracked separately and is not mixed with urine. Notes remain visible as context and do not change the evaluation.",
        "no_valid_entries": "No valid entries found.", "merge_original_only": "Merging is only available for the original Urinote CSV, not the daily data CSV.",
        "no_new_entries": "No valid new entries found.", "encoding_error": "The text encoding was not recognized.",
        "invalid_daily_data": "Daily data format detected, but no measurement days were found.", "already_present": "Entry was already present",
        "entry_added": "Entry added", "entry_deleted": "Entry deleted", "day_deleted": "Day deleted",
        "no_entry_created": "No entry created", "to": "to", "new_entries": "new entries merged", "existing_entries": "already present",
        "added": "added", "updated": "updated",
        "report_bug": "Report bug", "bug_report_title": "Bug report",
        "medical_report": "Medical report", "medical_report_intro": "Creates a structured PDF report for medical appointments.",
        "period_from": "Period from", "period_to": "Period to", "include_daily_details": "Include daily details",
        "include_notes": "Include notes", "medical_report_note": "The report always uses a neutral print layout and no theme colors.",
        "create_pdf": "Create PDF", "report_no_days": "There are no measurement days in the selected period.",
        "report_save_error": "The PDF report could not be saved.", "selected_period": "Selected period",
        "created": "Created", "report_summary": "Summary", "evaluated_days": "Evaluated days",
        "urine_total_report": "Urine total", "urine_average_report": "Urine average per evaluated day",
        "water_total_report": "Water total", "daily_overview": "Daily overview", "evaluation": "Evaluation",
        "daily_details": "Daily details", "time": "Time", "type": "Type", "amount": "Amount",
        "general_notes": "General notes", "evaluation_rules": "Evaluation rules",
        "report_rule_text": "A measurement day runs from 06:00 to 05:59. Only complete days with at least eight hours between the first and last urine or water entry are included in totals, averages and low/normal evaluation. Complete days below 700 ml urine are marked low; all other complete days are marked normal. This organizational evaluation is not a medical diagnosis.",
        "report_privacy": "Created locally with UroBilanz. This report does not provide medical advice.",
        "bug_report_privacy": "CSV values, notes and health data are not added to the report automatically.",
        "bug_description": "What happened?", "bug_steps": "Steps to reproduce",
        "bug_expected": "What should have happened instead?",
        "bug_report_preview": "Review and edit the report before sending",
        "save_report": "Save report", "prepare_email": "Prepare email",
        "about_menu": "About UroBilanz", "about_description": "Local logging and analysis tool for urine and fluid records.",
        "about_developer": "Developer", "about_developer_value": "Schrotty74, with support from OpenAI Codex",
        "about_license": "License", "about_github": "GitHub", "about_contact": "Contact"
    ]
]

func tr(_ key: String, _ language: AppLanguage, replacements: [String: String] = [:]) -> String {
    var text = translations[language]?[key] ?? translations[.de]?[key] ?? key
    for (name, value) in replacements {
        text = text.replacingOccurrences(of: "{\(name)}", with: value)
    }
    return text
}

private struct AppLanguageKey: EnvironmentKey {
    static let defaultValue: AppLanguage = .de
}

extension EnvironmentValues {
    var appLanguage: AppLanguage {
        get { self[AppLanguageKey.self] }
        set { self[AppLanguageKey.self] = newValue }
    }
}
