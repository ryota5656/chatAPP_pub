import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var userImageURLs: [String: String] = [:]
    
    private let chatRepository: ChatRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(chatRepository: ChatRepositoryProtocol,
         userRepository: UserRepositoryProtocol) {
        self.chatRepository = chatRepository
        self.userRepository = userRepository
    }
    
    @MainActor
    func fetchChats(chatId: String) async {
        for await chatList in chatRepository.fetchChats(chatId: chatId) {
            self.chats = chatList
            // バックグラウンド処理に変更
            Task {
                await fetchUserImages(for: chatList)
            }
        }
    }
    
    @MainActor
    private func fetchUserImages(for chats: [Chat]) async {
        for chat in chats {
            if userImageURLs[chat.userId] == nil {
                if let imageURL = await fetchUserImageURL(userId: chat.userId) {
                    userImageURLs[chat.userId] = imageURL
                }
            }
        }
    }
    
    private func fetchUserImageURL(userId: String) async -> String? {
        do {
            return try await userRepository.fetchUserImageURL(userId: userId)
        } catch {
            print("Error fetching user image URL: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveChat(chatId: String, text: String, userId: String) async {
        do {
            try await chatRepository.saveChat(chatId: chatId, text: text, userId: userId)
        } catch {
            print("Error saving chat: \(error.localizedDescription)")
        }
    }
}