import Foundation
import UniformTypeIdentifiers

final class ApplyFiltersUseCase {
    func apply(result: ScanResult, criteria: FilterCriteria) -> FilteredResult {
        var flatMatches: [FileNode] = []

        func matchesType(_ node: FileNode) -> Bool {
            let filters = criteria.typeFilters
            if filters.isEmpty { return true }

            let nodeTypeId = node.typeIdentifier?.lowercased()
            let nodeExt = node.fileExtension.lowercased()
            let nodeUTType = nodeTypeId.flatMap { UTType($0) }

            for filter in filters {
                let filterLower = filter.lowercased()

                if filterLower == nodeTypeId { return true }
                if filterLower == nodeExt { return true }

                if let filterUTType = UTType(filterLower), let nodeUTType {
                    if nodeUTType.conforms(to: filterUTType) { return true }
                }
            }
            return false
        }

        func matches(_ node: FileNode) -> Bool {
            if let minSize = criteria.minSizeBytes, node.size < minSize { return false }
            if let maxSize = criteria.maxSizeBytes, node.size > maxSize { return false }

            if !matchesType(node) { return false }

            if let from = criteria.dateFrom, let modified = node.modifiedDate, modified < from { return false }
            if let to = criteria.dateTo, let modified = node.modifiedDate, modified > to { return false }

            if !criteria.pathIncludes.isEmpty {
                let path = node.url.path.lowercased()
                if !criteria.pathIncludes.contains(where: { path.contains($0.lowercased()) }) { return false }
            }

            if !criteria.pathExcludes.isEmpty {
                let path = node.url.path.lowercased()
                if criteria.pathExcludes.contains(where: { path.contains($0.lowercased()) }) { return false }
            }

            if !criteria.tags.isEmpty {
                let lowerTags = Set(node.tagNames.map { $0.lowercased() })
                if !criteria.tags.contains(where: { lowerTags.contains($0.lowercased()) }) { return false }
            }

            if let search = criteria.searchText?.lowercased() {
                let path = node.url.path.lowercased()
                let name = node.name.lowercased()
                if !path.contains(search) && !name.contains(search) { return false }
            }

            return true
        }

        func clone(_ node: FileNode, children: [FileNode], size: UInt64) -> FileNode {
            FileNode(
                url: node.url,
                name: node.name,
                isDirectory: node.isDirectory,
                size: size,
                createdDate: node.createdDate,
                modifiedDate: node.modifiedDate,
                typeIdentifier: node.typeIdentifier,
                tagNames: node.tagNames,
                fileExtension: node.fileExtension,
                children: children
            )
        }

        func filterNode(_ node: FileNode) -> FileNode? {
            let childResults = node.children.compactMap { filterNode($0) }
            let isMatch = matches(node)

            if isMatch { flatMatches.append(node) }

            if node.isDirectory {
                if isMatch || !childResults.isEmpty {
                    let size = childResults.reduce(0) { $0 + $1.size }
                    return clone(node, children: childResults, size: size)
                }
                return nil
            }

            return isMatch ? node : nil
        }

        let filteredRoot = filterNode(result.root) ?? clone(result.root, children: [], size: 0)
        let stats = filteredRoot.collectStats()

        return FilteredResult(
            root: filteredRoot,
            totalSize: stats.totalSize,
            totalFiles: stats.totalFiles,
            totalFolders: stats.totalFolders,
            flatMatches: flatMatches
        )
    }
}
