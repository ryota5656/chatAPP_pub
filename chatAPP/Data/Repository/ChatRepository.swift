import FirebaseFirestore

protocol ChatRepositoryProtocol {
    func fetchChats(chatId: String) -> AsyncStream<[Chat]>
    func saveChat(chatId: String, text: String, userId: String) async throws
    func updateChatList(chatId: String, lastChat: String, lastDate: Date) async throws
}

class ChatRepository: ChatRepositoryProtocol {
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // addSnapshotListenerを使用するためAsyncStreamを使用しています。
    func fetchChats(chatId: String) -> AsyncStream<[Chat]> {
        AsyncStream { continuation in
            // 既存のリスナーがあれば削除
            listener?.remove()
            
            listener = db.collection("chat")
                .whereField("chatId", isEqualTo: chatId)
                .order(by: "date")
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        print("Error fetching chats: \(error)")
                        continuation.yield([])
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        continuation.yield([])
                        return
                    }
                    
                    let chats = documents.compactMap { document -> Chat? in
                        try? document.data(as: Chat.self)
                    }
                    
                    continuation.yield(chats)
                }
            
            continuation.onTermination = { @Sendable _ in
                self.listener?.remove()
            }
        }
    }
    
    func saveChat(chatId: String, text: String, userId: String) async throws {
        let docRef = db.collection("chat").document()
        let currentDate = Date()
        
        let chat = Chat(id: docRef.documentID,
                        userId: userId,
                        chatId: chatId,
                        text: text,
                        date: currentDate,
                        readed: false)
        
        try  docRef.setData(from: chat)
        // チャットリスト画面の最新日時・最新投稿を更新するため記述してます
        try await updateChatList(chatId: chatId, lastChat: text, lastDate: currentDate)
    }
    
    func updateChatList(chatId: String, lastChat: String, lastDate: Date) async throws {
        let chatData: [String: Any] = [
            "lastChat": lastChat,
            "lastDate": lastDate
        ]
        try await db.collection("chatList").document(chatId).updateData(chatData)
    }
}
