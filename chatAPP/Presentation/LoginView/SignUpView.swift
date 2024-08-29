import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign Up") {
                Task {
                    await viewModel.signUp(email: email, password: password)
                }
            }

            if viewModel.isAuthenticated {
                // ログイン後のページに遷移
                if viewModel.isAuthenticated {
                    ChatListScreen(authVm: viewModel)
                }
            }
        }
    }
}
