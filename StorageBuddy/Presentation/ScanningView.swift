import SwiftUI

struct ScanningView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("Scanning...")
                .font(.system(size: 22, weight: .semibold))

            Text(coordinator.scanProgress.currentPath)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .truncationMode(.middle)

            ProgressView()
                .frame(width: 420)

            Text("Items processed: \(coordinator.scanProgress.itemsProcessed)")
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            Button("Cancel Scan") {
                coordinator.cancelScan()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}
