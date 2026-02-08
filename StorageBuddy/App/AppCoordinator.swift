import Combine
import Foundation
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    enum AppPhase {
        case idle
        case scanning
        case results
    }

    @Published var phase: AppPhase = .idle
    @Published var targetURL: URL?
    @Published var scanResult: ScanResult?
    @Published var filteredResult: FilteredResult?
    @Published var scanProgress: ScanProgress = ScanProgress.empty

    let filterViewModel: FilterViewModel

    private let progressPublisher: ScanProgressPublisher
    private let startScanUseCase: StartScanUseCase
    private let cancelScanUseCase: CancelScanUseCase
    private let applyFiltersUseCase: ApplyFiltersUseCase
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let cancellationToken = ScanCancellationToken()
        let progressPublisher = ScanProgressPublisher()
        let scanner = FileScanner(metadataLoader: MetadataLoader())

        self.progressPublisher = progressPublisher
        self.startScanUseCase = StartScanUseCase(
            scanner: scanner,
            progressPublisher: progressPublisher,
            cancellationToken: cancellationToken
        )
        self.cancelScanUseCase = CancelScanUseCase(cancellationToken: cancellationToken)
        self.applyFiltersUseCase = ApplyFiltersUseCase()
        self.filterViewModel = FilterViewModel()

        progressPublisher.$progress
            .receive(on: DispatchQueue.main)
            .assign(to: &$scanProgress)

        filterViewModel.$criteria
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }

    func selectTarget(url: URL) {
        targetURL = url
        startScan()
    }

    func startScan() {
        guard let targetURL else { return }
        phase = .scanning
        scanResult = nil
        filteredResult = nil
        scanProgress = ScanProgress.empty

        Task {
            do {
                let result = try await startScanUseCase.startScan(target: targetURL)
                scanResult = result
                applyFilters()
                phase = .results
            } catch {
                phase = .idle
            }
        }
    }

    func cancelScan() {
        cancelScanUseCase.cancel()
        phase = .idle
        targetURL = nil
        scanResult = nil
        filteredResult = nil
    }

    func newScan() {
        phase = .idle
        targetURL = nil
        scanResult = nil
        filteredResult = nil
    }

    private func applyFilters() {
        guard let scanResult else { return }
        filteredResult = applyFiltersUseCase.apply(result: scanResult, criteria: filterViewModel.criteria)
    }
}
