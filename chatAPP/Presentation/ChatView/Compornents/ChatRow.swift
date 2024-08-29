import SwiftUI

struct ChatRow: View {
    
    let currentUserId: String
    let chat: Chat
    @Binding var userImageURL: String?
    
    var body: some View {
        HStack(alignment: .top) {
            if chat.userId == currentUserId {
                Spacer()
                currentUserChatState
                currentUserChatText
            } else {
                userThumb
                chatText
                chatState
                Spacer()
            }
        }
        .padding(.bottom)
        .onAppear {
            
        }
    }
}

extension ChatRow {
    private var userThumb : some View {
        AsyncImage(url: URL(string: userImageURL ?? "")) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
        } placeholder: {
            Image("defaultUserImage")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
        }
    }
    
    private var chatText: some View {
        Text(chat.text)
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .foregroundColor(.primary)
            .cornerRadius(30)
    }
    
    private var currentUserChatText: some View {
        Text(chat.text)
            .padding()
            .background(Color("Bubble"))
            .foregroundColor(.black)
            .cornerRadius(30)
    }
    
    private var chatState: some View {
        VStack(alignment: .trailing) {
            Spacer()
            Text(formattedDateString)
        }
        .foregroundColor(.secondary)
        .font(.footnote)
    }
    
    private var currentUserChatState: some View {
        VStack(alignment: .trailing) {
            Spacer()
            if chat.readed {
                Text("既読")
            }
            Text(formattedDateString)
        }
        .foregroundColor(.secondary)
        .font(.footnote)
    }
    
    private var formattedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: chat.date)
    }
}
