# Travel Mode E2E テストシナリオ

**作成日:** 2026-02-28
**対象バージョン:** 1.0.0+1
**対象画面:** `/settings/travel` (`TravelModeScreen`)

---

## 結果記入方法

| 記号 | 意味 |
|------|------|
| ✅ | 期待結果と一致 |
| ❌ | 期待結果と異なる |
| ⚠️ | 一部異なる (備考記入) |
| ⏭️ | スキップ (理由記入) |

---

## セクション 1: 自動テスト (integration_test)

> `flutter test integration_test/flows/travel_mode_test.dart` で実行可能。
> 実機またはシミュレータ接続が必要。

### 前提条件

- `buildPatientTestApp` で `TravelModeScreen` (実画面) をルーティング
- `TravelModeRobot` (Page Object) を用意
- `timezoneSettingsProvider` はデフォルト状態 (enabled: false, mode: fixedInterval)

---

### グループ 1: ナビゲーション

#### TM-01: Settings → Travel Mode 画面遷移

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | `buildPatientTestApp(TestAppConfig.patient())` で起動 | SettingsScreen 表示 | | |
| 2 | "Travel Mode" ListTile までスクロール | ListTile 表示 (flight_takeoff アイコン) | | |
| 3 | "Travel Mode" タップ | TravelModeScreen へ遷移 | | |
| 4 | AppBar タイトル確認 | "Travel Mode" テキスト表示 | | |

---

### グループ 2: 初期状態 (disabled)

#### TM-02: 初期状態 — トグル OFF、条件部 UI 非表示

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | TravelModeScreen を開く | 画面表示 | | |
| 2 | "Enable Travel Mode" トグル確認 | OFF 状態で表示 | | |
| 3 | LocationDisplay 確認 | **表示されている** (常時表示) | | |
| 4 | TimezoneModeSelector 確認 | **非表示** | | |
| 5 | "Affected Medications" ヘッダー確認 | **非表示** | | |
| 6 | AffectedMedList 確認 | **非表示** | | |
| 7 | "Consult your doctor" インフォボックス確認 | **非表示** | | |

#### TM-03: LocationDisplay — 常時表示項目

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | LocationDisplay カード確認 | MpCard 内に 3 行表示 | | |
| 2 | 現在地行確認 | `location_on` アイコン + "Current:" テキスト含む | | |
| 3 | 自宅行確認 | `home` アイコン + "Home:" テキスト含む | | |
| 4 | 時差行確認 | "Time difference:" テキスト含む | | |

---

### グループ 3: トグル ON/OFF

#### TM-04: トグル ON → 条件部 UI 表示

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | "Enable Travel Mode" トグルをタップ | ON に切り替わる | | |
| 2 | TimezoneModeSelector 確認 | **表示** — 2 つのラジオオプション | | |
| 3 | "Affected Medications" ヘッダー確認 | **表示** | | |
| 4 | "Consult your doctor" インフォボックス確認 | **表示** — `info` アイコン付き | | |

#### TM-05: トグル OFF → 条件部 UI 再非表示

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | TM-04 完了状態 (トグル ON) | 条件部 UI すべて表示中 | | |
| 2 | "Enable Travel Mode" トグルを再タップ | OFF に切り替わる | | |
| 3 | TimezoneModeSelector 確認 | **非表示** | | |
| 4 | "Affected Medications" ヘッダー確認 | **非表示** | | |
| 5 | "Consult your doctor" インフォボックス確認 | **非表示** | | |
| 6 | LocationDisplay 確認 | **表示のまま** (常時表示) | | |

---

### グループ 4: モード選択

#### TM-06: デフォルトモード = Fixed Interval

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | トグル ON にする | TimezoneModeSelector 表示 | | |
| 2 | "Fixed Interval (Home Time)" ラジオ確認 | **選択状態** (home アイコン) | | |
| 3 | "Local Time Adaptation" ラジオ確認 | **未選択状態** (wb_sunny アイコン) | | |

#### TM-07: Local Time モードに切り替え

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | "Local Time Adaptation" ラジオタップ | 選択状態に変更 | | |
| 2 | "Fixed Interval (Home Time)" 確認 | **未選択** に変更 | | |

#### TM-08: Fixed Interval に再切り替え

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | TM-07 完了状態 (Local Time 選択中) | | | |
| 2 | "Fixed Interval (Home Time)" ラジオタップ | 選択状態に変更 | | |
| 3 | "Local Time Adaptation" 確認 | **未選択** に変更 | | |

---

### グループ 5: 影響を受ける薬リスト — データあり

> **Config:** `TestAppConfig.patientWithMedications()`

#### TM-09: 薬 + スケジュールがある場合のリスト表示

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | `patientWithMedications` config で起動 → Travel Mode → トグル ON | AffectedMedList 表示 | | |
| 2 | Aspirin カード確認 | 薬名 "Aspirin" テキスト表示 | | |
| 3 | Blood Pressure Med カード確認 | 薬名 "Blood Pressure Med" テキスト表示 | | |
| 4 | Vitamin D カード確認 | 薬名 "Vitamin D" テキスト表示 | | |
| 5 | 各カード内の PillIcon 確認 | MpPillIcon ウィジェット表示 | | |

#### TM-10: 薬カードに時間 (home/local) 表示

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | TM-09 完了状態 | 薬カード表示中 | | |
| 2 | Aspirin カードの時間行確認 | "AM" または "PM" を含むテキスト表示 (2行: 08:00, 20:00) | | |
| 3 | 時間フォーマット確認 | `h:mm a` 形式 + タイムゾーンラベル含む | | |

---

### グループ 6: 影響を受ける薬リスト — データなし

> **Config:** `TestAppConfig.patient()` (薬なし)

#### TM-11: 薬がない場合の空状態

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 薬なし patient config → Travel Mode → トグル ON | AffectedMedList 表示領域 | | |
| 2 | Empty State 確認 | "No scheduled medications" テキスト表示 | | |

---

### グループ 7: インフォボックス

#### TM-12: 医師相談メッセージ表示

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | トグル ON 状態 | インフォボックス表示 | | |
| 2 | アイコン確認 | `Icons.info` 表示 | | |
| 3 | メッセージ確認 | "Consult your doctor" を含むテキスト表示 | | |

---

### 自動テスト サマリ

| グループ | テスト数 | 優先度 |
|---------|---------|--------|
| ナビゲーション | 1 | Critical |
| 初期状態 | 2 | Critical |
| トグル ON/OFF | 2 | Critical |
| モード選択 | 3 | High |
| 薬リスト (データあり) | 2 | High |
| 薬リスト (データなし) | 1 | High |
| インフォボックス | 1 | Medium |
| **合計** | **12** | |

---

## セクション 2: 手動テスト (実機操作)

> 実機のタイムゾーン変更、通知確認など、自動化できない項目。
> 実機 1 台で実施可能。

### テスト環境準備

| 項目 | 内容 |
|------|------|
| 端末 | iOS 実機 または Android 実機 |
| 前提 | Patient アカウント + 薬 2 件以上 + スケジュール設定済み |
| ビルド | `flutter run --release` (Release モード推奨) |

---

### グループ 8: 実タイムゾーン検出

#### TM-13: 端末のタイムゾーンが LocationDisplay に反映される

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末の設定 → 一般 → 日付と時刻 → タイムゾーン確認 | 例: Asia/Tokyo | | |
| 2 | アプリ → Settings → Travel Mode | TravelModeScreen 表示 | | |
| 3 | "Current:" 行を確認 | 端末のタイムゾーン都市名が表示 (例: "Tokyo") | | |
| 4 | "Home:" 行を確認 | UserProfile.homeTimezone の都市名が表示 | | |

#### TM-14: 端末のタイムゾーンを変更して再起動

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末の設定 → 日付と時刻 → 自動設定をOFF | 手動タイムゾーン選択モードへ | | |
| 2 | タイムゾーンを "America/New_York" (EST) に変更 | 端末時刻が EST に切り替わる | | |
| 3 | アプリを完全終了 → 再起動 | SplashScreen → HomeScreen | | |
| 4 | Settings → Travel Mode を開く | TravelModeScreen 表示 | | |
| 5 | "Current:" 行確認 | "New York" + EST オフセット表示 | | |
| 6 | 時差表示確認 | Home との時差が正しく計算 (例: "+14 hours" for Tokyo→NY) | | |
| 7 | **テスト後:** タイムゾーンを元に戻す (自動設定 ON) | 復旧確認 | | |

---

### グループ 9: 時間調整の目視確認

#### TM-15: Fixed Interval モード — 時間変換の正確性

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | Home=Asia/Tokyo, Current=America/New_York に設定 | 時差: -14 hours | | |
| 2 | トグル ON、Fixed Interval 選択 | 薬リスト表示 | | |
| 3 | 朝 08:00 の薬確認 | Home: 8:00 AM / Local: 6:00 PM (前日) 相当の表示 | | |
| 4 | 計算が正しいか手動検証 | UTC 変換ベースで一致 | | |

#### TM-16: Local Time モード — 同一 wall-clock 維持

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | TM-15 と同じタイムゾーン設定 | 時差: -14 hours | | |
| 2 | "Local Time Adaptation" に切り替え | 薬リスト再計算 | | |
| 3 | 朝 08:00 の薬確認 | Home: 8:00 AM / Local: **8:00 AM** (同一表示) | | |
| 4 | 全薬の Home 時間と Local 時間が同一であることを確認 | 時間帯に関わらず wall-clock time が一致 | | |

#### TM-17: モード切り替えで薬時間が即座に再計算

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | Fixed Interval 選択中 → 薬時間を目視確認 | Home と Local が異なる時間を表示 | | |
| 2 | Local Time に切り替え | 薬時間が**即座に**更新される (画面遷移なし) | | |
| 3 | Fixed Interval に戻す | 元の時間表示に**即座に**戻る | | |

---

### グループ 10: エッジケース

#### TM-18: Home と Current が同一タイムゾーン

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末タイムゾーンを Home と同一に設定 | 例: 両方 Asia/Tokyo | | |
| 2 | Travel Mode → トグル ON | 薬リスト表示 | | |
| 3 | 時差表示確認 | "Time difference: +0 hours" | | |
| 4 | 薬の Home 時間と Local 時間が同一か確認 | 両モードとも同一時間表示 | | |

#### TM-19: 30 分刻みタイムゾーン (例: India — IST +5:30)

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 端末タイムゾーンを "Asia/Kolkata" に変更 | IST +5:30 | | |
| 2 | アプリ再起動 → Travel Mode | TravelModeScreen 表示 | | |
| 3 | 時差表示確認 | 正しい時差表示 (整数でない場合も対応) | | |
| 4 | Fixed Interval で薬時間確認 | 30 分のオフセットが正しく反映 | | |
| 5 | **テスト後:** タイムゾーンを元に戻す | 復旧確認 | | |

#### TM-20: 薬が多数 (5件以上) の場合のスクロール

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | 薬 5 件以上 + 各スケジュール設定済み | データ準備 | | |
| 2 | Travel Mode → トグル ON | 薬リスト表示 | | |
| 3 | 画面を下にスクロール | 全薬カードがスクロールで到達可能 | | |
| 4 | スクロール中にクリップ/レイアウト崩れがないか確認 | 正常レンダリング | | |

---

### グループ 11: 日本語ロケール

#### TM-21: 日本語表示の確認

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | Settings → Language → 日本語 に切り替え | UI 日本語化 | | |
| 2 | Travel Mode を開く | AppBar: "トラベルモード" | | |
| 3 | トグルラベル確認 | "トラベルモードを有効にする" | | |
| 4 | トグル ON → モード選択確認 | "固定間隔（自宅時刻）" / "現地時刻に適応" | | |
| 5 | 薬リストヘッダー確認 | "影響を受けるお薬" | | |
| 6 | インフォボックス確認 | "3時間以上の時差がある場合は、医師にご相談ください" | | |
| 7 | 薬なし時の空状態確認 | "スケジュールされたお薬がありません" | | |

---

### グループ 12: 画面遷移と状態保持

#### TM-22: Back ボタンで Settings に戻る

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | Travel Mode 画面で AppBar の戻るボタンタップ | SettingsScreen に戻る | | |
| 2 | クラッシュなし確認 | 正常遷移 | | |

#### TM-23: トグル ON → Settings に戻る → 再進入

| # | 操作 | 期待結果 | 結果 | 備考 |
|---|------|----------|------|------|
| 1 | Travel Mode → トグル ON → Local Time 選択 | 条件部 UI 表示、Local Time 選択中 | | |
| 2 | 戻るボタンで Settings に戻る | SettingsScreen 表示 | | |
| 3 | 再度 "Travel Mode" タップ | TravelModeScreen 再表示 | | |
| 4 | 状態確認 | Provider がメモリ内 → トグル ON / Local Time が維持されている **または** リセット (実装依存) | | |

---

### 手動テスト サマリ

| グループ | テスト数 | 優先度 |
|---------|---------|--------|
| 実タイムゾーン検出 | 2 | Critical |
| 時間調整の目視確認 | 3 | Critical |
| エッジケース | 3 | High |
| 日本語ロケール | 1 | High |
| 画面遷移と状態保持 | 2 | Medium |
| **合計** | **11** | |

---

## 全体チェックリスト

### 自動テスト (12 件)

- [ ] TM-01: Settings → Travel Mode 画面遷移
- [ ] TM-02: 初期状態 — トグル OFF + 条件部非表示
- [ ] TM-03: LocationDisplay 常時表示
- [ ] TM-04: トグル ON → 条件部 UI 表示
- [ ] TM-05: トグル OFF → 条件部 UI 再非表示
- [ ] TM-06: デフォルトモード = Fixed Interval
- [ ] TM-07: Local Time モードに切り替え
- [ ] TM-08: Fixed Interval に再切り替え
- [ ] TM-09: 薬 + スケジュールあり → リスト表示
- [ ] TM-10: 薬カードに home/local 時間表示
- [ ] TM-11: 薬なし → "No scheduled medications"
- [ ] TM-12: インフォボックス表示

### 手動テスト (11 件)

- [ ] TM-13: 端末タイムゾーンが LocationDisplay に反映
- [ ] TM-14: タイムゾーン変更 → 再起動後に反映
- [ ] TM-15: Fixed Interval — UTC 変換の正確性
- [ ] TM-16: Local Time — wall-clock 維持
- [ ] TM-17: モード切り替えで即座再計算
- [ ] TM-18: Home = Current 同一タイムゾーン
- [ ] TM-19: 30 分刻みタイムゾーン (IST +5:30)
- [ ] TM-20: 薬 5 件以上のスクロール
- [ ] TM-21: 日本語ロケール全文確認
- [ ] TM-22: Back ボタン遷移
- [ ] TM-23: 状態保持 (ON → 戻る → 再進入)

---

## 既知の制約事項

| 項目 | 内容 |
|------|------|
| タイムゾーン自動検出 | `TimezoneService().currentLocation` はデバイスのタイムゾーンを読み取る。シミュレータでは変更不可の場合あり |
| CI 環境 | CI (Ubuntu/UTC) では `currentTimezone` = UTC 固定。自動テストは `textContaining` で部分一致推奨 |
| 状態永続化 | `timezoneSettingsProvider` はメモリ内のみ。アプリ再起動で enabled=false にリセット |
| DST (サマータイム) | DST 切り替え日のテストは時期依存。手動テスト TM-15 実施時に DST 境界を意識 |
| 時間フォーマット | 12 時間制 (`h:mm a`) 固定。端末の 24h 設定に関わらず AM/PM 表示 |
