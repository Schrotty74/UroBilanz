import SwiftUI
import AppKit
import UniformTypeIdentifiers

private final class MedicalReportTextView: NSTextView {
    override var isOpaque: Bool { true }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.white.setFill()
        dirtyRect.fill()
        super.draw(dirtyRect)
    }
}

struct MedicalReportSheet: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language
    @State private var from = Date()
    @State private var to = Date()
    @State private var includeDetails = true
    @State private var includeNotes = true
    @State private var errorMessage: String?

    private var selectedDays: [DaySummary] {
        let calendar = Calendar(identifier: .gregorian)
        let lower = calendar.startOfDay(for: min(from, to))
        let upper = calendar.startOfDay(for: max(from, to))
        return model.days.filter {
            let day = calendar.startOfDay(for: $0.messtag)
            return day >= lower && day <= upper
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(tr("medical_report", language))
                .font(.title2.weight(.bold))
            Text(tr("medical_report_intro", language))
                .foregroundStyle(.secondary)

            Form {
                DatePicker(tr("period_from", language), selection: $from, displayedComponents: .date)
                DatePicker(tr("period_to", language), selection: $to, displayedComponents: .date)
                Toggle(tr("include_daily_details", language), isOn: $includeDetails)
                Toggle(tr("include_notes", language), isOn: $includeNotes)
            }

            Text(tr("medical_report_note", language))
                .font(.callout)
                .foregroundStyle(.secondary)

            HStack {
                Text("\(selectedDays.count) \(tr("measurement_days", language))")
                    .foregroundStyle(.secondary)
                Spacer()
                Button(tr("close", language)) { dismiss() }
                Button(tr("create_pdf", language), systemImage: "doc.richtext") {
                    export()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(selectedDays.isEmpty)
            }
        }
        .padding(24)
        .frame(width: 590)
        .onAppear {
            guard let first = model.days.first?.messtag,
                  let last = model.days.last?.messtag else { return }
            from = first
            to = last
        }
        .alert(tr("medical_report", language), isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func export() {
        do {
            try MedicalReportPDF.export(
                days: selectedDays,
                language: language,
                includeDetails: includeDetails,
                includeNotes: includeNotes
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

@MainActor
enum MedicalReportPDF {
    private static let pageSize = NSSize(width: 595.2, height: 841.8)
    private static let margin: CGFloat = 42
    private static let ink = NSColor(calibratedRed: 0.09, green: 0.13, blue: 0.15, alpha: 1)
    private static let heading = NSColor(calibratedRed: 0.09, green: 0.24, blue: 0.32, alpha: 1)
    private static let muted = NSColor(calibratedRed: 0.32, green: 0.39, blue: 0.42, alpha: 1)
    private static let headerFill = NSColor(calibratedRed: 0.91, green: 0.94, blue: 0.95, alpha: 1)
    private static let lowFill = NSColor(calibratedRed: 1, green: 0.95, blue: 0.84, alpha: 1)
    private static let incompleteFill = NSColor(calibratedWhite: 0.93, alpha: 1)
    private static let urineBar = NSColor(calibratedRed: 0.84, green: 0.60, blue: 0.13, alpha: 1)
    private static let waterBar = NSColor(calibratedRed: 0.33, green: 0.55, blue: 0.66, alpha: 1)

    static func export(
        days: [DaySummary],
        language: AppLanguage,
        includeDetails: Bool,
        includeNotes: Bool
    ) throws {
        guard !days.isEmpty else {
            throw reportError(tr("report_no_days", language))
        }

        let panel = NSSavePanel()
        panel.allowedContentTypes = [.pdf]
        panel.nameFieldStringValue = "urobilanz-arztbericht-\(dateStamp()).pdf"
        guard panel.runModal() == .OK, let url = panel.url else { return }

        try write(
            days: days,
            language: language,
            includeDetails: includeDetails,
            includeNotes: includeNotes,
            to: url
        )
    }

    static func write(
        days: [DaySummary],
        language: AppLanguage,
        includeDetails: Bool,
        includeNotes: Bool,
        to url: URL
    ) throws {
        guard !days.isEmpty else {
            throw reportError(tr("report_no_days", language))
        }
        let report = attributedReport(
            days: days,
            language: language,
            includeDetails: includeDetails,
            includeNotes: includeNotes
        )
        let printableWidth = pageSize.width - margin * 2
        let textView = MedicalReportTextView(frame: NSRect(x: 0, y: 0, width: printableWidth, height: 100))
        textView.isEditable = false
        textView.isSelectable = false
        textView.drawsBackground = true
        textView.backgroundColor = .white
        textView.textContainerInset = .zero
        textView.textContainer?.containerSize = NSSize(width: printableWidth, height: .greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        textView.textStorage?.setAttributedString(report)
        textView.layoutManager?.ensureLayout(for: textView.textContainer!)

        let usedHeight = textView.layoutManager?.usedRect(for: textView.textContainer!).height ?? 100
        textView.frame = NSRect(x: 0, y: 0, width: printableWidth, height: max(usedHeight, 100))

        let printInfo = NSPrintInfo()
        printInfo.paperSize = pageSize
        printInfo.topMargin = margin
        printInfo.bottomMargin = margin
        printInfo.leftMargin = margin
        printInfo.rightMargin = margin
        printInfo.horizontalPagination = .fit
        printInfo.verticalPagination = .automatic
        printInfo.isVerticallyCentered = false
        printInfo.jobDisposition = .save
        let temporaryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("urobilanz-medical-report-\(UUID().uuidString).pdf")
        printInfo.dictionary()[NSPrintInfo.AttributeKey.jobSavingURL] = temporaryURL

        let operation = NSPrintOperation(view: textView, printInfo: printInfo)
        operation.showsPrintPanel = false
        operation.showsProgressPanel = false
        guard operation.run() else {
            throw reportError(tr("report_save_error", language))
        }
        defer { try? FileManager.default.removeItem(at: temporaryURL) }
        try addWhitePageBackground(from: temporaryURL, to: url, language: language)
    }

    static func attributedReport(
        days: [DaySummary],
        language: AppLanguage,
        includeDetails: Bool,
        includeNotes: Bool
    ) -> NSAttributedString {
        let report = NSMutableAttributedString()
        let locale = Locale(identifier: language == .de ? "de_DE" : "en_US")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = .medium

        if let iconURL = Bundle.main.url(forResource: "urobilanz-app-icon", withExtension: "png"),
           let icon = NSImage(contentsOf: iconURL) {
            icon.size = NSSize(width: 48, height: 48)
            let attachment = NSTextAttachment()
            attachment.image = icon
            report.append(NSAttributedString(attachment: attachment))
            report.append(NSAttributedString(string: "\n"))
        }

        append("UroBilanz\n", to: report, size: 13, weight: .bold, color: heading)
        append("\(tr("medical_report", language))\n", to: report, size: 24, weight: .bold, color: ink)
        if let first = days.first?.messtag, let last = days.last?.messtag {
            append(
                "\(tr("selected_period", language)): \(dateFormatter.string(from: first)) \(tr("to", language)) \(dateFormatter.string(from: last))\n",
                to: report,
                size: 10,
                color: muted
            )
        }
        append(
            "\(tr("created", language)): \(dateFormatter.string(from: Date()))\n\n",
            to: report,
            size: 10,
            color: muted
        )

        section(tr("report_summary", language), in: report)
        let evaluated = days.filter(\.isCompleteMeasurementDay)
        let low = evaluated.filter { $0.urineTotal < 700 }
        let urineTotal = evaluated.reduce(0) { $0 + $1.urineTotal }
        let waterTotal = evaluated.reduce(0) { $0 + $1.waterTotal }
        let average = evaluated.isEmpty ? 0 : Int((Double(urineTotal) / Double(evaluated.count)).rounded())
        let metrics = [
            (tr("measurement_days", language), days.count),
            (tr("evaluated_days", language), evaluated.count),
            (tr("incomplete_days", language), days.count - evaluated.count),
            (tr("low_days", language), low.count),
            (tr("normal_days", language), evaluated.count - low.count),
        ]
        for (label, value) in metrics {
            append("\(label): ", to: report, size: 10, weight: .semibold, color: muted)
            append("\(value)\n", to: report, size: 10, weight: .bold, color: ink)
        }
        append("\(tr("urine_total_report", language)): ", to: report, size: 10, weight: .semibold, color: muted)
        append("\(formatted(urineTotal, locale: locale)) ml\n", to: report, size: 10, weight: .bold, color: ink)
        append("\(tr("urine_average_report", language)): ", to: report, size: 10, weight: .semibold, color: muted)
        append("\(formatted(average, locale: locale)) ml\n", to: report, size: 10, weight: .bold, color: ink)
        append("\(tr("water_total_report", language)): ", to: report, size: 10, weight: .semibold, color: muted)
        append("\(formatted(waterTotal, locale: locale)) ml\n\n", to: report, size: 10, weight: .bold, color: ink)

        section(tr("daily_progress", language), in: report)
        appendDailyProgress(days: days, language: language, locale: locale, to: report)

        section(tr("evaluation_rules", language), in: report)
        append(
            tr("report_rule_text", language) + "\n\n",
            to: report,
            size: 9.5,
            color: ink,
            background: incompleteFill
        )

        section(tr("daily_overview", language), in: report)
        tableHeader(
            "\(tr("date", language))\t\(tr("urine", language))\t\(tr("water", language))\t\(tr("evaluation", language))\n",
            in: report
        )
        for day in days {
            let assessment = assessment(for: day, language: language)
            let fill = !day.isCompleteMeasurementDay ? incompleteFill : day.urineTotal < 700 ? lowFill : NSColor.clear
            tableRow(
                "\(dateFormatter.string(from: day.messtag))\t\(formatted(day.urineTotal, locale: locale)) ml\t\(formatted(day.waterTotal, locale: locale)) ml\t\(assessment)\n",
                fill: fill,
                in: report
            )
        }
        report.append(NSAttributedString(string: "\n"))

        if includeDetails {
            section(tr("daily_details", language), in: report)
            for day in days {
                append(
                    "\(dateFormatter.string(from: day.messtag)) - \(assessment(for: day, language: language))\n",
                    to: report,
                    size: 12,
                    weight: .bold,
                    color: heading,
                    keepWithNext: true
                )
                tableHeader(
                    "\(tr("time", language))\t\(tr("type", language))\t\(tr("amount", language))\(includeNotes ? "\t\(tr("note", language))" : "")\n",
                    in: report
                )
                for entry in detailEntries(day: day, language: language) {
                    let note = includeNotes ? "\t\(entry.note)" : ""
                    tableRow("\(entry.time)\t\(entry.type)\t\(entry.amount)\(note)\n", fill: .clear, in: report)
                }
                if includeNotes, !day.generalNotes.isEmpty {
                    append(
                        "\(tr("general_notes", language)): \(day.generalNotes.joined(separator: " · "))\n",
                        to: report,
                        size: 9,
                        weight: .semibold,
                        color: muted,
                        background: headerFill
                    )
                }
                report.append(NSAttributedString(string: "\n"))
            }
        }

        append(tr("report_privacy", language), to: report, size: 8.5, color: muted)
        return report
    }

    private static func appendDailyProgress(
        days: [DaySummary],
        language: AppLanguage,
        locale: Locale,
        to report: NSMutableAttributedString
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = .medium
        let maximum = max(1, days.flatMap { [$0.urineTotal, $0.waterTotal] }.max() ?? 1)

        for day in days {
            append(
                "\(dateFormatter.string(from: day.messtag))\n",
                to: report,
                size: 9,
                weight: .bold,
                color: ink,
                keepWithNext: true
            )
            appendProgressLine(
                label: tr("urine", language),
                value: day.urineTotal,
                maximum: maximum,
                color: urineBar,
                locale: locale,
                to: report
            )
            appendProgressLine(
                label: tr("water", language),
                value: day.waterTotal,
                maximum: maximum,
                color: waterBar,
                locale: locale,
                to: report
            )
            report.append(NSAttributedString(string: "\n"))
        }
    }

    private static func appendProgressLine(
        label: String,
        value: Int,
        maximum: Int,
        color: NSColor,
        locale: Locale,
        to report: NSMutableAttributedString
    ) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.paragraphSpacing = 1
        paragraph.tabStops = [
            NSTextTab(textAlignment: .left, location: 54),
            NSTextTab(textAlignment: .right, location: 425),
        ]

        report.append(NSAttributedString(
            string: "\(label)\t",
            attributes: [
                .font: NSFont.systemFont(ofSize: 8),
                .foregroundColor: muted,
                .paragraphStyle: paragraph,
            ]
        ))

        let attachment = NSTextAttachment()
        attachment.image = progressBarImage(
            width: max(1, CGFloat(value) / CGFloat(maximum) * 285),
            color: color
        )
        report.append(NSAttributedString(attachment: attachment))
        report.append(NSAttributedString(
            string: "\t\(formatted(value, locale: locale)) ml\n",
            attributes: [
                .font: NSFont.systemFont(ofSize: 8, weight: .semibold),
                .foregroundColor: ink,
                .paragraphStyle: paragraph,
            ]
        ))
    }

    private static func progressBarImage(width: CGFloat, color: NSColor) -> NSImage {
        let size = NSSize(width: width, height: 5)
        let image = NSImage(size: size)
        image.lockFocus()
        color.setFill()
        NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()
        image.unlockFocus()
        return image
    }

    private static func addWhitePageBackground(from sourceURL: URL, to destinationURL: URL, language: AppLanguage) throws {
        guard let source = CGPDFDocument(sourceURL as CFURL) else {
            throw reportError(tr("report_save_error", language))
        }
        var mediaBox = CGRect(origin: .zero, size: pageSize)
        guard let context = CGContext(destinationURL as CFURL, mediaBox: &mediaBox, nil) else {
            throw reportError(tr("report_save_error", language))
        }

        for pageNumber in 1...source.numberOfPages {
            guard let page = source.page(at: pageNumber) else { continue }
            context.beginPDFPage(nil)
            context.setFillColor(NSColor.white.cgColor)
            context.fill(mediaBox)
            context.drawPDFPage(page)
            context.endPDFPage()
        }
        context.closePDF()
    }

    private static func detailEntries(day: DaySummary, language: AppLanguage) -> [(time: String, type: String, amount: String, note: String)] {
        var rows: [(String, String, String, String)] = []
        for item in day.urine {
            let note = day.noteRows.filter { $0.0 == item.0 }.map(\.1).joined(separator: " / ")
            rows.append((item.0, tr("urine", language), "\(item.1) ml", note))
        }
        for item in day.water {
            rows.append((item.0, tr("water", language), "\(item.1) ml", ""))
        }
        return rows.sorted { measurementMinutes($0.0) < measurementMinutes($1.0) }
    }

    private static func assessment(for day: DaySummary, language: AppLanguage) -> String {
        if !day.isCompleteMeasurementDay { return tr("incomplete", language) }
        return tr(day.urineTotal < 700 ? "low" : "normal", language)
    }

    private static func measurementMinutes(_ time: String) -> Int {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return Int.max }
        let hour = parts[0] < 6 ? parts[0] + 24 : parts[0]
        return hour * 60 + parts[1]
    }

    private static func section(_ title: String, in report: NSMutableAttributedString) {
        append("\(title)\n", to: report, size: 15, weight: .bold, color: heading, keepWithNext: true)
    }

    private static func tableHeader(_ text: String, in report: NSMutableAttributedString) {
        append(text, to: report, size: 9, weight: .bold, color: ink, background: headerFill, tabbed: true, keepWithNext: true)
    }

    private static func tableRow(_ text: String, fill: NSColor, in report: NSMutableAttributedString) {
        append(text, to: report, size: 9, color: ink, background: fill, tabbed: true)
    }

    private static func append(
        _ text: String,
        to report: NSMutableAttributedString,
        size: CGFloat,
        weight: NSFont.Weight = .regular,
        color: NSColor,
        background: NSColor = .clear,
        tabbed: Bool = false,
        keepWithNext: Bool = false
    ) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.paragraphSpacing = size * 0.2
        paragraph.lineSpacing = 1.5
        if keepWithNext {
            paragraph.paragraphSpacing = 2
        }
        if tabbed {
            paragraph.firstLineHeadIndent = 0
            paragraph.headIndent = 365
            paragraph.tabStops = [
                NSTextTab(textAlignment: .left, location: 120),
                NSTextTab(textAlignment: .left, location: 245),
                NSTextTab(textAlignment: .left, location: 365),
            ]
        }
        report.append(NSAttributedString(
            string: text,
            attributes: [
                .font: NSFont.systemFont(ofSize: size, weight: weight),
                .foregroundColor: color,
                .backgroundColor: background,
                .paragraphStyle: paragraph,
            ]
        ))
    }

    private static func formatted(_ value: Int, locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private static func dateStamp() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: Date())
    }

    private static func reportError(_ message: String) -> NSError {
        NSError(domain: "UroBilanz.MedicalReport", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
