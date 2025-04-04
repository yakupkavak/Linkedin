import SwiftUI
import CoreData

class PostViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    
    @Published var textContent: String = ""
    @Published var selectedImage: UIImage? = nil
    
    func fetchPosts(context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Post")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let objects = try context.fetch(request)
            self.posts = objects.map { obj in
                let pid = obj.value(forKey: "id") as? UUID ?? UUID()
                let text = obj.value(forKey: "text") as? String ?? ""
                let timestamp = obj.value(forKey: "timestamp") as? Date ?? Date()
                let imageData = obj.value(forKey: "imageData") as? Data
                let likeCount = obj.value(forKey: "likeCount") as? Int64 ?? 0
                
                return PostModel(
                    id: pid,
                    text: text,
                    timestamp: timestamp,
                    imageData: imageData,
                    likeCount: likeCount
                )
            }
        } catch {
            print("fetchPosts hata: \(error)")
            self.posts = []
        }
    }
    
    func createPost(author: UserModel, context: NSManagedObjectContext) {
        // Post entity
        guard let entity = NSEntityDescription.entity(forEntityName: "Post", in: context) else { return }
        let newPost = NSManagedObject(entity: entity, insertInto: context)
        
        let newId = UUID()
        newPost.setValue(newId, forKey: "id")
        newPost.setValue(textContent, forKey: "text")
        newPost.setValue(Date(), forKey: "timestamp")
        newPost.setValue(0, forKey: "likeCount")
        
        if let image = selectedImage, let data = image.jpegData(compressionQuality: 0.8) {
            newPost.setValue(data, forKey: "imageData")
        }
        
        // Author ilişkisiz yapıyorsanız, “authorName” gibi string tutabilirsiniz.
        // Ama “author” relationship property’si var diyelim; o zaman:
        // 1) User NSManagedObject bulup setValue ile bağlarız:
        
        if let userObj = findUserObject(by: author.id, context: context) {
            // Relationship set
            newPost.setValue(userObj, forKey: "author")
        }
        
        do {
            try context.save()
            textContent = ""
            selectedImage = nil
            fetchPosts(context: context)
        } catch {
            print("createPost hata: \(error)")
        }
    }
    
    // Beğeni (like) arttırma
    func likePost(_ post: PostModel, context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Post")
        request.predicate = NSPredicate(format: "id == %@", post.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let obj = results.first {
                let currentLikes = obj.value(forKey: "likeCount") as? Int64 ?? 0
                obj.setValue(currentLikes + 1, forKey: "likeCount")
                try context.save()
                fetchPosts(context: context)
            }
        } catch {
            print("likePost hata: \(error)")
        }
    }
    
    // Yardımcı fonksiyon: userId ile User NSManagedObject bul
    private func findUserObject(by userId: UUID, context: NSManagedObjectContext) -> NSManagedObject? {
        let req = NSFetchRequest<NSManagedObject>(entityName: "User")
        req.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        return (try? context.fetch(req))?.first
    }
}
