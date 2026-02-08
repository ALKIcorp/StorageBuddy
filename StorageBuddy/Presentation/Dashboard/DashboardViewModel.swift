import Foundation

struct DashboardViewModel {
    let result: FilteredResult?

    var summaryText: String {
        guard let result else { return "No results" }
        return "\(result.totalFiles) files, \(result.totalFolders) folders, \(result.totalSize.formattedBytes())"
    }

    var largestFiles: [FileNode] {
        guard let result else { return [] }
        return result.flatMatches
            .filter { !$0.isDirectory }
            .sorted(by: { $0.size > $1.size })
            .prefix(20)
            .map { $0 }
    }

    var largestFolders: [FileNode] {
        guard let result else { return [] }
        return result.flatMatches
            .filter { $0.isDirectory }
            .sorted(by: { $0.size > $1.size })
            .prefix(10)
            .map { $0 }
    }
}
