import SwiftUI
import Dependencies

struct SignInScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @Dependency(\.authViewModel) var viewModel

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
                .onTapGesture {
                    if viewModel.isAuthenticated {
                        // ログイン後のページに遷移
                        ChatListScreen()
                    }
                }
                // 新規登録画面への遷移ボタン
                NavigationLink(destination: SignUpScreen(viewModel: viewModel)) {
                    Text("Create Account")
                        .padding(.top, 16)
                }
                // パスワードのリセットページへ移動する
                NavigationLink(destination: ResetPasswordScreen(viewModel: viewModel)) {
                    Text("Password Reset")
                        .padding(.top, 16)
                }
            }
        }
    }
}

