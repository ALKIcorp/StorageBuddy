import Foundation

struct FilterCriteria {
    let minSizeBytes: UInt64?
    let maxSizeBytes: UInt64?
    let typeFilters: [String]
    let pathIncludes: [String]
    let pathExcludes: [String]
    let tags: [String]
    let searchText: String?
    let dateFrom: Date?
    let dateTo: Date?

    init(
        minSizeBytes: UInt64? = nil,
        maxSizeBytes: UInt64? = nil,
        typeFilters: [String] = [],
        pathIncludes: [String] = [],
        pathExcludes: [String] = [],
        tags: [String] = [],
        searchText: String? = nil,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) {
        self.minSizeBytes = minSizeBytes
        self.maxSizeBytes = maxSizeBytes
        self.typeFilters = typeFilters
        self.pathIncludes = pathIncludes
        self.pathExcludes = pathExcludes
        self.tags = tags
        self.searchText = searchText
        self.dateFrom = dateFrom
        self.dateTo = dateTo
    }
}
