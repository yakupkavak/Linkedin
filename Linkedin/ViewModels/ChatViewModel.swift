import SwiftUI
import CoreData

class ChatViewModel: ObservableObject {
    @Published var messages: [MessageModel] = []
    @Published var inputText: String = ""
    
    // İki kullanıcı arasındaki mesajları çek
    func fetchMessagesBetween(user1: UserModel, user2: UserModel, context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Message")
        
        // (sender.id == user1.id && receiver.id == user2.id) OR (sender.id == user2.id && receiver.id == user1.id)
        // Manuel KVC kullanarak "sender.id" / "receiver.id" alanlarını kontrol eden predicate:
        let pred1 = NSPredicate(format: "sender.id == %@ AND receiver.id == %@", user1.id as CVarArg, user2.id as CVarArg)
        let pred2 = NSPredicate(format: "sender.id == %@ AND receiver.id == %@", user2.id as CVarArg, user1.id as CVarArg)
        
        let compound = NSCompoundPredicate(orPredicateWithSubpredicates: [pred1, pred2])
        request.predicate = compound
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let objects = try context.fetch(request)
            self.messages = objects.map { obj in
                let mid = obj.value(forKey: "id") as? UUID ?? UUID()
                let text = obj.value(forKey: "text") as? String ?? ""
                let time = obj.value(forKey: "timestamp") as? Date ?? Date()
                
                return MessageModel(id: mid, text: text, timestamp: time)
            }
        } catch {
            print("fetchMessagesBetween hata: \(error)")
            self.messages = []
        }
    }
    
    // Yeni mesaj gönder
    func sendMessage(from sender: UserModel, to receiver: UserModel, context: NSManagedObjectContext) {
        guard !inputText.isEmpty else { return }
        
        // "Message" entity'sini bul
        guard let messageEntity = NSEntityDescription.entity(forEntityName: "Message", in: context) else { return }
        let newMsg = NSManagedObject(entity: messageEntity, insertInto: context)
        
        newMsg.setValue(UUID(), forKey: "id")
        newMsg.setValue(inputText, forKey: "text")
        newMsg.setValue(Date(), forKey: "timestamp")
        
        // sender/receiver relationship
        if let senderObj = findUserObject(by: sender.id, context: context),
           let receiverObj = findUserObject(by: receiver.id, context: context) {
            newMsg.setValue(senderObj, forKey: "sender")
            newMsg.setValue(receiverObj, forKey: "receiver")
        }
        
        do {
            try context.save()
            // Mesaj gönderildikten sonra input sıfırla
            inputText = ""
            // Listeyi güncelle
            fetchMessagesBetween(user1: sender, user2: receiver, context: context)
        } catch {
            print("sendMessage hata: \(error)")
        }
    }
    
    // Belirli userId ile User NSManagedObject bul
    private func findUserObject(by userId: UUID, context: NSManagedObjectContext) -> NSManagedObject? {
        let req = NSFetchRequest<NSManagedObject>(entityName: "User")
        req.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        return try? context.fetch(req).first
    }
}
