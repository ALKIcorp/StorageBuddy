import Foundation

@MainActor
final class FilterViewModel: ObservableObject {
    @Published var minSizeMB: String = "" { didSet { updateCriteria() } }
    @Published var maxSizeMB: String = "" { didSet { updateCriteria() } }
    @Published var typeText: String = "" { didSet { updateCriteria() } }
    @Published var pathIncludeText: String = "" { didSet { updateCriteria() } }
    @Published var pathExcludeText: String = "" { didSet { updateCriteria() } }
    @Published var tagText: String = "" { didSet { updateCriteria() } }
    @Published var searchText: String = "" { didSet { updateCriteria() } }
    @Published var dateFrom: Date? { didSet { updateCriteria() } }
    @Published var dateTo: Date? { didSet { updateCriteria() } }

    @Published private(set) var criteria: FilterCriteria = FilterCriteria()

    func reset() {
        minSizeMB = ""
        maxSizeMB = ""
        typeText = ""
        pathIncludeText = ""
        pathExcludeText = ""
        tagText = ""
        searchText = ""
        dateFrom = nil
        dateTo = nil
    }

    private func updateCriteria() {
        let minBytes = FilterViewModel.parseSizeMB(minSizeMB)
        let maxBytes = FilterViewModel.parseSizeMB(maxSizeMB)

        criteria = FilterCriteria(
            minSizeBytes: minBytes,
            maxSizeBytes: maxBytes,
            typeFilters: FilterViewModel.parseList(typeText),
            pathIncludes: FilterViewModel.parseList(pathIncludeText),
            pathExcludes: FilterViewModel.parseList(pathExcludeText),
            tags: FilterViewModel.parseList(tagText),
            searchText: searchText.isEmpty ? nil : searchText,
            dateFrom: dateFrom,
            dateTo: dateTo
        )
    }

    private static func parseSizeMB(_ text: String) -> UInt64? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let value = Double(trimmed) else { return nil }
        if value < 0 { return nil }
        return UInt64(value * 1_048_576)
    }

    private static func parseList(_ text: String) -> [String] {
        text
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
