import Foundation

struct ScanResult {
    let root: FileNode
    let duration: TimeInterval
    let totalSize: UInt64
    let totalFiles: Int
    let totalFolders: Int
    let allNodes: [FileNode]
}
