import FirebaseFirestore
import Foundation

struct ChatList: Decodable, Identifiable, Equatable {
    @DocumentID var id: String?
    let title: String
    let lastChat: String?
    let lastDate: Date?
    let userIds: [String]?
}

class co {
    static let chatList = "chatList"
}

enum DataState {
    case loading
    case success
    case failure(Error)
}
