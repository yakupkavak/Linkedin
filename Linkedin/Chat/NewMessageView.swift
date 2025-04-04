import SwiftUI
import CoreData

struct NewMessageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var chatVM = ChatViewModel()
    
    @State private var allUsers: [UserModel] = []
    @State private var selectedUser: UserModel? = nil
    @State private var messageText: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kime gönderilecek?")) {
                    Picker("Kullanıcı Seç", selection: $selectedUser) {
                        Text("Seçiniz").tag(UserModel?.none)
                        ForEach(allUsers, id: \.id) { user in
                            if user.id != authViewModel.currentUser?.id {
                                Text(user.fullName).tag(UserModel?.some(user))
                            }
                        }
                    }
                }
                
                Section(header: Text("Mesajınız")) {
                    TextField("Mesaj giriniz", text: $messageText)
                }
                
                Section {
                    Button("Gönder") {
                        guard let currentUser = authViewModel.currentUser,
                              let receiver = selectedUser,
                              !messageText.isEmpty else { return }
                        
                        // chatVM.inputText üzerinden gönderelim
                        chatVM.inputText = messageText
                        chatVM.sendMessage(from: currentUser, to: receiver, context: viewContext)
                        
                        // Ekranı kapat
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Yeni Mesaj", displayMode: .inline)
            .navigationBarItems(leading: Button("Vazgeç") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                fetchAllUsers()
            }
        }
    }
    
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
