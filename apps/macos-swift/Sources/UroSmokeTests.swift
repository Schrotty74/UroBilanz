import SwiftUI

struct ImportTestView: View {
    @EnvironmentObject private var model: UrinModel

    var body: some View {
        Text("Importtest")
            .task {
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
                    runWorkflowTest()
                    runEvaluationEdgeTests()
                }
                exit(0)
            }
    }

    private func importPaths(from args: [String]) -> [String] {
        guard let start = args.firstIndex(of: "--test-import") else { return [] }
        var paths: [String] = []
        for value in args[(start + 1)...] {
            if value.hasPrefix("--") { break }
            paths.append(value)
        }
        return paths
    }

    private func runWorkflowTest() {
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

    private func runEvaluationEdgeTests() {
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

    private func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        Calendar(identifier: .gregorian).date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)) ?? Date()
    }

    private func assertWorkflow(_ condition: Bool, _ message: String) {
        if !condition {
            print("Workflowtest Fehler: \(message)")
            exit(1)
        }
    }
}
