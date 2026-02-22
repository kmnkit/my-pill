import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Kusuridoki'**
  String get appTitle;

  /// No description provided for @onboardingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your reliable medication companion'**
  String get onboardingHeadline;

  /// No description provided for @onboardingFeature1.
  ///
  /// In en, this message translates to:
  /// **'Never miss a dose'**
  String get onboardingFeature1;

  /// No description provided for @onboardingFeature2.
  ///
  /// In en, this message translates to:
  /// **'Works across timezones'**
  String get onboardingFeature2;

  /// No description provided for @onboardingFeature3.
  ///
  /// In en, this message translates to:
  /// **'Keep family connected'**
  String get onboardingFeature3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @tryWithoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Try without an account'**
  String get tryWithoutAccount;

  /// No description provided for @localDataOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'Without an account, your data is stored only on this device.'**
  String get localDataOnlyNotice;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kusuridoki'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your medication companion'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingFinish;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @onboardingNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use this to personalize your experience'**
  String get onboardingNameSubtitle;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get onboardingNameHint;

  /// No description provided for @onboardingNameSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingNameSkip;

  /// No description provided for @onboardingRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'How will you use Kusuridoki?'**
  String get onboardingRoleTitle;

  /// No description provided for @onboardingRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the option that best describes you'**
  String get onboardingRoleSubtitle;

  /// No description provided for @onboardingRolePatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get onboardingRolePatient;

  /// No description provided for @onboardingRolePatientDesc.
  ///
  /// In en, this message translates to:
  /// **'I\'m managing my own medications'**
  String get onboardingRolePatientDesc;

  /// No description provided for @onboardingRoleCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver'**
  String get onboardingRoleCaregiver;

  /// No description provided for @onboardingRoleCaregiverDesc.
  ///
  /// In en, this message translates to:
  /// **'I\'m helping someone else with their medications'**
  String get onboardingRoleCaregiverDesc;

  /// No description provided for @onboardingTimezoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your timezone'**
  String get onboardingTimezoneTitle;

  /// No description provided for @onboardingTimezoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This ensures reminders arrive at the right time'**
  String get onboardingTimezoneSubtitle;

  /// No description provided for @onboardingTimezoneDetected.
  ///
  /// In en, this message translates to:
  /// **'Detected timezone'**
  String get onboardingTimezoneDetected;

  /// No description provided for @onboardingTimezoneChange.
  ///
  /// In en, this message translates to:
  /// **'Change timezone'**
  String get onboardingTimezoneChange;

  /// No description provided for @onboardingTimezonePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Timezone'**
  String get onboardingTimezonePickerTitle;

  /// No description provided for @onboardingTimezoneSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search timezones...'**
  String get onboardingTimezoneSearchHint;

  /// No description provided for @onboardingTimezoneNoResults.
  ///
  /// In en, this message translates to:
  /// **'No timezones found'**
  String get onboardingTimezoneNoResults;

  /// No description provided for @onboardingNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on track'**
  String get onboardingNotificationTitle;

  /// No description provided for @onboardingNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get timely reminders for your medications'**
  String get onboardingNotificationSubtitle;

  /// No description provided for @onboardingNotificationEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get onboardingNotificationEnable;

  /// No description provided for @onboardingNotificationSkip.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get onboardingNotificationSkip;

  /// No description provided for @onboardingNotificationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get onboardingNotificationEnabled;

  /// No description provided for @onboardingNotificationDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get onboardingNotificationDenied;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @medicationsToday.
  ///
  /// In en, this message translates to:
  /// **'{count} medications today, {taken} taken'**
  String medicationsToday(int count, int taken);

  /// No description provided for @lowStockAlert.
  ///
  /// In en, this message translates to:
  /// **'{name} - {count} pills remaining'**
  String lowStockAlert(String name, int count);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @adherence.
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get adherence;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @myMedications.
  ///
  /// In en, this message translates to:
  /// **'My Medications'**
  String get myMedications;

  /// No description provided for @searchMedications.
  ///
  /// In en, this message translates to:
  /// **'Search medications...'**
  String get searchMedications;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// No description provided for @editMedication.
  ///
  /// In en, this message translates to:
  /// **'Edit Medication'**
  String get editMedication;

  /// No description provided for @saveMedication.
  ///
  /// In en, this message translates to:
  /// **'Save Medication'**
  String get saveMedication;

  /// No description provided for @deleteMedication.
  ///
  /// In en, this message translates to:
  /// **'Delete Medication'**
  String get deleteMedication;

  /// No description provided for @deleteMedicationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this medication? This action cannot be undone.'**
  String get deleteMedicationConfirm;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @dosageUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get dosageUnit;

  /// No description provided for @pillShape.
  ///
  /// In en, this message translates to:
  /// **'Pill Shape'**
  String get pillShape;

  /// No description provided for @pillColor.
  ///
  /// In en, this message translates to:
  /// **'Pill Color'**
  String get pillColor;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take or upload a photo'**
  String get takePhoto;

  /// No description provided for @scheduleType.
  ///
  /// In en, this message translates to:
  /// **'Schedule Type'**
  String get scheduleType;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @currentStock.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// No description provided for @stockRemaining.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String stockRemaining(int current, int total);

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @updateInventory.
  ///
  /// In en, this message translates to:
  /// **'Update Inventory'**
  String get updateInventory;

  /// No description provided for @noMedications.
  ///
  /// In en, this message translates to:
  /// **'No medications yet'**
  String get noMedications;

  /// No description provided for @addFirstMedication.
  ///
  /// In en, this message translates to:
  /// **'Add your first medication to get started'**
  String get addFirstMedication;

  /// No description provided for @round.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get round;

  /// No description provided for @capsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get capsule;

  /// No description provided for @oval.
  ///
  /// In en, this message translates to:
  /// **'Oval'**
  String get oval;

  /// No description provided for @square.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get square;

  /// No description provided for @triangle.
  ///
  /// In en, this message translates to:
  /// **'Triangle'**
  String get triangle;

  /// No description provided for @hexagon.
  ///
  /// In en, this message translates to:
  /// **'Hexagon'**
  String get hexagon;

  /// No description provided for @mg.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get mg;

  /// No description provided for @ml.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get ml;

  /// No description provided for @pills.
  ///
  /// In en, this message translates to:
  /// **'pills'**
  String get pills;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @setSchedule.
  ///
  /// In en, this message translates to:
  /// **'Set Schedule'**
  String get setSchedule;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @specificDays.
  ///
  /// In en, this message translates to:
  /// **'Specific Days'**
  String get specificDays;

  /// No description provided for @interval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get interval;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @timesPerDay.
  ///
  /// In en, this message translates to:
  /// **'Times per day'**
  String get timesPerDay;

  /// No description provided for @addAnotherTime.
  ///
  /// In en, this message translates to:
  /// **'Add another time'**
  String get addAnotherTime;

  /// No description provided for @everyNHours.
  ///
  /// In en, this message translates to:
  /// **'Every {hours} hours'**
  String everyNHours(int hours);

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @snoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get snoozed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @takeNow.
  ///
  /// In en, this message translates to:
  /// **'Take Now'**
  String get takeNow;

  /// No description provided for @snoozeMinutes.
  ///
  /// In en, this message translates to:
  /// **'Snooze {minutes} min'**
  String snoozeMinutes(int minutes);

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @pillsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} pills remaining'**
  String pillsRemaining(int count);

  /// No description provided for @weeklyAdherence.
  ///
  /// In en, this message translates to:
  /// **'Weekly Adherence'**
  String get weeklyAdherence;

  /// No description provided for @overallAdherence.
  ///
  /// In en, this message translates to:
  /// **'Overall Adherence'**
  String get overallAdherence;

  /// No description provided for @adherenceRate.
  ///
  /// In en, this message translates to:
  /// **'Adherence Rate'**
  String get adherenceRate;

  /// No description provided for @adherenceRatePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String adherenceRatePercent(int percent);

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @keepItUp.
  ///
  /// In en, this message translates to:
  /// **'Keep up the great work!'**
  String get keepItUp;

  /// No description provided for @medicationBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Medication Breakdown'**
  String get medicationBreakdown;

  /// No description provided for @recentHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent History'**
  String get recentHistory;

  /// No description provided for @travelMode.
  ///
  /// In en, this message translates to:
  /// **'Travel Mode'**
  String get travelMode;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentLocation;

  /// No description provided for @homeLocation.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLocation;

  /// No description provided for @timeDifference.
  ///
  /// In en, this message translates to:
  /// **'Time difference: {hours}'**
  String timeDifference(String hours);

  /// No description provided for @enableTravelMode.
  ///
  /// In en, this message translates to:
  /// **'Enable Travel Mode'**
  String get enableTravelMode;

  /// No description provided for @fixedInterval.
  ///
  /// In en, this message translates to:
  /// **'Fixed Interval (Home Time)'**
  String get fixedInterval;

  /// No description provided for @fixedIntervalDesc.
  ///
  /// In en, this message translates to:
  /// **'Take meds at home timezone'**
  String get fixedIntervalDesc;

  /// No description provided for @localTime.
  ///
  /// In en, this message translates to:
  /// **'Local Time Adaptation'**
  String get localTime;

  /// No description provided for @localTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust to local timezone'**
  String get localTimeDesc;

  /// No description provided for @affectedMedications.
  ///
  /// In en, this message translates to:
  /// **'Affected Medications'**
  String get affectedMedications;

  /// No description provided for @consultDoctor.
  ///
  /// In en, this message translates to:
  /// **'Consult your doctor for 3+ hour time differences'**
  String get consultDoctor;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @profileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile Info'**
  String get profileInfo;

  /// No description provided for @signInSettings.
  ///
  /// In en, this message translates to:
  /// **'Sign-in Settings'**
  String get signInSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @criticalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Critical Alerts'**
  String get criticalAlerts;

  /// No description provided for @snoozeDuration.
  ///
  /// In en, this message translates to:
  /// **'Snooze Duration'**
  String get snoozeDuration;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get highContrast;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @extraLarge.
  ///
  /// In en, this message translates to:
  /// **'XL'**
  String get extraLarge;

  /// No description provided for @safetyPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Safety & Privacy'**
  String get safetyPrivacy;

  /// No description provided for @exportHistory.
  ///
  /// In en, this message translates to:
  /// **'Export History'**
  String get exportHistory;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @deactivateAccount.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get deactivateAccount;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @upgradeMessage.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for a cleaner experience'**
  String get upgradeMessage;

  /// No description provided for @switchToCaregiverView.
  ///
  /// In en, this message translates to:
  /// **'Switch to Caregiver View'**
  String get switchToCaregiverView;

  /// No description provided for @familyCaregivers.
  ///
  /// In en, this message translates to:
  /// **'Family & Caregivers'**
  String get familyCaregivers;

  /// No description provided for @linkedCaregivers.
  ///
  /// In en, this message translates to:
  /// **'Linked Caregivers'**
  String get linkedCaregivers;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @revokeAccess.
  ///
  /// In en, this message translates to:
  /// **'Revoke Access'**
  String get revokeAccess;

  /// No description provided for @inviteCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Invite Caregiver'**
  String get inviteCaregiver;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @shareVia.
  ///
  /// In en, this message translates to:
  /// **'Share via'**
  String get shareVia;

  /// No description provided for @privacyNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Notice'**
  String get privacyNoticeTitle;

  /// No description provided for @privacyNotice1.
  ///
  /// In en, this message translates to:
  /// **'Caregivers can only see medication adherence and scheduled reminders'**
  String get privacyNotice1;

  /// No description provided for @privacyNotice2.
  ///
  /// In en, this message translates to:
  /// **'Private notes and other health data remain visible only to you'**
  String get privacyNotice2;

  /// No description provided for @caregiverDashboard.
  ///
  /// In en, this message translates to:
  /// **'My Patients'**
  String get caregiverDashboard;

  /// No description provided for @dailyAdherence.
  ///
  /// In en, this message translates to:
  /// **'Daily Adherence'**
  String get dailyAdherence;

  /// No description provided for @takenCount.
  ///
  /// In en, this message translates to:
  /// **'{taken}/{total} taken'**
  String takenCount(int taken, int total);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @highContrastDescription.
  ///
  /// In en, this message translates to:
  /// **'Increase contrast for better visibility'**
  String get highContrastDescription;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @linkAccount.
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get linkAccount;

  /// No description provided for @linkWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Link with Google'**
  String get linkWithGoogle;

  /// No description provided for @linkWithApple.
  ///
  /// In en, this message translates to:
  /// **'Link with Apple'**
  String get linkWithApple;

  /// No description provided for @accountLinked.
  ///
  /// In en, this message translates to:
  /// **'Account linked successfully'**
  String get accountLinked;

  /// No description provided for @signInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign in was cancelled'**
  String get signInCancelled;

  /// No description provided for @accountAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This account is already linked to another user'**
  String get accountAlreadyLinked;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @signInToSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync data'**
  String get signInToSync;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @signInToAccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your account'**
  String get signInToAccess;

  /// No description provided for @errorLoadingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error loading account'**
  String get errorLoadingAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign in failed: {error}'**
  String googleSignInFailed(String error);

  /// No description provided for @appleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple sign in failed: {error}'**
  String appleSignInFailed(String error);

  /// No description provided for @linkFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to link account: {error}'**
  String linkFailed(String error);

  /// No description provided for @appleSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Apple sign in was cancelled'**
  String get appleSignInCancelled;

  /// No description provided for @appleCredentialAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This Apple account is already linked to another user'**
  String get appleCredentialAlreadyInUse;

  /// No description provided for @appleInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Apple sign in failed. Please try again'**
  String get appleInvalidCredential;

  /// No description provided for @appleOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Apple sign in is not enabled for this app'**
  String get appleOperationNotAllowed;

  /// No description provided for @appleProviderAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'An Apple account is already linked to this profile'**
  String get appleProviderAlreadyLinked;

  /// No description provided for @appleNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again'**
  String get appleNetworkError;

  /// No description provided for @appleSignInUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Apple sign in failed. Please try again later'**
  String get appleSignInUnknownError;

  /// No description provided for @privateEmailNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'re using Apple\'s private email relay.'**
  String get privateEmailNotice;

  /// No description provided for @emailHidden.
  ///
  /// In en, this message translates to:
  /// **'Email hidden'**
  String get emailHidden;

  /// No description provided for @usesPrivateEmail.
  ///
  /// In en, this message translates to:
  /// **'Using private email relay'**
  String get usesPrivateEmail;

  /// No description provided for @emailAddressInfo.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressInfo;

  /// No description provided for @weeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get weeklySummary;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @premiumMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get premiumMonthly;

  /// No description provided for @premiumYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly Plan (34% off)'**
  String get premiumYearly;

  /// No description provided for @premiumMonthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'¥480/mo'**
  String get premiumMonthlyPrice;

  /// No description provided for @premiumYearlyPrice.
  ///
  /// In en, this message translates to:
  /// **'¥3,800/yr'**
  String get premiumYearlyPrice;

  /// No description provided for @unlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get unlockPremium;

  /// No description provided for @premiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get premiumFeatures;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get noAds;

  /// No description provided for @unlimitedCaregivers.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Caregivers'**
  String get unlimitedCaregivers;

  /// No description provided for @pdfReports.
  ///
  /// In en, this message translates to:
  /// **'PDF Reports'**
  String get pdfReports;

  /// No description provided for @customSounds.
  ///
  /// In en, this message translates to:
  /// **'Custom Notification Sounds'**
  String get customSounds;

  /// No description provided for @premiumThemes.
  ///
  /// In en, this message translates to:
  /// **'Premium Themes'**
  String get premiumThemes;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @alreadyPremium.
  ///
  /// In en, this message translates to:
  /// **'You\'re a Premium member'**
  String get alreadyPremium;

  /// No description provided for @premiumExpiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires: {date}'**
  String premiumExpiresAt(String date);

  /// No description provided for @caregiverLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Free plan allows only 1 caregiver'**
  String get caregiverLimitReached;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium for unlimited'**
  String get upgradeToPremium;

  /// No description provided for @tryPremium.
  ///
  /// In en, this message translates to:
  /// **'Try Premium'**
  String get tryPremium;

  /// No description provided for @freeTier.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freeTier;

  /// No description provided for @premiumTier.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get premiumTier;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report'**
  String get weeklyReport;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReport;

  /// No description provided for @generatePdf.
  ///
  /// In en, this message translates to:
  /// **'Generate PDF'**
  String get generatePdf;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get shareReport;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeature;

  /// No description provided for @unlockThisFeature.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to unlock this feature'**
  String get unlockThisFeature;

  /// No description provided for @selectReportPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select Report Period'**
  String get selectReportPeriod;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @reportGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Report generated successfully'**
  String get reportGeneratedSuccessfully;

  /// No description provided for @errorGeneratingReport.
  ///
  /// In en, this message translates to:
  /// **'Error generating report'**
  String get errorGeneratingReport;

  /// No description provided for @pdfReportsRequirePremium.
  ///
  /// In en, this message translates to:
  /// **'PDF reports are a premium feature. Upgrade to access detailed adherence reports.'**
  String get pdfReportsRequirePremium;

  /// No description provided for @premiumBenefits.
  ///
  /// In en, this message translates to:
  /// **'Premium Benefits:'**
  String get premiumBenefits;

  /// No description provided for @weeklyMonthlyReports.
  ///
  /// In en, this message translates to:
  /// **'Weekly and monthly reports'**
  String get weeklyMonthlyReports;

  /// No description provided for @detailedAdherenceStats.
  ///
  /// In en, this message translates to:
  /// **'Detailed adherence statistics'**
  String get detailedAdherenceStats;

  /// No description provided for @sharableWithDoctors.
  ///
  /// In en, this message translates to:
  /// **'Sharable with doctors and caregivers'**
  String get sharableWithDoctors;

  /// No description provided for @unlimitedCaregiversBenefit.
  ///
  /// In en, this message translates to:
  /// **'Unlimited caregivers'**
  String get unlimitedCaregiversBenefit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @backupAndSync.
  ///
  /// In en, this message translates to:
  /// **'Backup & Sync'**
  String get backupAndSync;

  /// No description provided for @syncWithCloud.
  ///
  /// In en, this message translates to:
  /// **'Sync your data with the cloud'**
  String get syncWithCloud;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync:'**
  String get lastSync;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @syncComplete.
  ///
  /// In en, this message translates to:
  /// **'Sync complete'**
  String get syncComplete;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto-sync'**
  String get autoSync;

  /// No description provided for @autoSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically sync when changes are made'**
  String get autoSyncSubtitle;

  /// No description provided for @takePhotoOption.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhotoOption;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// No description provided for @missedDoseAlerts.
  ///
  /// In en, this message translates to:
  /// **'Missed Dose Alerts'**
  String get missedDoseAlerts;

  /// No description provided for @missedDoseAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when patients miss medications'**
  String get missedDoseAlertsSubtitle;

  /// No description provided for @lowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get lowStockAlerts;

  /// No description provided for @lowStockAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified about low medication inventory'**
  String get lowStockAlertsSubtitle;

  /// No description provided for @switchToPatientView.
  ///
  /// In en, this message translates to:
  /// **'Switch to Patient View'**
  String get switchToPatientView;

  /// No description provided for @areYouSureSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSureSignOut;

  /// No description provided for @dataSharingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing Preferences'**
  String get dataSharingPreferences;

  /// No description provided for @dataSharingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control what information you share with your caregivers'**
  String get dataSharingSubtitle;

  /// No description provided for @shareAdherenceData.
  ///
  /// In en, this message translates to:
  /// **'Share adherence data with caregivers'**
  String get shareAdherenceData;

  /// No description provided for @shareMedicationList.
  ///
  /// In en, this message translates to:
  /// **'Share medication list with caregivers'**
  String get shareMedicationList;

  /// No description provided for @allowCaregiverNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow caregiver notifications'**
  String get allowCaregiverNotifications;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @noAdsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enjoy an ad-free experience'**
  String get noAdsDescription;

  /// No description provided for @unlimitedCaregiversDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect with unlimited family members'**
  String get unlimitedCaregiversDescription;

  /// No description provided for @pdfReportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Export detailed medication reports'**
  String get pdfReportsDescription;

  /// No description provided for @customSoundsDescription.
  ///
  /// In en, this message translates to:
  /// **'Personalize notification sounds'**
  String get customSoundsDescription;

  /// No description provided for @premiumThemesDescription.
  ///
  /// In en, this message translates to:
  /// **'Access exclusive themes'**
  String get premiumThemesDescription;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get purchaseFailed;

  /// No description provided for @purchasesRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully!'**
  String get purchasesRestored;

  /// No description provided for @noPurchasesFound.
  ///
  /// In en, this message translates to:
  /// **'No purchases found to restore.'**
  String get noPurchasesFound;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @noCaregiversLinked.
  ///
  /// In en, this message translates to:
  /// **'No caregivers linked yet'**
  String get noCaregiversLinked;

  /// No description provided for @revokeAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke Access'**
  String get revokeAccessTitle;

  /// No description provided for @revokeAccessConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to revoke access for {name}?'**
  String revokeAccessConfirm(String name);

  /// No description provided for @revoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// No description provided for @accessRevokedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Access revoked successfully'**
  String get accessRevokedSuccess;

  /// No description provided for @failedToRevokeAccess.
  ///
  /// In en, this message translates to:
  /// **'Failed to revoke access: {error}'**
  String failedToRevokeAccess(String error);

  /// No description provided for @errorLoadingCaregivers.
  ///
  /// In en, this message translates to:
  /// **'Error loading caregivers: {error}'**
  String errorLoadingCaregivers(String error);

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {error}'**
  String syncFailed(String error);

  /// No description provided for @noRemindersForToday.
  ///
  /// In en, this message translates to:
  /// **'No reminders for today'**
  String get noRemindersForToday;

  /// No description provided for @errorLoadingReminders.
  ///
  /// In en, this message translates to:
  /// **'Error loading reminders'**
  String get errorLoadingReminders;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @deactivateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get deactivateAccountTitle;

  /// No description provided for @deactivateAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'You will be signed out. Your data will be preserved and you can sign back in later.'**
  String get deactivateAccountMessage;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get deactivate;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all data. This cannot be undone.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'All medications, schedules, history, and caregiver links will be permanently deleted.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete Everything'**
  String get deleteEverything;

  /// No description provided for @errorDeactivatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error logging out: {error}'**
  String errorDeactivatingAccount(String error);

  /// No description provided for @errorDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account: {error}'**
  String errorDeletingAccount(String error);

  /// No description provided for @minuteShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minuteShort;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @needsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get needsImprovement;

  /// No description provided for @startTrackingMessage.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your medications to see your adherence score.'**
  String get startTrackingMessage;

  /// No description provided for @excellentMessage.
  ///
  /// In en, this message translates to:
  /// **'Keep up the great work! Your consistency is impressive.'**
  String get excellentMessage;

  /// No description provided for @goodMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing well! A few missed doses here and there.'**
  String get goodMessage;

  /// No description provided for @fairMessage.
  ///
  /// In en, this message translates to:
  /// **'Room for improvement. Try setting more reminders.'**
  String get fairMessage;

  /// No description provided for @needsImprovementMessage.
  ///
  /// In en, this message translates to:
  /// **'Let\'s work on building a consistent routine together.'**
  String get needsImprovementMessage;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @byMedication.
  ///
  /// In en, this message translates to:
  /// **'By Medication'**
  String get byMedication;

  /// No description provided for @noMedicationData.
  ///
  /// In en, this message translates to:
  /// **'No medication data available'**
  String get noMedicationData;

  /// No description provided for @adsRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ads removed successfully!'**
  String get adsRemovedSuccess;

  /// No description provided for @processingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processingEllipsis;

  /// No description provided for @textSizeSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Text size {label}'**
  String textSizeSemanticLabel(String label);

  /// No description provided for @criticalMedication.
  ///
  /// In en, this message translates to:
  /// **'Critical Medication'**
  String get criticalMedication;

  /// No description provided for @criticalMedicationLabel.
  ///
  /// In en, this message translates to:
  /// **'Mark as Critical Medication'**
  String get criticalMedicationLabel;

  /// No description provided for @criticalMedicationDesc.
  ///
  /// In en, this message translates to:
  /// **'Critical medications use high-priority alerts that can bypass Do Not Disturb'**
  String get criticalMedicationDesc;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @updateMedication.
  ///
  /// In en, this message translates to:
  /// **'Update Medication'**
  String get updateMedication;

  /// No description provided for @pleaseEnterMedicationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a medication name'**
  String get pleaseEnterMedicationName;

  /// No description provided for @pleaseEnterDosage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a dosage'**
  String get pleaseEnterDosage;

  /// No description provided for @pleaseEnterValidDosage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number for dosage'**
  String get pleaseEnterValidDosage;

  /// No description provided for @errorSavingMedication.
  ///
  /// In en, this message translates to:
  /// **'Error saving medication: {error}'**
  String errorSavingMedication(String error);

  /// No description provided for @errorUpdatingMedication.
  ///
  /// In en, this message translates to:
  /// **'Error updating medication: {error}'**
  String errorUpdatingMedication(String error);

  /// No description provided for @errorLoadingMedication.
  ///
  /// In en, this message translates to:
  /// **'Error loading medication'**
  String get errorLoadingMedication;

  /// No description provided for @errorLoadingMedications.
  ///
  /// In en, this message translates to:
  /// **'Error loading medications'**
  String get errorLoadingMedications;

  /// No description provided for @medicationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Medication not found'**
  String get medicationNotFound;

  /// No description provided for @noMedicationsFound.
  ///
  /// In en, this message translates to:
  /// **'No medications found'**
  String get noMedicationsFound;

  /// No description provided for @searchMedicationsHint.
  ///
  /// In en, this message translates to:
  /// **'Search medications...'**
  String get searchMedicationsHint;

  /// No description provided for @dosageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Aspirin'**
  String get dosageHint;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @noScheduleConfigured.
  ///
  /// In en, this message translates to:
  /// **'No schedule configured'**
  String get noScheduleConfigured;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get times;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @everyNHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Every {hours} hours'**
  String everyNHoursLabel(int hours);

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @errorLoadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Error loading history'**
  String get errorLoadingHistory;

  /// No description provided for @errorLoadingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Error loading schedule'**
  String get errorLoadingSchedule;

  /// No description provided for @deleteMedicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Medication'**
  String get deleteMedicationTitle;

  /// No description provided for @howOften.
  ///
  /// In en, this message translates to:
  /// **'How often?'**
  String get howOften;

  /// No description provided for @howManyTimesPerDay.
  ///
  /// In en, this message translates to:
  /// **'How many times per day?'**
  String get howManyTimesPerDay;

  /// No description provided for @whatTimes.
  ///
  /// In en, this message translates to:
  /// **'What times?'**
  String get whatTimes;

  /// No description provided for @whichDays.
  ///
  /// In en, this message translates to:
  /// **'Which days?'**
  String get whichDays;

  /// No description provided for @whatTime.
  ///
  /// In en, this message translates to:
  /// **'What time?'**
  String get whatTime;

  /// No description provided for @every.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get every;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysUnit;

  /// No description provided for @addAnotherTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Add another time'**
  String get addAnotherTimeLabel;

  /// No description provided for @dailyDesc.
  ///
  /// In en, this message translates to:
  /// **'Take every day at the same time'**
  String get dailyDesc;

  /// No description provided for @specificDaysDesc.
  ///
  /// In en, this message translates to:
  /// **'Take on selected days of the week'**
  String get specificDaysDesc;

  /// No description provided for @intervalDesc.
  ///
  /// In en, this message translates to:
  /// **'Take every X hours or days'**
  String get intervalDesc;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @refillSetRemaining.
  ///
  /// In en, this message translates to:
  /// **'Refill (Set Remaining = Total)'**
  String get refillSetRemaining;

  /// No description provided for @pleaseEnterValidNumbers.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers'**
  String get pleaseEnterValidNumbers;

  /// No description provided for @remainingMustBeZeroOrGreater.
  ///
  /// In en, this message translates to:
  /// **'Remaining must be 0 or greater'**
  String get remainingMustBeZeroOrGreater;

  /// No description provided for @totalMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Total must be greater than 0'**
  String get totalMustBeGreaterThanZero;

  /// No description provided for @remainingCannotExceedTotal.
  ///
  /// In en, this message translates to:
  /// **'Remaining cannot exceed total'**
  String get remainingCannotExceedTotal;

  /// No description provided for @myPatients.
  ///
  /// In en, this message translates to:
  /// **'My Patients'**
  String get myPatients;

  /// No description provided for @noPatientsLinked.
  ///
  /// In en, this message translates to:
  /// **'No patients linked'**
  String get noPatientsLinked;

  /// No description provided for @noPatientsLinkedDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask patients to share their invite code with you'**
  String get noPatientsLinkedDesc;

  /// No description provided for @alertTypes.
  ///
  /// In en, this message translates to:
  /// **'Alert Types'**
  String get alertTypes;

  /// No description provided for @missedDose.
  ///
  /// In en, this message translates to:
  /// **'Missed Dose'**
  String get missedDose;

  /// No description provided for @missedDoseDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when a patient misses their scheduled medication'**
  String get missedDoseDesc;

  /// No description provided for @lowStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStockLabel;

  /// No description provided for @lowStockDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive alerts when medication inventory is running low'**
  String get lowStockDesc;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @notificationsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be notified when your patients take or miss medications'**
  String get notificationsWillAppear;

  /// No description provided for @alertsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Alerts will appear when patients miss doses or have low medication stock'**
  String get alertsWillAppear;

  /// No description provided for @invitation.
  ///
  /// In en, this message translates to:
  /// **'Invitation'**
  String get invitation;

  /// No description provided for @youveBeenInvited.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been invited!'**
  String get youveBeenInvited;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite Code: {code}'**
  String inviteCodeLabel(String code);

  /// No description provided for @acceptInvitation.
  ///
  /// In en, this message translates to:
  /// **'Accept Invitation'**
  String get acceptInvitation;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @successfullyLinked.
  ///
  /// In en, this message translates to:
  /// **'Successfully linked as caregiver!'**
  String get successfullyLinked;

  /// No description provided for @failedToAcceptInvite.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept invite: {error}'**
  String failedToAcceptInvite(String error);

  /// No description provided for @inviteLinkGenerated.
  ///
  /// In en, this message translates to:
  /// **'Invite link generated successfully!'**
  String get inviteLinkGenerated;

  /// No description provided for @failedToGenerateInvite.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate invite: {error}'**
  String failedToGenerateInvite(String error);

  /// No description provided for @cannotAddMoreCaregivers.
  ///
  /// In en, this message translates to:
  /// **'Cannot add more caregivers'**
  String get cannotAddMoreCaregivers;

  /// No description provided for @generateInviteLink.
  ///
  /// In en, this message translates to:
  /// **'Generate Invite Link'**
  String get generateInviteLink;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generating;

  /// No description provided for @generateInviteLinkDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate an invite link to share with your caregiver'**
  String get generateInviteLinkDesc;

  /// No description provided for @newLink.
  ///
  /// In en, this message translates to:
  /// **'New Link'**
  String get newLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied!'**
  String get linkCopied;

  /// No description provided for @processingInvite.
  ///
  /// In en, this message translates to:
  /// **'Processing invite...'**
  String get processingInvite;

  /// No description provided for @inviteAccepted.
  ///
  /// In en, this message translates to:
  /// **'Invite accepted successfully!'**
  String get inviteAccepted;

  /// No description provided for @joinMeOnMyPill.
  ///
  /// In en, this message translates to:
  /// **'Join me on MyPill'**
  String get joinMeOnMyPill;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @line.
  ///
  /// In en, this message translates to:
  /// **'LINE'**
  String get line;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @loadingAdherence.
  ///
  /// In en, this message translates to:
  /// **'Loading adherence...'**
  String get loadingAdherence;

  /// No description provided for @positionQrCode.
  ///
  /// In en, this message translates to:
  /// **'Position the QR code within the frame'**
  String get positionQrCode;

  /// No description provided for @noScheduledMedications.
  ///
  /// In en, this message translates to:
  /// **'No scheduled medications'**
  String get noScheduledMedications;

  /// No description provided for @failedToStart.
  ///
  /// In en, this message translates to:
  /// **'Failed to start: {error}'**
  String failedToStart(String error);

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'34% OFF'**
  String get off;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @markAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark as taken'**
  String get markAsTaken;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
