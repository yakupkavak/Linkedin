import SwiftUI
import CoreData

class AuthViewModel: ObservableObject {
    @Published var currentUser: UserModel? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var userType: String = "employee"
    
    @Published var isFirstLaunch: Bool = true
    
    func checkFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            isFirstLaunch = false
        } else {
            isFirstLaunch = true
        }
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        UserDefaults.standard.set(true, forKey: "didLaunchBefore")
    }
    
    // Kayıt olma
    func signUp(context: NSManagedObjectContext) -> Bool {
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty else { return false }
        
        // 1) Email mevcut mu?
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                print("Bu email zaten mevcut.")
                return false
            }
        } catch {
            print("Fetch hata: \(error)")
            return false
        }
        
        // 2) Yeni User NSManagedObject
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else {
            return false
        }
        let newUserObj = NSManagedObject(entity: entity, insertInto: context)
        
        let newId = UUID()
        
        // setValue ile alanları dolduruyoruz
        newUserObj.setValue(newId, forKey: "id")
        newUserObj.setValue(email, forKey: "email")
        newUserObj.setValue(password, forKey: "password")
        newUserObj.setValue(fullName, forKey: "fullName")
        newUserObj.setValue(userType, forKey: "userType")
        // bio, profileImage varsayılan nil bırakıldı
        
        do {
            try context.save()
            // Model'e çevir
            self.currentUser = UserModel(
                id: newId,
                email: email,
                password: password,
                fullName: fullName,
                userType: userType,
                bio: nil,
                profileImage: nil
            )
            return true
        } catch {
            print("signUp hata: \(error)")
            return false
        }
    }
    
    // Giriş yapma
    func login(context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let results = try context.fetch(request)
            if let userObj = results.first {
                // Model'e çevir
                let userModel = UserModel(
                    id: userObj.value(forKey: "id") as? UUID ?? UUID(),
                    email: userObj.value(forKey: "email") as? String ?? "",
                    password: userObj.value(forKey: "password") as? String ?? "",
                    fullName: userObj.value(forKey: "fullName") as? String ?? "",
                    userType: userObj.value(forKey: "userType") as? String ?? "employee",
                    bio: userObj.value(forKey: "bio") as? String,
                    profileImage: userObj.value(forKey: "profileImage") as? Data
                )
                currentUser = userModel
                return true
            }
        } catch {
            print("login hata: \(error)")
        }
        return false
    }
    
    // Çıkış
    func logout() {
        currentUser = nil
        email = ""
        password = ""
        fullName = ""
        userType = "employee"
    }
}
