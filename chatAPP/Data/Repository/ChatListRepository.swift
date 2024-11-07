import FirebaseFirestore

protocol ChatListRepositoryProtocol {
    func fetchChatList() -> AsyncThrowingStream<[ChatList], Error>
    func saveChatList(chatListTitle: String) async throws
    func deleteChatList(documentId: String) async throws
}

class ChatListRepository: ChatListRepositoryProtocol {
    private var db = Firestore.firestore()
    //　リスナーを変数で保持することで、リスナーの管理（設定・削除・確認）をできるようにしています
    private var listener: ListenerRegistration?
    
    // addSnapshotListenerを使用するためAsyncStreamを使用しています。
    func fetchChatList() -> AsyncThrowingStream<[ChatList], Error> {
        AsyncThrowingStream { continuation in
            // 既存のリスナーがあれば削除
            listener?.remove()
            
            listener = db.collection("chatList")
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        print("Error fetching chats: \(error)")
                        continuation.finish(throwing: error)
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        continuation.finish()
                        return
                    }
                    
                    //　デコード処理どちらの記述でもよい
//                    let chatList = documents.compactMap { document -> ChatList? in
//                        try? document.data(as: ChatList.self)
//                    }
                    
                    let chatList = documents.compactMap { document -> ChatList? in
                        let data = document.data()
                        let id = document.documentID
                        let title = data["title"] as? String ?? ""
                        let lastChat = data["lastChat"] as? String ?? ""
                        let lastDate = data["lastDate"] as? Date ?? Date()
                        let userIds = data["userIds"] as? [String] ?? [""]
                        return ChatList(id: id, title: title, lastChat: lastChat, lastDate: lastDate, userIds: userIds)
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
        let docRef = db.collection(co.chatList).document()
        try await docRef.setData(["title": chatListTitle])
    }
    
    func deleteChatList(documentId: String) async throws {
        try await db.collection("chatList").document(documentId).delete()
    }
}
