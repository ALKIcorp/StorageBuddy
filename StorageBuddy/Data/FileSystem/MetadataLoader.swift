import Foundation

struct FileMetadata {
    let isDirectory: Bool
    let size: UInt64
    let createdDate: Date?
    let modifiedDate: Date?
    let typeIdentifier: String?
    let tagNames: [String]
    let fileExtension: String
    let isSymbolicLink: Bool
}

final class MetadataLoader {
    func load(url: URL) -> FileMetadata? {
        do {
            let values = try url.resourceValues(forKeys: [
                .isDirectoryKey,
                .fileSizeKey,
                .totalFileAllocatedSizeKey,
                .creationDateKey,
                .contentModificationDateKey,
                .typeIdentifierKey,
                .tagNamesKey,
                .isSymbolicLinkKey
            ])

            let isDirectory = values.isDirectory ?? false
            let sizeValue = values.totalFileAllocatedSize ?? values.fileSize ?? 0
            let fileExtension = url.pathExtension

            return FileMetadata(
                isDirectory: isDirectory,
                size: UInt64(sizeValue),
                createdDate: values.creationDate,
                modifiedDate: values.contentModificationDate,
                typeIdentifier: values.typeIdentifier,
                tagNames: values.tagNames ?? [],
                fileExtension: fileExtension,
                isSymbolicLink: values.isSymbolicLink ?? false
            )
        } catch {
            return nil
        }
    }
}
