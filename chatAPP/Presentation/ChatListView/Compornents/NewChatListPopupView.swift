import SwiftUI

struct NewChatListPopup: View {
    @ObservedObject var viewModel: ChatListViewModel
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Chat List Name", text: $viewModel.chatListName)
            }
            .navigationBarTitle("New Chat List", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    viewModel.showingNewChatListPopup = false
                    viewModel.resetChatListName()
                },
                trailing: Button("Save") {
                    onSave()
                    viewModel.showingNewChatListPopup = false
                }
                .disabled(viewModel.chatListName.isEmpty)
            )
        }
    }
}
