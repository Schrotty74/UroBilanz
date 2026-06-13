import Foundation

@MainActor
enum ImportSmokeTestRunner {
    static func run() -> Never {
        let model = UrinModel()
        let args = Array(ProcessInfo.processInfo.arguments)
        let runWorkflow = args.contains("--test-workflow")
        let paths = importPaths(from: args)
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
        if runWorkflow {
            runWorkflowTest(model: model)
            runEvaluationEdgeTests(model: model)
            runNoteAlignmentTest(model: model)
            runMedicalReportTest(model: model)
            runThemeImportTest()
        }
        exit(0)
    }

    private static func importPaths(from args: [String]) -> [String] {
        guard let start = args.firstIndex(of: "--test-import") else { return [] }
        var paths: [String] = []
        for value in args[(start + 1)...] {
            if value.hasPrefix("--") { break }
            paths.append(value)
        }
        return paths
    }

    private static func runWorkflowTest(model: UrinModel) {
        let beforeDays = model.days.count
        let day = date(2030, 1, 2, 12, 0)
        let urineTime = date(2030, 1, 2, 6, 10)
        let waterTime = date(2030, 1, 2, 6, 20)

        model.addManualEntries(date: day, urineTime: urineTime, urineMl: 250, waterTime: waterTime, waterMl: 300, note: "Workflow-Test")
        assertWorkflow(model.days.count == beforeDays + 1, "manual day was not added")
        assertWorkflow(model.entriesForMesstag(day).count == 3, "manual entries were not added")

        guard let urineIndex = model.entriesForMesstag(day).first(where: { $0.entry.type == "Urin" })?.index else {
            assertWorkflow(false, "urine entry missing")
            return
        }
        model.updateManualEntry(index: urineIndex, date: day, urineTime: urineTime, urineMl: 400, waterTime: waterTime, waterMl: nil, note: "")
        let editedDay = model.days.first { Calendar(identifier: .gregorian).isDate($0.messtag, inSameDayAs: day) }
        assertWorkflow(editedDay?.urineTotal == 400, "manual edit did not update urine total")

        guard let waterIndex = model.entriesForMesstag(day).first(where: { $0.entry.type == "Wasser" })?.index else {
            assertWorkflow(false, "water entry missing")
            return
        }
        model.deleteEntry(index: waterIndex)
        let afterDeleteEntry = model.days.first { Calendar(identifier: .gregorian).isDate($0.messtag, inSameDayAs: day) }
        assertWorkflow(afterDeleteEntry?.waterTotal == 0, "entry delete did not remove water value")

        assertWorkflow(model.rawCSV.contains("Datum,Typ,ml,Hinweis"), "backup CSV header missing")
        model.deleteMeasurementDay(day)
        assertWorkflow(model.days.count == beforeDays, "measurement day delete did not restore day count")
        print("Swift workflow smoke test passed")
    }

    private static func runEvaluationEdgeTests(model: UrinModel) {
        model.clearData()
        let incompleteDay = date(2031, 1, 1, 12, 0)
        model.addManualEntries(
            date: incompleteDay,
            urineTime: date(2031, 1, 1, 8, 0),
            urineMl: 420,
            waterTime: date(2031, 1, 1, 8, 20),
            waterMl: 320,
            note: "unvollstaendig"
        )

        let lowDay = date(2031, 1, 2, 12, 0)
        model.addManualEntries(
            date: lowDay,
            urineTime: date(2031, 1, 2, 6, 0),
            urineMl: 600,
            waterTime: date(2031, 1, 2, 18, 0),
            waterMl: 1600,
            note: "niedrig"
        )

        let rows = model.summaryRows(kind: .week)
        assertWorkflow(rows.count == 1, "edge week should be grouped together")
        guard let row = rows.first else { return }
        assertWorkflow(row.values["Tage"] == "1", "incomplete day must not count as evaluated day")
        assertWorkflow(row.values["Unvollständige Tage"] == "1", "incomplete day count missing")
        assertWorkflow(row.values["● Urin Gesamt ml"] == "600", "incomplete urine total must not be added")
        assertWorkflow(row.values["Auffälligkeit"]?.contains("niedrig") == true, "low complete day missing in week flag")
        assertWorkflow(row.values["Auffälligkeit"]?.contains("unvollständig") == true, "incomplete day missing in week flag")
        assertWorkflow(model.alertRows().count == 2, "alerts should include low and incomplete days")
        print("Swift evaluation edge test passed")
    }

    private static func runNoteAlignmentTest(model: UrinModel) {
        model.clearData()
        let csv = """
        Datum,Typ,ml,Hinweis
        21.5.2026 09:16,Urin,100,wenig Stuhl
        21.5.2026 11:26,Urin,250,wenig Stuhl
        21.5.2026 14:26,Urin,200,
        21.5.2026 16:29,Urin,80,Katastrophe heute
        21.5.2026 18:20,Urin,150,
        22.5.2026 05:27,Urin,120,
        23.5.2026 07:43,Urin,50,Stuhlgang
        23.5.2026 11:33,Urin,130,massiv weniger seit Tadalafil.
        23.5.2026 14:36,Urin,390,besser jetzt aber noch immer unterbrochen
        23.5.2026 16:32,Urin,260,
        23.5.2026 18:24,Urin,170,
        23.5.2026 22:11,Urin,120,
        24.5.2026 05:24,Urin,100,sehr wenig für einen Morgenurin
        """
        do {
            try model.load(csv: csv)
            guard let day = model.days.first(where: { model.formattedDate($0.messtag) == "21.05.2026" }) else {
                assertWorkflow(false, "note alignment day missing")
                return
            }
            assertWorkflow(day.noteRows.contains { $0.0 == "09:16" && $0.1 == "wenig Stuhl" }, "21.5 note must stay attached to 09:16")
            assertWorkflow(day.noteRows.contains { $0.0 == "11:26" && $0.1 == "wenig Stuhl" }, "21.5 note must stay attached to 11:26")
            assertWorkflow(day.noteRows.contains { $0.0 == "16:29" && $0.1 == "Katastrophe heute" }, "21.5 note must stay attached to 16:29")
            guard let nextDay = model.days.first(where: { model.formattedDate($0.messtag) == "23.05.2026" }) else {
                assertWorkflow(false, "23.5 note alignment day missing")
                return
            }
            assertWorkflow(nextDay.noteRows.contains { $0.0 == "07:43" && $0.1 == "Stuhlgang" }, "23.5 note must stay attached to 07:43")
            assertWorkflow(nextDay.noteRows.contains { $0.0 == "11:33" && $0.1 == "massiv weniger seit Tadalafil." }, "23.5 note must stay attached to 11:33")
            assertWorkflow(nextDay.noteRows.contains { $0.0 == "14:36" && $0.1 == "besser jetzt aber noch immer unterbrochen" }, "23.5 note must stay attached to 14:36")
            assertWorkflow(nextDay.noteRows.contains { $0.0 == "05:24" && $0.1 == "sehr wenig für einen Morgenurin" }, "23.5 note must stay attached to 05:24")
            print("Swift note alignment smoke test passed")
        } catch {
            print("Hinweis-Zuordnungstest Fehler: \(error.localizedDescription)")
            exit(1)
        }
    }

    private static func runThemeImportTest() {
        let path = FileManager.default.currentDirectoryPath + "/docs/themes/example-custom-theme.json"
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let theme = try JSONDecoder().decode(CustomThemeDefinition.self, from: data).validated()
            assertWorkflow(theme.id == "harbor-night", "custom theme id mismatch")
            assertWorkflow(theme.title(.en) == "Harbor Night", "custom theme title mismatch")
            assertWorkflow(theme.style.isDark, "custom theme should be dark")
            let encoded = try JSONEncoder().encode(theme)
            let decoded = try JSONDecoder().decode(CustomThemeDefinition.self, from: encoded).validated()
            assertWorkflow(decoded.id == theme.id, "custom theme export roundtrip failed")
            let builtInCopy = try AppTheme.classicDark.exportCopy(existingIds: [theme.id, "classic-dark-custom"])
            assertWorkflow(builtInCopy.id == "classic-dark-custom-2", "built-in theme export copy id should avoid collisions")
            assertWorkflow(builtInCopy.title(.de) == "Classic Dunkel Kopie", "built-in theme export copy title mismatch")
            assertWorkflow(builtInCopy.mode == "dark", "built-in theme export copy mode mismatch")

            var duplicate = theme
            duplicate.id = AppTheme.classicLight.rawValue
            do {
                _ = try duplicate.validated()
                assertWorkflow(false, "built-in theme id should be rejected")
            } catch {
                // Expected.
            }
            print("Swift theme import smoke test passed")
        } catch {
            print("Theme-Importtest Fehler: \(error.localizedDescription)")
            exit(1)
        }
    }

    private static func runMedicalReportTest(model: UrinModel) {
        guard !model.days.isEmpty else {
            assertWorkflow(false, "medical report needs measurement days")
            return
        }
        let report = MedicalReportPDF.attributedReport(
            days: model.days,
            language: .de,
            includeDetails: true,
            includeNotes: true
        )
        assertWorkflow(report.string.contains("Arztbericht"), "medical report title missing")
        assertWorkflow(report.string.contains("Tagesverlauf"), "medical report daily progress missing")
        assertWorkflow(report.string.contains("Tagesübersicht"), "medical report overview missing")
        assertWorkflow(report.string.contains("Stuhlgang"), "medical report note missing")

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("urobilanz-medical-report-smoke.pdf")
        try? FileManager.default.removeItem(at: url)
        do {
            try MedicalReportPDF.write(
                days: model.days,
                language: .de,
                includeDetails: true,
                includeNotes: true,
                to: url
            )
            let data = try Data(contentsOf: url)
            assertWorkflow(data.starts(with: Data("%PDF".utf8)), "medical report is not a PDF")
            assertWorkflow(data.count > 5_000, "medical report PDF is unexpectedly small")
            if !ProcessInfo.processInfo.arguments.contains("--keep-test-report") {
                try? FileManager.default.removeItem(at: url)
            }
            print("Swift medical report smoke test passed")
        } catch {
            print("Arztbericht-Test Fehler: \(error.localizedDescription)")
            exit(1)
        }
    }

    private static func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        Calendar(identifier: .gregorian).date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)) ?? Date()
    }

    private static func assertWorkflow(_ condition: Bool, _ message: String) {
        if !condition {
            print("Workflowtest Fehler: \(message)")
            exit(1)
        }
    }
}
