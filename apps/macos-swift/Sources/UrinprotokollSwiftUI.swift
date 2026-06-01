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
        "dashboard": "Dashboard", "year": "Jahr", "month": "Monat", "week": "Woche", "day": "Tag", "notes": "Notizen",
        "language": "Sprache", "remember_data": "Daten merken", "entry": "Eintrag", "merge_csv": "CSV ergänzen", "load_csv": "CSV laden",
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
        "flags": "Auffälligkeiten", "flag": "Auffälligkeit", "low": "niedrig", "normal": "normal", "days": "Tage",
        "urine_count": "Urin Anzahl", "week_short": "KW", "urine_times": "Urin Zeiten", "urine_sum": "Urin Summe",
        "water_times": "Wasser Zeiten", "water_sum": "Wasser Summe", "hints": "Hinweise", "action": "Aktion", "delete_day": "Tag löschen",
        "delete_measurement_day": "Messtag löschen?", "delete_day_detail": "Alle Urin-, Wasser- und Hinweis-Einträge dieses Messtags werden gelöscht.",
        "delete_day_confirm": "Messtag {date} wirklich löschen?\n\nAlle Urin-, Wasser- und Hinweis-Einträge dieses Messtags werden gelöscht.",
        "medical_notes": "Medizinische Notizen", "note_1": "Die Auswertung verwendet Messtage von 06:00 bis 05:59.",
        "note_2": "Einträge zwischen 00:00 und 05:59 werden dem Vortag zugerechnet.",
        "note_3": "Auffälligkeiten sind organisatorische Hinweise, keine medizinische Bewertung.",
        "note_4": "Wasserwerte werden separat geführt und nicht mit Urinmengen vermischt.",
        "no_valid_entries": "Keine gültigen Einträge gefunden.", "merge_original_only": "Ergänzen ist nur mit der originalen Urinote-CSV möglich, nicht mit der Tagesdaten-CSV.",
        "no_new_entries": "Keine gültigen neuen Einträge gefunden.", "encoding_error": "Die Textkodierung wurde nicht erkannt.",
        "invalid_daily_data": "Tagesdaten-Format erkannt, aber keine Messtage gefunden.", "already_present": "Eintrag war bereits vorhanden",
        "entry_added": "Eintrag hinzugefügt", "entry_deleted": "Eintrag gelöscht", "day_deleted": "Messtag gelöscht",
        "no_entry_created": "Kein Eintrag erstellt", "to": "bis", "new_entries": "neue Einträge ergänzt", "existing_entries": "bereits vorhanden",
        "added": "hinzugefügt", "updated": "aktualisiert"
    ],
    .en: [
        "dashboard": "Dashboard", "year": "Year", "month": "Month", "week": "Week", "day": "Day", "notes": "Notes",
        "language": "Language", "remember_data": "Remember data", "entry": "Entry", "merge_csv": "Merge CSV", "load_csv": "Load CSV",
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
        "flags": "Flags", "flag": "Flag", "low": "low", "normal": "normal", "days": "Days",
        "urine_count": "Urine count", "week_short": "Week", "urine_times": "Urine times", "urine_sum": "Urine total",
        "water_times": "Water times", "water_sum": "Water total", "hints": "Notes", "action": "Action", "delete_day": "Delete day",
        "delete_measurement_day": "Delete measurement day?", "delete_day_detail": "All urine, water and note entries for this day will be deleted.",
        "delete_day_confirm": "Delete measurement day {date}?\n\nAll urine, water and note entries for this day will be deleted.",
        "medical_notes": "Medical notes", "note_1": "The analysis uses measurement days from 06:00 to 05:59.",
        "note_2": "Entries between 00:00 and 05:59 are assigned to the previous day.",
        "note_3": "Flags are organizational hints, not medical assessments.",
        "note_4": "Water values are tracked separately and are not mixed with urine volumes.",
        "no_valid_entries": "No valid entries found.", "merge_original_only": "Merging is only available for the original Urinote CSV, not the daily data CSV.",
        "no_new_entries": "No valid new entries found.", "encoding_error": "The text encoding was not recognized.",
        "invalid_daily_data": "Daily data format detected, but no measurement days were found.", "already_present": "Entry was already present",
        "entry_added": "Entry added", "entry_deleted": "Entry deleted", "day_deleted": "Day deleted",
        "no_entry_created": "No entry created", "to": "to", "new_entries": "new entries merged", "existing_entries": "already present",
        "added": "added", "updated": "updated"
    ]
]

private func tr(_ key: String, _ language: AppLanguage, replacements: [String: String] = [:]) -> String {
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
}

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .classicDark
}

extension EnvironmentValues {
    var appTheme: AppTheme {
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
        case .notes: "note.text"
        }
    }
}

struct Entry {
    let original: Date
    let messtag: Date
    let type: String
    let ml: Int
    let note: String

    var key: String {
        "\(Int(original.timeIntervalSince1970))|\(type)|\(ml)|\(note.trimmingCharacters(in: .whitespacesAndNewlines))"
    }
}

struct DaySummary: Identifiable {
    let messtag: Date
    let year: Int
    let month: Int
    let monthName: String
    let week: Int
    let dayName: String
    let urine: [(String, Int)]
    let water: [(String, Int)]
    let notes: [String]

    var id: Date { messtag }
    var urineTotal: Int { urine.reduce(0) { $0 + $1.1 } }
    var waterTotal: Int { water.reduce(0) { $0 + $1.1 } }
    var urineCount: Int { urine.count }
    var notesText: String { notes.joined(separator: " | ") }
}

struct SummaryRow: Identifiable {
    let id: String
    let values: [String: String]
    let urineAverage: Int
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
        let header = ["Jahr","Monat","KW","Messtag","Tag","Urin Uhrzeit","Urin ml","Urin Anzahl","Urin gesamt ml","Wasser Uhrzeit","Wasser ml","Wasser gesamt ml","Hinweise"]
        let rows = days.map { day in
            [
                "\(day.year)",
                stableMonthName(day.month),
                "\(day.week)",
                rawDayFormatter.string(from: day.messtag),
                stableDayName(day.messtag),
                day.urine.map(\.0).joined(separator: " | "),
                day.urine.map { "\($0.1)" }.joined(separator: " | "),
                "\(day.urineCount)",
                "\(day.urineTotal)",
                day.water.map(\.0).joined(separator: " | "),
                day.water.map { "\($0.1)" }.joined(separator: " | "),
                "\(day.waterTotal)",
                day.notesText
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

    func summaryRows(kind: AppSection) -> [SummaryRow] {
        switch kind {
        case .year:
            summarize(grouping: { "\($0.year)" }, labels: { ["Jahr": "\($0.year)"] })
        case .month:
            summarize(grouping: { "\($0.year)-\($0.month)" }, labels: { ["Jahr": "\($0.year)", "Monat": "\($0.month)", "Monat Name": $0.monthName] })
        case .week:
            summarize(grouping: { "\($0.year)-\($0.week)" }, labels: { ["Jahr": "\($0.year)", "KW": "\($0.week)"] })
        default:
            []
        }
    }

    func alertRows() -> [DaySummary] {
        filteredDays.filter { $0.urineTotal < 800 }
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
            let notes = (row["Hinweise"] ?? "").isEmpty ? [] : [row["Hinweise"] ?? ""]
            return DaySummary(
                messtag: messtag,
                year: comps.year ?? Int(row["Jahr"] ?? "0") ?? 0,
                month: comps.month ?? 0,
                monthName: monthName(comps.month ?? 1),
                week: comps.weekOfYear ?? Int(row["KW"] ?? "0") ?? 0,
                dayName: dayName(messtag),
                urine: urine,
                water: water,
                notes: notes
            )
        }.sorted { $0.messtag < $1.messtag }
        guard !imported.isEmpty else {
            throw NSError(domain: "Urinprotokoll", code: 3, userInfo: [NSLocalizedDescriptionKey: tr("invalid_daily_data", language)])
        }
        return imported
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
        var noteUsed = false
        func make(_ item: (String, Int), type: String) -> Entry {
            let original = dateFromMesstag(day.messtag, time: item.0)
            let note = noteUsed ? "" : day.notesText
            noteUsed = true
            return Entry(original: original, messtag: measurementDay(for: original), type: type, ml: item.1, note: note)
        }
        var result = day.urine.map { make($0, type: "Urin") } + day.water.map { make($0, type: "Wasser") }
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
            return DaySummary(
                messtag: day,
                year: comps.year ?? 0,
                month: comps.month ?? 0,
                monthName: monthName(comps.month ?? 1),
                week: comps.weekOfYear ?? 0,
                dayName: dayName(day),
                urine: rows.filter { $0.type == "Urin" }.map { (timeFormatter.string(from: $0.original), $0.ml) },
                water: rows.filter { $0.type == "Wasser" }.map { (timeFormatter.string(from: $0.original), $0.ml) },
                notes: Array(NSOrderedSet(array: rows.map(\.note).filter { !$0.isEmpty })) as? [String] ?? []
            )
        }
    }

    private func summarize(grouping: (DaySummary) -> String, labels: (DaySummary) -> [String: String]) -> [SummaryRow] {
        let grouped = Dictionary(grouping: filteredDays, by: grouping)
        return grouped.keys.sorted().compactMap { key in
            guard let rows = grouped[key], let first = rows.first else { return nil }
            let urineTotal = rows.reduce(0) { $0 + $1.urineTotal }
            let waterTotal = rows.reduce(0) { $0 + $1.waterTotal }
            let urineCount = rows.reduce(0) { $0 + $1.urineCount }
            let average = rows.isEmpty ? 0 : urineTotal / rows.count
            let hasLowDay = rows.contains { $0.urineTotal < 800 }
            var values = labels(first)
            values["Tage"] = "\(rows.count)"
            values["● Urin Gesamt ml"] = format(urineTotal)
            values["● Urin Ø ml/Tag"] = format(average)
            values["● Urin Anzahl"] = "\(urineCount)"
            values["💧 Wasser Gesamt ml"] = format(waterTotal)
            values["Auffälligkeit"] = tr(hasLowDay ? "low" : "normal", language)
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

    private func parseCSV(_ text: String) -> [[String: String]] {
        let lines = text.components(separatedBy: .newlines).filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard let first = lines.first else { return [] }
        let delimiter = detectDelimiter(first)
        let headers = parseCSVLine(first, delimiter: delimiter).map {
            $0.trimmingCharacters(in: CharacterSet(charactersIn: "\u{feff}").union(.whitespacesAndNewlines))
        }
        return lines.dropFirst().compactMap { line in
            var values = parseCSVLine(line, delimiter: delimiter)
            if values.count > headers.count, headers.count == 4 {
                let note = values[3...].joined(separator: String(delimiter))
                values = Array(values.prefix(3)) + [note]
            }
            guard values.count >= 3 else { return nil }
            return Dictionary(uniqueKeysWithValues: headers.enumerated().map { index, header in
                (header, index < values.count ? values[index].trimmingCharacters(in: .whitespacesAndNewlines) : "")
            })
        }
    }

    private func detectDelimiter(_ firstLine: String) -> Character {
        firstLine.filter { $0 == ";" }.count > firstLine.filter { $0 == "," }.count ? ";" : ","
    }

    private func parseCSVLine(_ line: String, delimiter: Character) -> [String] {
        var values: [String] = []
        var field = ""
        var quoted = false
        let chars = Array(line)
        var index = 0
        while index < chars.count {
            let char = chars[index]
            let next = index + 1 < chars.count ? chars[index + 1] : nil
            if char == "\"" && quoted && next == "\"" {
                field.append("\"")
                index += 1
            } else if char == "\"" {
                quoted.toggle()
            } else if char == delimiter && !quoted {
                values.append(field)
                field = ""
            } else {
                field.append(char)
            }
            index += 1
        }
        values.append(field)
        return values
    }

    private func splitList(_ value: String) -> [String] {
        value.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }

    private func parseAmount(_ value: String) -> Int {
        let cleaned = value
            .replacingOccurrences(of: "ml", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Int(cleaned) ?? 0
    }

    private func zipLists(times: [String], amounts: [Int]) -> [(String, Int)] {
        (0..<max(times.count, amounts.count)).map { index in
            (index < times.count ? times[index] : "", index < amounts.count ? amounts[index] : 0)
        }
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

    private func escape(_ value: String) -> String {
        let cleaned = value.replacingOccurrences(of: "\n", with: " | ")
        return cleaned.contains(",") || cleaned.contains("\"") ? "\"\(cleaned.replacingOccurrences(of: "\"", with: "\"\""))\"" : cleaned
    }
}

@main
struct UrinprotokollSwiftUIApp: App {
    @StateObject private var model = UrinModel()

    var body: some Scene {
        WindowGroup("UroBilanz") {
            if ProcessInfo.processInfo.arguments.contains("--test-import") {
                ImportTestView()
                    .environmentObject(model)
                    .frame(width: 420, height: 160)
            } else {
                ContentView()
                    .environmentObject(model)
                    .frame(minWidth: 1120, minHeight: 760)
            }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("\(tr("load_csv", model.language))...") { model.openCSV() }
                    .keyboardShortcut("o")
            }
        }
    }
}

struct ImportTestView: View {
    @EnvironmentObject private var model: UrinModel

    var body: some View {
        Text("Importtest")
            .task {
                let paths = ProcessInfo.processInfo.arguments.drop { $0 != "--test-import" }.dropFirst()
                for path in paths {
                    do {
                        let csv = try String(contentsOfFile: path, encoding: .utf8)
                        try model.load(csv: csv)
                        print("\(path): \(model.days.count) Messtage")
                    } catch {
                        print("\(path): Fehler: \(error.localizedDescription)")
                        exit(1)
                    }
                }
                exit(0)
            }
    }
}

struct ContentView: View {
    @EnvironmentObject private var model: UrinModel
    @AppStorage("uroBilanzTheme") private var themeRaw = AppTheme.classicDark.rawValue
    @AppStorage("uroBilanzLanguage") private var languageRaw = AppLanguage.systemDefault.rawValue
    @State private var selection: AppSection = .dashboard
    @State private var showsEntrySheet = false

    var body: some View {
        let theme = AppTheme(rawValue: themeRaw) ?? .classicDark
        let language = AppLanguage(rawValue: languageRaw) ?? .de
        NavigationSplitView {
            List(AppSection.allCases, selection: $selection) { section in
                Label(section.title(language), systemImage: section.symbol)
                    .tag(section)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            VStack(spacing: 0) {
                ToolbarStrip(selection: $selection, showsEntrySheet: $showsEntrySheet, themeRaw: $themeRaw, languageRaw: $languageRaw)
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
        .alert(tr("csv_error", language), isPresented: Binding(
            get: { model.errorMessage != nil },
            set: { if !$0 { model.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { model.errorMessage = nil }
        } message: {
            Text(model.errorMessage ?? "")
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

struct ToolbarStrip: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appTheme) private var theme
    @Binding var selection: AppSection
    @Binding var showsEntrySheet: Bool
    @Binding var themeRaw: String
    @Binding var languageRaw: String
    @Environment(\.appLanguage) private var language

    var body: some View {
        HStack(spacing: 12) {
            AppMark(size: 54)
            VStack(alignment: .leading, spacing: 2) {
                Text(selection.title(language))
                    .font(.title2.weight(.bold))
                Text(model.status)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 8) {
                Text(tr("remember_data", language))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                Toggle(tr("remember_data", language), isOn: $model.rememberData)
                    .labelsHidden()
                    .onChange(of: model.rememberData) { _, _ in model.toggleRemember() }
                    .toggleStyle(.switch)
            }
            ThemeMenu(themeRaw: $themeRaw)
            LanguageMenu(languageRaw: $languageRaw)
            Button(tr("entry", language), systemImage: "plus.circle") { showsEntrySheet = true }
            Button(tr("merge_csv", language), systemImage: "plus.square.on.square") { model.openMergeCSV() }
            Button(tr("load_csv", language), systemImage: "square.and.arrow.down") { model.openCSV() }
            Button(tr("delete", language), systemImage: "trash", role: .destructive) { model.clearData() }
                .disabled(!model.hasData)
            Button(tr("backup", language), systemImage: "externaldrive") { model.exportBackup() }
                .disabled(!model.hasData)
            Button(tr("daily_data", language), systemImage: "tablecells") { model.exportDays() }
                .disabled(!model.hasData)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .background(.bar)
    }
}

struct ThemeMenu: View {
    @Environment(\.appTheme) private var theme
    @Binding var themeRaw: String
    @Environment(\.appLanguage) private var language

    private var selectedTheme: AppTheme {
        AppTheme(rawValue: themeRaw) ?? .classicDark
    }

    var body: some View {
        Menu {
            ForEach(AppTheme.allCases) { option in
                Button {
                    themeRaw = option.rawValue
                } label: {
                    if option == selectedTheme {
                        Label(option.title(language), systemImage: "checkmark")
                    } else {
                        Text(option.title(language))
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(selectedTheme.title(language))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.bold))
            }
            .font(.callout.weight(.semibold))
            .foregroundStyle(theme.controlForeground)
            .padding(.horizontal, 12)
            .frame(width: 164, height: 34)
            .background(theme.controlBackground, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .stroke(theme.controlBorder, lineWidth: theme == .highContrast ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
        .menuStyle(.borderlessButton)
    }
}

struct LanguageMenu: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.appLanguage) private var language
    @Binding var languageRaw: String

    var body: some View {
        Menu {
            ForEach(AppLanguage.allCases) { option in
                Button {
                    languageRaw = option.rawValue
                } label: {
                    if option == language {
                        Label(option.label, systemImage: "checkmark")
                    } else {
                        Text(option.label)
                    }
                }
            }
        } label: {
            Label(language.label, systemImage: "globe")
                .font(.callout.weight(.semibold))
                .foregroundStyle(theme.controlForeground)
                .padding(.horizontal, 10)
                .frame(height: 34)
                .background(theme.controlBackground, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .stroke(theme.controlBorder, lineWidth: theme == .highContrast ? 1.5 : 1)
                }
        }
        .help(tr("language", language))
        .buttonStyle(.plain)
        .menuStyle(.borderlessButton)
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
                        LineChartView(days: model.filteredDays)
                            .frame(height: 240)
                            .liquidCard()
                        MonthBarChart(rows: model.summaryRows(kind: .month))
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

struct FilterBar: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appLanguage) private var language

    var body: some View {
        HStack {
            Picker(tr("year", language), selection: $model.selectedYear) {
                Text(tr("all_years", language)).tag("all")
                ForEach(model.years, id: \.self) { year in
                    Text(verbatim: String(year)).tag(String(year))
                }
            }
            Picker(tr("month", language), selection: $model.selectedMonth) {
                Text(tr("all_months", language)).tag("all")
                ForEach(Array(monthNames.enumerated()), id: \.offset) { index, name in
                    Text(name).tag("\(index + 1)")
                }
            }
            Spacer()
        }
        .disabled(!model.hasData)
    }

    private var monthNames: [String] {
        language == .de
            ? ["Januar","Februar","März","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember"]
            : ["January","February","March","April","May","June","July","August","September","October","November","December"]
    }
}

struct MetricGrid: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appLanguage) private var language

    var body: some View {
        let days = model.filteredDays
        let urineTotal = days.reduce(0) { $0 + $1.urineTotal }
        let waterTotal = days.reduce(0) { $0 + $1.waterTotal }
        let metrics = [
            (tr("measurement_days", language), "\(days.count)", "calendar"),
            (tr("urine_total", language), model.format(urineTotal), "circle.fill"),
            (tr("urine_average", language), model.format(days.isEmpty ? 0 : urineTotal / days.count), "chart.line.uptrend.xyaxis"),
            (tr("water_total", language), model.format(waterTotal), "drop.fill"),
            (tr("low_days", language), "\(days.filter { $0.urineTotal < 800 }.count)", "exclamationmark.triangle"),
            (tr("normal_days", language), "\(days.filter { $0.urineTotal >= 800 }.count)", "checkmark.circle")
        ]
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12) {
            ForEach(metrics, id: \.0) { metric in
                VStack(alignment: .leading, spacing: 6) {
                    Label(metric.0, systemImage: metric.2)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Text(metric.1)
                        .font(.title3.weight(.bold))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .liquidCard(cornerRadius: 14)
            }
        }
    }
}

struct LineChartView: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.appLanguage) private var language
    let days: [DaySummary]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ChartHeader(title: tr("daily_progress", language))
            Canvas { context, size in
                let area = CGRect(x: 28, y: 4, width: max(size.width - 42, 1), height: max(size.height - 24, 1))
                drawAxes(context: &context, area: area)
                drawSeries(context: &context, values: days.map(\.urineTotal), color: theme.urineColor, area: area)
                drawSeries(context: &context, values: days.map(\.waterTotal), color: theme.waterColor, area: area)
            }
        }
    }

    private func drawAxes(context: inout GraphicsContext, area: CGRect) {
        var path = Path()
        path.move(to: CGPoint(x: area.minX, y: area.minY))
        path.addLine(to: CGPoint(x: area.minX, y: area.maxY))
        path.addLine(to: CGPoint(x: area.maxX, y: area.maxY))
        context.stroke(path, with: .color(.secondary.opacity(0.25)), lineWidth: 1)
    }

    private func drawSeries(context: inout GraphicsContext, values: [Int], color: Color, area: CGRect) {
        guard values.count > 1 else { return }
        let maxValue = CGFloat(max(values.max() ?? 1, 1))
        var path = Path()
        for (index, value) in values.enumerated() {
            let x = area.minX + CGFloat(index) / CGFloat(max(values.count - 1, 1)) * area.width
            let y = area.maxY - CGFloat(value) / maxValue * area.height
            if index == 0 { path.move(to: CGPoint(x: x, y: y)) } else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        context.stroke(path, with: .color(color), lineWidth: 2)
    }
}

struct MonthBarChart: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.appLanguage) private var language
    let rows: [SummaryRow]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ChartHeader(title: tr("monthly_comparison", language))
            Canvas { context, size in
                let area = CGRect(x: 28, y: 4, width: max(size.width - 42, 1), height: max(size.height - 24, 1))
                let maxValue = CGFloat(max(rows.compactMap { parseFormattedInt($0.values["● Urin Gesamt ml"] ?? "0") }.max() ?? 1, 1))
                let step = area.width / CGFloat(max(rows.count, 1))
                for (index, row) in rows.enumerated() {
                    let urine = CGFloat(parseFormattedInt(row.values["● Urin Gesamt ml"] ?? "0"))
                    let water = CGFloat(parseFormattedInt(row.values["💧 Wasser Gesamt ml"] ?? "0"))
                    let x = area.minX + CGFloat(index) * step
                    context.fill(Path(CGRect(x: x, y: area.maxY - (urine / maxValue * area.height), width: max(step * 0.28, 4), height: urine / maxValue * area.height)), with: .color(theme.urineColor.opacity(0.80)))
                    context.fill(Path(CGRect(x: x + max(step * 0.34, 6), y: area.maxY - (water / maxValue * area.height), width: max(step * 0.28, 4), height: water / maxValue * area.height)), with: .color(theme.waterColor.opacity(0.80)))
                }
            }
        }
    }

    private func parseFormattedInt(_ text: String) -> Int {
        Int(text.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")) ?? 0
    }
}

struct ChartHeader: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.appLanguage) private var language
    let title: String

    var body: some View {
        HStack(spacing: 14) {
            Text(title)
                .font(.headline)
            Label(tr("urine", language), systemImage: "circle.fill")
                .foregroundStyle(theme.urineColor)
            Label(tr("water", language), systemImage: "drop.fill")
                .foregroundStyle(theme.waterColor)
            Spacer()
        }
        .font(.caption.weight(.semibold))
        .labelStyle(.titleAndIcon)
    }
}

struct ThemedTableColumn<Row: Identifiable>: Identifiable {
    let id = UUID()
    let title: String
    let width: CGFloat
    let content: (Row) -> AnyView

    init<Content: View>(_ title: String, width: CGFloat, @ViewBuilder content: @escaping (Row) -> Content) {
        self.title = title
        self.width = width
        self.content = { AnyView(content($0)) }
    }
}

struct ThemedDataTable<Row: Identifiable>: View {
    @Environment(\.appTheme) private var theme
    let rows: [Row]
    let columns: [ThemedTableColumn<Row>]
    var minHeight: CGFloat?
    var maxHeight: CGFloat?

    private var totalWidth: CGFloat {
        columns.reduce(0) { $0 + $1.width }
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(columns) { column in
                                column.content(row)
                                    .frame(width: column.width, alignment: .leading)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                            }
                        }
                        .background(index.isMultiple(of: 2) ? Color.clear : theme.tableRow)
                        Divider().opacity(0.35)
                    }
                } header: {
                    HStack(spacing: 0) {
                        ForEach(columns) { column in
                            Text(column.title)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(theme.controlForeground.opacity(0.80))
                                .frame(width: column.width, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                        }
                    }
                    .background(theme.tableBackground)
                    Divider().opacity(0.45)
                }
            }
            .frame(minWidth: totalWidth, alignment: .leading)
        }
        .defaultScrollAnchor(.topLeading)
        .frame(minHeight: minHeight ?? 0)
        .frame(maxHeight: maxHeight, alignment: .top)
        .background(theme.tableBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(theme.controlBorder.opacity(0.55), lineWidth: 1)
        }
    }
}

struct AlertTable: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(tr("flags", language))
                .font(.headline)
            ThemedDataTable(
                rows: model.alertRows(),
                columns: [
                    ThemedTableColumn(tr("date", language), width: 160) { Text(model.formattedDate($0.messtag)) },
                    ThemedTableColumn(tr("day", language), width: 160) { Text($0.dayName) },
                    ThemedTableColumn(tr("urine_total", language), width: 170) { day in
                        Text(model.format(day.urineTotal))
                            .foregroundStyle(day.urineTotal < 800 ? .red : .orange)
                            .monospacedDigit()
                    },
                    ThemedTableColumn(tr("water_total", language), width: 180) { Text(model.format($0.waterTotal)).monospacedDigit() },
                    ThemedTableColumn(tr("flag", language), width: 180) { _ in Text(tr("low", language)) }
                ],
                minHeight: 210
            )
        }
        .liquidCard()
    }
}

struct SummaryTableView: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appLanguage) private var language
    let section: AppSection

    var body: some View {
        let rows = model.summaryRows(kind: section)
        VStack(alignment: .leading, spacing: 12) {
            FilterBar()
            ThemedDataTable(
                rows: rows,
                columns: columns,
                maxHeight: section == .year ? CGFloat(48 + rows.count * 38) : nil
            )
        }
        .padding(22)
    }

    private var columns: [ThemedTableColumn<SummaryRow>] {
        switch section {
        case .year:
            return commonSummaryColumns(prefix: [
                ThemedTableColumn(tr("year", language), width: 120) { Text($0.values["Jahr"] ?? "") }
            ])
        case .month:
            return commonSummaryColumns(prefix: [
                ThemedTableColumn(tr("year", language), width: 110) { Text($0.values["Jahr"] ?? "") },
                ThemedTableColumn(tr("month", language), width: 150) { Text($0.values["Monat Name"] ?? "") }
            ])
        case .week:
            var result = commonSummaryColumns(prefix: [
                ThemedTableColumn(tr("year", language), width: 100) { Text($0.values["Jahr"] ?? "") },
                ThemedTableColumn(tr("week_short", language), width: 90) { Text($0.values["KW"] ?? "") }
            ])
            result.append(ThemedTableColumn(tr("flag", language), width: 150) { Text($0.values["Auffälligkeit"] ?? "") })
            return result
        default:
            return []
        }
    }

    private func commonSummaryColumns(prefix: [ThemedTableColumn<SummaryRow>]) -> [ThemedTableColumn<SummaryRow>] {
        prefix + [
            ThemedTableColumn(tr("days", language), width: 90) { Text($0.values["Tage"] ?? "") },
            ThemedTableColumn(tr("urine_total", language), width: 170) { Text($0.values["● Urin Gesamt ml"] ?? "").monospacedDigit() },
            ThemedTableColumn(tr("urine_average", language), width: 170) { Text($0.values["● Urin Ø ml/Tag"] ?? "").monospacedDigit() },
            ThemedTableColumn(tr("urine_count", language), width: 140) { Text($0.values["● Urin Anzahl"] ?? "").monospacedDigit() },
            ThemedTableColumn(tr("water_total", language), width: 180) { Text($0.values["💧 Wasser Gesamt ml"] ?? "").monospacedDigit() }
        ]
    }
}

struct DayTableView: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appLanguage) private var language
    @State private var pendingDeleteDay: DaySummary?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FilterBar()
            ThemedDataTable(rows: model.filteredDays, columns: [
                ThemedTableColumn(tr("date", language), width: 110) { Text(model.formattedDate($0.messtag)) },
                ThemedTableColumn(tr("day", language), width: 100) { Text($0.dayName) },
                ThemedTableColumn(tr("urine_times", language), width: 120) { multilineCell($0.urine.map(\.0).joined(separator: "\n"), monospaced: true) },
                ThemedTableColumn(tr("urine_ml", language), width: 110) { multilineCell($0.urine.map { "\($0.1) ml" }.joined(separator: "\n"), monospaced: true) },
                ThemedTableColumn(tr("urine_sum", language), width: 120) { Text(model.format($0.urineTotal)).monospacedDigit() },
                ThemedTableColumn(tr("water_times", language), width: 120) { multilineCell($0.water.map(\.0).joined(separator: "\n"), monospaced: true) },
                ThemedTableColumn(tr("water_ml", language), width: 110) { multilineCell($0.water.map { "\($0.1) ml" }.joined(separator: "\n"), monospaced: true) },
                ThemedTableColumn(tr("water_sum", language), width: 130) { Text(model.format($0.waterTotal)).monospacedDigit() },
                ThemedTableColumn(tr("hints", language), width: 520) { day in
                    multilineCell(day.notesText, lineLimit: 3)
                        .help(day.notesText)
                },
                ThemedTableColumn(tr("action", language), width: 130) { day in
                    Button(tr("delete_day", language), role: .destructive) {
                        pendingDeleteDay = day
                    }
                }
            ])
        }
        .padding(22)
        .alert(tr("delete_measurement_day", language), isPresented: deleteAlertBinding) {
            Button(tr("cancel", language), role: .cancel) {
                pendingDeleteDay = nil
            }
            Button(tr("delete", language), role: .destructive) {
                if let pendingDeleteDay {
                    model.deleteMeasurementDay(pendingDeleteDay.messtag)
                }
                pendingDeleteDay = nil
            }
        } message: {
            Text(deleteMessage)
        }
    }

    private var deleteAlertBinding: Binding<Bool> {
        Binding(
            get: { pendingDeleteDay != nil },
            set: { if !$0 { pendingDeleteDay = nil } }
        )
    }

    private var deleteMessage: String {
        guard let pendingDeleteDay else {
            return tr("delete_day_detail", language)
        }
        return tr("delete_day_confirm", language, replacements: ["date": model.formattedDate(pendingDeleteDay.messtag)])
    }

    @ViewBuilder
    private func multilineCell(_ text: String, monospaced: Bool = false, lineLimit: Int? = nil) -> some View {
        let view = Text(text.isEmpty ? " " : text)
            .lineLimit(lineLimit)
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
        if monospaced {
            view.monospaced()
        } else {
            view
        }
    }
}

struct NotesView: View {
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(tr("medical_notes", language))
                .font(.title.weight(.bold))
            Group {
                Text(tr("note_1", language))
                Text(tr("note_2", language))
                Text(tr("note_3", language))
                Text(tr("note_4", language))
            }
            .font(.body)
            .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(28)
    }
}

struct AppBackground: View {
    let theme: AppTheme

    var body: some View {
        ZStack {
            theme.background.first ?? Color(nsColor: .windowBackgroundColor)
            LinearGradient(colors: theme.background, startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .ignoresSafeArea()
    }
}

extension View {
    func liquidCard(cornerRadius: CGFloat = 18) -> some View {
        modifier(LiquidCardModifier(cornerRadius: cornerRadius))
    }
}

private struct LiquidCardModifier: ViewModifier {
    @Environment(\.appTheme) private var theme
    let cornerRadius: CGFloat

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(macOS 26.0, *) {
            content
                .padding(14)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(theme.accent.opacity(theme == .highContrast ? 0.70 : 0.16), lineWidth: theme == .highContrast ? 1.5 : 1)
                )
        } else {
            content
                .padding(14)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(theme.accent.opacity(theme == .highContrast ? 0.70 : 0.24), lineWidth: 1)
                )
        }
    }
}
