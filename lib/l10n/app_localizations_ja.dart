// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'MyPill';

  @override
  String get onboardingHeadline => 'あなたの信頼できる服薬管理パートナー';

  @override
  String get onboardingFeature1 => '飲み忘れを防止';

  @override
  String get onboardingFeature2 => 'タイムゾーンをまたいで対応';

  @override
  String get onboardingFeature3 => 'ご家族とつながる';

  @override
  String get getStarted => 'はじめる';

  @override
  String get alreadyHaveAccount => 'アカウントをお持ちの方';

  @override
  String get goodMorning => 'おはようございます';

  @override
  String get goodAfternoon => 'こんにちは';

  @override
  String get goodEvening => 'こんばんは';

  @override
  String medicationsToday(int count, int taken) {
    return '今日の薬 $count種類、$taken種類服用済み';
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
  String get scheduleType => 'スケジュールタイプ';

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
    return '残り$countカプセル';
  }

  @override
  String get weeklyAdherence => '週間服薬遵守率';

  @override
  String get overallAdherence => '全体の服薬遵守率';

  @override
  String get adherenceRate => '服薬遵守率';

  @override
  String adherenceRatePercent(int percent) {
    return '$percent%';
  }

  @override
  String get excellent => '優秀';

  @override
  String get good => '良好';

  @override
  String get fair => '普通';

  @override
  String get poor => '要改善';

  @override
  String get keepItUp => '素晴らしいです！この調子で続けましょう！';

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
  String get safetyPrivacy => '安全とプライバシー';

  @override
  String get exportHistory => '履歴をエクスポート';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get about => 'このアプリについて';

  @override
  String version(String version) {
    return 'バージョン $version';
  }

  @override
  String get advanced => '詳細設定';

  @override
  String get deactivateAccount => 'アカウントを無効化';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get removeAds => '広告を削除';

  @override
  String get upgradeMessage => 'アップグレードして快適な体験を';

  @override
  String get switchToCaregiverView => '介護者ビューに切り替え';

  @override
  String get familyCaregivers => 'ご家族と介護者';

  @override
  String get linkedCaregivers => '連携中の介護者';

  @override
  String get connected => '連携中';

  @override
  String get revokeAccess => 'アクセスを取り消す';

  @override
  String get inviteCaregiver => '介護者を招待';

  @override
  String get scanQrCode => 'QRコードをスキャン';

  @override
  String get shareVia => '共有方法';

  @override
  String get privacyNoticeTitle => 'プライバシーについて';

  @override
  String get privacyNotice1 => '介護者は服薬遵守状況とスケジュールのみ閲覧できます';

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
}
