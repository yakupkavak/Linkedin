import SwiftUI
import CoreData

struct ChatListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject private var chatVM = ChatViewModel()
    @State private var allUsers: [UserModel] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(allUsers, id: \.id) { user in
                    // currentUser ile aynı ID'ye sahip olanı liste dışı bırak
                    if user.id != authViewModel.currentUser?.id {
                        NavigationLink(destination: ChatDetailView(otherUser: user)) {
                            Text(user.fullName)
                        }
                    }
                }
            }
            .navigationTitle("Mesajlar")
            .onAppear {
                fetchAllUsers()
            }
        }
    }
    
    // Tüm kullanıcıları (User entity) çekip UserModel dizisine dönüştür
    private func fetchAllUsers() {
        let req = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            let objects = try viewContext.fetch(req)
            let models = objects.map { obj -> UserModel in
                let id = obj.value(forKey: "id") as? UUID ?? UUID()
                let email = obj.value(forKey: "email") as? String ?? ""
                let password = obj.value(forKey: "password") as? String ?? ""
                let fullName = obj.value(forKey: "fullName") as? String ?? ""
                let userType = obj.value(forKey: "userType") as? String ?? "employee"
                let bio = obj.value(forKey: "bio") as? String
                let pImage = obj.value(forKey: "profileImage") as? Data
                return UserModel(id: id,
                                 email: email,
                                 password: password,
                                 fullName: fullName,
                                 userType: userType,
                                 bio: bio,
                                 profileImage: pImage)
            }
            self.allUsers = models
        } catch {
            print("fetchAllUsers hata: \(error)")
            self.allUsers = []
        }
    }
}
