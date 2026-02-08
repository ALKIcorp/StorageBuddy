import Foundation

struct FilteredResult {
    let root: FileNode
    let totalSize: UInt64
    let totalFiles: Int
    let totalFolders: Int
    let flatMatches: [FileNode]
}
