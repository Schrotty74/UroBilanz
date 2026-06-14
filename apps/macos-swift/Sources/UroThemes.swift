import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case classicLight = "classic-light"
    case classicDark = "classic-dark"
    case violetNight = "violet-night"
    case liquidDark = "liquid-dark"
    case medicalLight = "medical-light"
    case highContrast = "high-contrast"
    case summer = "summer"
    case creamSage = "cream-sage"

    var id: String { rawValue }

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .classicLight: language == .de ? "Classic Hell" : "Classic Light"
        case .classicDark: language == .de ? "Classic Dunkel" : "Classic Dark"
        case .violetNight: "Violet Night"
        case .liquidDark: "Liquid Dark"
        case .medicalLight: "Medical Light"
        case .highContrast: "High Contrast"
        case .summer: language == .de ? "Sommer Look" : "Summer Look"
        case .creamSage: language == .de ? "Creme Salbei" : "Cream Sage"
        }
    }

    var preferredScheme: ColorScheme {
        switch self {
        case .classicDark, .violetNight, .liquidDark, .highContrast: .dark
        case .classicLight, .medicalLight, .summer, .creamSage: .light
        }
    }

    var isDark: Bool { preferredScheme == .dark }

    var accent: Color {
        switch self {
        case .classicLight, .classicDark: .yellow
        case .violetNight: Color(red: 1.00, green: 0.47, blue: 0.78)
        case .liquidDark: Color(red: 1.00, green: 0.82, blue: 0.30)
        case .medicalLight: Color(red: 0.18, green: 0.53, blue: 0.57)
        case .highContrast: .yellow
        case .summer: Color(red: 1.00, green: 0.70, blue: 0.18)
        case .creamSage: Color(red: 0.47, green: 0.68, blue: 0.46)
        }
    }

    var urineColor: Color {
        switch self {
        case .violetNight: Color(red: 0.95, green: 0.98, blue: 0.55)
        case .highContrast: .yellow
        case .summer: Color(red: 0.88, green: 0.55, blue: 0.02)
        case .creamSage: Color(red: 0.78, green: 0.50, blue: 0.08)
        default: Color(red: 1.00, green: 0.82, blue: 0.25)
        }
    }

    var waterColor: Color {
        switch self {
        case .violetNight: Color(red: 0.55, green: 0.91, blue: 0.99)
        case .highContrast: .cyan
        case .summer: Color(red: 0.13, green: 0.65, blue: 0.75)
        case .creamSage: Color(red: 0.18, green: 0.56, blue: 0.62)
        default: Color(red: 0.16, green: 0.58, blue: 1.00)
        }
    }

    var background: [Color] {
        switch self {
        case .classicLight:
            [Color(nsColor: .windowBackgroundColor), .teal.opacity(0.10), .yellow.opacity(0.06)]
        case .classicDark:
            [Color(red: 0.05, green: 0.08, blue: 0.10), .teal.opacity(0.18), .yellow.opacity(0.08)]
        case .violetNight:
            [Color(red: 0.11, green: 0.11, blue: 0.16), Color(red: 0.18, green: 0.16, blue: 0.27), Color(red: 0.36, green: 0.22, blue: 0.46).opacity(0.55)]
        case .liquidDark:
            [Color(red: 0.04, green: 0.07, blue: 0.09), Color(red: 0.06, green: 0.20, blue: 0.23), Color(red: 0.12, green: 0.25, blue: 0.29).opacity(0.55)]
        case .medicalLight:
            [Color(red: 0.96, green: 0.99, blue: 0.99), Color(red: 0.87, green: 0.95, blue: 0.96), Color.white]
        case .highContrast:
            [.black, .black, .black]
        case .summer:
            [Color(red: 1.00, green: 0.95, blue: 0.78), Color(red: 1.00, green: 0.83, blue: 0.54), Color(red: 0.76, green: 0.94, blue: 0.88).opacity(0.55)]
        case .creamSage:
            [Color(red: 0.97, green: 0.94, blue: 0.88), Color(red: 0.93, green: 0.89, blue: 0.81), Color(red: 0.80, green: 0.88, blue: 0.76).opacity(0.50)]
        }
    }

    var controlBackground: Color {
        switch self {
        case .classicLight, .medicalLight, .creamSage:
            Color.white.opacity(0.86)
        case .summer:
            Color(red: 1.00, green: 0.91, blue: 0.70).opacity(0.88)
        case .highContrast:
            .black
        case .classicDark, .violetNight, .liquidDark:
            Color.black.opacity(0.38)
        }
    }

    var controlForeground: Color {
        switch self {
        case .classicLight, .medicalLight, .summer:
            Color(red: 0.10, green: 0.14, blue: 0.16)
        case .creamSage:
            Color(red: 0.20, green: 0.16, blue: 0.12)
        case .highContrast:
            .white
        case .classicDark, .violetNight, .liquidDark:
            .white
        }
    }

    var controlBorder: Color {
        switch self {
        case .highContrast:
            .white
        default:
            accent.opacity(isDark ? 0.30 : 0.22)
        }
    }

    var tableBackground: Color {
        switch self {
        case .classicLight, .medicalLight:
            Color.white.opacity(0.72)
        case .summer:
            Color(red: 1.00, green: 0.94, blue: 0.78).opacity(0.78)
        case .creamSage:
            Color(red: 0.98, green: 0.95, blue: 0.88).opacity(0.82)
        case .highContrast:
            .black
        case .classicDark:
            Color(red: 0.07, green: 0.10, blue: 0.12).opacity(0.76)
        case .violetNight:
            Color(red: 0.16, green: 0.16, blue: 0.22).opacity(0.78)
        case .liquidDark:
            Color(red: 0.08, green: 0.13, blue: 0.15).opacity(0.70)
        }
    }

    var tableRow: Color {
        switch self {
        case .classicLight, .medicalLight:
            Color.white.opacity(0.45)
        case .summer:
            Color(red: 1.00, green: 0.88, blue: 0.62).opacity(0.36)
        case .creamSage:
            Color(red: 0.91, green: 0.87, blue: 0.78).opacity(0.48)
        case .highContrast:
            Color.white.opacity(0.08)
        case .classicDark:
            Color.white.opacity(0.06)
        case .violetNight:
            Color(red: 0.27, green: 0.28, blue: 0.35).opacity(0.42)
        case .liquidDark:
            Color.white.opacity(0.07)
        }
    }

    var style: ThemeStyle {
        ThemeStyle(
            id: rawValue,
            preferredScheme: preferredScheme,
            isHighContrast: self == .highContrast,
            accent: accent,
            urineColor: urineColor,
            waterColor: waterColor,
            background: background,
            controlBackground: controlBackground,
            controlForeground: controlForeground,
            controlBorder: controlBorder,
            tableBackground: tableBackground,
            tableRow: tableRow
        )
    }

    func exportCopy(existingIds: Set<String>) throws -> CustomThemeDefinition {
        let baseId = "\(rawValue)-custom"
        let theme = CustomThemeDefinition(
            format: "urobilanz-theme",
            version: 1,
            id: Self.uniqueCustomId(baseId: baseId, existingIds: existingIds),
            name: CustomThemeDefinition.ThemeName(
                de: "\(title(.de)) Kopie",
                en: "\(title(.en)) Copy"
            ),
            mode: isDark ? "dark" : "light",
            colors: exportColors,
            effects: CustomThemeDefinition.ThemeEffects(
                glassOpacity: 0.86,
                glassBorderOpacity: 0.30,
                shadowOpacity: isDark ? 0.28 : 0.16
            )
        )
        return try theme.validated()
    }

    private static func uniqueCustomId(baseId: String, existingIds: Set<String>) -> String {
        var id = baseId
        var index = 2
        while CustomThemeDefinition.builtInIds.contains(id) || existingIds.contains(id) {
            id = "\(baseId)-\(index)"
            index += 1
        }
        return id
    }

    private var exportColors: CustomThemeDefinition.ThemeColors {
        switch self {
        case .classicLight:
            Self.colors(
                text: "#172024", mutedText: "#60706D", background: "#F6FBFA", backgroundAlt: "#EAF5F2",
                panel: "#FFFFFF", panelSoft: "#F2F8F6", border: "#C8D8D5", accent: "#A8C957",
                accentText: "#172024", urine: "#E8B923", urineSoft: "#F7E3A4", water: "#2D91E8",
                waterSoft: "#B9DBF8", low: "#F8D7DA", rowOdd: "#F4FAF8", rowEven: "#FFFFFF",
                chartUrine: "#E8B923", chartWater: "#2D91E8"
            )
        case .classicDark:
            Self.colors(
                text: "#F6FBFA", mutedText: "#C9D4D2", background: "#0E171A", backgroundAlt: "#172326",
                panel: "#142024", panelSoft: "#1B292C", border: "#3E5E59", accent: "#A8C957",
                accentText: "#101614", urine: "#F6C84F", urineSoft: "#51451D", water: "#4AA3FF",
                waterSoft: "#173A52", low: "#5C252B", rowOdd: "#192529", rowEven: "#101A1D",
                chartUrine: "#F6C84F", chartWater: "#4AA3FF"
            )
        case .violetNight:
            Self.colors(
                text: "#FFF7FF", mutedText: "#D8CBE3", background: "#1C1B29", backgroundAlt: "#2E2945",
                panel: "#292638", panelSoft: "#3B344F", border: "#70588A", accent: "#FF78C7",
                accentText: "#221527", urine: "#F3FA8C", urineSoft: "#4D4525", water: "#8DE9FC",
                waterSoft: "#25475B", low: "#603044", rowOdd: "#363647", rowEven: "#282738",
                chartUrine: "#F3FA8C", chartWater: "#8DE9FC"
            )
        case .liquidDark:
            Self.colors(
                text: "#EFFAF9", mutedText: "#B7D2D0", background: "#0B1316", backgroundAlt: "#102F36",
                panel: "#122328", panelSoft: "#1A383F", border: "#3E747C", accent: "#FFD24C",
                accentText: "#142024", urine: "#FFD24C", urineSoft: "#4C421C", water: "#41D1C7",
                waterSoft: "#193E45", low: "#5B2530", rowOdd: "#172B30", rowEven: "#0F1C20",
                chartUrine: "#FFD24C", chartWater: "#41D1C7"
            )
        case .medicalLight:
            Self.colors(
                text: "#183033", mutedText: "#5C7376", background: "#F6FCFC", backgroundAlt: "#DDEFF1",
                panel: "#FFFFFF", panelSoft: "#ECF7F8", border: "#B8D4D8", accent: "#2E8792",
                accentText: "#FFFFFF", urine: "#E8B923", urineSoft: "#F5E6AE", water: "#227DC6",
                waterSoft: "#C2DFF1", low: "#F5D5D8", rowOdd: "#F0F8F9", rowEven: "#FFFFFF",
                chartUrine: "#E8B923", chartWater: "#227DC6"
            )
        case .highContrast:
            Self.colors(
                text: "#FFFFFF", mutedText: "#FFFFFF", background: "#000000", backgroundAlt: "#000000",
                panel: "#000000", panelSoft: "#111111", border: "#FFFFFF", accent: "#FFFF00",
                accentText: "#000000", urine: "#FFFF00", urineSoft: "#333300", water: "#00FFFF",
                waterSoft: "#003333", low: "#FF4D4D", rowOdd: "#141414", rowEven: "#000000",
                chartUrine: "#FFFF00", chartWater: "#00FFFF"
            )
        case .summer:
            Self.colors(
                text: "#2A2618", mutedText: "#74664A", background: "#FFF3C8", backgroundAlt: "#FFD48A",
                panel: "#FFF0C2", panelSoft: "#FFE19E", border: "#D99635", accent: "#FFB32E",
                accentText: "#2A1A0A", urine: "#E08C04", urineSoft: "#F8DDA7", water: "#21A6BF",
                waterSoft: "#BCE7E7", low: "#F7C6B8", rowOdd: "#FFE1A0", rowEven: "#FFF0C2",
                chartUrine: "#E08C04", chartWater: "#21A6BF"
            )
        case .creamSage:
            Self.colors(
                text: "#34281F", mutedText: "#766E5F", background: "#F8F0E2", backgroundAlt: "#E8E0CE",
                panel: "#FDF4E6", panelSoft: "#E8DECB", border: "#B6C3A7", accent: "#78AD75",
                accentText: "#172015", urine: "#C77F14", urineSoft: "#ECD7AF", water: "#2E8F9E",
                waterSoft: "#C2DCD5", low: "#F2CFCB", rowOdd: "#E8DECB", rowEven: "#FDF4E6",
                chartUrine: "#C77F14", chartWater: "#2E8F9E"
            )
        }
    }

    private static func colors(
        text: String, mutedText: String, background: String, backgroundAlt: String,
        panel: String, panelSoft: String, border: String, accent: String,
        accentText: String, urine: String, urineSoft: String, water: String,
        waterSoft: String, low: String, rowOdd: String, rowEven: String,
        chartUrine: String, chartWater: String
    ) -> CustomThemeDefinition.ThemeColors {
        CustomThemeDefinition.ThemeColors(
            text: text,
            mutedText: mutedText,
            background: background,
            backgroundAlt: backgroundAlt,
            panel: panel,
            panelSoft: panelSoft,
            border: border,
            accent: accent,
            accentText: accentText,
            urine: urine,
            urineSoft: urineSoft,
            water: water,
            waterSoft: waterSoft,
            low: low,
            rowOdd: rowOdd,
            rowEven: rowEven,
            chartUrine: chartUrine,
            chartWater: chartWater
        )
    }
}

struct ThemeStyle {
    let id: String
    let preferredScheme: ColorScheme
    let isHighContrast: Bool
    let accent: Color
    let urineColor: Color
    let waterColor: Color
    let background: [Color]
    let controlBackground: Color
    let controlForeground: Color
    let controlBorder: Color
    let tableBackground: Color
    let tableRow: Color

    var isDark: Bool { preferredScheme == .dark }

    static func resolve(id: String, customThemes: [CustomThemeDefinition]) -> ThemeStyle {
        if let builtIn = AppTheme(rawValue: id) {
            return builtIn.style
        }
        if let custom = customThemes.first(where: { $0.id == id }) {
            return custom.style
        }
        return AppTheme.classicDark.style
    }
}

struct CustomThemeDefinition: Codable, Identifiable, Equatable {
    struct ThemeName: Codable, Equatable {
        var de: String?
        var en: String?
    }

    struct ThemeColors: Codable, Equatable {
        var text: String
        var mutedText: String?
        var background: String
        var backgroundAlt: String?
        var panel: String
        var panelSoft: String?
        var border: String?
        var accent: String
        var accentText: String?
        var urine: String
        var urineSoft: String?
        var water: String
        var waterSoft: String?
        var low: String?
        var rowOdd: String?
        var rowEven: String?
        var chartUrine: String?
        var chartWater: String?
    }

    struct ThemeEffects: Codable, Equatable {
        var glassOpacity: Double?
        var glassBorderOpacity: Double?
        var shadowOpacity: Double?
    }

    var format: String
    var version: Int
    var id: String
    var name: ThemeName
    var mode: String
    var colors: ThemeColors
    var effects: ThemeEffects?

    static let builtInIds = Set(AppTheme.allCases.map(\.rawValue))

    func title(_ language: AppLanguage) -> String {
        switch language {
        case .de: name.de ?? name.en ?? id
        case .en: name.en ?? name.de ?? id
        }
    }

    var style: ThemeStyle {
        let isDark = mode == "dark"
        let panelOpacity = effects?.glassOpacity ?? 0.86
        let borderOpacity = effects?.glassBorderOpacity ?? 0.30
        let accent = Color(hex: colors.accent) ?? .yellow
        let text = Color(hex: colors.text) ?? (isDark ? .white : .black)
        let background = Color(hex: colors.background) ?? (isDark ? .black : .white)
        let backgroundAlt = Color(hex: colors.backgroundAlt) ?? Color(hex: colors.panelSoft) ?? background
        let panel = Color(hex: colors.panel) ?? background
        let panelSoft = Color(hex: colors.panelSoft) ?? panel
        return ThemeStyle(
            id: id,
            preferredScheme: isDark ? .dark : .light,
            isHighContrast: false,
            accent: accent,
            urineColor: Color(hex: colors.chartUrine) ?? Color(hex: colors.urine) ?? .yellow,
            waterColor: Color(hex: colors.chartWater) ?? Color(hex: colors.water) ?? .blue,
            background: [background, backgroundAlt, panelSoft.opacity(0.55)],
            controlBackground: panel.opacity(panelOpacity),
            controlForeground: text,
            controlBorder: Color(hex: colors.border) ?? accent.opacity(borderOpacity),
            tableBackground: panel.opacity(max(0.40, panelOpacity - 0.08)),
            tableRow: (Color(hex: colors.rowOdd) ?? panelSoft).opacity(0.46)
        )
    }

    func validated() throws -> CustomThemeDefinition {
        guard format == "urobilanz-theme" else { throw ThemeImportError.invalidFormat }
        guard version == 1 else { throw ThemeImportError.invalidVersion }
        guard id.range(of: #"^[a-z0-9][a-z0-9-]*$"#, options: .regularExpression) != nil else { throw ThemeImportError.invalidId }
        guard !Self.builtInIds.contains(id) else { throw ThemeImportError.builtInId }
        guard mode == "light" || mode == "dark" else { throw ThemeImportError.invalidMode }
        guard !(name.de ?? name.en ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw ThemeImportError.missingName }
        let colorValues = [
            colors.text, colors.background, colors.panel, colors.accent, colors.urine, colors.water,
            colors.mutedText, colors.backgroundAlt, colors.panelSoft, colors.border, colors.accentText,
            colors.urineSoft, colors.waterSoft, colors.low, colors.rowOdd, colors.rowEven,
            colors.chartUrine, colors.chartWater,
        ].compactMap { $0 }
        guard colorValues.allSatisfy({ Color.isHexColor($0) }) else { throw ThemeImportError.invalidColor }
        let effectValues = [effects?.glassOpacity, effects?.glassBorderOpacity, effects?.shadowOpacity].compactMap { $0 }
        guard effectValues.allSatisfy({ $0 >= 0 && $0 <= 1 }) else { throw ThemeImportError.invalidEffect }
        return self
    }

    static func decodeList(_ raw: String) -> [CustomThemeDefinition] {
        guard let data = raw.data(using: .utf8),
              let themes = try? JSONDecoder().decode([CustomThemeDefinition].self, from: data) else {
            return []
        }
        return themes.compactMap { try? $0.validated() }
    }

    static func encodeList(_ themes: [CustomThemeDefinition]) -> String {
        guard let data = try? JSONEncoder().encode(themes),
              let raw = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return raw
    }
}

enum ThemeImportError: LocalizedError {
    case invalidFormat
    case invalidVersion
    case invalidId
    case builtInId
    case invalidMode
    case missingName
    case invalidColor
    case invalidEffect

    var errorDescription: String? {
        switch self {
        case .invalidFormat: "Theme-Format wird nicht erkannt."
        case .invalidVersion: "Theme-Version wird nicht unterstuetzt."
        case .invalidId: "Theme-ID darf nur Kleinbuchstaben, Zahlen und Bindestriche enthalten."
        case .builtInId: "Eingebaute Themes duerfen nicht ueberschrieben werden."
        case .invalidMode: "Theme-Modus muss light oder dark sein."
        case .missingName: "Theme-Name fehlt."
        case .invalidColor: "Eine Theme-Farbe fehlt oder ist ungueltig."
        case .invalidEffect: "Theme-Effekte muessen zwischen 0 und 1 liegen."
        }
    }
}

extension Color {
    init?(hex: String?) {
        guard let hex else { return nil }
        let clean = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isHexColor(clean) else { return nil }
        let value = String(clean.dropFirst())
        guard let rgb = Int(value, radix: 16) else { return nil }
        self.init(
            red: Double((rgb >> 16) & 0xff) / 255,
            green: Double((rgb >> 8) & 0xff) / 255,
            blue: Double(rgb & 0xff) / 255
        )
    }

    static func isHexColor(_ value: String) -> Bool {
        value.range(of: #"^#[0-9A-Fa-f]{6}$"#, options: .regularExpression) != nil
    }
}

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: ThemeStyle = AppTheme.classicDark.style
}

extension EnvironmentValues {
    var appTheme: ThemeStyle {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

