import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            switch coordinator.phase {
            case .idle:
                SelectTargetView(coordinator: coordinator)
            case .scanning:
                ScanningView(coordinator: coordinator)
            case .results:
                ResultsView(coordinator: coordinator)
            }
        }
        .frame(minWidth: 980, minHeight: 640)
    }
}

#Preview {
    ContentView()
}
