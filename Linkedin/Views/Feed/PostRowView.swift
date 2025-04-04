import SwiftUI

struct PostRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var postVM: PostViewModel

    let post: PostModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Yazar: (Relationship ile User getirilir veya ek alan)")

            Text(post.text)
            if let data = post.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
            }
            HStack {
                Button("Beğen (\(post.likeCount))") {
                    postVM.likePost(post, context: viewContext)
                }
                Spacer()
                Text("\(post.timestamp, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
