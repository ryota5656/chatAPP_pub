import SwiftUI

struct ProfileSettingForm: View {
    @ObservedObject var authVm: AuthViewModel
    @ObservedObject var chatListVm: ChatListViewModel
    @ObservedObject var userVm: UserViewModel
    
    var body: some View {
        userProfile
        setUserName
        setUserImage
    }
    
    private var userProfile: some View {
        HStack {
            AsyncImage(url: URL(string: userVm.currentUser?.image ?? "")) { image in
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
            VStack {
                Text(userVm.currentUser?.name ?? "未設定")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
    }
    
    private var setUserName: some View {
        HStack {
            Text("name")
            TextField("userName", text: $userVm.textFieldText)
                .onSubmit {
                    sendUserName()
                }
            Spacer()
        }
    }
    
    private var setUserImage: some View {
        HStack {
            Text("imageURL")
            TextField("imageURL", text: $userVm.imageFieldText)
                .onSubmit {
                    Task {
                        await sendUserImage()
                    }
                }
            Spacer()
        }
    }
    
    @MainActor
    func sendUserName() {
        Task {
            await userVm.updateUser(userId:authVm.getCurrentUserID())
        }
    }
    
    @MainActor
    func sendUserImage() async {
        Task {
            await userVm.updateUser(userId:authVm.getCurrentUserID())
        }
    }
}
