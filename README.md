【追加した機能】
ログイン機能を含めたチャット機能の作成

【詳細】
ログイン機能
・firebaseのAuthenticationを使用した認証機能
　-　サインイン
　-　ログアウト
　-　サインアップ（力を入れて実装していません）
　-　パスワードリセット（力を入れて実装していません）

プロフィール機能
・firebaseのfirestoreを使用したプロフィール情報の設定機能
　-　プロフィール名の設定
　-　プロフィール画像の設定

チャット機能
・firebaseのfirestoreを使用したチャットリスト・チャット機能
　-　チャットリスト（一覧）
　　-  新規チャットリストの表示
　　-  新規チャットリストの登録
　　-  新規チャットリストの削除
　-　チャット
　　- チャットの投稿（※画像の投稿などの機能つけていません）

【特にレビューしていただきたい点】
MVVMに沿った実装ができているか
チャットリストからチャットへの遷移時のデータのやり取りは適切か（@StateObjectや@ObservedObject使い方は正しいかなど）
firebaseからデータと取得した際のデータの保存・使用のしかたは適切か
上記のようなUIやデザインというのよりはビジネスロジックを中心に見ていただけれたら幸いです。

ログイン画面
![ログイン画面](https://github.com/user-attachments/assets/4fc7cafd-f4de-42c2-acc2-6c0fb9d5739b)
チャット一覧画面
![チャット一覧画面](https://github.com/user-attachments/assets/59d18a10-9825-4aeb-b502-4e8db8662d72)
新規チャット作成画面
![新規チャット作成画面](https://github.com/user-attachments/assets/82159cef-6406-4174-9e52-a315d477f6ff)
チャット画面
![チャット画面](https://github.com/user-attachments/assets/efe1c60b-840d-4eb0-a910-562c5a2db134)

