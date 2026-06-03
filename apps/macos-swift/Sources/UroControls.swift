import SwiftUI
import AppKit

struct ToolbarStrip: View {
    @EnvironmentObject private var model: UrinModel
    @Environment(\.appTheme) private var theme
    @Binding var selection: AppSection
    @Binding var showsEntrySheet: Bool
    @Binding var themeRaw: String
    @Binding var languageRaw: String
    @Environment(\.appLanguage) private var language

    var body: some View {
        HStack(spacing: 12) {
            AppMark(size: 54)
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
            ThemeMenu(themeRaw: $themeRaw)
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
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .background(.bar)
    }
}

struct ThemeMenu: View {
    @Environment(\.appTheme) private var theme
    @Binding var themeRaw: String
    @Environment(\.appLanguage) private var language

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
                        Label(option.title(language), systemImage: "checkmark")
                    } else {
                        Text(option.title(language))
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(selectedTheme.title(language))
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
                        .stroke(theme.controlBorder, lineWidth: theme == .highContrast ? 1.5 : 1)
                }
        }
        .help(tr("language", language))
        .buttonStyle(.plain)
        .menuStyle(.borderlessButton)
    }
}
