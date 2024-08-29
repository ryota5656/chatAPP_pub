import FirebaseAuth

protocol AuthRepositoryProtocol {
    func observeAuthChanges() -> AsyncStream<Any?>
    func getCurrentUserID() -> String
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func resetPassword(email: String) async throws
    func signOut() throws
}

class AuthRepository: AuthRepositoryProtocol {
    func observeAuthChanges() -> AsyncStream<Any?> {
        AsyncStream { continuation in
            let listener = Auth.auth().addStateDidChangeListener { _, user in
                continuation.yield(user)
            }
            
            continuation.onTermination = { @Sendable _ in
                Auth.auth().removeStateDidChangeListener(listener)
            }
        }
    }
    
    func getCurrentUserID() -> String {
        return Auth.auth().currentUser?.uid ?? "demoUser"
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
