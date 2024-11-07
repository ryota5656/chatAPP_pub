import Foundation

struct Chat: Codable, Identifiable, Equatable {
    let id: String
    let userId: String
    let chatId: String
    let text: String
    let date: Date
    let readed: Bool
}
