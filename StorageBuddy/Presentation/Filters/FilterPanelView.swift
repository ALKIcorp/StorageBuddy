import SwiftUI

struct FilterPanelView: View {
    @ObservedObject var viewModel: FilterViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Filters")
                    .font(.system(size: 14, weight: .semibold))

                groupTitle("Size (MB)")
                HStack {
                    TextField("Min", text: $viewModel.minSizeMB)
                    TextField("Max", text: $viewModel.maxSizeMB)
                }

                groupTitle("Types")
                TextField("e.g. jpg, pdf, public.movie", text: $viewModel.typeText)

                groupTitle("Date Range")
                DatePicker("From", selection: Binding($viewModel.dateFrom, replacingNilWith: Date()), displayedComponents: .date)
                DatePicker("To", selection: Binding($viewModel.dateTo, replacingNilWith: Date()), displayedComponents: .date)

                groupTitle("Path Includes")
                TextField("comma separated", text: $viewModel.pathIncludeText)

                groupTitle("Path Excludes")
                TextField("comma separated", text: $viewModel.pathExcludeText)

                groupTitle("Tags")
                TextField("comma separated", text: $viewModel.tagText)

                groupTitle("Search")
                TextField("name or path", text: $viewModel.searchText)

                Button("Reset Filters") {
                    viewModel.reset()
                }
                .padding(.top, 8)
            }
            .padding(12)
        }
    }

    private func groupTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.secondary)
    }
}

private extension Binding where Value == Date? {
    init(_ source: Binding<Date?>, replacingNilWith defaultDate: Date) {
        self.init(get: {
            source.wrappedValue ?? defaultDate
        }, set: { newValue in
            source.wrappedValue = newValue
        })
    }
}
