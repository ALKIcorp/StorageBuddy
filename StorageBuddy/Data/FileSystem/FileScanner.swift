import Foundation

enum ScanError: Error {
    case cancelled
}

final class FileScanner {
    private let metadataLoader: MetadataLoader

    init(metadataLoader: MetadataLoader) {
        self.metadataLoader = metadataLoader
    }

    func scan(
        url: URL,
        progress: @escaping (ScanProgress) -> Void,
        isCancelled: @escaping () -> Bool
    ) async throws -> ScanResult {
        let startTime = Date()

        return try await Task.detached(priority: .userInitiated) { [metadataLoader] in
            if isCancelled() { throw ScanError.cancelled }

            guard let rootMetadata = metadataLoader.load(url: url) else {
                throw ScanError.cancelled
            }

            let root = FileNode(
                url: url,
                name: url.lastPathComponent.isEmpty ? url.path : url.lastPathComponent,
                isDirectory: rootMetadata.isDirectory,
                size: rootMetadata.size,
                createdDate: rootMetadata.createdDate,
                modifiedDate: rootMetadata.modifiedDate,
                typeIdentifier: rootMetadata.typeIdentifier,
                tagNames: rootMetadata.tagNames,
                fileExtension: rootMetadata.fileExtension
            )

            var nodeMap: [URL: FileNode] = [url: root]
            let keys: [URLResourceKey] = [
                .isDirectoryKey,
                .fileSizeKey,
                .totalFileAllocatedSizeKey,
                .creationDateKey,
                .contentModificationDateKey,
                .typeIdentifierKey,
                .tagNamesKey,
                .isSymbolicLinkKey
            ]

            let enumerator = FileManager.default.enumerator(
                at: url,
                includingPropertiesForKeys: keys,
                options: [],
                errorHandler: { _, _ in
                    return true
                }
            )

            var processed = 0

            while let item = enumerator?.nextObject() as? URL {
                if isCancelled() { throw ScanError.cancelled }

                guard let metadata = metadataLoader.load(url: item) else { continue }
                if metadata.isSymbolicLink { continue }

                let node = FileNode(
                    url: item,
                    name: item.lastPathComponent,
                    isDirectory: metadata.isDirectory,
                    size: metadata.size,
                    createdDate: metadata.createdDate,
                    modifiedDate: metadata.modifiedDate,
                    typeIdentifier: metadata.typeIdentifier,
                    tagNames: metadata.tagNames,
                    fileExtension: metadata.fileExtension
                )

                nodeMap[item] = node

                let parentURL = item.deletingLastPathComponent()
                if let parent = nodeMap[parentURL] {
                    parent.children.append(node)
                }

                processed += 1
                if processed % 200 == 0 {
                    progress(ScanProgress(itemsProcessed: processed, currentPath: item.path, progressFraction: 0))
                }
            }

            func computeSizes(_ node: FileNode) -> UInt64 {
                if node.isDirectory {
                    let size = node.children.reduce(0) { $0 + computeSizes($1) }
                    node.size = size
                    return size
                }
                return node.size
            }

            _ = computeSizes(root)

            let allNodes = root.flattened()
            let stats = root.collectStats()

            let duration = Date().timeIntervalSince(startTime)

            return ScanResult(
                root: root,
                duration: duration,
                totalSize: stats.totalSize,
                totalFiles: stats.totalFiles,
                totalFolders: stats.totalFolders,
                allNodes: allNodes
            )
        }.value
    }
}
