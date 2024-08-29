import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Reset Password") {
                Task {
                    await viewModel.resetPassword(email: email)
                }
            }
        }
    }
}
