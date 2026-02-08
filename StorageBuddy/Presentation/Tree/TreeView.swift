import SwiftUI

struct TreeView: View {
    let viewModel: TreeViewModel

    var body: some View {
        if let root = viewModel.root {
            List {
                OutlineGroup(root, children: \.children) { node in
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
        } else {
            Text("No results")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
