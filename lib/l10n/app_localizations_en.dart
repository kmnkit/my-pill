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
  String get onboardingFeature1 => 'Dose packs & individual pills';

  @override
  String get onboardingFeature2 => 'Works across timezones';

  @override
  String get onboardingFeature3 => 'Keep family connected';

  @override
  String get getStarted => 'Get Started';

  @override
  String get alreadyHaveAccount => 'I already have an account';

  @override
  String get tryWithoutAccount => 'Try without an account';

  @override
  String get localDataOnlyNotice =>
      'Without an account, your data is stored only on this device.';

  @override
  String get medicalDisclaimer =>
      'This app is a reminder tool and is not intended as medical advice. Always follow your doctor\'s instructions.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Kusuridoki';

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
  String get onboardingNameRequired =>
      'Your name will be shown to the patients you support';

  @override
  String get onboardingNameMinLength => 'Please enter at least 2 characters';

  @override
  String get onboardingRoleTitle => 'How will you use Kusuridoki?';

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
    return '$count pills remaining';
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
  String streakDays(int count) {
    return '$count-day streak';
  }

  @override
  String nextDoseAt(String time) {
    return 'Next: $time';
  }

  @override
  String get allDoneForToday => 'All done for today!';

  @override
  String get allDoneCelebration =>
      'You took all your medications today. Keep it up!';

  @override
  String weeklyTrendImproved(int delta) {
    return '+$delta% vs last week';
  }

  @override
  String weeklyTrendDeclined(int delta) {
    return '-$delta% vs last week';
  }

  @override
  String get weeklyTrendSame => 'Same as last week';

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
  String get consultDoctor =>
      'Consult your doctor for 3+ hour time differences';

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
  String get features => 'Features';

  @override
  String get safetyPrivacy => 'Safety & Privacy';

  @override
  String get exportHistory => 'Export History';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get advanced => 'Advanced';

  @override
  String get deactivateAccount => 'Log Out';

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
  String googleSignInFailed(String error) {
    return 'Google sign in failed: $error';
  }

  @override
  String appleSignInFailed(String error) {
    return 'Apple sign in failed: $error';
  }

  @override
  String get linkFailed => 'Failed to link account. Please try again.';

  @override
  String get appleSignInCancelled => 'Apple sign in was cancelled';

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
  String get premiumComingSoon => 'Coming Soon';

  @override
  String get premiumComingSoonMessage =>
      'We\'re working on Premium. Stay tuned!';

  @override
  String get premiumMonthly => 'Monthly Plan';

  @override
  String get premiumYearly => 'Yearly Plan';

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
  String get unlimitedCaregivers => 'Unlimited Caregivers';

  @override
  String get pdfReports => 'PDF Reports';

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
  String get unlimitedCaregiversBenefit => 'Unlimited caregivers';

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
  String get failedToPickImage => 'Failed to pick image. Please try again.';

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
  String get deactivateAccountTitle => 'Log Out';

  @override
  String get deactivateAccountMessage =>
      'You will be signed out. Your data will be preserved and you can sign back in later.';

  @override
  String get logOutMessageAnonymous =>
      'You are not signed in. Logging out will permanently delete all medications, schedules, and reminders on this device. This cannot be undone.';

  @override
  String get logOutMessageAuthenticated =>
      'Your local data will be removed from this device. You can restore it by signing in again.';

  @override
  String get deactivate => 'Log Out';

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
    return 'Error logging out: $error';
  }

  @override
  String errorDeletingAccount(String error) {
    return 'Error deleting account: $error';
  }

  @override
  String get minuteShort => 'min';

  @override
  String get noData => 'No Data';

  @override
  String get noEmail => 'No email';

  @override
  String get needsImprovement => 'Needs Improvement';

  @override
  String get startTrackingMessage =>
      'Start tracking your medications to see your adherence score.';

  @override
  String get excellentMessage =>
      'Keep up the great work! Your consistency is impressive.';

  @override
  String get goodMessage =>
      'You\'re doing well! A few missed doses here and there.';

  @override
  String get fairMessage => 'Room for improvement. Try setting more reminders.';

  @override
  String get needsImprovementMessage =>
      'Let\'s work on building a consistent routine together.';

  @override
  String get thisWeek => 'This Week';

  @override
  String get byMedication => 'By Medication';

  @override
  String get noMedicationData => 'No medication data available';

  @override
  String get adsRemovedSuccess => 'Ads removed successfully!';

  @override
  String get processingEllipsis => 'Processing...';

  @override
  String textSizeSemanticLabel(String label) {
    return 'Text size $label';
  }

  @override
  String get criticalMedication => 'Critical Medication';

  @override
  String get criticalMedicationLabel => 'Mark as Critical Medication';

  @override
  String get criticalMedicationDesc =>
      'Critical medications use high-priority alerts that can bypass Do Not Disturb';

  @override
  String get saving => 'Saving...';

  @override
  String get updating => 'Updating...';

  @override
  String get updateMedication => 'Update Medication';

  @override
  String get pleaseEnterMedicationName => 'Please enter a medication name';

  @override
  String get pleaseEnterDosage => 'Please enter a dosage';

  @override
  String get pleaseEnterValidDosage => 'Please enter a valid number for dosage';

  @override
  String get errorSavingMedication =>
      'Failed to save medication. Please try again.';

  @override
  String get errorSavingSchedule =>
      'Failed to save schedule. Please try again.';

  @override
  String get errorUpdatingMedication =>
      'Failed to update medication. Please try again.';

  @override
  String get errorLoadingMedication => 'Error loading medication';

  @override
  String get errorLoadingMedications => 'Error loading medications';

  @override
  String get medicationNotFound => 'Medication not found';

  @override
  String get noMedicationsFound => 'No medications found';

  @override
  String get searchMedicationsHint => 'Search medications...';

  @override
  String get dosageHint => 'e.g., Aspirin';

  @override
  String get schedule => 'Schedule';

  @override
  String get status => 'Status';

  @override
  String get noScheduleConfigured => 'No schedule configured';

  @override
  String get type => 'Type';

  @override
  String get times => 'Times';

  @override
  String get days => 'Days';

  @override
  String everyNHoursLabel(int hours) {
    return 'Every $hours hours';
  }

  @override
  String get added => 'Added';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get errorLoadingHistory => 'Error loading history';

  @override
  String get errorLoadingSchedule => 'Error loading schedule';

  @override
  String get deleteMedicationTitle => 'Delete Medication';

  @override
  String get howOften => 'How often?';

  @override
  String get whatTimes => 'What times?';

  @override
  String get whichDays => 'Which days?';

  @override
  String get whatTime => 'What time?';

  @override
  String get every => 'Every';

  @override
  String get hours => 'hours';

  @override
  String get daysUnit => 'days';

  @override
  String get dailyDesc => 'Take every day at the same time';

  @override
  String get specificDaysDesc => 'Take on selected days of the week';

  @override
  String get intervalDesc => 'Take every X hours or days';

  @override
  String get remaining => 'Remaining';

  @override
  String get total => 'Total';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get refillSetRemaining => 'Refill (Set Remaining = Total)';

  @override
  String get pleaseEnterValidNumbers => 'Please enter valid numbers';

  @override
  String get remainingMustBeZeroOrGreater => 'Remaining must be 0 or greater';

  @override
  String get totalMustBeGreaterThanZero => 'Total must be greater than 0';

  @override
  String get remainingCannotExceedTotal => 'Remaining cannot exceed total';

  @override
  String get myPatients => 'My Patients';

  @override
  String get noPatientsLinked => 'No patients linked';

  @override
  String get noPatientsLinkedDesc =>
      'Ask patients to share their invite code with you';

  @override
  String get alertTypes => 'Alert Types';

  @override
  String get missedDose => 'Missed Dose';

  @override
  String get missedDoseDesc =>
      'Get notified when a patient misses their scheduled medication';

  @override
  String get lowStockLabel => 'Low Stock';

  @override
  String get lowStockDesc =>
      'Receive alerts when medication inventory is running low';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get notificationsWillAppear =>
      'You\'ll be notified when your patients take or miss medications';

  @override
  String get alertsWillAppear =>
      'Alerts will appear when patients miss doses or have low medication stock';

  @override
  String get invitation => 'Invitation';

  @override
  String get youveBeenInvited => 'You\'ve been invited!';

  @override
  String inviteCodeLabel(String code) {
    return 'Invite Code: $code';
  }

  @override
  String get acceptInvitation => 'Accept Invitation';

  @override
  String get decline => 'Decline';

  @override
  String get successfullyLinked => 'Successfully linked as caregiver!';

  @override
  String get failedToAcceptInvite =>
      'Failed to accept invite. Please try again.';

  @override
  String get inviteNotFound => 'Invite code not found. Please check the link.';

  @override
  String get inviteExpired =>
      'This invite has expired. Please ask for a new one.';

  @override
  String get inviteAlreadyUsed => 'This invite has already been used.';

  @override
  String get inviteSelfError => 'You cannot accept your own invite.';

  @override
  String get inviteLinkGenerated => 'Invite link generated successfully!';

  @override
  String get failedToGenerateInvite =>
      'Failed to generate invite. Please try again.';

  @override
  String get cannotAddMoreCaregivers => 'Cannot add more caregivers';

  @override
  String get generateInviteLink => 'Generate Invite Link';

  @override
  String get generating => 'Generating...';

  @override
  String get generateInviteLinkDesc =>
      'Generate an invite link to share with your caregiver';

  @override
  String get newLink => 'New Link';

  @override
  String get linkCopied => 'Link copied!';

  @override
  String get processingInvite => 'Processing invite...';

  @override
  String get inviteAccepted => 'Invite accepted successfully!';

  @override
  String get joinMeOnMyPill => 'Join me on MyPill';

  @override
  String get link => 'Link';

  @override
  String get line => 'LINE';

  @override
  String get sms => 'SMS';

  @override
  String get loadingAdherence => 'Loading adherence...';

  @override
  String get positionQrCode => 'Position the QR code within the frame';

  @override
  String get noScheduledMedications => 'No scheduled medications';

  @override
  String failedToStart(String error) {
    return 'Failed to start: $error';
  }

  @override
  String get off => '34% OFF';

  @override
  String get unit => 'Unit';

  @override
  String get markAsTaken => 'Mark as taken';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get authError => 'Authentication error. Please sign in again.';

  @override
  String get permissionDenied =>
      'You don\'t have permission to perform this action.';

  @override
  String get serviceUnavailable =>
      'Service temporarily unavailable. Please try again later.';

  @override
  String get dosageMustBePositive => 'Dosage must be greater than zero';

  @override
  String get pleaseSelectAtLeastOneTime => 'Please select at least one time';

  @override
  String get pleaseSelectAtLeastOneDay => 'Please select at least one day';

  @override
  String get ippokaModeLabel => 'Dose Pack';

  @override
  String get ippokaDesc => 'Register as a pre-packaged dose bundle';

  @override
  String get packet => 'Packet';

  @override
  String get packs => 'pack(s)';

  @override
  String get ippokaNameHint => 'e.g. Morning Meds, Evening Meds';

  @override
  String get timeoutError => 'Request timed out. Please try again.';

  @override
  String get defaultUserName => 'User';

  @override
  String get colorWhite => 'White';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorRed => 'Red';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorPurple => 'Purple';

  @override
  String get dayMonday => 'Monday';

  @override
  String get dayTuesday => 'Tuesday';

  @override
  String get dayWednesday => 'Wednesday';

  @override
  String get dayThursday => 'Thursday';

  @override
  String get dayFriday => 'Friday';

  @override
  String get daySaturday => 'Saturday';

  @override
  String get daySunday => 'Sunday';

  @override
  String get dayMondayShort => 'M';

  @override
  String get dayTuesdayShort => 'T';

  @override
  String get dayWednesdayShort => 'W';

  @override
  String get dayThursdayShort => 'T';

  @override
  String get dayFridayShort => 'F';

  @override
  String get daySaturdayShort => 'S';

  @override
  String get daySundayShort => 'S';

  @override
  String snoozeMinutesSemanticLabel(int duration, String selected) {
    return '$duration minutes snooze, $selected';
  }

  @override
  String get selected => 'selected';

  @override
  String get notSelected => 'not selected';

  @override
  String inventorySemanticLabel(int current, int total, int percent) {
    return 'Inventory: $current of $total, $percent%';
  }

  @override
  String get dosePackIcon => 'Dose pack icon';

  @override
  String medicationIconLabel(String shape, String color) {
    return 'Medication icon: $shape $color';
  }

  @override
  String get scheduleTypeDaily => 'Daily';

  @override
  String get scheduleTypeSpecificDays => 'Specific Days';

  @override
  String get scheduleTypeInterval => 'Interval';

  @override
  String get errorLoadingPatients =>
      'Failed to load patients. Please try again.';

  @override
  String get onboardingMedStyleTitle => 'How do you receive your medication?';

  @override
  String get onboardingMedStyleSubtitle =>
      'Your choice sets the default when adding medications';

  @override
  String get onboardingIndividualPills => 'Individual pills or tablets';

  @override
  String get onboardingIndividualPillsDesc =>
      'Separate medications from the pharmacy';

  @override
  String get onboardingDosePack => 'Dose packs (一包化)';

  @override
  String get onboardingDosePackDesc =>
      'Pre-packaged sachets bundling multiple meds';

  @override
  String get dosageTimingTitle => 'Dosage Timing';

  @override
  String get dosageTimingMorning => 'Morning';

  @override
  String get dosageTimingNoon => 'Noon';

  @override
  String get dosageTimingEvening => 'Evening';

  @override
  String get dosageTimingBedtime => 'Before Bed';

  @override
  String get dosageTimingRequired => 'Required';

  @override
  String get subscriptionTerms =>
      'Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period. You can manage and cancel subscriptions in your Apple ID account settings.';

  @override
  String get subscriptionTermsAndroid =>
      'Payment will be charged to your Google Play account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period. You can manage and cancel subscriptions in Google Play.';

  @override
  String get freeTrial => '7-Day Free Trial';

  @override
  String get freeTrialDescription =>
      'Try all premium features free for 7 days, then subscribe.';

  @override
  String get adPrivacyNotice =>
      'Your medication data is never used for ad targeting.';

  @override
  String get selectDosageTiming => 'When do you take it?';

  @override
  String get adjustTimes => 'Adjust Times';

  @override
  String timeRangeHint(String timing, String min, String max) {
    return '$timing: $min:00 ~ $max:59';
  }

  @override
  String get pleaseSelectAtLeastOneTiming =>
      'Please select at least one timing';

  @override
  String timeOutOfRange(String min, String max) {
    return 'Time must be between $min:00 and $max:59';
  }

  @override
  String get changeTimezone => 'Change Timezone';

  @override
  String get searchTimezone => 'Search timezones...';

  @override
  String get selectDestinationTimezone => 'Select Destination Timezone';

  @override
  String get clearAllDataTitle => 'Clear All Data';

  @override
  String get clearAllDataMessage =>
      'Delete all medications, schedules, reminders, and adherence records?';

  @override
  String get clearAllDataConfirm => 'Clear';

  @override
  String get addPatient => 'Add Patient';

  @override
  String get enterCodeManually => 'Enter code manually';

  @override
  String get enterInviteCode => 'Enter Invite Code';

  @override
  String get inviteCodeHint => '8-character code';

  @override
  String get invalidInviteCode => 'Please enter a valid 8-character code';

  @override
  String markedAsTaken(String name) {
    return 'Marked $name as taken';
  }

  @override
  String markedAsSkipped(String name) {
    return 'Skipped $name';
  }

  @override
  String snoozedReminder(String name) {
    return 'Snoozed $name for 15 minutes';
  }

  @override
  String get howToConnectPatient => 'How to connect';

  @override
  String get connectStep1 => 'Install くすりどき on the patient\'s phone';

  @override
  String get connectStep2 =>
      'On the patient\'s app: Settings → Family & Supporters → Generate QR Code';

  @override
  String get connectStep3 =>
      'Tap \"Add Patient\" (top right) and scan the QR code';

  @override
  String get shareConnectGuide => 'Share this guide';

  @override
  String get editSchedule => 'Edit Schedule';

  @override
  String get cancelScheduleSetupTitle => 'Cancel Schedule Setup';

  @override
  String get cancelScheduleSetupMessage =>
      'Going back without setting a schedule will delete this medication';

  @override
  String get inventoryUnitDoses => 'doses';

  @override
  String get changeName => 'Change Name';

  @override
  String get changeNameTitle => 'Change Name';

  @override
  String get changeNameHint => 'Enter your name';

  @override
  String get nameSaved => 'Name saved';
}
