import Foundation

struct TreeViewModel {
    let result: FilteredResult?

    var root: FileNode? {
        result?.root
    }
}
