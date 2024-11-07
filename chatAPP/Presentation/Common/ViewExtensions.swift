import SwiftUI

// custom modifierを定義
extension View {
    @ViewBuilder
    func visible(_ visible: Bool) -> some View {
        if visible {
            self // 表示の場合はそのままViewを返す
        } else {
            EmptyView() // 非表示の場合はEmptyViewを返す
        }
    }
}
