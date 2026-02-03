// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kusuridoki';

  @override
  String get onboardingHeadline => 'Your reliable medication companion';

  @override
  String get onboardingFeature1 => 'Never miss a dose';

  @override
  String get onboardingFeature2 => 'Works across timezones';

  @override
  String get onboardingFeature3 => 'Keep family connected';

  @override
  String get getStarted => 'Get Started';

  @override
  String get alreadyHaveAccount => 'I already have an account';

  @override
  String get onboardingWelcomeTitle => 'Welcome to MyPill';

  @override
  String get onboardingWelcomeSubtitle =>
      'Let\'s set up your medication companion';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingFinish => 'Get Started';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get onboardingNameTitle => 'What\'s your name?';

  @override
  String get onboardingNameSubtitle =>
      'We\'ll use this to personalize your experience';

  @override
  String get onboardingNameHint => 'Enter your name';

  @override
  String get onboardingNameSkip => 'Skip for now';

  @override
  String get onboardingRoleTitle => 'How will you use MyPill?';

  @override
  String get onboardingRoleSubtitle =>
      'Choose the option that best describes you';

  @override
  String get onboardingRolePatient => 'Patient';

  @override
  String get onboardingRolePatientDesc => 'I\'m managing my own medications';

  @override
  String get onboardingRoleCaregiver => 'Caregiver';

  @override
  String get onboardingRoleCaregiverDesc =>
      'I\'m helping someone else with their medications';

  @override
  String get onboardingTimezoneTitle => 'Confirm your timezone';

  @override
  String get onboardingTimezoneSubtitle =>
      'This ensures reminders arrive at the right time';

  @override
  String get onboardingTimezoneDetected => 'Detected timezone';

  @override
  String get onboardingTimezoneChange => 'Change timezone';

  @override
  String get onboardingTimezonePickerTitle => 'Select Timezone';

  @override
  String get onboardingTimezoneSearchHint => 'Search timezones...';

  @override
  String get onboardingTimezoneNoResults => 'No timezones found';

  @override
  String get onboardingNotificationTitle => 'Stay on track';

  @override
  String get onboardingNotificationSubtitle =>
      'Get timely reminders for your medications';

  @override
  String get onboardingNotificationEnable => 'Enable notifications';

  @override
  String get onboardingNotificationSkip => 'Maybe later';

  @override
  String get onboardingNotificationEnabled => 'Notifications enabled';

  @override
  String get onboardingNotificationDenied => 'Notifications disabled';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String medicationsToday(int count, int taken) {
    return '$count medications today, $taken taken';
  }

  @override
  String lowStockAlert(String name, int count) {
    return '$name - $count pills remaining';
  }

  @override
  String get home => 'Home';

  @override
  String get adherence => 'Adherence';

  @override
  String get medications => 'Medications';

  @override
  String get settings => 'Settings';

  @override
  String get patients => 'Patients';

  @override
  String get notifications => 'Notifications';

  @override
  String get alerts => 'Alerts';

  @override
  String get myMedications => 'My Medications';

  @override
  String get searchMedications => 'Search medications...';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get saveMedication => 'Save Medication';

  @override
  String get deleteMedication => 'Delete Medication';

  @override
  String get deleteMedicationConfirm =>
      'Are you sure you want to delete this medication? This action cannot be undone.';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get dosage => 'Dosage';

  @override
  String get dosageUnit => 'Unit';

  @override
  String get pillShape => 'Pill Shape';

  @override
  String get pillColor => 'Pill Color';

  @override
  String get takePhoto => 'Take or upload a photo';

  @override
  String get scheduleType => 'Schedule Type';

  @override
  String get inventory => 'Inventory';

  @override
  String get currentStock => 'Current Stock';

  @override
  String stockRemaining(int current, int total) {
    return '$current / $total';
  }

  @override
  String get lowStock => 'Low Stock';

  @override
  String get updateInventory => 'Update Inventory';

  @override
  String get noMedications => 'No medications yet';

  @override
  String get addFirstMedication => 'Add your first medication to get started';

  @override
  String get round => 'Round';

  @override
  String get capsule => 'Capsule';

  @override
  String get oval => 'Oval';

  @override
  String get square => 'Square';

  @override
  String get triangle => 'Triangle';

  @override
  String get hexagon => 'Hexagon';

  @override
  String get mg => 'mg';

  @override
  String get ml => 'ml';

  @override
  String get pills => 'pills';

  @override
  String get units => 'units';

  @override
  String get setSchedule => 'Set Schedule';

  @override
  String get daily => 'Daily';

  @override
  String get specificDays => 'Specific Days';

  @override
  String get interval => 'Interval';

  @override
  String get frequency => 'Frequency';

  @override
  String get timesPerDay => 'Times per day';

  @override
  String get addAnotherTime => 'Add another time';

  @override
  String everyNHours(int hours) {
    return 'Every $hours hours';
  }

  @override
  String get continueButton => 'Continue';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get taken => 'Taken';

  @override
  String get missed => 'Missed';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get skipped => 'Skipped';

  @override
  String get snoozed => 'Snoozed';

  @override
  String get pending => 'Pending';

  @override
  String get takeNow => 'Take Now';

  @override
  String snoozeMinutes(int minutes) {
    return 'Snooze $minutes min';
  }

  @override
  String get skip => 'Skip';

  @override
  String get medication => 'Medication';

  @override
  String pillsRemaining(int count) {
    return '$count capsules remaining';
  }

  @override
  String get weeklyAdherence => 'Weekly Adherence';

  @override
  String get overallAdherence => 'Overall Adherence';

  @override
  String get adherenceRate => 'Adherence Rate';

  @override
  String adherenceRatePercent(int percent) {
    return '$percent%';
  }

  @override
  String get excellent => 'Excellent';

  @override
  String get good => 'Good';

  @override
  String get fair => 'Fair';

  @override
  String get poor => 'Poor';

  @override
  String get keepItUp => 'Keep up the great work!';

  @override
  String get medicationBreakdown => 'Medication Breakdown';

  @override
  String get recentHistory => 'Recent History';

  @override
  String get travelMode => 'Travel Mode';

  @override
  String get currentLocation => 'Current';

  @override
  String get homeLocation => 'Home';

  @override
  String timeDifference(String hours) {
    return 'Time difference: $hours';
  }

  @override
  String get enableTravelMode => 'Enable Travel Mode';

  @override
  String get fixedInterval => 'Fixed Interval (Home Time)';

  @override
  String get fixedIntervalDesc => 'Take meds at home timezone';

  @override
  String get localTime => 'Local Time Adaptation';

  @override
  String get localTimeDesc => 'Adjust to local timezone';

  @override
  String get affectedMedications => 'Affected Medications';

  @override
  String get consultDoctor => 'Consult your doctor for 3+ timezone changes';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get profileInfo => 'Profile Info';

  @override
  String get signInSettings => 'Sign-in Settings';

  @override
  String get language => 'Language';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get criticalAlerts => 'Critical Alerts';

  @override
  String get snoozeDuration => 'Snooze Duration';

  @override
  String get display => 'Display';

  @override
  String get highContrast => 'High Contrast';

  @override
  String get textSize => 'Text Size';

  @override
  String get normal => 'Normal';

  @override
  String get large => 'Large';

  @override
  String get extraLarge => 'XL';

  @override
  String get safetyPrivacy => 'Safety & Privacy';

  @override
  String get exportHistory => 'Export History';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get advanced => 'Advanced';

  @override
  String get deactivateAccount => 'Deactivate Account';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get upgradeMessage => 'Upgrade for a cleaner experience';

  @override
  String get switchToCaregiverView => 'Switch to Caregiver View';

  @override
  String get familyCaregivers => 'Family & Caregivers';

  @override
  String get linkedCaregivers => 'Linked Caregivers';

  @override
  String get connected => 'Connected';

  @override
  String get revokeAccess => 'Revoke Access';

  @override
  String get inviteCaregiver => 'Invite Caregiver';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get shareVia => 'Share via';

  @override
  String get privacyNoticeTitle => 'Privacy Notice';

  @override
  String get privacyNotice1 =>
      'Caregivers can only see medication adherence and scheduled reminders';

  @override
  String get privacyNotice2 =>
      'Private notes and other health data remain visible only to you';

  @override
  String get caregiverDashboard => 'My Patients';

  @override
  String get dailyAdherence => 'Daily Adherence';

  @override
  String takenCount(int taken, int total) {
    return '$taken/$total taken';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get highContrastDescription =>
      'Increase contrast for better visibility';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get linkAccount => 'Link Account';

  @override
  String get linkWithGoogle => 'Link with Google';

  @override
  String get linkWithApple => 'Link with Apple';

  @override
  String get accountLinked => 'Account linked successfully';

  @override
  String get signInCancelled => 'Sign in was cancelled';

  @override
  String get accountAlreadyLinked =>
      'This account is already linked to another user';

  @override
  String get guestUser => 'Guest User';

  @override
  String get signInToSync => 'Sign in to sync data';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get signInToAccess => 'Sign in to access your account';

  @override
  String get errorLoadingAccount => 'Error loading account';

  @override
  String get or => 'or';

  @override
  String get createAccount => 'Create Account';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get validEmail => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String signInFailed(String error) {
    return 'Sign in failed: $error';
  }

  @override
  String googleSignInFailed(String error) {
    return 'Google sign in failed: $error';
  }

  @override
  String appleSignInFailed(String error) {
    return 'Apple sign in failed: $error';
  }

  @override
  String accountCreationFailed(String error) {
    return 'Account creation failed: $error';
  }

  @override
  String get resetEmailSent => 'Password reset email sent';

  @override
  String resetEmailFailed(String error) {
    return 'Failed to send reset email: $error';
  }

  @override
  String get enterEmail => 'Please enter your email address';

  @override
  String linkFailed(String error) {
    return 'Failed to link account: $error';
  }

  @override
  String get appleSignInCancelled => 'Sign in was cancelled';

  @override
  String get appleCredentialAlreadyInUse =>
      'This Apple account is already linked to another user';

  @override
  String get appleInvalidCredential => 'Apple sign in failed. Please try again';

  @override
  String get appleOperationNotAllowed =>
      'Apple sign in is not enabled for this app';

  @override
  String get appleProviderAlreadyLinked =>
      'An Apple account is already linked to this profile';

  @override
  String get appleNetworkError =>
      'Network error. Please check your connection and try again';

  @override
  String get appleSignInUnknownError =>
      'Apple sign in failed. Please try again later';

  @override
  String get privateEmailNotice =>
      'You\'re using Apple\'s private email relay.';

  @override
  String get emailHidden => 'Email hidden';

  @override
  String get usesPrivateEmail => 'Using private email relay';

  @override
  String get emailAddressInfo => 'Email address';

  @override
  String get weeklySummary => 'Weekly Summary';

  @override
  String get premium => 'Premium';

  @override
  String get premiumMonthly => 'Monthly Plan';

  @override
  String get premiumYearly => 'Yearly Plan (34% off)';

  @override
  String get premiumMonthlyPrice => '¥480/mo';

  @override
  String get premiumYearlyPrice => '¥3,800/yr';

  @override
  String get unlockPremium => 'Upgrade to Premium';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get noAds => 'No Ads';

  @override
  String get unlimitedCaregivers => 'Unlimited caregivers';

  @override
  String get pdfReports => 'PDF Reports';

  @override
  String get customSounds => 'Custom Notification Sounds';

  @override
  String get premiumThemes => 'Premium Themes';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get alreadyPremium => 'You\'re a Premium member';

  @override
  String premiumExpiresAt(String date) {
    return 'Expires: $date';
  }

  @override
  String get caregiverLimitReached => 'Free plan allows only 1 caregiver';

  @override
  String get upgradeToPremium => 'Upgrade to Premium for unlimited';

  @override
  String get tryPremium => 'Try Premium';

  @override
  String get freeTier => 'Free Plan';

  @override
  String get premiumTier => 'Premium Plan';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get exportReport => 'Export Report';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get monthlyReport => 'Monthly Report';

  @override
  String get generatePdf => 'Generate PDF';

  @override
  String get shareReport => 'Share Report';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get unlockThisFeature => 'Upgrade to Premium to unlock this feature';

  @override
  String get selectReportPeriod => 'Select Report Period';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get reportGeneratedSuccessfully => 'Report generated successfully';

  @override
  String get errorGeneratingReport => 'Error generating report';

  @override
  String get pdfReportsRequirePremium =>
      'PDF reports are a premium feature. Upgrade to access detailed adherence reports.';

  @override
  String get premiumBenefits => 'Premium Benefits:';

  @override
  String get weeklyMonthlyReports => 'Weekly and monthly reports';

  @override
  String get detailedAdherenceStats => 'Detailed adherence statistics';

  @override
  String get sharableWithDoctors => 'Sharable with doctors and caregivers';

  @override
  String get close => 'Close';

  @override
  String get backupAndSync => 'Backup & Sync';

  @override
  String get syncWithCloud => 'Sync your data with the cloud';

  @override
  String get lastSync => 'Last sync:';

  @override
  String get never => 'Never';

  @override
  String get justNow => 'Just now';

  @override
  String get syncing => 'Syncing...';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get syncComplete => 'Sync complete';

  @override
  String get autoSync => 'Auto-sync';

  @override
  String get autoSyncSubtitle => 'Automatically sync when changes are made';

  @override
  String get takePhotoOption => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String failedToPickImage(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get missedDoseAlerts => 'Missed Dose Alerts';

  @override
  String get missedDoseAlertsSubtitle =>
      'Get notified when patients miss medications';

  @override
  String get lowStockAlerts => 'Low Stock Alerts';

  @override
  String get lowStockAlertsSubtitle =>
      'Get notified about low medication inventory';

  @override
  String get switchToPatientView => 'Switch to Patient View';

  @override
  String get areYouSureSignOut => 'Are you sure you want to sign out?';

  @override
  String get dataSharingPreferences => 'Data Sharing Preferences';

  @override
  String get dataSharingSubtitle =>
      'Control what information you share with your caregivers';

  @override
  String get shareAdherenceData => 'Share adherence data with caregivers';

  @override
  String get shareMedicationList => 'Share medication list with caregivers';

  @override
  String get allowCaregiverNotifications => 'Allow caregiver notifications';

  @override
  String get manageSubscription => 'Manage Subscription';

  @override
  String get noAdsDescription => 'Enjoy an ad-free experience';

  @override
  String get unlimitedCaregiversDescription =>
      'Connect with unlimited family members';

  @override
  String get pdfReportsDescription => 'Export detailed medication reports';

  @override
  String get customSoundsDescription => 'Personalize notification sounds';

  @override
  String get premiumThemesDescription => 'Access exclusive themes';

  @override
  String get purchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get purchasesRestored => 'Purchases restored successfully!';

  @override
  String get noPurchasesFound => 'No purchases found to restore.';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get noCaregiversLinked => 'No caregivers linked yet';

  @override
  String get revokeAccessTitle => 'Revoke Access';

  @override
  String revokeAccessConfirm(String name) {
    return 'Are you sure you want to revoke access for $name?';
  }

  @override
  String get revoke => 'Revoke';

  @override
  String get accessRevokedSuccess => 'Access revoked successfully';

  @override
  String failedToRevokeAccess(String error) {
    return 'Failed to revoke access: $error';
  }

  @override
  String errorLoadingCaregivers(String error) {
    return 'Error loading caregivers: $error';
  }

  @override
  String syncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get noRemindersForToday => 'No reminders for today';

  @override
  String get errorLoadingReminders => 'Error loading reminders';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get appVersion => 'App Version';

  @override
  String get deactivateAccountTitle => 'Deactivate Account';

  @override
  String get deactivateAccountMessage =>
      'Your account will be deactivated and you will be signed out. Your data will be preserved and you can sign back in later.';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountMessage =>
      'This will permanently delete your account and all data. This cannot be undone.';

  @override
  String get deleteAccountConfirmTitle => 'Are you sure?';

  @override
  String get deleteAccountConfirmMessage =>
      'All medications, schedules, history, and caregiver links will be permanently deleted.';

  @override
  String get deleteEverything => 'Delete Everything';

  @override
  String errorDeactivatingAccount(String error) {
    return 'Error deactivating account: $error';
  }

  @override
  String errorDeletingAccount(String error) {
    return 'Error deleting account: $error';
  }

  @override
  String get minuteShort => 'min';
}
