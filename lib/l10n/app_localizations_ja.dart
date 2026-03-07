// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'くすりどき';

  @override
  String get onboardingHeadline => 'あなたの信頼できる服薬管理パートナー';

  @override
  String get onboardingFeature1 => '一包化・個別薬に対応';

  @override
  String get onboardingFeature2 => 'タイムゾーンをまたいで対応';

  @override
  String get onboardingFeature3 => 'ご家族とつながる';

  @override
  String get getStarted => 'はじめる';

  @override
  String get alreadyHaveAccount => 'アカウントをお持ちの方';

  @override
  String get tryWithoutAccount => 'アカウントなしで試す';

  @override
  String get localDataOnlyNotice => 'アカウントなしの場合、データはこの端末にのみ保存されます。';

  @override
  String get onboardingWelcomeTitle => 'くすりどきへようこそ';

  @override
  String get onboardingWelcomeSubtitle => '服薬管理パートナーを設定しましょう';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingBack => '戻る';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingFinish => 'はじめる';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get onboardingNameTitle => 'お名前を教えてください';

  @override
  String get onboardingNameSubtitle => 'あなたに合わせた体験を提供するために使用します';

  @override
  String get onboardingNameHint => '名前を入力';

  @override
  String get onboardingNameSkip => '今はスキップ';

  @override
  String get onboardingNameRequired => 'サポートする方にあなたの名前が表示されます';

  @override
  String get onboardingNameMinLength => '2文字以上入力してください';

  @override
  String get onboardingRoleTitle => 'くすりどきをどのように使いますか？';

  @override
  String get onboardingRoleSubtitle => 'あなたに最も当てはまるものを選んでください';

  @override
  String get onboardingRolePatient => '患者';

  @override
  String get onboardingRolePatientDesc => '自分のお薬を管理します';

  @override
  String get onboardingRoleCaregiver => 'サポーター';

  @override
  String get onboardingRoleCaregiverDesc => '他の人のお薬管理をサポートします';

  @override
  String get onboardingTimezoneTitle => 'タイムゾーンを確認';

  @override
  String get onboardingTimezoneSubtitle => 'リマインダーが正しい時間に届くようにします';

  @override
  String get onboardingTimezoneDetected => '検出されたタイムゾーン';

  @override
  String get onboardingTimezoneChange => 'タイムゾーンを変更';

  @override
  String get onboardingTimezonePickerTitle => 'タイムゾーンを選択';

  @override
  String get onboardingTimezoneSearchHint => 'タイムゾーンを検索...';

  @override
  String get onboardingTimezoneNoResults => 'タイムゾーンが見つかりません';

  @override
  String get onboardingNotificationTitle => 'お薬を忘れずに';

  @override
  String get onboardingNotificationSubtitle => 'お薬の時間をお知らせします';

  @override
  String get onboardingNotificationEnable => '通知を有効にする';

  @override
  String get onboardingNotificationSkip => '後で設定する';

  @override
  String get onboardingNotificationEnabled => '通知が有効になりました';

  @override
  String get onboardingNotificationDenied => '通知が無効です';

  @override
  String get goodMorning => 'おはようございます';

  @override
  String get goodAfternoon => 'こんにちは';

  @override
  String get goodEvening => 'こんばんは';

  @override
  String medicationsToday(int count, int taken) {
    return '今日のお薬 $count種類、$taken種類服用済み';
  }

  @override
  String lowStockAlert(String name, int count) {
    return '$name - 残り$count錠';
  }

  @override
  String get home => 'ホーム';

  @override
  String get adherence => '服薬状況';

  @override
  String get medications => 'お薬';

  @override
  String get settings => '設定';

  @override
  String get patients => '患者';

  @override
  String get notifications => '通知';

  @override
  String get alerts => 'アラート';

  @override
  String get myMedications => 'お薬一覧';

  @override
  String get searchMedications => 'お薬を検索...';

  @override
  String get addMedication => 'お薬を追加';

  @override
  String get editMedication => 'お薬を編集';

  @override
  String get saveMedication => '保存';

  @override
  String get deleteMedication => '削除';

  @override
  String get deleteMedicationConfirm => 'このお薬を削除してもよろしいですか？この操作は取り消せません。';

  @override
  String get medicationName => 'お薬の名前';

  @override
  String get dosage => '用量';

  @override
  String get dosageUnit => '単位';

  @override
  String get pillShape => '錠剤の形';

  @override
  String get pillColor => '色';

  @override
  String get takePhoto => '写真を撮影・アップロード';

  @override
  String get scheduleType => '服用スケジュール';

  @override
  String get inventory => '在庫';

  @override
  String get currentStock => '現在の在庫';

  @override
  String stockRemaining(int current, int total) {
    return '$current / $total';
  }

  @override
  String get lowStock => '残量少';

  @override
  String get updateInventory => '在庫を更新';

  @override
  String get noMedications => 'お薬がまだ登録されていません';

  @override
  String get addFirstMedication => '最初のお薬を追加して始めましょう';

  @override
  String get round => '丸形';

  @override
  String get capsule => 'カプセル';

  @override
  String get oval => '楕円形';

  @override
  String get square => '四角形';

  @override
  String get triangle => '三角形';

  @override
  String get hexagon => '六角形';

  @override
  String get mg => 'mg';

  @override
  String get ml => 'ml';

  @override
  String get pills => '錠';

  @override
  String get units => '単位';

  @override
  String get setSchedule => 'スケジュール設定';

  @override
  String get daily => '毎日';

  @override
  String get specificDays => '曜日指定';

  @override
  String get interval => '間隔指定';

  @override
  String get frequency => '頻度';

  @override
  String get timesPerDay => '1日あたりの回数';

  @override
  String get addAnotherTime => '時刻を追加';

  @override
  String everyNHours(int hours) {
    return '$hours時間ごと';
  }

  @override
  String get continueButton => '次へ';

  @override
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sun => '日';

  @override
  String get taken => '服用済み';

  @override
  String get missed => '未服用';

  @override
  String get upcoming => '次回';

  @override
  String get skipped => 'スキップ';

  @override
  String get snoozed => 'スヌーズ中';

  @override
  String get pending => '待機中';

  @override
  String get takeNow => '今すぐ服用';

  @override
  String snoozeMinutes(int minutes) {
    return '$minutes分スヌーズ';
  }

  @override
  String get skip => 'スキップ';

  @override
  String get medication => 'お薬';

  @override
  String pillsRemaining(int count) {
    return '残り$count錠';
  }

  @override
  String get weeklyAdherence => '週間の服薬状況';

  @override
  String get overallAdherence => '全体の服薬状況';

  @override
  String get adherenceRate => '服薬率';

  @override
  String adherenceRatePercent(int percent) {
    return '$percent%';
  }

  @override
  String get excellent => 'とても良い';

  @override
  String get good => '良好';

  @override
  String get fair => 'まあまあ';

  @override
  String get poor => '要改善';

  @override
  String get keepItUp => '素晴らしいです！この調子で続けましょう。';

  @override
  String streakDays(int count) {
    return '$count日連続';
  }

  @override
  String nextDoseAt(String time) {
    return '次の服薬: $time';
  }

  @override
  String get allDoneForToday => '今日の服薬が完了しました！';

  @override
  String get allDoneCelebration => '今日の服薬をすべて完了しました。この調子で頑張りましょう！';

  @override
  String weeklyTrendImproved(int delta) {
    return '先週比 +$delta%';
  }

  @override
  String weeklyTrendDeclined(int delta) {
    return '先週比 -$delta%';
  }

  @override
  String get weeklyTrendSame => '先週と同じ';

  @override
  String get medicationBreakdown => 'お薬別の詳細';

  @override
  String get recentHistory => '最近の履歴';

  @override
  String get travelMode => 'トラベルモード';

  @override
  String get currentLocation => '現在地';

  @override
  String get homeLocation => '自宅';

  @override
  String timeDifference(String hours) {
    return '時差: $hours';
  }

  @override
  String get enableTravelMode => 'トラベルモードを有効にする';

  @override
  String get fixedInterval => '固定間隔（自宅時刻）';

  @override
  String get fixedIntervalDesc => '自宅のタイムゾーンで服用';

  @override
  String get localTime => '現地時刻に適応';

  @override
  String get localTimeDesc => '現地のタイムゾーンに調整';

  @override
  String get affectedMedications => '影響を受けるお薬';

  @override
  String get consultDoctor => '3時間以上の時差がある場合は、医師にご相談ください';

  @override
  String get settingsTitle => '設定';

  @override
  String get account => 'アカウント';

  @override
  String get profileInfo => 'プロフィール情報';

  @override
  String get signInSettings => 'サインイン設定';

  @override
  String get language => '言語';

  @override
  String get pushNotifications => 'プッシュ通知';

  @override
  String get criticalAlerts => '重要なアラート';

  @override
  String get snoozeDuration => 'スヌーズ時間';

  @override
  String get display => '表示';

  @override
  String get highContrast => 'ハイコントラスト';

  @override
  String get textSize => '文字サイズ';

  @override
  String get normal => '標準';

  @override
  String get large => '大';

  @override
  String get extraLarge => '特大';

  @override
  String get features => '機能';

  @override
  String get safetyPrivacy => '安全とプライバシー';

  @override
  String get exportHistory => '履歴をエクスポート';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get about => 'このアプリについて';

  @override
  String version(String version) {
    return 'バージョン $version';
  }

  @override
  String get advanced => '詳細設定';

  @override
  String get deactivateAccount => 'ログアウト';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get removeAds => '広告を削除';

  @override
  String get upgradeMessage => 'アップグレードしてもっと快適に使いましょう';

  @override
  String get switchToCaregiverView => 'サポータービューに切り替え';

  @override
  String get familyCaregivers => 'ご家族とサポーター';

  @override
  String get linkedCaregivers => '連携中のサポーター';

  @override
  String get connected => '連携中';

  @override
  String get revokeAccess => 'アクセスを取り消す';

  @override
  String get inviteCaregiver => 'サポーターを招待';

  @override
  String get scanQrCode => 'QRコードをスキャン';

  @override
  String get shareVia => '共有方法';

  @override
  String get privacyNoticeTitle => 'プライバシーについて';

  @override
  String get privacyNotice1 => 'サポーターは服薬状況とスケジュールのみ閲覧できます';

  @override
  String get privacyNotice2 => '個人的なメモやその他の健康データはあなただけに表示されます';

  @override
  String get caregiverDashboard => '担当患者';

  @override
  String get dailyAdherence => '本日の服薬状況';

  @override
  String takenCount(int taken, int total) {
    return '$taken/$total 服用済み';
  }

  @override
  String get confirm => '確認';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get retry => '再試行';

  @override
  String get loading => '読み込み中...';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get noDataAvailable => 'データがありません';

  @override
  String get signIn => 'サインイン';

  @override
  String get signOut => 'サインアウト';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get highContrastDescription => '視認性を向上させるためにコントラストを強化';

  @override
  String get signInWithGoogle => 'Googleでサインイン';

  @override
  String get signInWithApple => 'Appleでサインイン';

  @override
  String get linkAccount => 'アカウント連携';

  @override
  String get linkWithGoogle => 'Googleと連携';

  @override
  String get linkWithApple => 'Appleと連携';

  @override
  String get accountLinked => 'アカウントが正常に連携されました';

  @override
  String get signInCancelled => 'サインインがキャンセルされました';

  @override
  String get accountAlreadyLinked => 'このアカウントは既に別のユーザーに連携されています';

  @override
  String get guestUser => 'ゲストユーザー';

  @override
  String get signInToSync => 'サインインしてデータを同期';

  @override
  String get notSignedIn => '未サインイン';

  @override
  String get signInToAccess => 'アカウントにアクセスするにはサインインしてください';

  @override
  String get errorLoadingAccount => 'アカウントの読み込みエラー';

  @override
  String get or => 'または';

  @override
  String googleSignInFailed(String error) {
    return 'Googleサインインに失敗しました: $error';
  }

  @override
  String appleSignInFailed(String error) {
    return 'Appleサインインに失敗しました: $error';
  }

  @override
  String get linkFailed => 'アカウント連携に失敗しました。もう一度お試しください。';

  @override
  String get appleSignInCancelled => 'Appleサインインがキャンセルされました';

  @override
  String get appleCredentialAlreadyInUse => 'このAppleアカウントは既に別のユーザーに連携されています';

  @override
  String get appleInvalidCredential => 'Appleサインインに失敗しました。もう一度お試しください';

  @override
  String get appleOperationNotAllowed => 'このアプリではAppleサインインが有効になっていません';

  @override
  String get appleProviderAlreadyLinked => 'このプロフィールには既にAppleアカウントが連携されています';

  @override
  String get appleNetworkError => 'ネットワークエラーです。接続を確認して再試行してください';

  @override
  String get appleSignInUnknownError => 'Appleサインインに失敗しました。後でもう一度お試しください';

  @override
  String get privateEmailNotice => 'Appleのプライベートメールリレーを使用中です。';

  @override
  String get emailHidden => 'メール非公開';

  @override
  String get usesPrivateEmail => 'プライベートメールリレーを使用中';

  @override
  String get emailAddressInfo => 'メールアドレス';

  @override
  String get weeklySummary => '週間サマリー';

  @override
  String get premium => 'プレミアム';

  @override
  String get premiumMonthly => '月額プラン';

  @override
  String get premiumYearly => '年額プラン';

  @override
  String get premiumMonthlyPrice => '¥480/月';

  @override
  String get premiumYearlyPrice => '¥3,800/年';

  @override
  String get unlockPremium => 'プレミアムにアップグレード';

  @override
  String get premiumFeatures => 'プレミアム機能';

  @override
  String get noAds => '広告なし';

  @override
  String get unlimitedCaregivers => '無制限のサポーター連携';

  @override
  String get pdfReports => 'PDFレポート出力';

  @override
  String get customSounds => 'カスタム通知音';

  @override
  String get premiumThemes => 'プレミアムテーマ';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get alreadyPremium => 'プレミアム会員です';

  @override
  String premiumExpiresAt(String date) {
    return '有効期限: $date';
  }

  @override
  String get caregiverLimitReached => '無料プランではサポーターは1名までです';

  @override
  String get upgradeToPremium => 'プレミアムにアップグレードして無制限で使おう';

  @override
  String get tryPremium => 'プレミアムを試す';

  @override
  String get freeTier => '無料プラン';

  @override
  String get premiumTier => 'プレミアムプラン';

  @override
  String get currentPlan => '現在のプラン';

  @override
  String get exportReport => 'レポートを出力';

  @override
  String get weeklyReport => '週間レポート';

  @override
  String get monthlyReport => '月間レポート';

  @override
  String get generatePdf => 'PDFを生成';

  @override
  String get shareReport => 'レポートを共有';

  @override
  String get premiumFeature => 'プレミアム機能';

  @override
  String get unlockThisFeature => 'この機能を使うにはプレミアムにアップグレードしてください';

  @override
  String get selectReportPeriod => 'レポート期間を選択';

  @override
  String get last7Days => '過去7日間';

  @override
  String get last30Days => '過去30日間';

  @override
  String get weekly => '週間';

  @override
  String get monthly => '月間';

  @override
  String get reportGeneratedSuccessfully => 'レポートが正常に生成されました';

  @override
  String get errorGeneratingReport => 'レポート生成中にエラーが発生しました';

  @override
  String get pdfReportsRequirePremium =>
      'PDFレポートはプレミアム機能です。詳細な服薬状況レポートにアクセスするにはアップグレードしてください。';

  @override
  String get premiumBenefits => 'プレミアム特典：';

  @override
  String get weeklyMonthlyReports => '週間・月間レポート';

  @override
  String get detailedAdherenceStats => '詳細な服薬統計';

  @override
  String get sharableWithDoctors => '医師やサポーターと共有可能';

  @override
  String get unlimitedCaregiversBenefit => 'サポーター無制限';

  @override
  String get close => '閉じる';

  @override
  String get backupAndSync => 'バックアップと同期';

  @override
  String get syncWithCloud => 'データをクラウドと同期';

  @override
  String get lastSync => '最終同期：';

  @override
  String get never => '未同期';

  @override
  String get justNow => 'たった今';

  @override
  String get syncing => '同期中...';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get syncComplete => '同期完了';

  @override
  String get autoSync => '自動同期';

  @override
  String get autoSyncSubtitle => '変更があると自動的に同期します';

  @override
  String get takePhotoOption => '写真を撮る';

  @override
  String get chooseFromGallery => 'ギャラリーから選択';

  @override
  String get removePhoto => '写真を削除';

  @override
  String get failedToPickImage => '画像の選択に失敗しました。もう一度お試しください。';

  @override
  String get missedDoseAlerts => '服用忘れアラート';

  @override
  String get missedDoseAlertsSubtitle => '患者がお薬を飲み忘れた時に通知を受け取る';

  @override
  String get lowStockAlerts => '在庫不足アラート';

  @override
  String get lowStockAlertsSubtitle => '薬の在庫が少ない時に通知を受け取る';

  @override
  String get switchToPatientView => '患者ビューに切り替え';

  @override
  String get areYouSureSignOut => 'サインアウトしてもよろしいですか？';

  @override
  String get dataSharingPreferences => 'データ共有設定';

  @override
  String get dataSharingSubtitle => 'サポーターと共有する情報を管理します';

  @override
  String get shareAdherenceData => '服薬データをサポーターと共有';

  @override
  String get shareMedicationList => 'お薬リストをサポーターと共有';

  @override
  String get allowCaregiverNotifications => 'サポーターへの通知を許可';

  @override
  String get manageSubscription => 'サブスクリプション管理';

  @override
  String get noAdsDescription => '広告なしの快適な体験';

  @override
  String get unlimitedCaregiversDescription => '無制限のサポーターと連携';

  @override
  String get pdfReportsDescription => '詳細な服薬レポートを出力';

  @override
  String get customSoundsDescription => '通知音をカスタマイズ';

  @override
  String get premiumThemesDescription => '限定テーマにアクセス';

  @override
  String get purchaseFailed => '購入に失敗しました。もう一度お試しください。';

  @override
  String get purchasesRestored => '購入が正常に復元されました！';

  @override
  String get noPurchasesFound => '復元する購入が見つかりません。';

  @override
  String errorWithMessage(String message) {
    return 'エラー: $message';
  }

  @override
  String get noCaregiversLinked => 'まだサポーターが連携されていません';

  @override
  String get revokeAccessTitle => 'アクセスを取り消す';

  @override
  String revokeAccessConfirm(String name) {
    return '$nameのアクセスを取り消してもよろしいですか？';
  }

  @override
  String get revoke => '取り消す';

  @override
  String get accessRevokedSuccess => 'アクセスが正常に取り消されました';

  @override
  String failedToRevokeAccess(String error) {
    return 'アクセスの取り消しに失敗しました: $error';
  }

  @override
  String errorLoadingCaregivers(String error) {
    return 'サポーターの読み込みエラー: $error';
  }

  @override
  String syncFailed(String error) {
    return '同期に失敗しました: $error';
  }

  @override
  String get noRemindersForToday => '今日のリマインダーはありません';

  @override
  String get errorLoadingReminders => 'リマインダーの読み込みエラー';

  @override
  String get errorLoadingSettings => '設定の読み込みエラー';

  @override
  String get appVersion => 'アプリバージョン';

  @override
  String get deactivateAccountTitle => 'ログアウト';

  @override
  String get deactivateAccountMessage => 'サインアウトされます。データは保持され、後でサインインできます。';

  @override
  String get logOutMessageAnonymous =>
      'サインインしていません。ログアウトすると、この端末のすべてのお薬、スケジュール、リマインダーが完全に削除されます。この操作は取り消せません。';

  @override
  String get logOutMessageAuthenticated =>
      'この端末のローカルデータが削除されます。再度サインインすると復元できます。';

  @override
  String get deactivate => 'ログアウト';

  @override
  String get deleteAccountTitle => 'アカウントを削除';

  @override
  String get deleteAccountMessage => 'アカウントとすべてのデータが完全に削除されます。この操作は取り消せません。';

  @override
  String get deleteAccountConfirmTitle => '本当によろしいですか？';

  @override
  String get deleteAccountConfirmMessage =>
      'すべてのお薬、スケジュール、履歴、サポーター連携が完全に削除されます。';

  @override
  String get deleteEverything => 'すべて削除';

  @override
  String errorDeactivatingAccount(String error) {
    return 'ログアウトエラー: $error';
  }

  @override
  String errorDeletingAccount(String error) {
    return 'アカウント削除エラー: $error';
  }

  @override
  String get minuteShort => '分';

  @override
  String get noData => 'データなし';

  @override
  String get noEmail => 'メール未設定';

  @override
  String get needsImprovement => '改善が必要';

  @override
  String get startTrackingMessage => 'お薬の服用を記録して、服薬状況を確認しましょう。';

  @override
  String get excellentMessage => '素晴らしい！一貫した服薬を続けています。';

  @override
  String get goodMessage => 'よく頑張っています！少し飲み忘れがある程度です。';

  @override
  String get fairMessage => '改善の余地があります。リマインダーを増やしてみましょう。';

  @override
  String get needsImprovementMessage => '一緒に安定した服薬習慣を作りましょう。';

  @override
  String get thisWeek => '今週';

  @override
  String get byMedication => 'お薬別';

  @override
  String get noMedicationData => 'お薬のデータがありません';

  @override
  String get adsRemovedSuccess => '広告を削除しました！';

  @override
  String get processingEllipsis => '処理中...';

  @override
  String textSizeSemanticLabel(String label) {
    return 'テキストサイズ $label';
  }

  @override
  String get criticalMedication => '重要な薬';

  @override
  String get criticalMedicationLabel => '重要な薬として設定';

  @override
  String get criticalMedicationDesc => '重要な薬は「おやすみモード」を無視する高優先度アラートを使用します';

  @override
  String get saving => '保存中...';

  @override
  String get updating => '更新中...';

  @override
  String get updateMedication => 'お薬を更新';

  @override
  String get pleaseEnterMedicationName => 'お薬の名前を入力してください';

  @override
  String get pleaseEnterDosage => '用量を入力してください';

  @override
  String get pleaseEnterValidDosage => '有効な数値を入力してください';

  @override
  String get errorSavingMedication => 'お薬の保存に失敗しました。もう一度お試しください。';

  @override
  String get errorSavingSchedule => 'スケジュールの保存に失敗しました。もう一度お試しください。';

  @override
  String get errorUpdatingMedication => 'お薬の更新に失敗しました。もう一度お試しください。';

  @override
  String get errorLoadingMedication => 'お薬の読み込みに失敗しました';

  @override
  String get errorLoadingMedications => 'お薬リストの読み込みに失敗しました';

  @override
  String get medicationNotFound => 'お薬が見つかりません';

  @override
  String get noMedicationsFound => 'お薬が見つかりません';

  @override
  String get searchMedicationsHint => 'お薬を検索...';

  @override
  String get dosageHint => '例: アスピリン';

  @override
  String get schedule => 'スケジュール';

  @override
  String get status => 'ステータス';

  @override
  String get noScheduleConfigured => 'スケジュール未設定';

  @override
  String get type => '種類';

  @override
  String get times => '時間';

  @override
  String get days => '日';

  @override
  String everyNHoursLabel(int hours) {
    return '$hours時間ごと';
  }

  @override
  String get added => '追加日';

  @override
  String get noHistoryYet => '履歴がありません';

  @override
  String get errorLoadingHistory => '履歴の読み込みに失敗しました';

  @override
  String get errorLoadingSchedule => 'スケジュールの読み込みに失敗しました';

  @override
  String get deleteMedicationTitle => 'お薬を削除';

  @override
  String get howOften => 'どのくらいの頻度で？';

  @override
  String get whatTimes => '何時に？';

  @override
  String get whichDays => 'どの曜日に？';

  @override
  String get whatTime => '何時に？';

  @override
  String get every => '毎';

  @override
  String get hours => '時間';

  @override
  String get daysUnit => '日';

  @override
  String get dailyDesc => '毎日同じ時間に服用';

  @override
  String get specificDaysDesc => '選択した曜日に服用';

  @override
  String get intervalDesc => 'X時間またはX日ごとに服用';

  @override
  String get remaining => '残り';

  @override
  String get total => '合計';

  @override
  String get quickActions => 'クイック操作';

  @override
  String get refillSetRemaining => '補充 (残り = 合計に設定)';

  @override
  String get pleaseEnterValidNumbers => '有効な数値を入力してください';

  @override
  String get remainingMustBeZeroOrGreater => '残りは0以上にしてください';

  @override
  String get totalMustBeGreaterThanZero => '合計は0より大きくしてください';

  @override
  String get remainingCannotExceedTotal => '残りは合計を超えられません';

  @override
  String get myPatients => '担当患者';

  @override
  String get noPatientsLinked => '連携された患者がいません';

  @override
  String get noPatientsLinkedDesc => '患者に招待コードを共有してもらいましょう';

  @override
  String get alertTypes => 'アラートの種類';

  @override
  String get missedDose => '飲み忘れ';

  @override
  String get missedDoseDesc => '患者が予定された薬を飲み忘れた時に通知を受け取ります';

  @override
  String get lowStockLabel => '在庫不足';

  @override
  String get lowStockDesc => 'お薬の在庫が少なくなった時にアラートを受け取ります';

  @override
  String get noNotificationsYet => '通知はまだありません';

  @override
  String get notificationsWillAppear => '患者がお薬を服用・飲み忘れた時に通知されます';

  @override
  String get alertsWillAppear => '患者が飲み忘れや在庫不足の時にアラートが表示されます';

  @override
  String get invitation => '招待';

  @override
  String get youveBeenInvited => '招待されました！';

  @override
  String inviteCodeLabel(String code) {
    return '招待コード: $code';
  }

  @override
  String get acceptInvitation => '招待を受ける';

  @override
  String get decline => '辞退';

  @override
  String get successfullyLinked => '介護者として連携されました！';

  @override
  String get failedToAcceptInvite => '招待の受け入れに失敗しました。もう一度お試しください。';

  @override
  String get inviteNotFound => '招待コードが見つかりません。リンクを確認してください。';

  @override
  String get inviteExpired => 'この招待の有効期限が切れています。新しい招待を依頼してください。';

  @override
  String get inviteAlreadyUsed => 'この招待はすでに使用されています。';

  @override
  String get inviteSelfError => '自分自身の招待を受け入れることはできません。';

  @override
  String get inviteLinkGenerated => '招待リンクが生成されました！';

  @override
  String get failedToGenerateInvite => '招待の生成に失敗しました。もう一度お試しください。';

  @override
  String get cannotAddMoreCaregivers => 'これ以上介護者を追加できません';

  @override
  String get generateInviteLink => '招待リンクを生成';

  @override
  String get generating => '生成中...';

  @override
  String get generateInviteLinkDesc => '介護者と共有する招待リンクを生成します';

  @override
  String get newLink => '新しいリンク';

  @override
  String get linkCopied => 'リンクがコピーされました！';

  @override
  String get processingInvite => '招待を処理中...';

  @override
  String get inviteAccepted => '招待が受け入れられました！';

  @override
  String get joinMeOnMyPill => 'MyPillで一緒に管理しましょう';

  @override
  String get link => 'リンク';

  @override
  String get line => 'LINE';

  @override
  String get sms => 'SMS';

  @override
  String get loadingAdherence => '服薬状況を読み込み中...';

  @override
  String get positionQrCode => '枠内にQRコードを配置してください';

  @override
  String get noScheduledMedications => 'スケジュールされたお薬がありません';

  @override
  String failedToStart(String error) {
    return '起動に失敗しました: $error';
  }

  @override
  String get off => '34%オフ';

  @override
  String get unit => '単位';

  @override
  String get markAsTaken => '服用済みにする';

  @override
  String get genericError => 'エラーが発生しました。もう一度お試しください。';

  @override
  String get networkError => 'ネットワークエラーです。接続を確認してください。';

  @override
  String get authError => '認証エラーです。再度サインインしてください。';

  @override
  String get permissionDenied => 'この操作を行う権限がありません。';

  @override
  String get serviceUnavailable => 'サービスが一時的に利用できません。後でお試しください。';

  @override
  String get dosageMustBePositive => '用量は0より大きい値を入力してください';

  @override
  String get pleaseSelectAtLeastOneTime => '服用時間を1つ以上選択してください';

  @override
  String get pleaseSelectAtLeastOneDay => '曜日を1つ以上選択してください';

  @override
  String get ippokaModeLabel => '一包化';

  @override
  String get ippokaDesc => '複数の薬を1つの袋にまとめて管理します';

  @override
  String get packet => 'パケット';

  @override
  String get packs => '包';

  @override
  String get ippokaNameHint => '例：朝の薬、夕の薬';

  @override
  String get timeoutError => 'リクエストがタイムアウトしました。もう一度お試しください。';

  @override
  String get defaultUserName => 'ユーザー';

  @override
  String get colorWhite => '白';

  @override
  String get colorBlue => '青';

  @override
  String get colorYellow => '黄';

  @override
  String get colorPink => 'ピンク';

  @override
  String get colorRed => '赤';

  @override
  String get colorGreen => '緑';

  @override
  String get colorOrange => 'オレンジ';

  @override
  String get colorPurple => '紫';

  @override
  String get dayMonday => '月曜日';

  @override
  String get dayTuesday => '火曜日';

  @override
  String get dayWednesday => '水曜日';

  @override
  String get dayThursday => '木曜日';

  @override
  String get dayFriday => '金曜日';

  @override
  String get daySaturday => '土曜日';

  @override
  String get daySunday => '日曜日';

  @override
  String get dayMondayShort => '月';

  @override
  String get dayTuesdayShort => '火';

  @override
  String get dayWednesdayShort => '水';

  @override
  String get dayThursdayShort => '木';

  @override
  String get dayFridayShort => '金';

  @override
  String get daySaturdayShort => '土';

  @override
  String get daySundayShort => '日';

  @override
  String snoozeMinutesSemanticLabel(int duration, String selected) {
    return 'スヌーズ$duration分、$selected';
  }

  @override
  String get selected => '選択中';

  @override
  String get notSelected => '未選択';

  @override
  String inventorySemanticLabel(int current, int total, int percent) {
    return '在庫: $total個中$current個、$percent%';
  }

  @override
  String get dosePackIcon => '一包化アイコン';

  @override
  String medicationIconLabel(String shape, String color) {
    return 'お薬アイコン: $shape $color';
  }

  @override
  String get scheduleTypeDaily => '毎日';

  @override
  String get scheduleTypeSpecificDays => '曜日指定';

  @override
  String get scheduleTypeInterval => '間隔指定';

  @override
  String get errorLoadingPatients => '患者情報の読み込みに失敗しました。もう一度お試しください。';

  @override
  String get onboardingMedStyleTitle => 'お薬はどのように受け取っていますか？';

  @override
  String get onboardingMedStyleSubtitle => 'お薬を追加するときのデフォルト設定に反映されます';

  @override
  String get onboardingIndividualPills => '個別の薬（錠剤・カプセルなど）';

  @override
  String get onboardingIndividualPillsDesc => '薬局で一種類ずつ受け取るタイプ';

  @override
  String get onboardingDosePack => '一包化（分包薬）';

  @override
  String get onboardingDosePackDesc => '複数の薬をまとめた分包薬';

  @override
  String get dosageTimingTitle => '服用タイミング';

  @override
  String get dosageTimingMorning => '朝';

  @override
  String get dosageTimingNoon => '昼';

  @override
  String get dosageTimingEvening => '夕';

  @override
  String get dosageTimingBedtime => '寝る前';

  @override
  String get dosageTimingRequired => '必須';

  @override
  String get subscriptionTerms =>
      'お支払いは購入確認時にApple IDアカウントに請求されます。現在の期間終了の24時間前までにキャンセルしない限り、サブスクリプションは自動的に更新されます。Apple IDアカウント設定でサブスクリプションの管理・キャンセルができます。';

  @override
  String get selectDosageTiming => 'いつ服用しますか？';

  @override
  String get adjustTimes => '時間を調整';

  @override
  String timeRangeHint(String timing, String min, String max) {
    return '$timing: $min:00 ~ $max:59';
  }

  @override
  String get pleaseSelectAtLeastOneTiming => '少なくとも1つのタイミングを選択してください';

  @override
  String timeOutOfRange(String min, String max) {
    return '時間は$min:00から$max:59の間である必要があります';
  }

  @override
  String get changeTimezone => 'タイムゾーンを変更';

  @override
  String get searchTimezone => 'タイムゾーンを検索...';

  @override
  String get selectDestinationTimezone => '渡航先のタイムゾーンを選択';

  @override
  String get clearAllDataTitle => 'すべてのデータを消去';

  @override
  String get clearAllDataMessage => 'すべてのお薬、スケジュール、リマインダー、服薬記録を削除しますか？';

  @override
  String get clearAllDataConfirm => '消去';

  @override
  String get addPatient => '患者を追加';

  @override
  String get enterCodeManually => 'コードを手入力';

  @override
  String get enterInviteCode => '招待コードを入力';

  @override
  String get inviteCodeHint => '8文字のコード';

  @override
  String get invalidInviteCode => '有効な8文字のコードを入力してください';

  @override
  String markedAsTaken(String name) {
    return '$nameを服用済みにしました';
  }

  @override
  String markedAsSkipped(String name) {
    return '$nameをスキップしました';
  }

  @override
  String snoozedReminder(String name) {
    return '$nameを15分スヌーズしました';
  }

  @override
  String get howToConnectPatient => '連携方法';

  @override
  String get connectStep1 => '患者のスマホにくすりどきをインストール';

  @override
  String get connectStep2 => '患者のアプリで 設定 → ご家族とサポーター → QRコードを生成';

  @override
  String get connectStep3 => '右上の「患者を追加」ボタンでQRをスキャン';

  @override
  String get shareConnectGuide => 'この手順を共有する';

  @override
  String get editSchedule => 'スケジュール編集';

  @override
  String get cancelScheduleSetupTitle => 'スケジュール設定をキャンセル';

  @override
  String get cancelScheduleSetupMessage => 'スケジュールを設定せずに戻ると、お薬が削除されます';

  @override
  String get inventoryUnitDoses => '回分';
}
