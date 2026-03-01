# Caregiver 実機テスト マトリクス

**作成日:** 2026-02-28
**対象バージョン:** 1.0.0+1
**テスト環境:** 実機 2台 (iOS + Android または同一プラットフォーム 2台)

---

## テスト環境準備

### 必要なもの

| 項目 | 内容 |
|------|------|
| 端末 A | Patient 役 (iPhone 推奨) |
| 端末 B | Caregiver 役 (Android または別の iPhone) |
| Firebase アカウント | **異なる** 2つのアカウント (Google または Apple) |
| アプリインストール | 両端末ともインストール済み |

### アプリ実行

```bash
flutter devices                    # 接続デバイス一覧
flutter run -d <端末A_ID>          # ターミナル 1
flutter run -d <端末B_ID>          # ターミナル 2
```

### 結果記入方法

| 記号 | 意味 |
|------|------|
| ✅ | 期待結果と一致 |
| ❌ | 期待結果と異なる |
| ⚠️ | 一部異なる (備考記入) |
| ⏭️ | スキップ (理由記入) |

---

## グループ 1: アカウント作成

> **前提:** 両端末ともアプリ未ログイン状態

### TC-01: 端末 A — Patient アカウント作成

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A アプリ起動 | SplashScreen → LoginScreen 表示 | | |
| 2 | 言語選択 (English / 日本語) 確認 | 2つのボタン表示、タップで切り替え | | |
| 3 | "Sign in with Google" または "Sign in with Apple" タップ | システム認証ダイアログ表示 | | |
| 4 | **アカウント A** でログイン完了 | OnboardingScreen → Role 選択ステップへ | | |
| 5 | Role 選択: "Patient" | 次のステップへ遷移 | | |
| 6 | 名前入力 (任意 — スキップ可能) | 次のステップへ遷移 | | |
| 7 | Timezone 選択 (自動検知または手動選択) | 次のステップへ遷移 | | |
| 8 | 通知権限を許可 | HomeScreen 表示 | | |

### TC-02: 端末 B — Caregiver アカウント作成

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B アプリ起動 | SplashScreen → LoginScreen 表示 | | |
| 2 | **アカウント B** (A と異なる) でログイン | 認証完了 → OnboardingScreen へ | | |
| 3 | Role 選択: "Caregiver" | 次のステップへ遷移 (一包化ステップはスキップ) | | |
| 4 | 名前入力 (**必須** — 2文字以上) | Next ボタン有効化、次のステップへ | | |
| 5 | Timezone + 通知権限 | オンボーディング完了 | | |
| 6 | 結果確認 | CaregiverDashboardScreen 表示 ("My Patients") | | |

---

## グループ 2: Patient データ準備

> **前提:** TC-01 完了、端末 A が HomeScreen にある

### TC-03: 端末 A に服薬データ作成

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 下部タブ "Medications" タップ | MedicationsListScreen 表示 | | |
| 2 | "+" ボタンタップ | AddMedicationScreen 表示 | | |
| 3 | 薬名入力 (例: "ロキソニン") | テキスト入力完了 | | |
| 4 | 薬の色・形状選択 | 選択反映 | | |
| 5 | "Save" タップ | ScheduleScreen へ自動遷移 | | |
| 6 | 服薬タイミング選択 (例: Morning) | 時間調整セクション表示 | | |
| 7 | "Continue" タップ | 薬一覧に戻り、追加した薬が表示 | | |
| 8 | HomeScreen に戻る | 今日のタイムラインに薬が表示 | | |

---

## グループ 3: 招待 — QR コードスキャン

> **前提:** TC-01 ~ TC-03 完了

### TC-04: Patient が招待 QR コードを生成

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A → 下部タブ "Settings" | SettingsScreen 表示 | | |
| 2 | "Family & Caregivers" タップ | FamilyScreen 表示 | | |
| 3 | "Linked Caregivers" セクション確認 | "No caregivers linked" Empty State 表示 | | |
| 4 | "Generate Invite Link" ボタンタップ | ローディング → QR コード生成 | | |
| 5 | QR コード表示確認 | 200×200 QR 画像 + `Code: XXXXXXXX` テキスト表示 | | |
| 6 | 共有ボタン確認 | Link (コピー), LINE, Email, SMS の 4 ボタン表示 | | |
| 7 | "Invite link generated" スナックバー確認 | 緑色スナックバー表示 | | |

### TC-05: Caregiver が QR コードをスキャンして連結

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → CaregiverDashboardScreen (Empty State) | "Scan QR Code" ボタン表示 | | |
| 2 | "Scan QR Code" ボタンタップ | カメラ権限要求ダイアログ表示 | | |
| 3 | カメラ権限「許可」タップ | QrScannerScreen 表示、カメラビュー起動 | | |
| 4 | 中央ガイドボックス確認 | 250×250 スキャンエリアオーバーレイ表示 | | |
| 5 | 下部案内テキスト確認 | スキャン操作説明テキスト表示 | | |
| 6 | 端末 B を端末 A の QR コードに向ける | 自動スキャン → "Processing invite..." 表示 | | |
| 7 | Cloud Function 呼び出し待機 | "Successfully linked" 緑色スナックバー表示 | | |
| 8 | 端末 B ダッシュボード確認 | Patient カードに "田中 花子" (端末 A の名前) 表示 | | |
| 9 | 端末 A → FamilyScreen 確認 | "Linked Caregivers" セクションに Caregiver 名表示、"Connected" バッジ | | |

---

## グループ 4: 招待 — リンク共有

> **前提:** TC-01 ~ TC-02 完了。TC-04/05 で連結済みの場合は先に Revoke してから実施

### TC-06: リンクコピー後の手動受諾

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A → FamilyScreen → "Generate Invite Link" | QR + コード表示 | | |
| 2 | Link アイコン (チェーンマーク) タップ | "Link copied" スナックバー表示、クリップボードに URL 保存 | | |
| 3 | 端末 A → 別アプリ (メモ等) 実行 | アプリ切り替え | | |
| 4 | クリップボード貼り付け → URL 確認 | `https://mypill.app/invite/{code}` 形式 | | |
| 5 | URL を端末 B へ送信 (AirDrop/メッセージ/直接入力) | 端末 B で URL 受信 | | |
| 6 | 端末 B で URL をタップ | InviteHandlerScreen 表示 | | |
| 7 | 招待コード表示確認 | "Code: XXXXXXXX" テキスト表示 | | |
| 8 | "Accept Invitation" ボタンタップ | ローディングスピナー表示 | | |
| 9 | 連結完了確認 | "Successfully linked" スナックバー → `/home` へ遷移 | | |

### TC-07: 共有シートによる送信

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A FamilyScreen → QR 生成後 "LINE" アイコンタップ | システム共有シート (Share Sheet) 表示 | | |
| 2 | 共有シートでアプリ選択 (メッセージ, LINE 等) | アプリが開き URL が添付される | | |
| 3 | 端末 B でメッセージ受信 → URL タップ | InviteHandlerScreen 表示 | | |
| 4 | "Accept Invitation" タップ → 連結完了 | "Successfully linked" スナックバー | | |

---

## グループ 5: Caregiver ダッシュボード — リアルタイム監視

> **前提:** 端末 A (Patient) と端末 B (Caregiver) が連結済み

### TC-08: Caregiver ダッシュボード基本表示

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → 下部タブ Patients 選択 | CaregiverDashboardScreen 表示 | | |
| 2 | "My Patients" ヘッダー確認 | タイトル表示 | | |
| 3 | PatientDataCard 確認 | 端末 A の Patient 名 + アバター表示 | | |
| 4 | 今日の服薬状態確認 | TC-03 で追加した薬 + ステータスバッジ (pending/taken/missed) 表示 | | |
| 5 | 服薬率 (%) 確認 | 数値 % 表示 | | |

### TC-09: リアルタイム服薬状態更新

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → CaregiverDashboardScreen を開いた状態 | Patient カードの服薬状態表示中 | | |
| 2 | 端末 A → HomeScreen でリマインダーのチェックボタンタップ | アクションダイアログ表示 | | |
| 3 | "Take Now" 選択 | 端末 A HomeScreen バッジ更新 ("Taken") | | |
| 4 | 端末 B ダッシュボード確認 (10 秒以内) | 該当薬のバッジが "Taken" (緑) に更新 | | |

---

## グループ 6: Caregiver タブ画面

### TC-10: Notifications 画面

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → 下部タブ Notifications | CaregiverNotificationsScreen 表示 | | |
| 2 | 画面内容確認 | ベルアイコン + "No notifications yet" + 説明文表示 | | |
| 3 | Empty State UI 確認 | 正常レンダリング (現在プレースホルダー) | | |

### TC-11: Alerts 画面

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → 下部タブ Alerts | CaregiverAlertsScreen 表示 | | |
| 2 | Empty State 確認 | 警告アイコン + "Alerts" タイトル + "Alerts will appear here" 表示 | | |
| 3 | "Missed Dose" カード確認 | 赤アイコン + タイトル + 説明文表示 | | |
| 4 | "Low Stock" カード確認 | 青アイコン + タイトル + 説明文表示 | | |

### TC-12: タブ間ナビゲーション

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | Patients → Notifications → Alerts → Settings | 全 4 タブ正常遷移 | | |
| 2 | Settings → Patients に戻る | ダッシュボード再表示、状態維持 | | |

---

## グループ 7: Caregiver Settings

### TC-13: 言語切り替え

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → Settings → Language セクション | English / 日本語 ボタン表示 | | |
| 2 | 日本語タップ | UI が日本語に切り替わる | | |
| 3 | English タップ | UI が英語に切り替わる | | |

### TC-14: 通知設定トグル

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → Settings → Notifications セクション | "Missed Dose Alerts" トグル表示 | | |
| 2 | トグル OFF → ON | スイッチ状態変更 + 設定保存 | | |
| 3 | アプリ再起動 → Settings 再表示 | トグル状態が維持されている | | |
| 4 | "Low Stock Alerts" トグル ON/OFF | 同様に保存される | | |

### TC-15: Patient ビューへ切り替え

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → Settings → "Switch to Patient View" | HomeScreen (`/home`) へ遷移 | | |
| 2 | 下部タブ確認 | Patient タブ (Home / Adherence / Medications / Settings) 表示 | | |
| 3 | 端末 B の Patient 画面閲覧 | 端末 B 自身の薬データ表示 (または空状態) | | |

### TC-16: Sign Out

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → Settings → "Sign Out" (赤文字) | 確認ダイアログ表示 | | |
| 2 | "Sign Out" ボタンタップ | ログアウト処理 | | |
| 3 | 結果確認 | LoginScreen へ遷移 | | |
| 4 | 端末 A FamilyScreen 確認 | Caregiver リンクは**維持** (ログアウトはリンク削除ではない) | | |

### TC-17: Deactivate Account

> **注意:** 実際のアカウント非活性化 — テスト用アカウント使用推奨

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → Settings → "Deactivate Account" | 確認ダイアログ表示 | | |
| 2 | ダイアログ内容確認 | 非活性化警告メッセージ表示 | | |
| 3 | "Deactivate" ボタンタップ | Caregiver リンク全解除 → ログアウト | | |
| 4 | 端末 A → FamilyScreen 確認 | Caregiver リンク一覧から該当 Caregiver 削除 | | |

### TC-18: Delete Account

> **注意:** 永久削除 — 必ずテスト用アカウントで実施

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → Settings → "Delete Account" | 1次確認ダイアログ表示 | | |
| 2 | "Continue" タップ | 2次確認ダイアログ表示 | | |
| 3 | "Delete Everything" タップ | 再認証要求 (Apple/Google 再ログイン) | | |
| 4 | 再認証完了 | Cloud Function `deleteUserAccount` 呼び出し → ログアウト | | |
| 5 | 端末 A FamilyScreen 確認 | 該当 Caregiver リンク自動削除 | | |
| 6 | Firebase Console 確認 | `caregiverAccess/{uid}` 配下のドキュメント全削除 | | |

---

## グループ 8: アクセス権限取消 (Revoke)

> **前提:** 端末 A, B が連結済み

### TC-19: Patient が Caregiver アクセスを取消

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A → Settings → Family & Caregivers | FamilyScreen: Caregiver 一覧表示 | | |
| 2 | Caregiver カードのポップアップメニュー → "Revoke Access" タップ | 確認ダイアログ表示 | | |
| 3 | ダイアログ内容確認 | "Revoke access from {名前}?" メッセージ表示 | | |
| 4 | "Cancel" タップ | ダイアログ閉じる、リンク維持 | | |
| 5 | 再度 "Revoke Access" タップ | ダイアログ再表示 | | |
| 6 | "Revoke" 確認タップ | "Access revoked successfully" 緑色スナックバー | | |
| 7 | 端末 A FamilyScreen 確認 | Caregiver 一覧が空 (Empty State) | | |
| 8 | 端末 B → Caregiver ダッシュボード確認 | Patient カード消失 (空ダッシュボード) | | |

---

## グループ 9: エッジケース

### TC-20: 自己招待受諾の試行

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A で招待リンクを生成 | QR + URL 生成 | | |
| 2 | **端末 A 自身で同じ招待コードを受諾** | "Cannot accept your own invite" エラー | | |
| 3 | エラースナックバー表示確認 | 赤色エラーメッセージ表示 | | |

### TC-21: 使用済みコードの再利用

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | TC-05/06 で受諾済みのコードをメモ | コードメモ | | |
| 2 | Revoke 後に同じコードで再受諾を試行 | "Invite already used" エラー表示 | | |

### TC-22: 無効な QR コードのスキャン

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B → QrScannerScreen に入る | カメラビュー表示 | | |
| 2 | mypill.app ドメイン以外の QR コードをスキャン | **無反応** (スキャン無視) | | |
| 3 | アプリクラッシュなし確認 | カメラ正常稼働継続 | | |

### TC-23: Rate Limit 確認

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A → FamilyScreen で 1 分以内に "Generate Invite Link" を 6 回以上タップ | 最初 5 回: 成功 | | |
| 2 | 6 回目のタップ | "Too many requests. Please try again later." エラー表示 | | |

### TC-24: ネットワークオフライン状態

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A を機内モードに設定 | ネットワーク遮断 | | |
| 2 | FamilyScreen → "Generate Invite Link" タップ | エラースナックバー表示 ("Failed to generate invite") | | |
| 3 | 機内モード解除 | 再試行で正常動作 | | |

### TC-25: InviteHandlerScreen — Decline ボタン

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 B で招待リンクを開く | InviteHandlerScreen 表示 | | |
| 2 | "Decline" ボタンタップ | 画面を閉じて `/home` へ遷移 | | |
| 3 | 端末 A FamilyScreen 確認 | Caregiver リンク未生成 (Empty State のまま) | | |

---

## グループ 10: Patient アカウント削除時の連動解除

> **注意:** 永久削除 — 必ずテスト用アカウントで実施

### TC-26: Patient アカウント削除後の Caregiver データ整理

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末 A, B 連結済み確認 | 端末 B ダッシュボードに Patient 表示 | | |
| 2 | 端末 A → Settings → Delete Account | 2段階確認 → 再認証 | | |
| 3 | 削除完了 | 端末 A → LoginScreen へ遷移 | | |
| 4 | 端末 B ダッシュボード確認 | Patient カード消失 | | |
| 5 | Firebase Console → `caregiverAccess/{端末B_uid}/patients/{端末A_uid}` | ドキュメントなし確認 | | |
| 6 | Firebase Console → `users/{端末A_uid}` | ドキュメントなし確認 | | |

---

## チェックリスト

テスト完了後、全項目の通過を確認:

### 連結フロー
- [ ] QR スキャンで連結成功 (TC-05)
- [ ] リンクコピー → 手動受諾で連結成功 (TC-06)
- [ ] 共有シートによる連結成功 (TC-07)
- [ ] 連結後に端末 A FamilyScreen で Caregiver 名 + "Connected" バッジ表示

### モニタリング
- [ ] Caregiver ダッシュボードに Patient カード表示 (TC-08)
- [ ] 服薬状態リアルタイム更新 (TC-09)
- [ ] Notifications 画面 Empty State 正常表示 (TC-10)
- [ ] Alerts 画面タイプカード正常表示 (TC-11)

### 設定
- [ ] 言語切り替え動作 (TC-13)
- [ ] 通知トグル保存・再起動後維持 (TC-14)
- [ ] Patient ビュー切り替え動作 (TC-15)
- [ ] Sign Out 後 LoginScreen 遷移 (TC-16)

### 権限取消
- [ ] Revoke ダイアログ表示・キャンセル動作 (TC-19)
- [ ] Revoke 後に端末 A 一覧から削除 (TC-19)
- [ ] Revoke 後に端末 B ダッシュボードから Patient 削除 (TC-19)

### エッジケース
- [ ] 自己招待受諾時エラー表示 (TC-20)
- [ ] 使用済みコードエラー表示 (TC-21)
- [ ] 無効 QR スキャン時に無視 — クラッシュなし (TC-22)
- [ ] オフライン状態のエラー処理 (TC-24)
- [ ] Decline ボタンで招待拒否 (TC-25)

### アカウント削除
- [ ] Caregiver Deactivate → Patient 側リンク削除 (TC-17)
- [ ] Caregiver Delete → 全データ削除 (TC-18)
- [ ] Patient Delete → Caregiver ダッシュボードから削除 (TC-26)

---

## 既知の制約事項

| 項目 | 内容 |
|------|------|
| Notifications 画面 | Empty State のみ表示 (実際の通知フィード未実装) |
| Alerts 画面 | アラートタイプの説明のみ表示 (ライブデータフィード未実装) |
| ディープリンク | `mypill.app` ドメインの実際のアプリ連結設定が必要。未設定時はブラウザで開く |
| QR スキャン | シミュレータ不可、実機必須 |
| Rate Limit | 1 分あたり 5 回制限、テスト時は間隔調整が必要 |
| kPremiumEnabled | 現在 `false` — Caregiver スロット数制限 UI 非表示 |
| Anonymous ユーザー | 匿名ログインでは Cloud Functions (招待/受諾) が動作しない可能性あり |
