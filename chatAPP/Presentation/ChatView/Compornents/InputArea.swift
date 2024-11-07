import SwiftUI

struct InputArea: View {
    //Bindingを使うことで親ビューのtextFieldTextに値を入れる
    @Binding var textFieldText: String
    @FocusState private var textFieldFocused: Bool
    // クロージャーでsubmitを押したときに引数で入れたonSend: sendChatのsendChatが呼び出される
    var onSend: () -> Void
    
    var body: some View {
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
                    onSend()
                }
                .focused($textFieldFocused)
            Image(systemName: "mic")
                .font(.title2)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview{
    InputArea(textFieldText: .constant(""), onSend: {})
}

