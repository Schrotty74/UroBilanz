import Foundation

func parseCSV(_ text: String) -> [[String: String]] {
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

func detectDelimiter(_ firstLine: String) -> Character {
    firstLine.filter { $0 == ";" }.count > firstLine.filter { $0 == "," }.count ? ";" : ","
}

func parseCSVLine(_ line: String, delimiter: Character) -> [String] {
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

func splitList(_ value: String) -> [String] {
    value.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
}

func parseAmount(_ value: String) -> Int {
    let cleaned = value
        .replacingOccurrences(of: "ml", with: "")
        .replacingOccurrences(of: ".", with: "")
        .replacingOccurrences(of: ",", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
    return Int(cleaned) ?? 0
}

func zipLists(times: [String], amounts: [Int]) -> [(String, Int)] {
    (0..<max(times.count, amounts.count)).map { index in
        (index < times.count ? times[index] : "", index < amounts.count ? amounts[index] : 0)
    }
}

func escape(_ value: String) -> String {
    let cleaned = value.replacingOccurrences(of: "\n", with: " | ")
    return cleaned.contains(",") || cleaned.contains("\"") ? "\"\(cleaned.replacingOccurrences(of: "\"", with: "\"\""))\"" : cleaned
}
