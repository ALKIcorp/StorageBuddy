import Foundation

struct NodeStats {
    let totalSize: UInt64
    let totalFiles: Int
    let totalFolders: Int
}

extension FileNode {
    func collectStats() -> NodeStats {
        var totalSize: UInt64 = 0
        var totalFiles = 0
        var totalFolders = 0

        func walk(_ node: FileNode) {
            if node.isDirectory {
                totalFolders += 1
                node.children.forEach { walk($0) }
            } else {
                totalFiles += 1
                totalSize += node.size
            }
        }

        walk(self)
        return NodeStats(totalSize: totalSize, totalFiles: totalFiles, totalFolders: totalFolders)
    }

    func flattened() -> [FileNode] {
        var nodes: [FileNode] = []
        func walk(_ node: FileNode) {
            nodes.append(node)
            node.children.forEach { walk($0) }
        }
        walk(self)
        return nodes
    }
}
