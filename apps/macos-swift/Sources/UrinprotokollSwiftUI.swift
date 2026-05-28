import SwiftUI
import AppKit
import UniformTypeIdentifiers

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

    var title: String {
        switch self {
        case .classicLight: "Classic Hell"
        case .classicDark: "Classic Dunkel"
        case .violetNight: "Violet Night"
        case .liquidDark: "Liquid Dark"
        case .medicalLight: "Medical Light"
        case .highContrast: "High Contrast"
        case .summer: "Sommer Look"
        case .creamSage: "Creme Salbei"
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
    @Published var status = "Keine Daten geladen."
    @Published var rememberData = UserDefaults.standard.bool(forKey: "swiftUIRememberData")
    @Published var selectedYear = "all"
    @Published var selectedMonth = "all"
    @Published var errorMessage: String?

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
            throw NSError(domain: "Urinprotokoll", code: 1, userInfo: [NSLocalizedDescriptionKey: "Keine gültigen Einträge gefunden."])
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
                throw NSError(domain: "Urinprotokoll", code: 4, userInfo: [NSLocalizedDescriptionKey: "Ergänzen ist nur mit der originalen Urinote-CSV möglich, nicht mit der Tagesdaten-CSV."])
            }
            let incoming = parsed.compactMap(rawEntry)
            guard !incoming.isEmpty else {
                throw NSError(domain: "Urinprotokoll", code: 5, userInfo: [NSLocalizedDescriptionKey: "Keine gültigen neuen Einträge gefunden."])
            }
            let existing = Set(entries.map(\.key))
            let additions = incoming.filter { !existing.contains($0.key) }
            entries = (entries + additions).sorted { $0.original < $1.original }
            days = makeDays(from: entries)
            rawCSV = entriesToRawCSV(entries)
            if rememberData {
                defaults.set(rawCSV, forKey: "swiftUISavedCSV")
            }
            updateStatus(extra: "\(additions.count) neue Einträge ergänzt · \(incoming.count - additions.count) bereits vorhanden")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addEntry(original: Date, type: String, ml: Int, note: String) {
        let entry = Entry(original: original, messtag: measurementDay(for: original), type: type, ml: ml, note: note.trimmingCharacters(in: .whitespacesAndNewlines))
        if entries.contains(where: { $0.key == entry.key }) {
            updateStatus(extra: "Eintrag war bereits vorhanden")
            return
        }
        entries = (entries + [entry]).sorted { $0.original < $1.original }
        days = makeDays(from: entries)
        rawCSV = entriesToRawCSV(entries)
        if rememberData {
            defaults.set(rawCSV, forKey: "swiftUISavedCSV")
        }
        updateStatus(extra: "Eintrag hinzugefügt")
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
        updateStatus(extra: "Eintrag gelöscht")
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
            updateStatus(extra: "Kein Eintrag erstellt")
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
        updateStatus(extra: "\(manualEntries.count) Eintrag\(manualEntries.count == 1 ? "" : "e") \(index == nil ? "hinzugefügt" : "aktualisiert")")
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
                day.monthName,
                "\(day.week)",
                formattedDate(day.messtag),
                day.dayName,
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
        formatter.locale = Locale(identifier: "de_DE")
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
            guard let rawDay = row["Messtag"], let messtag = displayDate.date(from: rawDay) else { return nil }
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
                monthName: row["Monat"] ?? monthName(comps.month ?? 1),
                week: comps.weekOfYear ?? Int(row["KW"] ?? "0") ?? 0,
                dayName: row["Tag"] ?? dayName(messtag),
                urine: urine,
                water: water,
                notes: notes
            )
        }.sorted { $0.messtag < $1.messtag }
        guard !imported.isEmpty else {
            throw NSError(domain: "Urinprotokoll", code: 3, userInfo: [NSLocalizedDescriptionKey: "Tagesdaten-Format erkannt, aber keine Messtage gefunden."])
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
            values["Auffälligkeit"] = hasLowDay ? "niedrig" : "normal"
            return SummaryRow(id: key, values: values, urineAverage: average)
        }
    }

    private func updateStatus(extra: String? = nil) {
        guard let first = days.first?.messtag, let last = days.last?.messtag else {
            status = "Keine Daten geladen."
            return
        }
        status = "\(days.count) Messtage · \(formattedDate(first)) bis \(formattedDate(last))" + (extra.map { " · \($0)" } ?? "")
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
        throw NSError(domain: "Urinprotokoll", code: 2, userInfo: [NSLocalizedDescriptionKey: "Die Textkodierung wurde nicht erkannt."])
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
        Int(value.replacingOccurrences(of: "ml", with: "").replacingOccurrences(of: ".", with: "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
    }

    private func zipLists(times: [String], amounts: [Int]) -> [(String, Int)] {
        (0..<max(times.count, amounts.count)).map { index in
            (index < times.count ? times[index] : "", index < amounts.count ? amounts[index] : 0)
        }
    }

    private func monthName(_ month: Int) -> String {
        let names = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
        return names[max(0, min(month - 1, names.count - 1))]
    }

    private func dayName(_ date: Date) -> String {
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
                Button("CSV laden...") { model.openCSV() }
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
    @State private var selection: AppSection = .dashboard
    @State private var showsEntrySheet = false

    var body: some View {
        let theme = AppTheme(rawValue: themeRaw) ?? .classicDark
        NavigationSplitView {
            List(AppSection.allCases, selection: $selection) { section in
                Label(section.rawValue, systemImage: section.symbol)
                    .tag(section)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            VStack(spacing: 0) {
                ToolbarStrip(selection: $selection, showsEntrySheet: $showsEntrySheet, themeRaw: $themeRaw)
                Divider()
                detailView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(AppBackground(theme: theme))
        }
        .environment(\.appTheme, theme)
        .preferredColorScheme(theme.preferredScheme)
        .tint(theme.accent)
        .sheet(isPresented: $showsEntrySheet) {
            EntrySheet()
                .environmentObject(model)
        }
        .alert("CSV konnte nicht geladen werden", isPresented: Binding(
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
        case .year: SummaryTableView(title: "Jahr", section: .year)
        case .month: SummaryTableView(title: "Monat", section: .month)
        case .week: SummaryTableView(title: "Woche", section: .week)
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

    var body: some View {
        HStack(spacing: 12) {
            AppMark(size: 54)
            VStack(alignment: .leading, spacing: 2) {
                Text(selection.rawValue)
                    .font(.title2.weight(.bold))
                Text(model.status)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 8) {
                Text("Daten merken")
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                Toggle("Daten merken", isOn: $model.rememberData)
                    .labelsHidden()
                    .onChange(of: model.rememberData) { _, _ in model.toggleRemember() }
                    .toggleStyle(.switch)
            }
            ThemeMenu(themeRaw: $themeRaw)
            Button("Eintrag", systemImage: "plus.circle") { showsEntrySheet = true }
            Button("CSV ergänzen", systemImage: "plus.square.on.square") { model.openMergeCSV() }
            Button("CSV laden", systemImage: "square.and.arrow.down") { model.openCSV() }
            Button("Löschen", systemImage: "trash", role: .destructive) { model.clearData() }
                .disabled(!model.hasData)
            Button("Backup", systemImage: "externaldrive") { model.exportBackup() }
                .disabled(!model.hasData)
            Button("Tagesdaten", systemImage: "tablecells") { model.exportDays() }
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
                        Label(option.title, systemImage: "checkmark")
                    } else {
                        Text(option.title)
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(selectedTheme.title)
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

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "drop.triangle")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)
            Text("Keine Daten geladen")
                .font(.title2.weight(.bold))
            Text("Lade einen CSV-Export aus Urinote oder eine Tagesdaten-CSV.")
                .foregroundStyle(.secondary)
            Button("CSV laden", systemImage: "square.and.arrow.down") { model.openCSV() }
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

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(editIndex == nil ? "Eintrag hinzufügen" : "Eintrag bearbeiten")
                .font(.title2.weight(.bold))
            Form {
                DatePicker("Datum", selection: $date, displayedComponents: [.date])
                DatePicker("Urin Uhrzeit", selection: $urineTime, displayedComponents: [.hourAndMinute])
                TextField("Urin ml", text: $urineMl)
                DatePicker("Wasser Uhrzeit", selection: $waterTime, displayedComponents: [.hourAndMinute])
                TextField("Wasser ml", text: $waterMl)
                TextField("Hinweis", text: $note, axis: .vertical)
                    .lineLimit(3...5)
            }
            entryList
            HStack {
                Spacer()
                Button("Schließen") { dismiss() }
                Button("Neu") { resetForm(keepDate: true) }
                Group {
                    Button("Hinzufügen") {
                        save()
                        resetForm(keepDate: true)
                    }
                    Button("Hinzufügen & schließen") {
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
    }

    private var hasInput: Bool {
        Int(urineMl) != nil || Int(waterMl) != nil || !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var entryList: some View {
        let rows = model.entriesForMesstag(date)
        return VStack(alignment: .leading, spacing: 8) {
            Text("Einträge an diesem Messtag")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            if rows.isEmpty {
                Text("Für diesen Messtag gibt es noch keine Einträge.")
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
                                Text(row.entry.type)
                                    .fontWeight(.semibold)
                                    .frame(width: 70, alignment: .leading)
                                Text(row.entry.type == "Hinweis" ? "Hinweis" : "\(row.entry.ml) ml")
                                    .monospacedDigit()
                                    .frame(width: 86, alignment: .leading)
                                Text(row.entry.note)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                Spacer()
                                Button("Bearbeiten") { fillForm(row.index, row.entry) }
                                Button("Löschen", role: .destructive) { model.deleteEntry(index: row.index) }
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
        let now = Date()
        editIndex = nil
        if !keepDate {
            date = now
        }
        urineTime = now
        waterTime = now
        urineMl = ""
        waterMl = ""
        note = ""
    }
}

struct FilterBar: View {
    @EnvironmentObject private var model: UrinModel

    var body: some View {
        HStack {
            Picker("Jahr", selection: $model.selectedYear) {
                Text("Alle Jahre").tag("all")
                ForEach(model.years, id: \.self) { year in
                    Text("\(year)").tag("\(year)")
                }
            }
            Picker("Monat", selection: $model.selectedMonth) {
                Text("Alle Monate").tag("all")
                ForEach(Array(["Januar","Februar","März","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember"].enumerated()), id: \.offset) { index, name in
                    Text(name).tag("\(index + 1)")
                }
            }
            Spacer()
        }
        .disabled(!model.hasData)
    }
}

struct MetricGrid: View {
    @EnvironmentObject private var model: UrinModel

    var body: some View {
        let days = model.filteredDays
        let urineTotal = days.reduce(0) { $0 + $1.urineTotal }
        let waterTotal = days.reduce(0) { $0 + $1.waterTotal }
        let metrics = [
            ("Messtage", "\(days.count)", "calendar"),
            ("Urin gesamt ml", model.format(urineTotal), "circle.fill"),
            ("Urin Ø ml/Tag", model.format(days.isEmpty ? 0 : urineTotal / days.count), "chart.line.uptrend.xyaxis"),
            ("Wasser gesamt ml", model.format(waterTotal), "drop.fill"),
            ("Niedrige Urin-Tage", "\(days.filter { $0.urineTotal < 800 }.count)", "exclamationmark.triangle"),
            ("Normale Urin-Tage", "\(days.filter { $0.urineTotal >= 800 }.count)", "checkmark.circle")
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
    let days: [DaySummary]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ChartHeader(title: "Tagesverlauf")
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
    let rows: [SummaryRow]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ChartHeader(title: "Monatsvergleich")
            Canvas { context, size in
                let area = CGRect(x: 28, y: 4, width: max(size.width - 42, 1), height: max(size.height - 24, 1))
                let maxValue = CGFloat(max(rows.compactMap { Int(($0.values["● Urin Gesamt ml"] ?? "0").replacingOccurrences(of: ".", with: "")) }.max() ?? 1, 1))
                let step = area.width / CGFloat(max(rows.count, 1))
                for (index, row) in rows.enumerated() {
                    let urine = CGFloat(Int((row.values["● Urin Gesamt ml"] ?? "0").replacingOccurrences(of: ".", with: "")) ?? 0)
                    let water = CGFloat(Int((row.values["💧 Wasser Gesamt ml"] ?? "0").replacingOccurrences(of: ".", with: "")) ?? 0)
                    let x = area.minX + CGFloat(index) * step
                    context.fill(Path(CGRect(x: x, y: area.maxY - (urine / maxValue * area.height), width: max(step * 0.28, 4), height: urine / maxValue * area.height)), with: .color(theme.urineColor.opacity(0.80)))
                    context.fill(Path(CGRect(x: x + max(step * 0.34, 6), y: area.maxY - (water / maxValue * area.height), width: max(step * 0.28, 4), height: water / maxValue * area.height)), with: .color(theme.waterColor.opacity(0.80)))
                }
            }
        }
    }
}

struct ChartHeader: View {
    @Environment(\.appTheme) private var theme
    let title: String

    var body: some View {
        HStack(spacing: 14) {
            Text(title)
                .font(.headline)
            Label("Urin", systemImage: "circle.fill")
                .foregroundStyle(theme.urineColor)
            Label("Wasser", systemImage: "drop.fill")
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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Auffälligkeiten")
                .font(.headline)
            ThemedDataTable(
                rows: model.alertRows(),
                columns: [
                    ThemedTableColumn("Messtag", width: 160) { Text(model.formattedDate($0.messtag)) },
                    ThemedTableColumn("Tag", width: 160) { Text($0.dayName) },
                    ThemedTableColumn("Urin gesamt ml", width: 170) { day in
                        Text(model.format(day.urineTotal))
                            .foregroundStyle(day.urineTotal < 800 ? .red : .orange)
                            .monospacedDigit()
                    },
                    ThemedTableColumn("Wasser gesamt ml", width: 180) { Text(model.format($0.waterTotal)).monospacedDigit() },
                    ThemedTableColumn("Auffälligkeit", width: 180) { _ in Text("niedrig") }
                ],
                minHeight: 210
            )
        }
        .liquidCard()
    }
}

struct SummaryTableView: View {
    @EnvironmentObject private var model: UrinModel
    let title: String
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
                ThemedTableColumn("Jahr", width: 120) { Text($0.values["Jahr"] ?? "") }
            ])
        case .month:
            return commonSummaryColumns(prefix: [
                ThemedTableColumn("Jahr", width: 110) { Text($0.values["Jahr"] ?? "") },
                ThemedTableColumn("Monat", width: 150) { Text($0.values["Monat Name"] ?? "") }
            ])
        case .week:
            var result = commonSummaryColumns(prefix: [
                ThemedTableColumn("Jahr", width: 100) { Text($0.values["Jahr"] ?? "") },
                ThemedTableColumn("KW", width: 90) { Text($0.values["KW"] ?? "") }
            ])
            result.append(ThemedTableColumn("Auffälligkeit", width: 150) { Text($0.values["Auffälligkeit"] ?? "") })
            return result
        default:
            return []
        }
    }

    private func commonSummaryColumns(prefix: [ThemedTableColumn<SummaryRow>]) -> [ThemedTableColumn<SummaryRow>] {
        prefix + [
            ThemedTableColumn("Tage", width: 90) { Text($0.values["Tage"] ?? "") },
            ThemedTableColumn("Urin Gesamt ml", width: 170) { Text($0.values["● Urin Gesamt ml"] ?? "").monospacedDigit() },
            ThemedTableColumn("Urin Ø ml/Tag", width: 170) { Text($0.values["● Urin Ø ml/Tag"] ?? "").monospacedDigit() },
            ThemedTableColumn("Urin Anzahl", width: 140) { Text($0.values["● Urin Anzahl"] ?? "").monospacedDigit() },
            ThemedTableColumn("Wasser Gesamt ml", width: 180) { Text($0.values["💧 Wasser Gesamt ml"] ?? "").monospacedDigit() }
        ]
    }
}

struct DayTableView: View {
    @EnvironmentObject private var model: UrinModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FilterBar()
            ThemedDataTable(rows: model.filteredDays, columns: [
                ThemedTableColumn("Datum", width: 110) { Text(model.formattedDate($0.messtag)) },
                ThemedTableColumn("Tag", width: 100) { Text($0.dayName) },
                ThemedTableColumn("Urin Zeiten", width: 120) { multilineCell($0.urine.map(\.0).joined(separator: "\n"), monospaced: true) },
                ThemedTableColumn("Urin ml", width: 110) { multilineCell($0.urine.map { "\($0.1) ml" }.joined(separator: "\n"), monospaced: true) },
                ThemedTableColumn("Urin Summe", width: 120) { Text(model.format($0.urineTotal)).monospacedDigit() },
                ThemedTableColumn("Wasser Zeiten", width: 120) { multilineCell($0.water.map(\.0).joined(separator: "\n"), monospaced: true) },
                ThemedTableColumn("Wasser ml", width: 110) { multilineCell($0.water.map { "\($0.1) ml" }.joined(separator: "\n"), monospaced: true) },
                ThemedTableColumn("Wasser Summe", width: 130) { Text(model.format($0.waterTotal)).monospacedDigit() },
                ThemedTableColumn("Hinweise", width: 520) { day in
                    multilineCell(day.notesText, lineLimit: 3)
                        .help(day.notesText)
                }
            ])
        }
        .padding(22)
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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Medizinische Notizen")
                .font(.title.weight(.bold))
            Group {
                Text("Die Auswertung verwendet Messtage von 06:00 bis 05:59.")
                Text("Einträge zwischen 00:00 und 05:59 werden dem Vortag zugerechnet.")
                Text("Auffälligkeiten sind organisatorische Hinweise, keine medizinische Bewertung.")
                Text("Wasserwerte werden separat geführt und nicht mit Urinmengen vermischt.")
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
