import Foundation

struct PostModel {
    var id: UUID
    var text: String
    var timestamp: Date
    var imageData: Data?
    var likeCount: Int64
    // Author ID (isteğe bağlı) => Burada yoksa da olur
}
