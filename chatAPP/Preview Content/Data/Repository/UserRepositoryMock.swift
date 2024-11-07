import Foundation

class MockUserRepository: UserRepositoryProtocol {
    func startListeningForUserChanges(userId: String) -> AsyncStream<User?> {
        AsyncStream { continuation in
            let mockUser = User(id: "1", name: "test2", image: "")
            
            continuation.yield(mockUser)
            continuation.finish()
        }
    }
    
    func fetchUserImageURL(userId: String) async throws -> String? { return "" }
    
    func updateUser(userId: String, name: String?, image: String?) async throws {}
}
