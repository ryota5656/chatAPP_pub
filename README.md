基本構成<br>
chatAPP<br>
├── ChatApp.swift<br>
├── Presentation //VおよびVMを管理<br>
├── Data<br>
│  └─── Repositories　//FireBaseとのやりとりを担当<br>
├── Domain<br>
│  └──Entities　//モデル<br>
├── DI　//Dependencies<br>
├── previewContent <br>
│  ├─── DI //DependenciesPreview用<br>
│  └─── Data //Mock<br>
その他 <br>
<br>
<br>
【追加した機能】<br>
ログイン機能を含めたチャット機能の作成<br>
<br>
【詳細】<br>
ログイン機能<br>
・firebaseのAuthenticationを使用した認証機能<br>
　-　サインイン<br>
　-　ログアウト<br>
　-　サインアップ（力を入れて実装していません）<br>
　-　パスワードリセット（力を入れて実装していません）<br>
<br>
プロフィール機能<br>
・firebaseのfirestoreを使用したプロフィール情報の設定機能<br>
　-　プロフィール名の設定<br>
　-　プロフィール画像の設定<br>
<br>
チャット機能<br>
・firebaseのfirestoreを使用したチャットリスト・チャット機能<br>
　-　チャットリスト（一覧）<br>
　　-  新規チャットリストの表示<br>
　　-  新規チャットリストの登録<br>
　　-  新規チャットリストの削除<br>
　-　チャット<br>
　　- チャットの投稿（※画像の投稿などの機能つけていません）<br>
<br>
<br>
ログイン画面<br>
![ログイン画面](https://github.com/user-attachments/assets/4fc7cafd-f4de-42c2-acc2-6c0fb9d5739b)<br>
チャット一覧画面<br>
![チャット一覧画面](https://github.com/user-attachments/assets/59d18a10-9825-4aeb-b502-4e8db8662d72)<br>
新規チャット作成画面<br>
![新規チャット作成画面](https://github.com/user-attachments/assets/82159cef-6406-4174-9e52-a315d477f6ff)<br>
チャット画面<br>
![チャット画面](https://github.com/user-attachments/assets/efe1c60b-840d-4eb0-a910-562c5a2db134)<br>

