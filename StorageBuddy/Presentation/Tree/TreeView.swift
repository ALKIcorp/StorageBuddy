import SwiftUI

struct TreeView: View {
    let viewModel: TreeViewModel
    @State private var sortOrder: SortOrder = .descending

    var body: some View {
        if let root = viewModel.root {
            List {
                TreeNodeView(node: root, sortOrder: $sortOrder)
            }
            .toolbar {
                Picker("Sort", selection: $sortOrder) {
                    ForEach(SortOrder.allCases, id: \.self) { order in
                        Text(order.title)
                    }
                }
                .pickerStyle(.segmented)
                .help("Sort by size")
            }
        } else {
            Text("No results")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

}

private struct TreeNodeView: View {
    let node: FileNode
    @Binding var sortOrder: SortOrder

    var body: some View {
        if node.isDirectory {
            DisclosureGroup {
                ForEach(sortedChildren(for: node)) { child in
                    TreeNodeView(node: child, sortOrder: $sortOrder)
                }
            } label: {
                TreeNodeRow(node: node)
            }
        } else {
            TreeNodeRow(node: node)
        }
    }

    private func sortedChildren(for node: FileNode) -> [FileNode] {
        node.children.sorted { left, right in
            if left.size == right.size {
                return left.name.localizedStandardCompare(right.name) == .orderedAscending
            }
            switch sortOrder {
            case .ascending:
                return left.size < right.size
            case .descending:
                return left.size > right.size
            }
        }
    }
}

private struct TreeNodeRow: View {
    let node: FileNode

    var body: some View {
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

private enum SortOrder: CaseIterable {
    case ascending
    case descending

    var title: String {
        switch self {
        case .ascending:
            return "Size: Small to Large"
        case .descending:
            return "Size: Large to Small"
        }
    }
}
