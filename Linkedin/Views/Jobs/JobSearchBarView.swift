import SwiftUI

struct JobSearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Arama...", text: $searchText, onCommit: {
                onSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Button {
                onSearch()
            } label: {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding()
    }
}
