import SwiftUI

struct ChatListScreen: View {
    @ObservedObject var authVm: AuthViewModel
    @StateObject var chatListVm: ChatListViewModel
    @StateObject var userVm: UserViewModel
    
    init(authVm: AuthViewModel) {
        self.authVm = authVm
        let userRepository = UserRepository()
        let chatListRepository = ChatListRepository()
        _userVm = StateObject(wrappedValue: UserViewModel(userRepository: userRepository))
        _chatListVm = StateObject(wrappedValue: ChatListViewModel(chatListRepository: chatListRepository))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                header
                
                Divider()
                
                profileSection
                
                Divider()
                
                Text("Chat List")
                
                list
            }
            .padding(.horizontal)
            .onAppear {
               startListeningForUserChanges()
               fetchChatList()
           }
        }
    }
}

extension ChatListScreen {
    private var header: some View {
        HStack {
            Text("トーク")
                .font(.title2.bold())
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "text.badge.checkmark")
                VStack {
                    Button(action: {
                        chatListVm.showNewChatListPopup()
                    }) {
                        Image(systemName: "plus.square.fill")
                            .accentColor(.black)
                    }
                    .sheet(isPresented: $chatListVm.showingNewChatListPopup) {
                        NewChatListPopup(viewModel: chatListVm) {
                            Task {
                                await chatListVm.saveChatList(chatListTitle: chatListVm.chatListName)
                            }
                        }
                        .presentationDetents([.medium])
                    }
                    Text("NewChat")
                        .font(.caption2)
                }
                
                VStack() {
                    Button(action: {
                        authVm.signOut()
                    }) {
                        Image(systemName: "house.fill")
                            .accentColor(.black)
                    }
                    Text("LogOut")
                        .font(.caption2)
                }
            }
            .font(.title2)
        }
    }
    
    private var profileSection: some View {
        VStack {
            Button(action: { chatListVm.toggleProfileExpanded() }) {
                HStack {
                    Text("Profile Setting")
                    Spacer()
                    Image(systemName: chatListVm.isProfileExpanded ? "chevron.up" : "chevron.down")
                }
            }
            .padding(.vertical, 8)
            
            if chatListVm.isProfileExpanded {
                ProfileSettingForm(authVm: authVm, chatListVm: chatListVm, userVm: userVm)
            }
        }
    }
    
    private var list: some View {
        List {
            ForEach(chatListVm.chatList) { chat in
                NavigationLink(destination: ChatView(chatId: chat.id ?? "",title: chat.title, viewModel: authVm, chatRepository: ChatRepository(), userRepository: UserRepository())) {
                    ChatListRow(chatList: chat)
                }
                .frame(height: 80)
                .listRowInsets(EdgeInsets())
            }
            
            .onDelete(perform: remove)
        }
        .listStyle(PlainListStyle())
        .listStyle(.grouped)
    }
    
    private func remove(at offsets: IndexSet) {
        offsets.forEach { index in
            guard let id = chatListVm.chatList[index].id else { return }
            Task {
                await chatListVm.deleteDocument(documentId: id)
            }
        }
    }
    
    private func fetchChatList() {
        Task {
            await chatListVm.fetchChatList()
        }
    }
    
    private func startListeningForUserChanges() {
        Task {
            await userVm.startListeningForUserChanges(userId: authVm.getCurrentUserID())
        }
    }
}
#Preview {
    ChatListScreen(authVm: AuthViewModel())
}

