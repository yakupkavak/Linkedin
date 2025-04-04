import SwiftUI

struct NewPostView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var postVM: PostViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Ne düşünüyorsun?", text: $postVM.textContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let image = postVM.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }

                Button("Resim Seç") {
                    showImagePicker = true
                }

                Spacer()

                Button("Paylaş") {
                    if let user = authViewModel.currentUser {
                        postVM.createPost(author: user, context: viewContext)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
            }
            .navigationTitle("Yeni Gönderi")
            .navigationBarItems(leading: Button("Vazgeç") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .sheet(isPresented: $showImagePicker) {
            // Basit bir ImagePicker implementasyonu (UIKit bridging)
            ImagePicker(selectedImage: $postVM.selectedImage)
        }
    }
}
