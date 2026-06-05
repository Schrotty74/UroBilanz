import Foundation

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
    let noteRows: [(String, String)]
    let generalNotes: [String]

    var id: Date { messtag }
    var urineTotal: Int { urine.reduce(0) { $0 + $1.1 } }
    var waterTotal: Int { water.reduce(0) { $0 + $1.1 } }
    var urineCount: Int { urine.count }
    var notesText: String { notes.joined(separator: " | ") }
    var noteRowsText: String {
        let attached = noteRows.map { time, note in
            time.isEmpty ? note : "\(time) · \(note)"
        }
        return (attached + generalNotes).joined(separator: "\n")
    }
    var isCompleteMeasurementDay: Bool {
        let minutes = (urine + water).compactMap { item -> Int? in
            let parts = item.0.split(separator: ":").compactMap { Int($0) }
            guard parts.count == 2 else { return nil }
            let hour = parts[0] < 6 ? parts[0] + 24 : parts[0]
            return hour * 60 + parts[1]
        }
        guard let first = minutes.min(), let last = minutes.max() else { return false }
        return last - first >= 8 * 60
    }
}

struct SummaryRow: Identifiable {
    let id: String
    let values: [String: String]
    let urineAverage: Int
}
