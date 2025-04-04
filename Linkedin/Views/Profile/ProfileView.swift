import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var profileVM = ProfileViewModel()

    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if let uiImage = profileVM.profileImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                }

                Button("Profil Resmi Seç") {
                    showImagePicker = true
                }

                TextField("Ad Soyad", text: $profileVM.fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Bio", text: $profileVM.bio)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Kaydet") {
                    if let user = authViewModel.currentUser {
                        profileVM.saveProfile(user: user, context: viewContext)
                    }
                }
                .padding()

                Spacer()

                Button("Çıkış Yap") {
                    authViewModel.logout()
                }
                .foregroundColor(.red)

                Spacer()
            }
            .navigationTitle("Profil")
            .onAppear {
                if let user = authViewModel.currentUser {
                    profileVM.loadProfile(user: user, context: viewContext)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            // Basit ImagePicker
            ImagePicker(selectedImage: $profileVM.profileImage)
        }
    }
}
