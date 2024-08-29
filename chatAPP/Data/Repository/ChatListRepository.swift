import FirebaseFirestore

protocol ChatListRepositoryProtocol {
    func fetchChatList() -> AsyncStream<[ChatList]>
    func saveChatList(chatListTitle: String) async throws
    func deleteDocument(documentId: String) async throws
}

class ChatListRepository: ChatListRepositoryProtocol {
    private var db = Firestore.firestore()
    //　リスナーを変数で保持することで、リスナーの管理（設定・削除・確認）をできるようにしています
    private var listener: ListenerRegistration?
    
    // addSnapshotListenerを使用するためAsyncStreamを使用しています。
    func fetchChatList() -> AsyncStream<[ChatList]> {
        AsyncStream { continuation in
            // 既存のリスナーがあれば削除
            listener?.remove()
            
            listener = db.collection("chatList")
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
                    
                    let chatList = documents.compactMap { document -> ChatList? in
                        try? document.data(as: ChatList.self)
                    }
                    // リスナー状態で得た値を随時ここで返しています
                    continuation.yield(chatList)
                }
            // AsyncStreamが終了するタイミングで実行されます
            continuation.onTermination = { @Sendable _ in
                self.listener?.remove()
            }
        }
    }
    
    func saveChatList(chatListTitle: String) async throws {
        let docRef = db.collection("chatList").document()
        try await docRef.setData(["title": chatListTitle])
    }
    
    func deleteDocument(documentId: String) async throws {
        try await db.collection("chatList").document(documentId).delete()
    }
}
