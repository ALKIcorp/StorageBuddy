import Foundation

final class CancelScanUseCase {
    private let cancellationToken: ScanCancellationToken

    init(cancellationToken: ScanCancellationToken) {
        self.cancellationToken = cancellationToken
    }

    func cancel() {
        cancellationToken.cancel()
    }
}
