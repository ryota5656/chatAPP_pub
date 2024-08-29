import SwiftUI
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userID: String?
    @Published var userName: String?
    @Published var userUrl: URL?
    
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
        observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        Task {
            for await user in authRepository.observeAuthChanges() {
                isAuthenticated = user != nil
            }
        }
    }
    
    func getCurrentUserID() -> String {
        return authRepository.getCurrentUserID()
    }
    
    func signIn(email: String, password: String) async {
        do {
            try await authRepository.signIn(email: email, password: password)
        } catch {
            print("Error signing in: \(error)")
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            try await authRepository.signUp(email: email, password: password)
        } catch {
            print("Error signing up: \(error)")
        }
    }
    
    func resetPassword(email: String) async {
        do {
            try await authRepository.resetPassword(email: email)
        } catch {
            print("Error in sending password reset: \(error)")
        }
    }
    
    func signOut() {
        do {
            try authRepository.signOut()
            isAuthenticated = false
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
