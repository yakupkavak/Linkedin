import Foundation

struct UserModel: Hashable {
    var id: UUID
    var email: String
    var password: String
    var fullName: String
    var userType: String   // "employee" veya "employer"
    var bio: String?
    var profileImage: Data?
}
