import Foundation

class MockChatRepository: ChatRepositoryProtocol {
    func fetchChats(chatId: String) -> AsyncStream<[Chat]> {
        AsyncStream { continuation in
            let mockChatLists = [
                Chat(id: "1", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "2", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "3", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "4", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "5", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "6", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "7", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "8", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "9", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "10", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "11", userId: "1", chatId: "1", text: "test", date: Date(), readed: true),
                Chat(id: "12", userId: "2", chatId: "1", text: "testtesttesttesttesttesttest", date: Date(), readed: true),
                Chat(id: "13", userId: "2", chatId: "1", text: "testtesttesttesttesttesttest", date: Date(), readed: false)
            ]
            continuation.yield(mockChatLists)
            continuation.finish()
        }
    }
    
    func saveChat(chatId: String, text: String, userId: String) async throws {}
    
    func updateChatList(chatId: String, lastChat: String, lastDate: Date) async throws {}
}
