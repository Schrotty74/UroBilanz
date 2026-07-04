import Foundation
import AppKit

@MainActor
final class UpdateChecker: ObservableObject {
    enum State: Equatable {
        case idle
        case checking
        case upToDate
        case available(tag: String, url: URL)
        case failed
    }

    @Published private(set) var state: State = .idle
    @Published var isBannerDismissed = false

    private let defaults = UserDefaults.standard
    private let latestReleaseURL = URL(string: "https://api.github.com/repos/Schrotty74/UroBilanz/releases/latest")
    private let oneDay: TimeInterval = 24 * 60 * 60
    private let lastCheckKey = "uroBilanzUpdateLastCheck"
    private let cachedTagKey = "uroBilanzUpdateLatestTag"
    private let cachedURLKey = "uroBilanzUpdateLatestURL"

    var currentVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }

    var isChecking: Bool {
        if case .checking = state { return true }
        return false
    }

    func scheduleAutomaticCheck() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await checkForUpdates(manual: false)
        }
    }

    func checkForUpdates(manual: Bool) async {
        if !manual, !shouldRunAutomaticCheck() {
            loadCachedResult()
            return
        }

        state = .checking
        do {
            guard let latestReleaseURL else { throw URLError(.badURL) }
            var request = URLRequest(url: latestReleaseURL)
            request.setValue("UroBilanz/\(currentVersion)", forHTTPHeaderField: "User-Agent")
            request.timeoutInterval = 12

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let release = try JSONDecoder().decode(GitHubRelease.self, from: data)
            defaults.set(Date().timeIntervalSince1970, forKey: lastCheckKey)
            defaults.set(release.tagName, forKey: cachedTagKey)
            defaults.set(release.htmlURL.absoluteString, forKey: cachedURLKey)

            if Self.isVersion(release.tagName, newerThan: currentVersion) {
                state = .available(tag: release.tagName, url: release.htmlURL)
                isBannerDismissed = false
            } else {
                state = .upToDate
            }
        } catch {
            if manual {
                state = .failed
            } else {
                state = .idle
            }
        }
    }

    func openReleasePage() {
        guard case let .available(_, url) = state else { return }
        NSWorkspace.shared.open(url)
    }

    private func shouldRunAutomaticCheck() -> Bool {
        let lastCheck = defaults.double(forKey: lastCheckKey)
        guard lastCheck > 0 else { return true }
        return Date().timeIntervalSince1970 - lastCheck >= oneDay
    }

    private func loadCachedResult() {
        guard let tag = defaults.string(forKey: cachedTagKey),
              let urlString = defaults.string(forKey: cachedURLKey),
              let url = URL(string: urlString),
              Self.isVersion(tag, newerThan: currentVersion) else {
            return
        }
        state = .available(tag: tag, url: url)
    }

    private static func isVersion(_ candidate: String, newerThan current: String) -> Bool {
        let left = versionParts(candidate)
        let right = versionParts(current)
        let count = max(left.count, right.count)
        for index in 0..<count {
            let leftValue = index < left.count ? left[index] : 0
            let rightValue = index < right.count ? right[index] : 0
            if leftValue != rightValue {
                return leftValue > rightValue
            }
        }
        return false
    }

    private static func versionParts(_ value: String) -> [Int] {
        let normalized = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: #"^[vV]"#, with: "", options: .regularExpression)
            .split(separator: "-", maxSplits: 1)
            .first ?? ""
        return normalized
            .split(separator: ".")
            .map { Int($0.filter(\.isNumber)) ?? 0 }
    }
}

private struct GitHubRelease: Decodable {
    let tagName: String
    let htmlURL: URL

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case htmlURL = "html_url"
    }
}
