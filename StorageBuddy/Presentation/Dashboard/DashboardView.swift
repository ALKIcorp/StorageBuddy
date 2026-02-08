import SwiftUI

struct DashboardView: View {
    let viewModel: DashboardViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Summary")
                    .font(.system(size: 16, weight: .semibold))

                Text(viewModel.summaryText)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                Divider()

                Text("Largest Files")
                    .font(.system(size: 14, weight: .semibold))

                fileList(viewModel.largestFiles)

                Divider()

                Text("Largest Folders")
                    .font(.system(size: 14, weight: .semibold))

                fileList(viewModel.largestFolders)
            }
            .padding(16)
        }
    }

    private func fileList(_ nodes: [FileNode]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(nodes) { node in
                HStack {
                    Text(node.name)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Spacer()
                    Text(node.size.formattedBytes())
                        .foregroundColor(.secondary)
                }
                .font(.system(size: 12))
            }
        }
    }
}
