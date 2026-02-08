import Foundation

final class FileNode: Identifiable, Hashable {
    let id: UUID
    let url: URL
    let name: String
    let isDirectory: Bool
    let createdDate: Date?
    let modifiedDate: Date?
    let typeIdentifier: String?
    let tagNames: [String]
    let fileExtension: String

    var size: UInt64
    var children: [FileNode]

    init(
        url: URL,
        name: String,
        isDirectory: Bool,
        size: UInt64,
        createdDate: Date?,
        modifiedDate: Date?,
        typeIdentifier: String?,
        tagNames: [String],
        fileExtension: String,
        children: [FileNode] = []
    ) {
        self.id = UUID()
        self.url = url
        self.name = name
        self.isDirectory = isDirectory
        self.size = size
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.typeIdentifier = typeIdentifier
        self.tagNames = tagNames
        self.fileExtension = fileExtension
        self.children = children
    }

    static func == (lhs: FileNode, rhs: FileNode) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
