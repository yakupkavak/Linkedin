import SwiftUI
import CoreData

class ProfileViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var bio: String = ""
    @Published var profileImage: UIImage? = nil
    
    func loadProfile(user: UserModel, context: NSManagedObjectContext) {
        // userId ile NSManagedObject bulup, oradan bio & profileImage çekiyoruz
        let req = NSFetchRequest<NSManagedObject>(entityName: "User")
        req.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            if let obj = try context.fetch(req).first {
                self.fullName = obj.value(forKey: "fullName") as? String ?? ""
                self.bio = obj.value(forKey: "bio") as? String ?? ""
                if let data = obj.value(forKey: "profileImage") as? Data, let uiImg = UIImage(data: data) {
                    self.profileImage = uiImg
                }
            }
        } catch {
            print("loadProfile hata: \(error)")
        }
    }
    
    func saveProfile(user: UserModel, context: NSManagedObjectContext) {
        // user'ı bulup güncelle
        let req = NSFetchRequest<NSManagedObject>(entityName: "User")
        req.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            if let obj = try context.fetch(req).first {
                obj.setValue(fullName, forKey: "fullName")
                obj.setValue(bio, forKey: "bio")
                
                if let uiImage = profileImage {
                    let data = uiImage.jpegData(compressionQuality: 0.8)
                    obj.setValue(data, forKey: "profileImage")
                }
                
                try context.save()
                print("Profil güncellendi.")
            }
        } catch {
            print("saveProfile hata: \(error)")
        }
    }
}
