import SwiftUI
import AppKit

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
        let days = model.filteredEvaluationDays
        let urineTotal = days.reduce(0) { $0 + $1.urineTotal }
        let waterTotal = days.reduce(0) { $0 + $1.waterTotal }
        let metrics = [
            (tr("measurement_days", language), "\(days.count)", "calendar"),
            (tr("urine_total", language), model.format(urineTotal), "circle.fill"),
            (tr("urine_average", language), model.format(days.isEmpty ? 0 : urineTotal / days.count), "chart.line.uptrend.xyaxis"),
            (tr("water_total", language), model.format(waterTotal), "drop.fill"),
            (tr("low_days", language), "\(days.filter { $0.urineTotal < 700 }.count)", "exclamationmark.triangle"),
            (tr("normal_days", language), "\(days.filter { $0.urineTotal >= 700 }.count)", "checkmark.circle")
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
                            .foregroundStyle(day.urineTotal < 700 ? .red : .orange)
                            .monospacedDigit()
                    },
                    ThemedTableColumn(tr("water_total", language), width: 180) { Text(model.format($0.waterTotal)).monospacedDigit() },
                    ThemedTableColumn(tr("flag", language), width: 180) { day in
                        Text(tr(day.isCompleteMeasurementDay ? "low" : "incomplete", language))
                    }
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
                ThemedTableColumn(tr("year", language), width: 90) { Text($0.values["Jahr"] ?? "") },
                ThemedTableColumn(tr("month", language), width: 125) { Text($0.values["Monat Name"] ?? "") }
            ])
        case .week:
            var result = commonSummaryColumns(prefix: [
                ThemedTableColumn(tr("year", language), width: 90) { Text($0.values["Jahr"] ?? "") },
                ThemedTableColumn(tr("week_short", language), width: 70) { Text($0.values["KW"] ?? "") }
            ])
            result.append(ThemedTableColumn(tr("flag", language), width: 120) { Text($0.values["Auffälligkeit"] ?? "") })
            return result
        default:
            return []
        }
    }

    private func commonSummaryColumns(prefix: [ThemedTableColumn<SummaryRow>]) -> [ThemedTableColumn<SummaryRow>] {
        prefix + [
            ThemedTableColumn(tr("days", language), width: 70) { Text($0.values["Tage"] ?? "") },
            ThemedTableColumn(tr("incomplete_days", language), width: 145) { Text($0.values["Unvollständige Tage"] ?? "") },
            ThemedTableColumn(tr("urine_total", language), width: 145) { Text($0.values["● Urin Gesamt ml"] ?? "").monospacedDigit() },
            ThemedTableColumn(tr("urine_average", language), width: 145) { Text($0.values["● Urin Ø ml/Tag"] ?? "").monospacedDigit() },
            ThemedTableColumn(tr("urine_count", language), width: 120) { Text($0.values["● Urin Anzahl"] ?? "").monospacedDigit() },
            ThemedTableColumn(tr("water_total", language), width: 155) { Text($0.values["💧 Wasser Gesamt ml"] ?? "").monospacedDigit() }
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
                ThemedTableColumn(tr("flag", language), width: 140) { day in
                    Text(tr(!day.isCompleteMeasurementDay ? "incomplete" : day.urineTotal < 700 ? "low" : "normal", language))
                },
                ThemedTableColumn(tr("hints", language), width: 470) { day in
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
    let theme: ThemeStyle

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
                        .stroke(theme.accent.opacity(theme.isHighContrast ? 0.70 : 0.16), lineWidth: theme.isHighContrast ? 1.5 : 1)
                )
        } else {
            content
                .padding(14)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(theme.accent.opacity(theme.isHighContrast ? 0.70 : 0.24), lineWidth: 1)
                )
        }
    }
}
