import Foundation

final class StartScanUseCase {
    private let scanner: FileScanner
    private let progressPublisher: ScanProgressPublisher
    private let cancellationToken: ScanCancellationToken

    init(
        scanner: FileScanner,
        progressPublisher: ScanProgressPublisher,
        cancellationToken: ScanCancellationToken
    ) {
        self.scanner = scanner
        self.progressPublisher = progressPublisher
        self.cancellationToken = cancellationToken
    }

    func startScan(target: URL) async throws -> ScanResult {
        cancellationToken.reset()
        await MainActor.run {
            progressPublisher.reset()
        }

        return try await scanner.scan(
            url: target,
            progress: { [weak progressPublisher] update in
                Task { @MainActor in
                    progressPublisher?.update(progress: update)
                }
            },
            isCancelled: { [weak cancellationToken] in
                cancellationToken?.isCancelled ?? true
            }
        )
    }
}
