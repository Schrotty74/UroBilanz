import SwiftUI
import AppKit
import UniformTypeIdentifiers

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
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_AT")
        formatter.dateFormat = "d.M.yyyy HH:mm"
        return formatter
    }()
    private static let displayDateDE: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_AT")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private static let displayDateEN: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    private static let rawDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_AT")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_AT")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    private static let jsonDateFormatter = ISO8601DateFormatter()

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
    var currentStreak: Int {
        currentStreak(in: days)
    }

    func currentStreak(in sourceDays: [DaySummary]) -> Int {
        let sortedDays = sourceDays.sorted { $0.messtag > $1.messtag }
        guard let firstDay = sortedDays.first?.messtag else { return 0 }
        var expectedDay = calendar.startOfDay(for: firstDay)
        var streak = 0
        for day in sortedDays {
            let currentDay = calendar.startOfDay(for: day.messtag)
            guard currentDay == expectedDay else { break }
            streak += 1
            expectedDay = calendar.date(byAdding: .day, value: -1, to: expectedDay) ?? expectedDay
        }
        return streak
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
            guard let rawDate = row["Datum"], let date = Self.dateFormatter.date(from: rawDate) else { continue }
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

    func exportJSON() {
        guard let data = try? exportJSONData() else { return }
        save(data: data, defaultName: "urobilanz-eintraege.json", contentType: .json)
    }

    func exportJSONData() throws -> Data {
        let rows = entries.sorted { $0.original < $1.original }.map { entry in
            [
                "datum": Self.jsonDateFormatter.string(from: entry.original),
                "typ": entry.type,
                "ml": (entry.ml as Int?) ?? 0,
                "hinweis": entry.note
            ] as [String: Any]
        }
        return try JSONSerialization.data(withJSONObject: rows, options: [.prettyPrinted, .sortedKeys])
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
                Self.rawDayFormatter.string(from: day.messtag),
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
        (language == .de ? Self.displayDateDE : Self.displayDateEN).string(from: date)
    }

    func formattedTime(_ date: Date) -> String {
        Self.timeFormatter.string(from: date)
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
            guard let rawDay = row["Messtag"], let messtag = Self.rawDayFormatter.date(from: rawDay) else { return nil }
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
        guard let rawDate = row["Datum"], let date = Self.dateFormatter.date(from: rawDate) else { return nil }
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
                .map { (Self.timeFormatter.string(from: $0.original), $0.note) }
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
                urine: rows.filter { $0.type == "Urin" }.map { (Self.timeFormatter.string(from: $0.original), $0.ml) },
                water: rows.filter { $0.type == "Wasser" }.map { (Self.timeFormatter.string(from: $0.original), $0.ml) },
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
            let trendValues = rows
                .sorted { $0.messtag < $1.messtag }
                .filter(\.isCompleteMeasurementDay)
                .map { Double($0.urineTotal) }
            return SummaryRow(id: key, values: values, urineAverage: average, trendValues: trendValues)
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
        return calendar.component(.hour, from: date) < 6
            ? calendar.date(byAdding: .day, value: -1, to: start) ?? start
            : start
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
        save(data: Data(text.utf8), defaultName: defaultName, contentType: .commaSeparatedText)
    }

    private func save(data: Data, defaultName: String, contentType: UTType) {
        guard !data.isEmpty else { return }
        let panel = NSSavePanel()
        panel.nameFieldStringValue = defaultName
        panel.allowedContentTypes = [contentType, .text]
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            try? data.write(to: url, options: .atomic)
        }
    }

    private func entriesToRawCSV(_ entries: [Entry]) -> String {
        let header = ["Datum", "Typ", "ml", "Hinweis"]
        let rows = entries.sorted { $0.original < $1.original }.map { entry in
            [
                "\(calendar.component(.day, from: entry.original)).\(calendar.component(.month, from: entry.original)).\(calendar.component(.year, from: entry.original)) \(Self.timeFormatter.string(from: entry.original))",
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
