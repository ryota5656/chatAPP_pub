import SwiftUI

struct ChatView: View {
    @State var chatId: String
    @State var title: String
    @StateObject private var chatVm: ChatViewModel
    @ObservedObject var authVm: AuthViewModel
    
    @State private var textFieldText: String = ""
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var textFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    init(chatId: String, title: String, viewModel: AuthViewModel, chatRepository: ChatRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        _chatId = State(initialValue: chatId)
        _title = State(initialValue: title)
        _authVm = ObservedObject(initialValue: viewModel)
        _chatVm = StateObject(wrappedValue: ChatViewModel(chatRepository: chatRepository, userRepository: userRepository))
    }
    
    @MainActor
    var body: some View {
        VStack(spacing: 0) {
            chatArea
            .overlay(navigationArea, alignment: .top)
            inputArea
        }
        .task {
            await chatVm.fetchChats(chatId: chatId)
            if let proxy = self.scrollViewProxy {
                self.scrollToLast(proxy: proxy)
            }
        }
        
        .onChange(of: chatVm.chats) {
            print("messageData changed: \(chatVm.chats)")
        }
        .navigationBarHidden(true)
    }
    
}

extension ChatView {
    
    private var chatArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(chatVm.chats) { chat in
                        ChatRow(currentUserId: authVm.getCurrentUserID(),
                                chat: chat,
                                // Binding型でuserImageURLsの管理もViewModelに移動
                                userImageURL: Binding(
                                    get: { chatVm.userImageURLs[chat.userId] },
                                    set: { _ in }
                                ))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 72)
            }
            .frame(maxWidth: .infinity)
            .background(Color("Background"))
            .onTapGesture {
                textFieldFocused = false
            }
            .onAppear {
                self.scrollViewProxy = proxy
                scrollToLast(proxy: proxy)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                scrollToLast(proxy: proxy, smooth: true)
            }
        }
    }
    
    private var inputArea: some View {
        HStack {
            HStack {
                Image(systemName: "plus")
                Image(systemName: "camera")
                Image(systemName: "photo")
            }
            .font(.title2)
            TextField("Aa", text: $textFieldText)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Capsule())
                .overlay(
                    Image(systemName: "face.smiling")
                        .font(.title2)
                        .padding(.trailing)
                        .foregroundColor(.gray)
                    
                    , alignment: .trailing
                )
                .onSubmit {
                    sendChat()
                }
                .focused($textFieldFocused)
            Image(systemName: "mic")
                .font(.title2)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(uiColor: .systemBackground))
    }
    
    private var navigationArea: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            Text(title)
                .font(.title2.bold())
            Spacer()
            HStack(spacing: 16) {
                Image(systemName: "text.magnifyingglass")
                Image(systemName: "phone")
                Image(systemName: "line.3.horizontal")
            }
            .font(.title2)
        }
        .padding()
        .background(Color("Background").opacity(0.9))
    }
    
    @MainActor
    private func sendChat() {
        guard !textFieldText.isEmpty else { return }
        
        Task {
            await chatVm.saveChat(chatId: chatId, text: textFieldText, userId: authVm.getCurrentUserID())
            self.textFieldText = ""
            if let proxy = self.scrollViewProxy {
                self.scrollToLast(proxy: proxy)
            }
            
        }
    }
    
    private func scrollToLast(proxy: ScrollViewProxy, smooth: Bool = false) {
        if let lastChat = chatVm.chats.last {
            if smooth {
                withAnimation(.easeInOut) {
                    proxy.scrollTo(lastChat.id, anchor: .bottom)
                }
            } else {
                proxy.scrollTo(lastChat.id, anchor: .bottom)
            }
        }
    }
}

//#Preview {
//    class MockChatRepository: ChatRepositoryProtocol {
//        func fetchChats(chatId: String) -> AsyncStream<[Chat]> {
//            <#code#>
//        }
//        
//        func fetchChats(chatId: String) async throws -> [Chat] {
//            return [
//                Chat(id: "1", userId: "user1", chatId: "1", text: "Hello", date: Date(), readed: false),
//                Chat(id: "2", userId: "user2", chatId: "1", text: "Hi there？!", date: Date(), readed: false)
//            ]
//        }
//        
//        func saveChat(chatId: String, text: String, userId: String) async throws {}
//        func updateChatList(chatId: String, lastChat: String, lastDate: Date) async throws {}
//    }
//    
//    class MockUserRepository: UserRepositoryProtocol {
//        func startListeningForUserChanges(userId: String) -> AsyncStream<User?> {
//            <#code#>
//        }
//        
//        func updateUser(userId: String, name: String?, image: String?) async throws {
//            <#code#>
//        }
//        
//        func fetchUserImageURL(userId: String) async throws -> String? {
//            return "https://example.com/user.jpg"
//        }
//    }
//    
//    let chatId = "1"
//    let title = "Test Chat"
//    let authViewModel = AuthViewModel()
//    let chatRepository = MockChatRepository()
//    let userRepository = MockUserRepository()
//    
//    return ChatView(
//        chatId: chatId,
//        title: title,
//        viewModel: authViewModel,
//        chatRepository: chatRepository,
//        userRepository: userRepository
//    )
//}
