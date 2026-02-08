import Foundation

struct ScanProgress {
    let itemsProcessed: Int
    let currentPath: String
    let progressFraction: Double

    static let empty = ScanProgress(itemsProcessed: 0, currentPath: "", progressFraction: 0)
}

@MainActor
final class ScanProgressPublisher: ObservableObject {
    @Published private(set) var progress: ScanProgress = .empty

    func update(progress: ScanProgress) {
        self.progress = progress
    }

    func reset() {
        progress = .empty
    }
}
