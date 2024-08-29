import FirebaseFirestore
import Foundation

class ChatListViewModel: ObservableObject {
    @Published var chatList: [ChatList] = []
    @Published var isProfileExpanded = false
    @Published var showingNewChatListPopup = false
    @Published var chatListName = ""
    private let chatListRepository: ChatListRepositoryProtocol
    
    init(chatListRepository: ChatListRepositoryProtocol) {
        self.chatListRepository = chatListRepository
    }
    
    // チャットリストを取得するメソッド
    // AsyncStreamでの対応
    @MainActor
    func fetchChatList() async {
        for await chatList in chatListRepository.fetchChatList() {
            self.chatList = chatList
        }
    }
    
    // チャットリストを保存するメソッド
    @MainActor
    func saveChatList(chatListTitle: String) async {
        guard !chatListName.isEmpty else { return print("chatName is Empty") }
        do {
            try await chatListRepository.saveChatList(chatListTitle: chatListTitle)
        } catch {
            print("Error saving chatList: \(error.localizedDescription)")
            showingNewChatListPopup = false
        }
        resetChatListName()
    }
    
    // チャットリストを削除するメソッド
    func deleteDocument(documentId: String) async {
        do {
            try await chatListRepository.deleteDocument(documentId: documentId)
        } catch {
            print("Error delete chatList: \(error.localizedDescription)")
        }
    }
    
    func toggleProfileExpanded() {
        isProfileExpanded.toggle()
    }
    
    func showNewChatListPopup() {
        showingNewChatListPopup = true
    }
    
    func resetChatListName() {
        chatListName = ""
    }
}
