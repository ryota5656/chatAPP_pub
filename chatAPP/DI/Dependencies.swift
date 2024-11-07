import Foundation
import Dependencies

enum ChatListRepositoryKey: DependencyKey {
    static let liveValue: any ChatListRepositoryProtocol = ChatListRepository()
    
}

enum ChatRepositoryKey: DependencyKey {
    static let liveValue: any ChatRepositoryProtocol = ChatRepository()
}

enum UserRepositoryKey: DependencyKey {
    static let liveValue: any UserRepositoryProtocol = UserRepository()
}

enum AuthRepositoryKey: DependencyKey {
    static let liveValue: AuthRepositoryProtocol = AuthRepository()
}

enum AuthViewModelKey: DependencyKey {
    static let liveValue = AuthViewModel()
}

enum ChatListViewModelKey: DependencyKey {
    static let liveValue = ChatListViewModel()
}

enum UserViewModelKey: DependencyKey {
    static let liveValue = UserViewModel()
}

extension DependencyValues {
    var chatListRepository: any ChatListRepositoryProtocol {
        get { self[ChatListRepositoryKey.self] }
        set { self[ChatListRepositoryKey.self] = newValue }
    }
    
    var chatRepository: any ChatRepositoryProtocol {
        get { self[ChatRepositoryKey.self] }
        set { self[ChatRepositoryKey.self] = newValue }
    }
    
    var userRepository: any UserRepositoryProtocol {
        get { self[UserRepositoryKey.self] }
        set { self[UserRepositoryKey.self] = newValue }
    }
    
    var authRepository: AuthRepositoryProtocol {
        get { self[AuthRepositoryKey.self] }
        set { self[AuthRepositoryKey.self] = newValue }
    }
    
    var authViewModel: AuthViewModel {
            get { self[AuthViewModelKey.self] }
            set { self[AuthViewModelKey.self] = newValue }
        }
    
    var chatListViewModel: ChatListViewModel {
        get { self[ChatListViewModelKey.self] }
        set { self[ChatListViewModelKey.self] = newValue }
    }
    
    var userViewModel: UserViewModel {
        get { self[UserViewModelKey.self] }
        set { self[UserViewModelKey.self] = newValue }
    }
}
