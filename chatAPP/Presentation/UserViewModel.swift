import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var textFieldText: String = ""
    @Published var imageFieldText: String = ""
    private let userRepository: UserRepositoryProtocol
    
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    // userProfileで表示するため現在のユーザーを取得するメソッド
    @MainActor
    func startListeningForUserChanges(userId: String) async {
        for await user in userRepository.startListeningForUserChanges(userId: userId) {
            self.currentUser = user
        }
    }
    
    // データの更新をするメソッド
    @MainActor
    func updateUser(userId: String) async {
        guard !imageFieldText.isEmpty || !textFieldText.isEmpty else { return }
        do {
            try await userRepository.updateUser(userId: userId, name: textFieldText, image: imageFieldText)
        } catch {
            print("Error update user: \(error.localizedDescription)")
        }
        textFieldText = ""
        imageFieldText = ""
    }
}
