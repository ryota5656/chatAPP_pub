import Foundation

class MockAuthRepository: AuthRepositoryProtocol {
    var mockUser: Any?
    func observeAuthChanges() -> AsyncStream<Any?> {
        AsyncStream { continuation in
            continuation.yield("login")
        }
    }
    
    func getCurrentUserID() -> String { return "2" }
    
    func signIn(email: String, password: String) async throws {}
    
    func signUp(email: String, password: String) async throws {}
    
    func resetPassword(email: String) async throws {}
    
    func signOut() async throws {}
}
