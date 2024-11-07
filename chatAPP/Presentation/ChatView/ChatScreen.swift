import SwiftUI

struct ChatScreen: View {
    @EnvironmentObject var authVm: AuthViewModel
    @StateObject var chatVm: ChatViewModel
    
    // UIに強く依存しているためscreen内で記述
    @State private var textFieldText: String = ""
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            chatArea
                .overlay(NavigationArea(chatVm: chatVm), alignment: .top)
            InputArea(textFieldText: $textFieldText, onSend: sendChat)
        }
        .task {
            await chatVm.fetchChats(chatId: chatVm.chatId)
        }
        .onChange(of: chatVm.chats) {
            print("messageData changed: \(chatVm.chats)")
        }
        .navigationBarHidden(true)
    }
}

extension ChatScreen {
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
                    .onAppear {
                        self.scrollViewProxy = proxy
                        scrollToLast(proxy: proxy)
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
        }
    }
    
    @MainActor
    private func sendChat() {
        guard !textFieldText.isEmpty else { return }
        
        Task {
            await chatVm.saveChat(chatId: chatVm.chatId, text: textFieldText, userId: authVm.getCurrentUserID())
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

#Preview {
    ChatScreen(chatVm: ChatViewModel(chatId: "1", title: "Preview Chat"))
        .environmentObject(AuthViewModel())
}
