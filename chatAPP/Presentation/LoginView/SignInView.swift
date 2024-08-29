import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Sign In") {
                    Task {
                        await viewModel.signIn(email: email, password: password)
                    }
                }
                .padding(.top, 16)

                if viewModel.isAuthenticated {
                    // ログイン後のページに遷移
                    ChatListScreen(authVm: viewModel)
                }

                // 新規登録画面への遷移ボタン
                NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                    Text("Create Account")
                        .padding(.top, 16)
                }
                // パスワードのリセットページへ移動する
                NavigationLink(destination: ResetPasswordView(viewModel: viewModel)) {
                    Text("Password Reset")
                        .padding(.top, 16)
                }
            }
        }
    }
}

#Preview("Authenticated State") {
    SignInView(viewModel: MockAuthViewModel())
        .previewLayout(.sizeThatFits)
}
// プレビュー用のAuthViewModel
class MockAuthViewModel: AuthViewModel {
    @Published var isAuthenticated2 = false
    @Published var userID2: String?
}
