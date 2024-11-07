import Foundation
import Dependencies

extension ChatListRepositoryKey {
    static let previewValue: any ChatListRepositoryProtocol = MockChatListRepository()
}

extension ChatRepositoryKey {
    static let previewValue: any ChatRepositoryProtocol = MockChatRepository()
}

extension UserRepositoryKey {
    static let previewValue: any UserRepositoryProtocol = MockUserRepository()
}

extension AuthRepositoryKey {
    static let previewValue: any AuthRepositoryProtocol = MockAuthRepository()
}
