import SwiftUI

struct MainFeedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var postVM = PostViewModel()

    @State private var showNewPost = false

    var body: some View {
        NavigationView {
            List {
                ForEach(postVM.posts, id: \.id) { post in
                    PostRowView(post: post)
                        .environmentObject(postVM)
                }
            }
            .navigationTitle("Ana Akış")
            .toolbar {
                Button {
                    showNewPost.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
            .onAppear {
                postVM.fetchPosts(context: viewContext)
            }
        }
        .sheet(isPresented: $showNewPost) {
            NewPostView(postVM: postVM)
                .environmentObject(authViewModel)
        }
    }
}
