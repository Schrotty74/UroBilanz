import SwiftUI

enum AppSection: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case year = "Jahr"
    case month = "Monat"
    case week = "Woche"
    case day = "Tag"
    case notes = "Notizen"

    var id: String { rawValue }

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .dashboard: tr("dashboard", language)
        case .year: tr("year", language)
        case .month: tr("month", language)
        case .week: tr("week", language)
        case .day: tr("day", language)
        case .notes: tr("notes", language)
        }
    }

    var symbol: String {
        switch self {
        case .dashboard: "chart.xyaxis.line"
        case .year: "calendar"
        case .month: "calendar.badge.clock"
        case .week: "calendar.day.timeline.left"
        case .day: "list.bullet.rectangle"
        case .notes: "info.circle"
        }
    }
}
