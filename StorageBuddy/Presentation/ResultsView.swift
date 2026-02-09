import SwiftUI

struct ResultsView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 0) {
            header
            HStack(spacing: 0) {
                FilterPanelView(viewModel: coordinator.filterViewModel)
                    .frame(width: 280)
                Divider()
                TabView {
                    DashboardView(viewModel: DashboardViewModel(result: coordinator.filteredResult))
                        .tabItem { Text("Dashboard") }
                    TreeView(viewModel: TreeViewModel(result: coordinator.filteredResult))
                        .tabItem { Text("Tree") }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(coordinator.targetURL?.path ?? "Scan Results")
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                    .truncationMode(.middle)
                if let result = coordinator.scanResult {
                    Text("\(result.totalFiles) files, \(result.totalFolders) folders, \(result.totalSize.formattedBytes())")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button("New Scan") {
                coordinator.newScan()
            }
        }
        .padding(12)
    }
}
