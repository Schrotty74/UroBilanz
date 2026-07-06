import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct UrinprotokollSwiftUIApp: App {
    @StateObject private var model = UrinModel()
    @StateObject private var updateChecker = UpdateChecker()

    init() {
        if let url = Bundle.main.url(forResource: "urobilanz-app-icon", withExtension: "png"),
           let image = NSImage(contentsOf: url) {
            NSApplication.shared.applicationIconImage = image
        }
    }

    var body: some Scene {
        WindowGroup("UroBilanz") {
            ContentView()
                .environmentObject(model)
                .environmentObject(updateChecker)
                .frame(minWidth: 1120, minHeight: 760)
                .task {
                    updateChecker.scheduleAutomaticCheck()
                }
        }
        .commands {
            AboutCommands()
            CommandGroup(replacing: .newItem) {
                Button("\(tr("load_csv", model.language))...") { model.openCSV() }
                    .keyboardShortcut("o")
            }
        }
        Window("UroBilanz", id: "about") {
            AboutWindowRoot()
        }
        .defaultSize(width: 520, height: 450)
        .windowResizability(.contentSize)
        .commands {
            AboutCommands()
        }
        Settings {
            SettingsRoot()
                .environmentObject(updateChecker)
        }
    }
}

private struct AboutCommands: Commands {
    @Environment(\.openWindow) private var openWindow

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button(tr("about_menu", .systemDefault)) {
                openWindow(id: "about")
            }
        }
    }
}

private struct AboutWindowRoot: View {
    @AppStorage("uroBilanzTheme") private var themeRaw = AppTheme.classicDark.rawValue
    @AppStorage("uroBilanzCustomThemes") private var customThemesRaw = "[]"

    var body: some View {
        let theme = ThemeStyle.resolve(
            id: themeRaw,
            customThemes: CustomThemeDefinition.decodeList(customThemesRaw)
        )
        AboutUroBilanzView(language: .systemDefault)
            .environment(\.appTheme, theme)
            .preferredColorScheme(theme.preferredScheme)
            .tint(theme.accent)
    }
}

private struct SettingsRoot: View {
    @EnvironmentObject private var updateChecker: UpdateChecker
    @AppStorage("uroBilanzTheme") private var themeRaw = AppTheme.classicDark.rawValue
    @AppStorage("uroBilanzCustomThemes") private var customThemesRaw = "[]"
    @AppStorage("uroBilanzLanguage") private var languageRaw = AppLanguage.systemDefault.rawValue

    var body: some View {
        let language = AppLanguage(rawValue: languageRaw) ?? .systemDefault
        let theme = ThemeStyle.resolve(
            id: themeRaw,
            customThemes: CustomThemeDefinition.decodeList(customThemesRaw)
        )

        VStack(alignment: .leading, spacing: 18) {
            Text(tr("settings", language))
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 10) {
                Text(tr("updates", language))
                    .font(.headline)
                Text(updateStatusText(language))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    Button(tr("check_for_updates", language)) {
                        Task { await updateChecker.checkForUpdates(manual: true) }
                    }
                    .disabled(updateChecker.isChecking)

                    if case .available = updateChecker.state {
                        Button(tr("open_release", language)) {
                            updateChecker.openReleasePage()
                        }
                    }
                }
            }
        }
        .padding(24)
        .frame(width: 430, alignment: .leading)
        .background(AppBackground(theme: theme))
        .environment(\.appTheme, theme)
        .preferredColorScheme(theme.preferredScheme)
        .tint(theme.accent)
    }

    private func updateStatusText(_ language: AppLanguage) -> String {
        switch updateChecker.state {
        case .idle:
            return tr("update_idle", language)
        case .checking:
            return tr("update_checking", language)
        case .upToDate:
            return tr("update_up_to_date", language)
        case let .available(tag, _):
            return tr("update_available", language, replacements: ["version": tag])
        case .failed:
            return tr("update_failed", language)
        }
    }
}

private struct AboutUroBilanzView: View {
    @Environment(\.appTheme) private var theme
    let language: AppLanguage

    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
    }

    private var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
    }

    private var versionText: String { "Version \(version) (\(build))" }

    var body: some View {
        VStack(spacing: 18) {
            AppMark(size: 104)

            VStack(spacing: 5) {
                Text("UroBilanz")
                    .font(.title.bold())
                Text(versionText)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            Text(tr("about_description", language))
                .multilineTextAlignment(.center)
                .foregroundStyle(theme.controlForeground)
                .frame(maxWidth: 410)

            Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 10) {
                aboutRow(tr("about_developer", language)) {
                    Text(tr("about_developer_value", language))
                }
                aboutRow(tr("about_license", language)) {
                    if let url = URL(string: "https://github.com/Schrotty74/UroBilanz/blob/main/LICENSE") {
                        Link("GNU General Public License v3", destination: url)
                    }
                }
                aboutRow(tr("about_github", language)) {
                    if let url = URL(string: "https://github.com/Schrotty74/UroBilanz") {
                        Link("github.com/Schrotty74/UroBilanz", destination: url)
                    }
                }
                aboutRow(tr("about_contact", language)) {
                    if let url = URL(string: "mailto:urobilanz@mailbox.org") {
                        Link("urobilanz@mailbox.org", destination: url)
                    }
                }
            }
            .font(.callout)
        }
        .padding(30)
        .frame(width: 520)
        .background(AppBackground(theme: theme))
    }

    @ViewBuilder
    private func aboutRow<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        GridRow {
            Text(title)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            content()
                .foregroundStyle(theme.controlForeground)
                .textSelection(.enabled)
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
    @EnvironmentObject private var updateChecker: UpdateChecker
    @AppStorage("uroBilanzTheme") private var themeRaw = AppTheme.classicDark.rawValue
    @AppStorage("uroBilanzCustomThemes") private var customThemesRaw = "[]"
    @AppStorage("uroBilanzLanguage") private var languageRaw = AppLanguage.systemDefault.rawValue
    @State private var selection: AppSection = .dashboard
    @State private var showsEntrySheet = false
    @State private var showsThemeImporter = false
    @State private var showsBugReport = false
    @State private var showsMedicalReport = false
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
                    deleteTheme: prepareDeleteSelectedTheme,
                    medicalReport: { showsMedicalReport = true },
                    reportBug: { showsBugReport = true }
                )
                updateBanner(language: language)
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
        .sheet(isPresented: $showsBugReport) {
            BugReportSheet(
                selection: selection,
                themeName: themeRaw,
                language: language
            )
            .environment(\.appTheme, theme)
        }
        .sheet(isPresented: $showsMedicalReport) {
            MedicalReportSheet()
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
        .onDisappear {
            updateChecker.cancelAutomaticCheck()
        }
    }

    @ViewBuilder
    private func updateBanner(language: AppLanguage) -> some View {
        if case let .available(tag, _) = updateChecker.state, !updateChecker.isBannerDismissed {
            HStack(spacing: 12) {
                Image(systemName: "arrow.down.circle")
                Text(tr("update_banner", language, replacements: ["version": tag]))
                    .font(.callout.weight(.semibold))
                Spacer()
                Button(tr("open_release", language)) {
                    updateChecker.openReleasePage()
                }
                Button {
                    updateChecker.dismissBanner()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tr("close", language))
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 10)
            .background(.bar)
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

struct BugReportSheet: View {
    let selection: AppSection
    let themeName: String
    let language: AppLanguage
    @Environment(\.dismiss) private var dismiss
    @State private var description = ""
    @State private var steps = ""
    @State private var expected = ""
    @State private var reportText = ""

    private let supportEmail = "urobilanz@mailbox.org"

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(tr("bug_report_title", language))
                .font(.title2.weight(.bold))
            Text(tr("bug_report_privacy", language))
                .foregroundStyle(.secondary)
            reportField(tr("bug_description", language), text: $description, height: 72)
            reportField(tr("bug_steps", language), text: $steps, height: 72)
            reportField(tr("bug_expected", language), text: $expected, height: 58)
            VStack(alignment: .leading, spacing: 6) {
                Text(tr("bug_report_preview", language))
                    .font(.headline)
                TextEditor(text: $reportText)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 220)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary.opacity(0.35), lineWidth: 1)
                    }
            }
            HStack {
                Spacer()
                Button(tr("close", language)) { dismiss() }
                Button(tr("save_report", language), action: saveReport)
                Button(tr("prepare_email", language), action: prepareEmail)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(22)
        .frame(width: 720)
        .frame(minHeight: 680)
        .onAppear(perform: refreshReport)
        .onChange(of: description) { _, _ in refreshReport() }
        .onChange(of: steps) { _, _ in refreshReport() }
        .onChange(of: expected) { _, _ in refreshReport() }
    }

    private func reportField(_ title: String, text: Binding<String>, height: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            TextEditor(text: text)
                .frame(height: height)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.secondary.opacity(0.35), lineWidth: 1)
                }
        }
    }

    private func refreshReport() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unbekannt"
        reportText = """
        UroBilanz Fehlerbericht

        Version: \(version)
        App: SwiftUI macOS
        Ansicht: \(selection.title(language))
        Sprache: \(language.label)
        Theme: \(themeName)
        Betriebssystem: \(ProcessInfo.processInfo.operatingSystemVersionString)
        GitHub: https://github.com/Schrotty74/UroBilanz

        Was ist passiert?
        \(description.isEmpty ? "-" : description)

        Schritte zum Nachstellen
        \(steps.isEmpty ? "-" : steps)

        Erwartetes Verhalten
        \(expected.isEmpty ? "-" : expected)

        Datenschutz: Keine CSV-Werte, Hinweise oder Gesundheitsdaten wurden automatisch hinzugefügt.
        """
    }

    private func saveReport() {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "urobilanz-fehlerbericht.txt"
        panel.allowedContentTypes = [.plainText]
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            try? (reportText + "\n").write(to: url, atomically: true, encoding: .utf8)
        }
    }

    private func prepareEmail() {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = supportEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: "UroBilanz Fehlerbericht"),
            URLQueryItem(name: "body", value: reportText),
        ]
        if let url = components.url {
            NSWorkspace.shared.open(url)
        }
    }
}

struct AppMark: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.appTheme) private var theme
    let size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                        .stroke(.white.opacity(isDarkAppearance ? 0.18 : 0.30), lineWidth: 1)
                }
            Image(nsImage: NSImage(contentsOfFile: "\(Bundle.main.resourcePath ?? "")/urobilanz-app-icon.png") ?? NSImage())
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
