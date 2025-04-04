import SwiftUI

struct ChatDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Diğer kullanıcı (sohbet ettiğimiz kişi)
    let otherUser: UserModel
    
    @StateObject private var chatVM = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(chatVM.messages, id: \.id) { msg in
                        if msgIsFromCurrentUser(msg) {
                            HStack {
                                Spacer()
                                Text(msg.text)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        } else {
                            HStack {
                                Text(msg.text)
                                    .padding(8)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Mesaj yazın...", text: $chatVM.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 8)
                
                Button("Gönder") {
                    if let currentUser = authViewModel.currentUser {
                        chatVM.sendMessage(from: currentUser, to: otherUser, context: viewContext)
                    }
                }
                .padding(.trailing, 8)
            }
            .padding(.vertical, 8)
        }
        .navigationTitle(otherUser.fullName)
        .onAppear {
            // Ekrana gelince mesajlar çekilsin
            if let currentUser = authViewModel.currentUser {
                chatVM.fetchMessagesBetween(user1: currentUser, user2: otherUser, context: viewContext)
            }
        }
    }
    
    private func msgIsFromCurrentUser(_ msg: MessageModel) -> Bool {
        // ChatViewModel sadece text/timestamp tutuyor;
        // eğer relationship tutuyorsanız, sendMessage ekinde "senderId" vs. bir alana yazın.
        // Bu basit modelde "senderId" yoksa "sender" check edemiyoruz.
        // Yine de "msgIsFromCurrentUser" dummy.
        // Gerçekte "senderId" tutarak currentUser.id == msg.senderId yaparsınız.
        return false
    }
}
