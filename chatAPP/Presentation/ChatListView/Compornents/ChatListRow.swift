import SwiftUI

struct ChatListRow: View {
    var chatList: ChatList
    
    var body: some View {
        listRow
    }
    
    private var listRow : some View {
        HStack {
            let images = "user01"
            
            // いつかimageを複数横並びに表示させる
            HStack(spacing: -28) {
                Image(images)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .background(
                        Circle()
                            .foregroundColor(Color(uiColor: .systemBackground))
                            .frame(width: 54, height: 54)
                    )
                
            }
            VStack(alignment: .leading) {
                Text(chatList.title)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                Text(chatList.lastChat ?? "")
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            Spacer()
            Text(formattedDateString(chatList.lastDate))
                .font(.caption)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
    
    func formattedDateString(_ date: Date?) -> String {
        if let formatDate = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: formatDate)
        }
        return ""
    }
}

#Preview {
    ChatListRow(chatList: ChatList(id: "1", title: "title", lastChat: "lastChat", lastDate: Date(), userIds: []))
}
