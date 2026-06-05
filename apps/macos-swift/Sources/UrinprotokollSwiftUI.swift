import SwiftUI
import AppKit
import UniformTypeIdentifiers

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
        "delete": "Löschen", "backup": "Backup", "daily_data": "Tagesdaten", "no_data": "Keine Daten geladen",
        "no_data_help": "Lade einen CSV-Export aus Urinote oder eine Tagesdaten-CSV.", "csv_error": "CSV konnte nicht geladen werden",
        "entry_add": "Eintrag hinzufügen", "entry_edit": "Eintrag bearbeiten", "date": "Datum", "urine_time": "Urin Uhrzeit",
        "urine_ml": "Urin ml", "water_time": "Wasser Uhrzeit", "water_ml": "Wasser ml", "note": "Hinweis", "close": "Schließen",
        "new": "Neu", "add": "Hinzufügen", "add_close": "Hinzufügen & schließen", "entry_delete": "Eintrag löschen?",
        "cancel": "Abbrechen", "entry_delete_confirm": "Diesen Eintrag wirklich löschen?", "entries_day": "Einträge an diesem Messtag",
        "no_entries_day": "Für diesen Messtag gibt es noch keine Einträge.", "edit": "Bearbeiten", "all_years": "Alle Jahre",
        "all_months": "Alle Monate", "measurement_days": "Messtage", "urine_total": "Urin gesamt ml", "urine_average": "Urin Ø ml/Tag",
        "water_total": "Wasser gesamt ml", "low_days": "Niedrige Urin-Tage", "normal_days": "Normale Urin-Tage",
        "daily_progress": "Tagesverlauf", "monthly_comparison": "Monatsvergleich", "urine": "Urin", "water": "Wasser",
        "flags": "Auffälligkeiten", "flag": "Auffälligkeit", "low": "niedrig", "normal": "normal", "incomplete": "unvollständig", "low_with_incomplete": "niedrig · {count} unvollständig", "normal_with_incomplete": "normal · {count} unvollständig", "days": "Tage", "incomplete_days": "Unvollständige Tage",
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
        "added": "hinzugefügt", "updated": "aktualisiert"
    ],
    .en: [
        "dashboard": "Dashboard", "year": "Year", "month": "Month", "week": "Week", "day": "Day", "notes": "Rules",
        "language": "Language", "import_theme": "Import theme", "export_theme": "Export theme", "delete_theme": "Delete theme", "delete_theme_confirm": "Delete imported theme?", "remember_data": "Remember data", "entry": "Entry", "merge_csv": "Merge CSV", "load_csv": "Load CSV",
        "delete": "Delete", "backup": "Backup", "daily_data": "Daily data", "no_data": "No data loaded",
        "no_data_help": "Load an Urinote CSV export or a daily data CSV.", "csv_error": "CSV could not be loaded",
        "entry_add": "Add entry", "entry_edit": "Edit entry", "date": "Date", "urine_time": "Urine time",
        "urine_ml": "Urine ml", "water_time": "Water time", "water_ml": "Water ml", "note": "Note", "close": "Close",
        "new": "New", "add": "Add", "add_close": "Add & close", "entry_delete": "Delete entry?",
        "cancel": "Cancel", "entry_delete_confirm": "Delete this entry?", "entries_day": "Entries for this day",
        "no_entries_day": "There are no entries for this day yet.", "edit": "Edit", "all_years": "All years",
        "all_months": "All months", "measurement_days": "Days", "urine_total": "Urine total ml", "urine_average": "Urine avg ml/day",
        "water_total": "Water total ml", "low_days": "Low urine days", "normal_days": "Normal urine days",
        "daily_progress": "Daily progress", "monthly_comparison": "Monthly comparison", "urine": "Urine", "water": "Water",
        "flags": "Flags", "flag": "Flag", "low": "low", "normal": "normal", "incomplete": "incomplete", "low_with_incomplete": "low · {count} incomplete", "normal_with_incomplete": "normal · {count} incomplete", "days": "Days", "incomplete_days": "Incomplete days",
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
        "added": "added", "updated": "updated"
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

enum AppTheme: String, CaseIterable, Identifiable {
    case classicLight = "classic-light"
    case classicDark = "classic-dark"
    case violetNight = "violet-night"
    case liquidDark = "liquid-dark"
    case medicalLight = "medical-light"
    case highContrast = "high-contrast"
    case summer = "summer"
    case creamSage = "cream-sage"

    var id: String { rawValue }

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .classicLight: language == .de ? "Classic Hell" : "Classic Light"
        case .classicDark: language == .de ? "Classic Dunkel" : "Classic Dark"
        case .violetNight: "Violet Night"
        case .liquidDark: "Liquid Dark"
        case .medicalLight: "Medical Light"
        case .highContrast: "High Contrast"
        case .summer: language == .de ? "Sommer Look" : "Summer Look"
        case .creamSage: language == .de ? "Creme Salbei" : "Cream Sage"
        }
    }

    var preferredScheme: ColorScheme {
        switch self {
        case .classicDark, .violetNight, .liquidDark, .highContrast: .dark
        case .classicLight, .medicalLight, .summer, .creamSage: .light
        }
    }

    var isDark: Bool { preferredScheme == .dark }

    var accent: Color {
        switch self {
        case .classicLight, .classicDark: .yellow
        case .violetNight: Color(red: 1.00, green: 0.47, blue: 0.78)
        case .liquidDark: Color(red: 1.00, green: 0.82, blue: 0.30)
        case .medicalLight: Color(red: 0.18, green: 0.53, blue: 0.57)
        case .highContrast: .yellow
        case .summer: Color(red: 1.00, green: 0.70, blue: 0.18)
        case .creamSage: Color(red: 0.47, green: 0.68, blue: 0.46)
        }
    }

    var urineColor: Color {
        switch self {
        case .violetNight: Color(red: 0.95, green: 0.98, blue: 0.55)
        case .highContrast: .yellow
        case .summer: Color(red: 0.88, green: 0.55, blue: 0.02)
        case .creamSage: Color(red: 0.78, green: 0.50, blue: 0.08)
        default: Color(red: 1.00, green: 0.82, blue: 0.25)
        }
    }

    var waterColor: Color {
        switch self {
        case .violetNight: Color(red: 0.55, green: 0.91, blue: 0.99)
        case .highContrast: .cyan
        case .summer: Color(red: 0.13, green: 0.65, blue: 0.75)
        case .creamSage: Color(red: 0.18, green: 0.56, blue: 0.62)
        default: Color(red: 0.16, green: 0.58, blue: 1.00)
        }
    }

    var background: [Color] {
        switch self {
        case .classicLight:
            [Color(nsColor: .windowBackgroundColor), .teal.opacity(0.10), .yellow.opacity(0.06)]
        case .classicDark:
            [Color(red: 0.05, green: 0.08, blue: 0.10), .teal.opacity(0.18), .yellow.opacity(0.08)]
        case .violetNight:
            [Color(red: 0.11, green: 0.11, blue: 0.16), Color(red: 0.18, green: 0.16, blue: 0.27), Color(red: 0.36, green: 0.22, blue: 0.46).opacity(0.55)]
        case .liquidDark:
            [Color(red: 0.04, green: 0.07, blue: 0.09), Color(red: 0.06, green: 0.20, blue: 0.23), Color(red: 0.12, green: 0.25, blue: 0.29).opacity(0.55)]
        case .medicalLight:
            [Color(red: 0.96, green: 0.99, blue: 0.99), Color(red: 0.87, green: 0.95, blue: 0.96), Color.white]
        case .highContrast:
            [.black, .black, .black]
        case .summer:
            [Color(red: 1.00, green: 0.95, blue: 0.78), Color(red: 1.00, green: 0.83, blue: 0.54), Color(red: 0.76, green: 0.94, blue: 0.88).opacity(0.55)]
        case .creamSage:
            [Color(red: 0.97, green: 0.94, blue: 0.88), Color(red: 0.93, green: 0.89, blue: 0.81), Color(red: 0.80, green: 0.88, blue: 0.76).opacity(0.50)]
        }
    }

    var controlBackground: Color {
        switch self {
        case .classicLight, .medicalLight, .creamSage:
            Color.white.opacity(0.86)
        case .summer:
            Color(red: 1.00, green: 0.91, blue: 0.70).opacity(0.88)
        case .highContrast:
            .black
        case .classicDark, .violetNight, .liquidDark:
            Color.black.opacity(0.38)
        }
    }

    var controlForeground: Color {
        switch self {
        case .classicLight, .medicalLight, .summer:
            Color(red: 0.10, green: 0.14, blue: 0.16)
        case .creamSage:
            Color(red: 0.20, green: 0.16, blue: 0.12)
        case .highContrast:
            .white
        case .classicDark, .violetNight, .liquidDark:
            .white
        }
    }

    var controlBorder: Color {
        switch self {
        case .highContrast:
            .white
        default:
            accent.opacity(isDark ? 0.30 : 0.22)
        }
    }

    var tableBackground: Color {
        switch self {
        case .classicLight, .medicalLight:
            Color.white.opacity(0.72)
        case .summer:
            Color(red: 1.00, green: 0.94, blue: 0.78).opacity(0.78)
        case .creamSage:
            Color(red: 0.98, green: 0.95, blue: 0.88).opacity(0.82)
        case .highContrast:
            .black
        case .classicDark:
            Color(red: 0.07, green: 0.10, blue: 0.12).opacity(0.76)
        case .violetNight:
            Color(red: 0.16, green: 0.16, blue: 0.22).opacity(0.78)
        case .liquidDark:
            Color(red: 0.08, green: 0.13, blue: 0.15).opacity(0.70)
        }
    }

    var tableRow: Color {
        switch self {
        case .classicLight, .medicalLight:
            Color.white.opacity(0.45)
        case .summer:
            Color(red: 1.00, green: 0.88, blue: 0.62).opacity(0.36)
        case .creamSage:
            Color(red: 0.91, green: 0.87, blue: 0.78).opacity(0.48)
        case .highContrast:
            Color.white.opacity(0.08)
        case .classicDark:
            Color.white.opacity(0.06)
        case .violetNight:
            Color(red: 0.27, green: 0.28, blue: 0.35).opacity(0.42)
        case .liquidDark:
            Color.white.opacity(0.07)
        }
    }

    var style: ThemeStyle {
        ThemeStyle(
            id: rawValue,
            preferredScheme: preferredScheme,
            isHighContrast: self == .highContrast,
            accent: accent,
            urineColor: urineColor,
            waterColor: waterColor,
            background: background,
            controlBackground: controlBackground,
            controlForeground: controlForeground,
            controlBorder: controlBorder,
            tableBackground: tableBackground,
            tableRow: tableRow
        )
    }

    func exportCopy(existingIds: Set<String>) throws -> CustomThemeDefinition {
        let baseId = "\(rawValue)-custom"
        let theme = CustomThemeDefinition(
            format: "urobilanz-theme",
            version: 1,
            id: Self.uniqueCustomId(baseId: baseId, existingIds: existingIds),
            name: CustomThemeDefinition.ThemeName(
                de: "\(title(.de)) Kopie",
                en: "\(title(.en)) Copy"
            ),
            mode: isDark ? "dark" : "light",
            colors: exportColors,
            effects: CustomThemeDefinition.ThemeEffects(
                glassOpacity: 0.86,
                glassBorderOpacity: 0.30,
                shadowOpacity: isDark ? 0.28 : 0.16
            )
        )
        return try theme.validated()
    }

    private static func uniqueCustomId(baseId: String, existingIds: Set<String>) -> String {
        var id = baseId
        var index = 2
        while CustomThemeDefinition.builtInIds.contains(id) || existingIds.contains(id) {
            id = "\(baseId)-\(index)"
            index += 1
        }
        return id
    }

    private var exportColors: CustomThemeDefinition.ThemeColors {
        switch self {
        case .classicLight:
            Self.colors(
                text: "#172024", mutedText: "#60706D", background: "#F6FBFA", backgroundAlt: "#EAF5F2",
                panel: "#FFFFFF", panelSoft: "#F2F8F6", border: "#C8D8D5", accent: "#A8C957",
                accentText: "#172024", urine: "#E8B923", urineSoft: "#F7E3A4", water: "#2D91E8",
                waterSoft: "#B9DBF8", low: "#F8D7DA", rowOdd: "#F4FAF8", rowEven: "#FFFFFF",
                chartUrine: "#E8B923", chartWater: "#2D91E8"
            )
        case .classicDark:
            Self.colors(
                text: "#F6FBFA", mutedText: "#C9D4D2", background: "#0E171A", backgroundAlt: "#172326",
                panel: "#142024", panelSoft: "#1B292C", border: "#3E5E59", accent: "#A8C957",
                accentText: "#101614", urine: "#F6C84F", urineSoft: "#51451D", water: "#4AA3FF",
                waterSoft: "#173A52", low: "#5C252B", rowOdd: "#192529", rowEven: "#101A1D",
                chartUrine: "#F6C84F", chartWater: "#4AA3FF"
            )
        case .violetNight:
            Self.colors(
                text: "#FFF7FF", mutedText: "#D8CBE3", background: "#1C1B29", backgroundAlt: "#2E2945",
                panel: "#292638", panelSoft: "#3B344F", border: "#70588A", accent: "#FF78C7",
                accentText: "#221527", urine: "#F3FA8C", urineSoft: "#4D4525", water: "#8DE9FC",
                waterSoft: "#25475B", low: "#603044", rowOdd: "#363647", rowEven: "#282738",
                chartUrine: "#F3FA8C", chartWater: "#8DE9FC"
            )
        case .liquidDark:
            Self.colors(
                text: "#EFFAF9", mutedText: "#B7D2D0", background: "#0B1316", backgroundAlt: "#102F36",
                panel: "#122328", panelSoft: "#1A383F", border: "#3E747C", accent: "#FFD24C",
                accentText: "#142024", urine: "#FFD24C", urineSoft: "#4C421C", water: "#41D1C7",
                waterSoft: "#193E45", low: "#5B2530", rowOdd: "#172B30", rowEven: "#0F1C20",
                chartUrine: "#FFD24C", chartWater: "#41D1C7"
            )
        case .medicalLight:
            Self.colors(
                text: "#183033", mutedText: "#5C7376", background: "#F6FCFC", backgroundAlt: "#DDEFF1",
                panel: "#FFFFFF", panelSoft: "#ECF7F8", border: "#B8D4D8", accent: "#2E8792",
                accentText: "#FFFFFF", urine: "#E8B923", urineSoft: "#F5E6AE", water: "#227DC6",
                waterSoft: "#C2DFF1", low: "#F5D5D8", rowOdd: "#F0F8F9", rowEven: "#FFFFFF",
                chartUrine: "#E8B923", chartWater: "#227DC6"
            )
        case .highContrast:
            Self.colors(
                text: "#FFFFFF", mutedText: "#FFFFFF", background: "#000000", backgroundAlt: "#000000",
                panel: "#000000", panelSoft: "#111111", border: "#FFFFFF", accent: "#FFFF00",
                accentText: "#000000", urine: "#FFFF00", urineSoft: "#333300", water: "#00FFFF",
                waterSoft: "#003333", low: "#FF4D4D", rowOdd: "#141414", rowEven: "#000000",
                chartUrine: "#FFFF00", chartWater: "#00FFFF"
            )
        case .summer:
            Self.colors(
                text: "#2A2618", mutedText: "#74664A", background: "#FFF3C8", backgroundAlt: "#FFD48A",
                panel: "#FFF0C2", panelSoft: "#FFE19E", border: "#D99635", accent: "#FFB32E",
                accentText: "#2A1A0A", urine: "#E08C04", urineSoft: "#F8DDA7", water: "#21A6BF",
                waterSoft: "#BCE7E7", low: "#F7C6B8", rowOdd: "#FFE1A0", rowEven: "#FFF0C2",
                chartUrine: "#E08C04", chartWater: "#21A6BF"
            )
        case .creamSage:
            Self.colors(
                text: "#34281F", mutedText: "#766E5F", background: "#F8F0E2", backgroundAlt: "#E8E0CE",
                panel: "#FDF4E6", panelSoft: "#E8DECB", border: "#B6C3A7", accent: "#78AD75",
                accentText: "#172015", urine: "#C77F14", urineSoft: "#ECD7AF", water: "#2E8F9E",
                waterSoft: "#C2DCD5", low: "#F2CFCB", rowOdd: "#E8DECB", rowEven: "#FDF4E6",
                chartUrine: "#C77F14", chartWater: "#2E8F9E"
            )
        }
    }

    private static func colors(
        text: String, mutedText: String, background: String, backgroundAlt: String,
        panel: String, panelSoft: String, border: String, accent: String,
        accentText: String, urine: String, urineSoft: String, water: String,
        waterSoft: String, low: String, rowOdd: String, rowEven: String,
        chartUrine: String, chartWater: String
    ) -> CustomThemeDefinition.ThemeColors {
        CustomThemeDefinition.ThemeColors(
            text: text,
            mutedText: mutedText,
            background: background,
            backgroundAlt: backgroundAlt,
            panel: panel,
            panelSoft: panelSoft,
            border: border,
            accent: accent,
            accentText: accentText,
            urine: urine,
            urineSoft: urineSoft,
            water: water,
            waterSoft: waterSoft,
            low: low,
            rowOdd: rowOdd,
            rowEven: rowEven,
            chartUrine: chartUrine,
            chartWater: chartWater
        )
    }
}

struct ThemeStyle {
    let id: String
    let preferredScheme: ColorScheme
    let isHighContrast: Bool
    let accent: Color
    let urineColor: Color
    let waterColor: Color
    let background: [Color]
    let controlBackground: Color
    let controlForeground: Color
    let controlBorder: Color
    let tableBackground: Color
    let tableRow: Color

    var isDark: Bool { preferredScheme == .dark }

    static func resolve(id: String, customThemes: [CustomThemeDefinition]) -> ThemeStyle {
        if let builtIn = AppTheme(rawValue: id) {
            return builtIn.style
        }
        if let custom = customThemes.first(where: { $0.id == id }) {
            return custom.style
        }
        return AppTheme.classicDark.style
    }
}

struct CustomThemeDefinition: Codable, Identifiable, Equatable {
    struct ThemeName: Codable, Equatable {
        var de: String?
        var en: String?
    }

    struct ThemeColors: Codable, Equatable {
        var text: String
        var mutedText: String?
        var background: String
        var backgroundAlt: String?
        var panel: String
        var panelSoft: String?
        var border: String?
        var accent: String
        var accentText: String?
        var urine: String
        var urineSoft: String?
        var water: String
        var waterSoft: String?
        var low: String?
        var rowOdd: String?
        var rowEven: String?
        var chartUrine: String?
        var chartWater: String?
    }

    struct ThemeEffects: Codable, Equatable {
        var glassOpacity: Double?
        var glassBorderOpacity: Double?
        var shadowOpacity: Double?
    }

    var format: String
    var version: Int
    var id: String
    var name: ThemeName
    var mode: String
    var colors: ThemeColors
    var effects: ThemeEffects?

    static let builtInIds = Set(AppTheme.allCases.map(\.rawValue))

    func title(_ language: AppLanguage) -> String {
        switch language {
        case .de: name.de ?? name.en ?? id
        case .en: name.en ?? name.de ?? id
        }
    }

    var style: ThemeStyle {
        let isDark = mode == "dark"
        let panelOpacity = effects?.glassOpacity ?? 0.86
        let borderOpacity = effects?.glassBorderOpacity ?? 0.30
        let accent = Color(hex: colors.accent) ?? .yellow
        let text = Color(hex: colors.text) ?? (isDark ? .white : .black)
        let background = Color(hex: colors.background) ?? (isDark ? .black : .white)
        let backgroundAlt = Color(hex: colors.backgroundAlt) ?? Color(hex: colors.panelSoft) ?? background
        let panel = Color(hex: colors.panel) ?? background
        let panelSoft = Color(hex: colors.panelSoft) ?? panel
        return ThemeStyle(
            id: id,
            preferredScheme: isDark ? .dark : .light,
            isHighContrast: false,
            accent: accent,
            urineColor: Color(hex: colors.chartUrine) ?? Color(hex: colors.urine) ?? .yellow,
            waterColor: Color(hex: colors.chartWater) ?? Color(hex: colors.water) ?? .blue,
            background: [background, backgroundAlt, panelSoft.opacity(0.55)],
            controlBackground: panel.opacity(panelOpacity),
            controlForeground: text,
            controlBorder: Color(hex: colors.border) ?? accent.opacity(borderOpacity),
            tableBackground: panel.opacity(max(0.40, panelOpacity - 0.08)),
            tableRow: (Color(hex: colors.rowOdd) ?? panelSoft).opacity(0.46)
        )
    }

    func validated() throws -> CustomThemeDefinition {
        guard format == "urobilanz-theme" else { throw ThemeImportError.invalidFormat }
        guard version == 1 else { throw ThemeImportError.invalidVersion }
        guard id.range(of: #"^[a-z0-9][a-z0-9-]*$"#, options: .regularExpression) != nil else { throw ThemeImportError.invalidId }
        guard !Self.builtInIds.contains(id) else { throw ThemeImportError.builtInId }
        guard mode == "light" || mode == "dark" else { throw ThemeImportError.invalidMode }
        guard !(name.de ?? name.en ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw ThemeImportError.missingName }
        let colorValues = [
            colors.text, colors.background, colors.panel, colors.accent, colors.urine, colors.water,
            colors.mutedText, colors.backgroundAlt, colors.panelSoft, colors.border, colors.accentText,
            colors.urineSoft, colors.waterSoft, colors.low, colors.rowOdd, colors.rowEven,
            colors.chartUrine, colors.chartWater,
        ].compactMap { $0 }
        guard colorValues.allSatisfy({ Color.isHexColor($0) }) else { throw ThemeImportError.invalidColor }
        let effectValues = [effects?.glassOpacity, effects?.glassBorderOpacity, effects?.shadowOpacity].compactMap { $0 }
        guard effectValues.allSatisfy({ $0 >= 0 && $0 <= 1 }) else { throw ThemeImportError.invalidEffect }
        return self
    }

    static func decodeList(_ raw: String) -> [CustomThemeDefinition] {
        guard let data = raw.data(using: .utf8),
              let themes = try? JSONDecoder().decode([CustomThemeDefinition].self, from: data) else {
            return []
        }
        return themes.compactMap { try? $0.validated() }
    }

    static func encodeList(_ themes: [CustomThemeDefinition]) -> String {
        guard let data = try? JSONEncoder().encode(themes),
              let raw = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return raw
    }
}

enum ThemeImportError: LocalizedError {
    case invalidFormat
    case invalidVersion
    case invalidId
    case builtInId
    case invalidMode
    case missingName
    case invalidColor
    case invalidEffect

    var errorDescription: String? {
        switch self {
        case .invalidFormat: "Theme-Format wird nicht erkannt."
        case .invalidVersion: "Theme-Version wird nicht unterstuetzt."
        case .invalidId: "Theme-ID darf nur Kleinbuchstaben, Zahlen und Bindestriche enthalten."
        case .builtInId: "Eingebaute Themes duerfen nicht ueberschrieben werden."
        case .invalidMode: "Theme-Modus muss light oder dark sein."
        case .missingName: "Theme-Name fehlt."
        case .invalidColor: "Eine Theme-Farbe fehlt oder ist ungueltig."
        case .invalidEffect: "Theme-Effekte muessen zwischen 0 und 1 liegen."
        }
    }
}

extension Color {
    init?(hex: String?) {
        guard let hex else { return nil }
        let clean = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isHexColor(clean) else { return nil }
        let value = String(clean.dropFirst())
        guard let rgb = Int(value, radix: 16) else { return nil }
        self.init(
            red: Double((rgb >> 16) & 0xff) / 255,
            green: Double((rgb >> 8) & 0xff) / 255,
            blue: Double(rgb & 0xff) / 255
        )
    }

    static func isHexColor(_ value: String) -> Bool {
        value.range(of: #"^#[0-9A-Fa-f]{6}$"#, options: .regularExpression) != nil
    }
}

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: ThemeStyle = AppTheme.classicDark.style
}

extension EnvironmentValues {
    var appTheme: ThemeStyle {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

enum AppSection: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case year = "Jahr"
    case month = "Monat"
    case week = "Woche"
    case day = "Tag"
    case notes = "Notizen"

    var id: String { rawValue }

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .dashboard: tr("dashboard", language)
        case .year: tr("year", language)
        case .month: tr("month", language)
        case .week: tr("week", language)
        case .day: tr("day", language)
        case .notes: tr("notes", language)
        }
    }

    var symbol: String {
        switch self {
        case .dashboard: "chart.xyaxis.line"
        case .year: "calendar"
        case .month: "calendar.badge.clock"
        case .week: "calendar.day.timeline.left"
        case .day: "list.bullet.rectangle"
        case .notes: "info.circle"
        }
    }
}

@MainActor
final class UrinModel: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var days: [DaySummary] = []
    @Published var rawCSV = ""
    @Published var status = ""
    @Published var rememberData = UserDefaults.standard.bool(forKey: "swiftUIRememberData")
    @Published var selectedYear = "all"
    @Published var selectedMonth = "all"
    @Published var errorMessage: String?
    @Published private(set) var language = AppLanguage.systemDefault

    private let defaults = UserDefaults.standard
    private let calendar = Calendar(identifier: .gregorian)
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_AT")
        formatter.dateFormat = "d.M.yyyy HH:mm"
        return formatter
    }()
    private let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_AT")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private let rawDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_AT")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_AT")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    var hasData: Bool { !days.isEmpty }
    var years: [Int] { Array(Set(days.map(\.year))).sorted() }
    var filteredDays: [DaySummary] {
        days.filter { day in
            (selectedYear == "all" || String(day.year) == selectedYear) &&
            (selectedMonth == "all" || String(day.month) == selectedMonth)
        }
    }
    var filteredEvaluationDays: [DaySummary] {
        filteredDays.filter(\.isCompleteMeasurementDay)
    }

    init() {
        if ProcessInfo.processInfo.arguments.contains("--test-import") {
            return
        }
        if rememberData, let saved = defaults.string(forKey: "swiftUISavedCSV"), !saved.isEmpty {
            try? load(csv: saved)
        } else {
            updateStatus()
        }
    }

    func setLanguage(_ nextLanguage: AppLanguage) {
        language = nextLanguage
        displayDate.locale = Locale(identifier: nextLanguage == .de ? "de_AT" : "en_US")
        displayDate.dateFormat = nextLanguage == .de ? "dd.MM.yyyy" : "MM/dd/yyyy"
        if !entries.isEmpty {
            days = makeDays(from: entries)
        }
        updateStatus()
    }

    func openCSV() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.commaSeparatedText, .text]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.begin { [weak self] response in
            guard response == .OK, let url = panel.url else { return }
            Task { @MainActor in
                self?.load(url: url)
            }
        }
    }

    func openMergeCSV() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.commaSeparatedText, .text]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.begin { [weak self] response in
            guard response == .OK, let url = panel.url else { return }
            Task { @MainActor in
                self?.merge(url: url)
            }
        }
    }

    func load(url: URL) {
        do {
            let csv = try readTextFile(url)
            try load(csv: csv)
            if rememberData {
                defaults.set(rawCSV, forKey: "swiftUISavedCSV")
                defaults.set(true, forKey: "swiftUIRememberData")
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func load(csv: String) throws {
        let parsed = parseCSV(csv)
        if parsed.first?.keys.contains("Messtag") == true {
            days = try loadDailyExport(parsed)
            entries = days.flatMap(entriesFromDay).sorted { $0.original < $1.original }
            rawCSV = entriesToRawCSV(entries)
            updateStatus()
            return
        }

        var nextEntries: [Entry] = []
        for row in parsed {
            guard let rawDate = row["Datum"], let date = dateFormatter.date(from: rawDate) else { continue }
            let rawType = row["Typ"] ?? ""
            let type = rawType == "Wasser" ? "Wasser" : rawType == "Hinweis" ? "Hinweis" : "Urin"
            let amount = Int(Double(row["ml"] ?? "0") ?? 0)
            nextEntries.append(Entry(
                original: date,
                messtag: measurementDay(for: date),
                type: type,
                ml: amount,
                note: (row["Hinweis"] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            ))
        }
        guard !nextEntries.isEmpty else {
            throw NSError(domain: "Urinprotokoll", code: 1, userInfo: [NSLocalizedDescriptionKey: tr("no_valid_entries", language)])
        }
        entries = nextEntries.sorted { $0.original < $1.original }
        days = makeDays(from: entries)
        rawCSV = entriesToRawCSV(entries)
        updateStatus()
    }

    func merge(url: URL) {
        do {
            let csv = try readTextFile(url)
            let parsed = parseCSV(csv)
            if parsed.first?.keys.contains("Messtag") == true {
                throw NSError(domain: "Urinprotokoll", code: 4, userInfo: [NSLocalizedDescriptionKey: tr("merge_original_only", language)])
            }
            let incoming = parsed.compactMap(rawEntry)
            guard !incoming.isEmpty else {
                throw NSError(domain: "Urinprotokoll", code: 5, userInfo: [NSLocalizedDescriptionKey: tr("no_new_entries", language)])
            }
            let existing = Set(entries.map(\.key))
            let additions = incoming.filter { !existing.contains($0.key) }
            entries = (entries + additions).sorted { $0.original < $1.original }
            days = makeDays(from: entries)
            rawCSV = entriesToRawCSV(entries)
            if rememberData {
                defaults.set(rawCSV, forKey: "swiftUISavedCSV")
            }
            updateStatus(extra: "\(additions.count) \(tr("new_entries", language)) · \(incoming.count - additions.count) \(tr("existing_entries", language))")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addEntry(original: Date, type: String, ml: Int, note: String) {
        let entry = Entry(original: original, messtag: measurementDay(for: original), type: type, ml: ml, note: note.trimmingCharacters(in: .whitespacesAndNewlines))
        if entries.contains(where: { $0.key == entry.key }) {
            updateStatus(extra: tr("already_present", language))
            return
        }
        entries = (entries + [entry]).sorted { $0.original < $1.original }
        days = makeDays(from: entries)
        rawCSV = entriesToRawCSV(entries)
        if rememberData {
            defaults.set(rawCSV, forKey: "swiftUISavedCSV")
        }
        updateStatus(extra: tr("entry_added", language))
    }

    func addManualEntries(date: Date, urineTime: Date, urineMl: Int?, waterTime: Date, waterMl: Int?, note: String) {
        saveManualEntries(date: date, urineTime: urineTime, urineMl: urineMl, waterTime: waterTime, waterMl: waterMl, note: note, replacing: nil)
    }

    func updateManualEntry(index: Int, date: Date, urineTime: Date, urineMl: Int?, waterTime: Date, waterMl: Int?, note: String) {
        saveManualEntries(date: date, urineTime: urineTime, urineMl: urineMl, waterTime: waterTime, waterMl: waterMl, note: note, replacing: index)
    }

    func deleteEntry(index: Int) {
        guard entries.indices.contains(index) else { return }
        entries.remove(at: index)
        days = makeDays(from: entries)
        rawCSV = entriesToRawCSV(entries)
        if rememberData {
            defaults.set(rawCSV, forKey: "swiftUISavedCSV")
        }
        updateStatus(extra: tr("entry_deleted", language))
    }

    func deleteMeasurementDay(_ date: Date) {
        let selectedDay = calendar.startOfDay(for: date)
        entries.removeAll { measurementDay(for: $0.original) == selectedDay }
        days = makeDays(from: entries)
        rawCSV = entriesToRawCSV(entries)
        if rememberData {
            defaults.set(rawCSV, forKey: "swiftUISavedCSV")
        }
        updateStatus(extra: tr("day_deleted", language))
    }

    func entriesForMesstag(_ date: Date) -> [(index: Int, entry: Entry)] {
        let selectedDay = calendar.startOfDay(for: date)
        return entries.enumerated()
            .filter { measurementDay(for: $0.element.original) == selectedDay }
            .map { (index: $0.offset, entry: $0.element) }
            .sorted { $0.entry.original < $1.entry.original }
    }

    private func saveManualEntries(date: Date, urineTime: Date, urineMl: Int?, waterTime: Date, waterMl: Int?, note: String, replacing index: Int?) {
        let cleanNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let urineDate = combinedDate(day: date, time: urineTime)
        let waterDate = combinedDate(day: date, time: waterTime)
        var manualEntries: [Entry] = []
        if let urineMl {
            manualEntries.append(Entry(original: urineDate, messtag: measurementDay(for: urineDate), type: "Urin", ml: urineMl, note: ""))
        }
        if let waterMl {
            manualEntries.append(Entry(original: waterDate, messtag: measurementDay(for: waterDate), type: "Wasser", ml: waterMl, note: ""))
        }
        if !cleanNote.isEmpty {
            let noteDate = manualEntries.first?.original ?? urineDate
            manualEntries.append(Entry(original: noteDate, messtag: measurementDay(for: noteDate), type: "Hinweis", ml: 0, note: cleanNote))
        }

        guard !manualEntries.isEmpty else {
            updateStatus(extra: tr("no_entry_created", language))
            return
        }

        var nextEntries = entries
        if let index, nextEntries.indices.contains(index) {
            nextEntries.remove(at: index)
        }
        entries = (nextEntries + manualEntries).sorted { $0.original < $1.original }
        days = makeDays(from: entries)
        rawCSV = entriesToRawCSV(entries)
        if rememberData {
            defaults.set(rawCSV, forKey: "swiftUISavedCSV")
        }
        updateStatus(extra: "\(manualEntries.count) \(tr("entry", language)) \(tr(index == nil ? "added" : "updated", language))")
    }

    func toggleRemember() {
        defaults.set(rememberData, forKey: "swiftUIRememberData")
        if rememberData, !rawCSV.isEmpty {
            defaults.set(rawCSV, forKey: "swiftUISavedCSV")
        }
        if !rememberData {
            defaults.removeObject(forKey: "swiftUISavedCSV")
        }
    }

    func clearData() {
        entries = []
        days = []
        rawCSV = ""
        selectedYear = "all"
        selectedMonth = "all"
        rememberData = false
        defaults.set(false, forKey: "swiftUIRememberData")
        defaults.removeObject(forKey: "swiftUISavedCSV")
        updateStatus()
    }

    func exportBackup() {
        save(text: rawCSV, defaultName: "urinote-backup.csv")
    }

    func exportDays() {
        let header = ["Jahr","Monat","KW","Messtag","Tag","Urin Uhrzeit","Urin ml","Urin Hinweis","Urin Anzahl","Urin gesamt ml","Wasser Uhrzeit","Wasser ml","Wasser gesamt ml","Hinweise","Allgemeine Hinweise"]
        let rows = days.map { day in
            let urineNotes = day.urine.map { item in
                day.noteRows
                    .filter { $0.0 == item.0 }
                    .map(\.1)
                    .joined(separator: " / ")
            }
            return [
                "\(day.year)",
                stableMonthName(day.month),
                "\(day.week)",
                rawDayFormatter.string(from: day.messtag),
                stableDayName(day.messtag),
                day.urine.map(\.0).joined(separator: " | "),
                day.urine.map { "\($0.1)" }.joined(separator: " | "),
                urineNotes.joined(separator: " | "),
                "\(day.urineCount)",
                "\(day.urineTotal)",
                day.water.map(\.0).joined(separator: " | "),
                day.water.map { "\($0.1)" }.joined(separator: " | "),
                "\(day.waterTotal)",
                day.notesText,
                day.generalNotes.joined(separator: " | ")
            ].map(escape).joined(separator: ",")
        }
        save(text: ([header.joined(separator: ",")] + rows).joined(separator: "\n"), defaultName: "urobilanz-tagesdaten.csv")
    }

    func formattedDate(_ date: Date) -> String {
        displayDate.string(from: date)
    }

    func formattedTime(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }

    func format(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: language == .de ? "de_DE" : "en_US")
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    func summaryRows(kind: AppSection, evaluationOnly: Bool = false) -> [SummaryRow] {
        let sourceDays = evaluationOnly ? filteredEvaluationDays : filteredDays
        switch kind {
        case .year:
            return summarize(days: sourceDays, grouping: { "\($0.year)" }, labels: { ["Jahr": "\($0.year)"] })
        case .month:
            return summarize(days: sourceDays, grouping: { "\($0.year)-\($0.month)" }, labels: { ["Jahr": "\($0.year)", "Monat": "\($0.month)", "Monat Name": $0.monthName] })
        case .week:
            return summarize(days: sourceDays, grouping: { "\($0.year)-\($0.week)" }, labels: { ["Jahr": "\($0.year)", "KW": "\($0.week)"] })
        default:
            return []
        }
    }

    func alertRows() -> [DaySummary] {
        filteredDays.filter { !$0.isCompleteMeasurementDay || $0.urineTotal < 700 }
    }

    private func loadDailyExport(_ rows: [[String: String]]) throws -> [DaySummary] {
        let imported = rows.compactMap { row -> DaySummary? in
            guard let rawDay = row["Messtag"], let messtag = rawDayFormatter.date(from: rawDay) else { return nil }
            let comps = calendar.dateComponents([.year, .month, .weekOfYear], from: messtag)
            let urine = zipLists(
                times: splitList(row["Urin Uhrzeit"] ?? row["● Urin Uhrzeit"] ?? ""),
                amounts: splitList(row["Urin ml"] ?? row["● Urin ml"] ?? "").map(parseAmount)
            )
            let water = zipLists(
                times: splitList(row["Wasser Uhrzeit"] ?? row["💧 Wasser Uhrzeit"] ?? ""),
                amounts: splitList(row["Wasser ml"] ?? row["💧 Wasser ml"] ?? "").map(parseAmount)
            )
            let generalNotes = splitList(row["Allgemeine Hinweise"] ?? "")
            let urineNoteSlots = splitListKeepingEmpty(row["Urin Hinweis"] ?? "")
            let importedNoteRows = urine.enumerated().compactMap { index, item -> (String, String)? in
                guard urineNoteSlots.indices.contains(index) else { return nil }
                let note = urineNoteSlots[index]
                guard !note.isEmpty else { return nil }
                return (item.0, note)
            }
            let notes = (importedNoteRows.map(\.1) + generalNotes)
            let legacyNotes = (row["Hinweise"] ?? "").isEmpty ? [] : [row["Hinweise"] ?? ""]
            return DaySummary(
                messtag: messtag,
                year: comps.year ?? Int(row["Jahr"] ?? "0") ?? 0,
                month: comps.month ?? 0,
                monthName: monthName(comps.month ?? 1),
                week: comps.weekOfYear ?? Int(row["KW"] ?? "0") ?? 0,
                dayName: dayName(messtag),
                urine: urine,
                water: water,
                notes: notes.isEmpty ? legacyNotes : notes,
                noteRows: importedNoteRows,
                generalNotes: generalNotes.isEmpty && importedNoteRows.isEmpty ? legacyNotes : generalNotes
            )
        }.sorted { $0.messtag < $1.messtag }
        guard !imported.isEmpty else {
            throw NSError(domain: "Urinprotokoll", code: 3, userInfo: [NSLocalizedDescriptionKey: tr("invalid_daily_data", language)])
        }
        return imported
    }

    private func splitListKeepingEmpty(_ value: String) -> [String] {
        value.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    private func rawEntry(_ row: [String: String]) -> Entry? {
        guard let rawDate = row["Datum"], let date = dateFormatter.date(from: rawDate) else { return nil }
        let rawType = row["Typ"] ?? ""
        let type = rawType == "Wasser" ? "Wasser" : rawType == "Hinweis" ? "Hinweis" : "Urin"
        return Entry(
            original: date,
            messtag: measurementDay(for: date),
            type: type,
            ml: Int(Double(row["ml"] ?? "0") ?? 0),
            note: (row["Hinweis"] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    private func entriesFromDay(_ day: DaySummary) -> [Entry] {
        func make(_ item: (String, Int), type: String, note: String = "") -> Entry {
            let original = dateFromMesstag(day.messtag, time: item.0)
            return Entry(original: original, messtag: measurementDay(for: original), type: type, ml: item.1, note: note)
        }
        var result = day.urine.map { item in
            make(item, type: "Urin", note: day.noteRows.filter { $0.0 == item.0 }.map(\.1).joined(separator: " / "))
        } + day.water.map { make($0, type: "Wasser") }
        for note in day.generalNotes {
            let original = dateFromNoon(day.messtag)
            result.append(Entry(original: original, messtag: measurementDay(for: original), type: "Hinweis", ml: 0, note: note))
        }
        if result.isEmpty && !day.notesText.isEmpty {
            let original = dateFromNoon(day.messtag)
            result.append(Entry(original: original, messtag: measurementDay(for: original), type: "Hinweis", ml: 0, note: day.notesText))
        }
        return result.sorted { $0.original < $1.original }
    }

    private func dateFromMesstag(_ messtag: Date, time: String) -> Date {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        let hour = parts.first ?? 0
        let minute = parts.dropFirst().first ?? 0
        var comps = calendar.dateComponents([.year, .month, .day], from: messtag)
        comps.hour = hour
        comps.minute = minute
        let date = calendar.date(from: comps) ?? messtag
        return hour < 6 ? calendar.date(byAdding: .day, value: 1, to: date) ?? date : date
    }

    private func combinedDate(day: Date, time: Date) -> Date {
        let dayParts = calendar.dateComponents([.year, .month, .day], from: day)
        let timeParts = calendar.dateComponents([.hour, .minute], from: time)
        var comps = DateComponents()
        comps.year = dayParts.year
        comps.month = dayParts.month
        comps.day = dayParts.day
        comps.hour = timeParts.hour
        comps.minute = timeParts.minute
        return calendar.date(from: comps) ?? day
    }

    private func dateFromNoon(_ day: Date) -> Date {
        var comps = calendar.dateComponents([.year, .month, .day], from: day)
        comps.hour = 12
        comps.minute = 0
        return calendar.date(from: comps) ?? day
    }

    private func makeDays(from entries: [Entry]) -> [DaySummary] {
        Dictionary(grouping: entries, by: { $0.messtag }).keys.sorted().map { day in
            let rows = entries.filter { $0.messtag == day }.sorted { $0.original < $1.original }
            let comps = calendar.dateComponents([.year, .month, .weekOfYear], from: day)
            let noteRows = rows
                .filter { $0.type == "Urin" && !$0.note.isEmpty }
                .map { (timeFormatter.string(from: $0.original), $0.note) }
            let generalNotes = rows
                .filter { $0.type == "Hinweis" && !$0.note.isEmpty }
                .map(\.note)
            return DaySummary(
                messtag: day,
                year: comps.year ?? 0,
                month: comps.month ?? 0,
                monthName: monthName(comps.month ?? 1),
                week: comps.weekOfYear ?? 0,
                dayName: dayName(day),
                urine: rows.filter { $0.type == "Urin" }.map { (timeFormatter.string(from: $0.original), $0.ml) },
                water: rows.filter { $0.type == "Wasser" }.map { (timeFormatter.string(from: $0.original), $0.ml) },
                notes: Array(NSOrderedSet(array: rows.map(\.note).filter { !$0.isEmpty })) as? [String] ?? [],
                noteRows: noteRows,
                generalNotes: generalNotes
            )
        }
    }

    private func summarize(days: [DaySummary], grouping: (DaySummary) -> String, labels: (DaySummary) -> [String: String]) -> [SummaryRow] {
        let grouped = Dictionary(grouping: days, by: grouping)
        return grouped.keys.sorted().compactMap { key in
            guard let rows = grouped[key], let first = rows.first else { return nil }
            let evaluatedRows = rows.filter(\.isCompleteMeasurementDay)
            let incompleteDays = rows.count - evaluatedRows.count
            let urineTotal = evaluatedRows.reduce(0) { $0 + $1.urineTotal }
            let waterTotal = evaluatedRows.reduce(0) { $0 + $1.waterTotal }
            let urineCount = evaluatedRows.reduce(0) { $0 + $1.urineCount }
            let average = evaluatedRows.isEmpty ? 0 : urineTotal / evaluatedRows.count
            let hasLowDay = evaluatedRows.contains { $0.urineTotal < 700 }
            var values = labels(first)
            values["Tage"] = "\(evaluatedRows.count)"
            values["Unvollständige Tage"] = "\(incompleteDays)"
            values["● Urin Gesamt ml"] = format(urineTotal)
            values["● Urin Ø ml/Tag"] = format(average)
            values["● Urin Anzahl"] = "\(urineCount)"
            values["💧 Wasser Gesamt ml"] = format(waterTotal)
            values["Auffälligkeit"] = incompleteDays > 0
                ? evaluatedRows.isEmpty
                    ? tr("incomplete", language)
                    : tr(hasLowDay ? "low_with_incomplete" : "normal_with_incomplete", language, replacements: ["count": "\(incompleteDays)"])
                : tr(hasLowDay ? "low" : "normal", language)
            return SummaryRow(id: key, values: values, urineAverage: average)
        }
    }

    private func updateStatus(extra: String? = nil) {
        guard let first = days.first?.messtag, let last = days.last?.messtag else {
            status = tr("no_data", language)
            return
        }
        status = "\(days.count) \(tr("measurement_days", language)) · \(formattedDate(first)) \(tr("to", language)) \(formattedDate(last))" + (extra.map { " · \($0)" } ?? "")
    }

    private func measurementDay(for date: Date) -> Date {
        let start = calendar.startOfDay(for: date)
        return calendar.component(.hour, from: date) < 6 ? calendar.date(byAdding: .day, value: -1, to: start)! : start
    }

    private func readTextFile(_ url: URL) throws -> String {
        let access = url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        let data = try Data(contentsOf: url, options: [.mappedIfSafe])
        if let text = String(data: data, encoding: .utf8) { return text }
        if let text = String(data: data, encoding: .utf16) { return text }
        if let text = String(data: data, encoding: .isoLatin1) { return text }
        throw NSError(domain: "Urinprotokoll", code: 2, userInfo: [NSLocalizedDescriptionKey: tr("encoding_error", language)])
    }

    private func save(text: String, defaultName: String) {
        guard !text.isEmpty else { return }
        let panel = NSSavePanel()
        panel.nameFieldStringValue = defaultName
        panel.allowedContentTypes = [.commaSeparatedText, .text]
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            try? text.write(to: url, atomically: true, encoding: .utf8)
        }
    }

    private func entriesToRawCSV(_ entries: [Entry]) -> String {
        let header = ["Datum", "Typ", "ml", "Hinweis"]
        let rows = entries.sorted { $0.original < $1.original }.map { entry in
            [
                "\(calendar.component(.day, from: entry.original)).\(calendar.component(.month, from: entry.original)).\(calendar.component(.year, from: entry.original)) \(timeFormatter.string(from: entry.original))",
                entry.type,
                "\(entry.ml)",
                entry.note
            ].map(escape).joined(separator: ",")
        }
        return ([header.joined(separator: ",")] + rows).joined(separator: "\n")
    }

    private func monthName(_ month: Int) -> String {
        let names = language == .de
            ? ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
            : ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return names[max(0, min(month - 1, names.count - 1))]
    }

    private func dayName(_ date: Date) -> String {
        let names = language == .de
            ? ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"]
            : ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return names[calendar.component(.weekday, from: date) - 1]
    }

    private func stableMonthName(_ month: Int) -> String {
        ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"][max(0, min(month - 1, 11))]
    }

    private func stableDayName(_ date: Date) -> String {
        ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"][calendar.component(.weekday, from: date) - 1]
    }

}

struct UrinprotokollSwiftUIApp: App {
    @StateObject private var model = UrinModel()

    var body: some Scene {
        WindowGroup("UroBilanz") {
            ContentView()
                .environmentObject(model)
                .frame(minWidth: 1120, minHeight: 760)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("\(tr("load_csv", model.language))...") { model.openCSV() }
                    .keyboardShortcut("o")
            }
        }
    }
}

@main
enum UroBilanzMain {
    static func main() {
        if ProcessInfo.processInfo.arguments.contains("--test-import") {
            ImportSmokeTestRunner.run()
        }
        UrinprotokollSwiftUIApp.main()
    }
}

struct ContentView: View {
    @EnvironmentObject private var model: UrinModel
    @AppStorage("uroBilanzTheme") private var themeRaw = AppTheme.classicDark.rawValue
    @AppStorage("uroBilanzCustomThemes") private var customThemesRaw = "[]"
    @AppStorage("uroBilanzLanguage") private var languageRaw = AppLanguage.systemDefault.rawValue
    @State private var selection: AppSection = .dashboard
    @State private var showsEntrySheet = false
    @State private var showsThemeImporter = false
    @State private var themeErrorMessage: String?
    @State private var pendingDeleteTheme: CustomThemeDefinition?

    private var customThemes: [CustomThemeDefinition] {
        CustomThemeDefinition.decodeList(customThemesRaw)
    }

    var body: some View {
        let theme = ThemeStyle.resolve(id: themeRaw, customThemes: customThemes)
        let language = AppLanguage(rawValue: languageRaw) ?? .de
        NavigationSplitView {
            List(AppSection.allCases, selection: $selection) { section in
                Label(section.title(language), systemImage: section.symbol)
                    .tag(section)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            VStack(spacing: 0) {
                ToolbarStrip(
                    selection: $selection,
                    showsEntrySheet: $showsEntrySheet,
                    themeRaw: $themeRaw,
                    languageRaw: $languageRaw,
                    customThemes: customThemes,
                    importTheme: { showsThemeImporter = true },
                    exportTheme: exportSelectedTheme,
                    deleteTheme: prepareDeleteSelectedTheme
                )
                Divider()
                detailView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(AppBackground(theme: theme))
        }
        .environment(\.appTheme, theme)
        .environment(\.appLanguage, language)
        .preferredColorScheme(theme.preferredScheme)
        .tint(theme.accent)
        .task { model.setLanguage(language) }
        .onChange(of: languageRaw) { _, value in
            model.setLanguage(AppLanguage(rawValue: value) ?? .de)
        }
        .sheet(isPresented: $showsEntrySheet) {
            EntrySheet()
                .environmentObject(model)
                .environment(\.appLanguage, language)
                .environment(\.appTheme, theme)
        }
        .fileImporter(isPresented: $showsThemeImporter, allowedContentTypes: [.json]) { result in
            importCustomTheme(result)
        }
        .alert(tr("csv_error", language), isPresented: Binding(
            get: { model.errorMessage != nil },
            set: { if !$0 { model.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { model.errorMessage = nil }
        } message: {
            Text(model.errorMessage ?? "")
        }
        .alert(tr("import_theme", language), isPresented: Binding(
            get: { themeErrorMessage != nil },
            set: { if !$0 { themeErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { themeErrorMessage = nil }
        } message: {
            Text(themeErrorMessage ?? "")
        }
        .alert(tr("delete_theme", language), isPresented: Binding(
            get: { pendingDeleteTheme != nil },
            set: { if !$0 { pendingDeleteTheme = nil } }
        )) {
            Button(tr("cancel", language), role: .cancel) { pendingDeleteTheme = nil }
            Button(tr("delete_theme", language), role: .destructive) {
                deleteCustomTheme(pendingDeleteTheme)
            }
        } message: {
            Text(tr("delete_theme_confirm", language))
        }
    }

    private func importCustomTheme(_ result: Result<URL, Error>) {
        do {
            let url = try result.get()
            let hasAccess = url.startAccessingSecurityScopedResource()
            defer {
                if hasAccess { url.stopAccessingSecurityScopedResource() }
            }
            let data = try Data(contentsOf: url)
            let theme = try JSONDecoder().decode(CustomThemeDefinition.self, from: data).validated()
            let themes = (customThemes.filter { $0.id != theme.id } + [theme]).sorted { $0.id < $1.id }
            customThemesRaw = CustomThemeDefinition.encodeList(themes)
            themeRaw = theme.id
        } catch {
            themeErrorMessage = error.localizedDescription
        }
    }

    private func exportSelectedTheme() {
        let language = AppLanguage(rawValue: languageRaw) ?? .de
        let theme: CustomThemeDefinition
        if let customTheme = customThemes.first(where: { $0.id == themeRaw }) {
            theme = customTheme
        } else if let builtInTheme = AppTheme(rawValue: themeRaw) {
            do {
                theme = try builtInTheme.exportCopy(existingIds: Set(customThemes.map(\.id)))
            } catch {
                themeErrorMessage = error.localizedDescription
                return
            }
        } else {
            return
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(theme),
              let text = String(data: data, encoding: .utf8) else {
            themeErrorMessage = tr("export_theme", language)
            return
        }
        saveTheme(text: text + "\n", defaultName: "urobilanz-theme-\(theme.id).json")
    }

    private func prepareDeleteSelectedTheme() {
        pendingDeleteTheme = customThemes.first { $0.id == themeRaw }
    }

    private func deleteCustomTheme(_ theme: CustomThemeDefinition?) {
        guard let theme else { return }
        customThemesRaw = CustomThemeDefinition.encodeList(customThemes.filter { $0.id != theme.id })
        if themeRaw == theme.id {
            themeRaw = AppTheme.classicDark.rawValue
        }
        pendingDeleteTheme = nil
    }

    private func saveTheme(text: String, defaultName: String) {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = defaultName
        panel.allowedContentTypes = [.json]
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            try? text.write(to: url, atomically: true, encoding: .utf8)
        }
    }

    @ViewBuilder
    private var detailView: some View {
        switch selection {
        case .dashboard: DashboardView()
        case .year: SummaryTableView(section: .year)
        case .month: SummaryTableView(section: .month)
        case .week: SummaryTableView(section: .week)
        case .day: DayTableView()
        case .notes: NotesView()
        }
    }
}

struct AppMark: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.appTheme) private var theme
    let size: CGFloat

    var body: some View {
        let fileName = theme.isDark || isDarkAppearance ? "urobilanz-icon-dark.svg" : "urobilanz-icon-light.svg"
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                        .stroke(.white.opacity(isDarkAppearance ? 0.18 : 0.30), lineWidth: 1)
                }
            Image(nsImage: NSImage(contentsOfFile: "\(Bundle.main.resourcePath ?? "")/\(fileName)") ?? NSImage())
                .resizable()
                .scaledToFit()
                .padding(size * 0.08)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(theme.isDark ? 0.32 : 0.16), radius: 10, x: 0, y: 5)
        .accessibilityLabel("UroBilanz")
    }

    private var isDarkAppearance: Bool {
        if colorScheme == .dark { return true }
        return NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
}

struct DashboardView: View {
    @EnvironmentObject private var model: UrinModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                FilterBar()
                if model.hasData {
                    MetricGrid()
                    HStack(alignment: .top, spacing: 14) {
                        LineChartView(days: model.filteredEvaluationDays)
                            .frame(height: 240)
                            .liquidCard()
                        MonthBarChart(rows: model.summaryRows(kind: .month, evaluationOnly: true))
                            .frame(height: 240)
                            .liquidCard()
                    }
                    AlertTable()
                } else {
                    EmptyStateView()
                }
            }
            .padding(22)
        }
    }
}

struct EmptyStateView: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "drop.triangle")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)
            Text(tr("no_data", language))
                .font(.title2.weight(.bold))
            Text(tr("no_data_help", language))
                .foregroundStyle(.secondary)
            Button(tr("load_csv", language), systemImage: "square.and.arrow.down") { model.openCSV() }
                .controlSize(.large)
        }
        .frame(maxWidth: .infinity, minHeight: 360)
        .liquidCard()
    }
}

struct EntrySheet: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.dismiss) private var dismiss
    @State private var date = Date()
    @State private var urineTime = Date()
    @State private var urineMl = ""
    @State private var waterTime = Date()
    @State private var waterMl = ""
    @State private var note = ""
    @State private var editIndex: Int?
    @State private var pendingDelete: PendingDelete?
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(tr(editIndex == nil ? "entry_add" : "entry_edit", language))
                .font(.title2.weight(.bold))
            Form {
                DatePicker(tr("date", language), selection: $date, displayedComponents: [.date])
                DatePicker(tr("urine_time", language), selection: $urineTime, displayedComponents: [.hourAndMinute])
                TextField(tr("urine_ml", language), text: $urineMl)
                DatePicker(tr("water_time", language), selection: $waterTime, displayedComponents: [.hourAndMinute])
                TextField(tr("water_ml", language), text: $waterMl)
                TextField(tr("note", language), text: $note, axis: .vertical)
                    .lineLimit(3...5)
            }
            entryList
            HStack {
                Spacer()
                Button(tr("close", language)) { dismiss() }
                Button(tr("new", language)) { resetForm(keepDate: true) }
                Group {
                    Button(tr("add", language)) {
                        save()
                        resetForm(keepDate: true, keepTime: true)
                    }
                    Button(tr("add_close", language)) {
                        save()
                        dismiss()
                    }
                }
                .keyboardShortcut(.defaultAction)
                .disabled(!hasInput)
            }
        }
        .padding(24)
        .frame(width: 680)
        .alert(tr("entry_delete", language), isPresented: deleteAlertBinding) {
            Button(tr("cancel", language), role: .cancel) {
                pendingDelete = nil
            }
            Button(tr("delete", language), role: .destructive) {
                if let pendingDelete {
                    model.deleteEntry(index: pendingDelete.index)
                }
                pendingDelete = nil
            }
        } message: {
            Text(pendingDelete?.message ?? tr("entry_delete_confirm", language))
        }
    }

    private var hasInput: Bool {
        Int(urineMl) != nil || Int(waterMl) != nil || !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var entryList: some View {
        let rows = model.entriesForMesstag(date)
        return VStack(alignment: .leading, spacing: 8) {
            Text(tr("entries_day", language))
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            if rows.isEmpty {
                Text(tr("no_entries_day", language))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVStack(spacing: 6) {
                        ForEach(rows, id: \.index) { row in
                            HStack(spacing: 10) {
                                Text(model.formattedTime(row.entry.original))
                                    .monospacedDigit()
                                    .frame(width: 54, alignment: .leading)
                                Text(typeTitle(row.entry.type))
                                    .fontWeight(.semibold)
                                    .frame(width: 70, alignment: .leading)
                                Text(row.entry.type == "Hinweis" ? tr("note", language) : "\(row.entry.ml) ml")
                                    .monospacedDigit()
                                    .frame(width: 86, alignment: .leading)
                                Text(row.entry.note)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                Spacer()
                                Button(tr("edit", language)) { fillForm(row.index, row.entry) }
                                Button(tr("delete", language), role: .destructive) {
                                    pendingDelete = pendingDeleteTarget(index: row.index, entry: row.entry)
                                }
                            }
                            .font(.callout)
                            .padding(8)
                            .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }
                }
                .frame(maxHeight: 190)
            }
        }
    }

    private func save() {
        if let editIndex {
            model.updateManualEntry(index: editIndex, date: date, urineTime: urineTime, urineMl: Int(urineMl), waterTime: waterTime, waterMl: Int(waterMl), note: note)
        } else {
            model.addManualEntries(date: date, urineTime: urineTime, urineMl: Int(urineMl), waterTime: waterTime, waterMl: Int(waterMl), note: note)
        }
    }

    private var deleteAlertBinding: Binding<Bool> {
        Binding(
            get: { pendingDelete != nil },
            set: { if !$0 { pendingDelete = nil } }
        )
    }

    private func pendingDeleteTarget(index: Int, entry: Entry) -> PendingDelete {
        let value = entry.type == "Hinweis" ? tr("note", language) : "\(typeTitle(entry.type)) \(entry.ml) ml"
        let message = "\(model.formattedDate(entry.messtag)) \(model.formattedTime(entry.original)) · \(value)\n\n\(tr("entry_delete_confirm", language))"
        return PendingDelete(index: index, message: message)
    }

    private func typeTitle(_ type: String) -> String {
        tr(type == "Wasser" ? "water" : type == "Hinweis" ? "note" : "urine", language)
    }

    private func fillForm(_ index: Int, _ entry: Entry) {
        editIndex = index
        date = entry.messtag
        urineTime = entry.original
        waterTime = entry.original
        urineMl = entry.type == "Urin" ? "\(entry.ml)" : ""
        waterMl = entry.type == "Wasser" ? "\(entry.ml)" : ""
        note = entry.note
    }

    private func resetForm(keepDate: Bool) {
        resetForm(keepDate: keepDate, keepTime: false)
    }

    private func resetForm(keepDate: Bool, keepTime: Bool) {
        let now = Date()
        let previousUrineTime = urineTime
        let previousWaterTime = waterTime
        editIndex = nil
        if !keepDate {
            date = now
        }
        urineTime = keepTime ? previousUrineTime : now
        waterTime = keepTime ? previousWaterTime : now
        urineMl = ""
        waterMl = ""
        note = ""
    }

    private struct PendingDelete: Identifiable {
        let id = UUID()
        let index: Int
        let message: String
    }
}
