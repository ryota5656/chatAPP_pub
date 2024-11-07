import Foundation

class MockChatListRepository: ChatListRepositoryProtocol {
    func saveChatList(chatListTitle: String) async throws {}
    
    func deleteChatList(documentId: String) async throws {}
    
    func fetchChatList() -> AsyncThrowingStream<[ChatList], Error> {
        AsyncThrowingStream { continuation in
            let mockChatLists = [
                ChatList(id: "1",title: "title1", lastChat: "lastChat1", lastDate: Date(), userIds: []),
                ChatList(id: "2",
                         title: "title2title2title2title2title2title2title2title2title2",
                         lastChat: "lastChat2lastChat2lastChat2lastChat2lastChat2lastChat2",
                         lastDate: Date(),
                         userIds: [])
            ]
            continuation.yield(mockChatLists)
            continuation.finish()
        }
    }
}
