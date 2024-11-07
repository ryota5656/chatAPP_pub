import FirebaseFirestore
import Foundation
import Dependencies

class ChatListViewModel: ObservableObject {
    @Published var chatList: [ChatList] = []
    @Published var isProfileExpanded = false
    @Published var showingNewChatListPopup = false
    @Published var chatListName = ""
    
    private var chatListState: DataState = .loading
    
    @Dependency(\.chatListRepository) private var chatListRepository
    
    // チャットリストを取得するメソッド
    // AsyncStreamでの対応
    // chatListStateについては今回特に使用していませんがView側の出し分ける振る舞いに使えるようにしています
    @MainActor
    func fetchChatList() async {
        do {
            chatListState = .loading
            for try await chatList in chatListRepository.fetchChatList() {
                self.chatList = chatList
            }
            chatListState = .success
        } catch {
            chatListState = .failure(error)
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
    func deleteChatList(documentId: String) async {
        do {
            try await chatListRepository.deleteChatList(documentId: documentId)
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

