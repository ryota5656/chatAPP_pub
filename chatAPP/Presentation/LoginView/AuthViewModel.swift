import SwiftUI
import FirebaseAuth
import Dependencies

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userID: String?
    @Published var userName: String?
    @Published var userUrl: URL?
    
    @Dependency(\.authRepository) private var authRepository
        
    init() {
        startObservingAuthChanges()
    }
    
    private func startObservingAuthChanges() {
        Task { @MainActor in
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
    
    @MainActor
    func signOut() async {
        do {
            try await authRepository.signOut()
            isAuthenticated = false
        } catch {
            print("Error signing out: \(error)")
        }
    }
}


