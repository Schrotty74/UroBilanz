import SwiftUI
import AppKit

struct ToolbarStrip: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appTheme) private var theme
    @Binding var selection: AppSection
    @Binding var showsEntrySheet: Bool
    @Binding var themeRaw: String
    @Binding var languageRaw: String
    let customThemes: [CustomThemeDefinition]
    let importTheme: () -> Void
    let exportTheme: () -> Void
    let deleteTheme: () -> Void
    let reportBug: () -> Void
    @Environment(\.appLanguage) private var language

    var body: some View {
        HStack(spacing: 12) {
            AppMark(size: 54)
            GitHubMark(size: 54)
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
            ThemeMenu(themeRaw: $themeRaw, customThemes: customThemes, importTheme: importTheme, exportTheme: exportTheme, deleteTheme: deleteTheme)
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
            Button(action: reportBug) {
                Image(systemName: "exclamationmark.bubble")
            }
            .accessibilityLabel(tr("report_bug", language))
            .help(tr("report_bug", language))
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .background(.bar)
    }
}

struct GitHubMark: View {
    @Environment(\.appTheme) private var theme
    let size: CGFloat

    var body: some View {
        Button {
            if let url = URL(string: "https://github.com/Schrotty74/UroBilanz") {
                NSWorkspace.shared.open(url)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                            .stroke(theme.controlBorder.opacity(0.7), lineWidth: 1)
                    }
                Image(nsImage: githubImage)
                    .resizable()
                    .scaledToFit()
                    .padding(size * 0.13)
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
        .help("UroBilanz auf GitHub")
        .accessibilityLabel("UroBilanz auf GitHub")
    }

    private var githubImage: NSImage {
        let fileName = theme.isDark ? "github-invertocat-white.svg" : "github-invertocat-black.svg"
        return NSImage(contentsOfFile: "\(Bundle.main.resourcePath ?? "")/\(fileName)") ?? NSImage()
    }
}

struct ThemeMenu: View {
    @Environment(\.appTheme) private var theme
    @Binding var themeRaw: String
    let customThemes: [CustomThemeDefinition]
    let importTheme: () -> Void
    let exportTheme: () -> Void
    let deleteTheme: () -> Void
    @Environment(\.appLanguage) private var language

    private var selectedTitle: String {
        if let builtIn = AppTheme(rawValue: themeRaw) {
            return builtIn.title(language)
        }
        if let custom = customThemes.first(where: { $0.id == themeRaw }) {
            return custom.title(language)
        }
        return AppTheme.classicDark.title(language)
    }

    var body: some View {
        Menu {
            ForEach(AppTheme.allCases) { option in
                Button {
                    themeRaw = option.rawValue
                } label: {
                    themeOptionLabel(option.title(language), isSelected: option.rawValue == themeRaw)
                }
            }
            if !customThemes.isEmpty {
                Divider()
                ForEach(customThemes) { option in
                    Button {
                        themeRaw = option.id
                    } label: {
                        themeOptionLabel(option.title(language), isSelected: option.id == themeRaw)
                    }
                }
            }
            Divider()
            Button(tr("import_theme", language), systemImage: "square.and.arrow.down") {
                importTheme()
            }
            Button(tr("export_theme", language), systemImage: "square.and.arrow.up") {
                exportTheme()
            }
            Button(tr("delete_theme", language), systemImage: "trash", role: .destructive) {
                deleteTheme()
            }
            .disabled(customThemes.first(where: { $0.id == themeRaw }) == nil)
        } label: {
            HStack(spacing: 8) {
                Text(selectedTitle)
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
                    .stroke(theme.controlBorder, lineWidth: theme.isHighContrast ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
        .menuStyle(.borderlessButton)
    }

    @ViewBuilder
    private func themeOptionLabel(_ title: String, isSelected: Bool) -> some View {
        HStack(spacing: 8) {
            if isSelected {
                Image(systemName: "checkmark")
                    .frame(width: 16)
            } else {
                Color.clear
                    .frame(width: 16, height: 1)
            }
            Text(title)
        }
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
                        .stroke(theme.controlBorder, lineWidth: theme.isHighContrast ? 1.5 : 1)
                }
        }
        .help(tr("language", language))
        .buttonStyle(.plain)
        .menuStyle(.borderlessButton)
    }
}
