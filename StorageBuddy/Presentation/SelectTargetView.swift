import SwiftUI

struct SelectTargetView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("Storage Buddy")
                .font(.system(size: 32, weight: .bold))

            Text("Select a volume or folder to scan. Read-only access only.")
                .foregroundColor(.secondary)

            Button("Select Target") {
                openPanel()
            }
            .keyboardShortcut(.defaultAction)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }

    private func openPanel() {
        let panel = NSOpenPanel()
        panel.title = "Choose Folder or Volume"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = false
        panel.prompt = "Select"

        if panel.runModal() == .OK, let url = panel.url {
            coordinator.selectTarget(url: url)
        }
    }
}
