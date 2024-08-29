import FirebaseFirestore

protocol UserRepositoryProtocol {
    func startListeningForUserChanges(userId: String) -> AsyncStream<User?>
    func fetchUserImageURL(userId: String) async throws -> String?
    func updateUser(userId: String, name: String?, image: String?) async throws
}

class UserRepository: UserRepositoryProtocol {
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // addSnapshotListenerを使用するためAsyncStreamを使用しています。
    func startListeningForUserChanges(userId: String) -> AsyncStream<User?> {
        AsyncStream { continuation in
            let listener = db.collection("users")
                .whereField("id", isEqualTo: userId)
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        print("Error getting documents: \(error)")
                        continuation.yield(nil)
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                        print("No matching documents")
                        continuation.yield(nil)
                        return
                    }
                    
                    // 通常、ユーザードキュメントは1つだけのはずなので、最初のドキュメントを使用
                    let document = documents[0]
                    if let userData = try? document.data(as: User.self) {
                        continuation.yield(userData)
                    } else {
                        continuation.yield(nil)
                    }
                }
            
            continuation.onTermination = { @Sendable _ in
                listener.remove()
            }
        }
    }
    
    func fetchUserImageURL(userId: String) async throws -> String? {
        let snapshot = try await db.collection("users")
            .whereField("id", isEqualTo: userId)
            .getDocuments()
        
        guard let document = snapshot.documents.first else {
            return nil
        }
        
        return document.data()["image"] as? String
    }
    
    func updateUser(userId: String, name: String?, image: String?) async throws {
        var updateFields: [String:Any] = [:]
        
        if let newImage = image {
            updateFields["image"] = newImage
        }
        
        if let newName = name {
            updateFields["name"] = newName
        }
        
        if updateFields.isEmpty { return }
        
        let snapshot = try await db.collection("users").whereField("id", isEqualTo: userId).getDocuments()
        
        guard let document = snapshot.documents.first else {
            print("No matching documents")
            throw NSError(domain: "UserUpdateError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        try await document.reference.updateData(updateFields)
        print("Document successfully updated")
    }
}
