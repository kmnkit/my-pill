import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    UserProfile buildFull() => const UserProfile(
          id: 'user-001',
          name: 'Alice Tanaka',
          email: 'alice@example.com',
          language: 'ja',
          highContrast: true,
          textSize: 'large',
          notificationsEnabled: false,
          criticalAlerts: true,
          snoozeDuration: 30,
          travelModeEnabled: true,
          homeTimezone: 'Asia/Tokyo',
          removeAds: true,
          usesPrivateEmail: true,
          onboardingComplete: true,
          userRole: 'caregiver',
          shareAdherenceData: false,
          shareMedicationList: false,
          allowCaregiverNotifications: false,
          missedDoseAlerts: false,
          lowStockAlerts: false,
        );

    UserProfile buildMinimal() => const UserProfile(id: 'user-002');

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields', () {
        final original = buildFull();
        final json = original.toJson();
        final restored = UserProfile.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.email, original.email);
        expect(restored.language, original.language);
        expect(restored.highContrast, original.highContrast);
        expect(restored.textSize, original.textSize);
        expect(restored.notificationsEnabled, original.notificationsEnabled);
        expect(restored.criticalAlerts, original.criticalAlerts);
        expect(restored.snoozeDuration, original.snoozeDuration);
        expect(restored.travelModeEnabled, original.travelModeEnabled);
        expect(restored.homeTimezone, original.homeTimezone);
        expect(restored.removeAds, original.removeAds);
        expect(restored.usesPrivateEmail, original.usesPrivateEmail);
        expect(restored.onboardingComplete, original.onboardingComplete);
        expect(restored.userRole, original.userRole);
        expect(restored.shareAdherenceData, original.shareAdherenceData);
        expect(restored.shareMedicationList, original.shareMedicationList);
        expect(restored.allowCaregiverNotifications,
            original.allowCaregiverNotifications);
        expect(restored.missedDoseAlerts, original.missedDoseAlerts);
        expect(restored.lowStockAlerts, original.lowStockAlerts);
      });

      test('roundtrip with null optional fields', () {
        final original = buildMinimal();
        final json = original.toJson();
        final restored = UserProfile.fromJson(json);

        expect(restored.name, isNull);
        expect(restored.email, isNull);
        expect(restored.homeTimezone, isNull);
      });

      test('toJson contains all expected keys', () {
        final json = buildFull().toJson();

        expect(json.containsKey('id'), isTrue);
        expect(json.containsKey('name'), isTrue);
        expect(json.containsKey('email'), isTrue);
        expect(json.containsKey('language'), isTrue);
        expect(json.containsKey('highContrast'), isTrue);
        expect(json.containsKey('textSize'), isTrue);
        expect(json.containsKey('notificationsEnabled'), isTrue);
        expect(json.containsKey('criticalAlerts'), isTrue);
        expect(json.containsKey('snoozeDuration'), isTrue);
        expect(json.containsKey('travelModeEnabled'), isTrue);
        expect(json.containsKey('homeTimezone'), isTrue);
        expect(json.containsKey('removeAds'), isTrue);
        expect(json.containsKey('usesPrivateEmail'), isTrue);
        expect(json.containsKey('onboardingComplete'), isTrue);
        expect(json.containsKey('userRole'), isTrue);
        expect(json.containsKey('shareAdherenceData'), isTrue);
        expect(json.containsKey('shareMedicationList'), isTrue);
        expect(json.containsKey('allowCaregiverNotifications'), isTrue);
        expect(json.containsKey('missedDoseAlerts'), isTrue);
        expect(json.containsKey('lowStockAlerts'), isTrue);
      });

      test('roundtrip preserves Japanese language code', () {
        final original = buildFull();
        final restored = UserProfile.fromJson(original.toJson());

        expect(restored.language, 'ja');
      });

      test('roundtrip preserves caregiver role', () {
        final original = buildFull();
        final restored = UserProfile.fromJson(original.toJson());

        expect(restored.userRole, 'caregiver');
      });
    });

    group('copyWith', () {
      test('copies with modified name leaves other fields unchanged', () {
        final original = buildFull();
        final copied = original.copyWith(name: 'Bob Smith');

        expect(copied.name, 'Bob Smith');
        expect(copied.id, original.id);
        expect(copied.email, original.email);
        expect(copied.language, original.language);
        expect(copied.highContrast, original.highContrast);
        expect(copied.textSize, original.textSize);
        expect(copied.notificationsEnabled, original.notificationsEnabled);
        expect(copied.criticalAlerts, original.criticalAlerts);
        expect(copied.snoozeDuration, original.snoozeDuration);
        expect(copied.travelModeEnabled, original.travelModeEnabled);
        expect(copied.homeTimezone, original.homeTimezone);
        expect(copied.removeAds, original.removeAds);
        expect(copied.usesPrivateEmail, original.usesPrivateEmail);
        expect(copied.onboardingComplete, original.onboardingComplete);
        expect(copied.userRole, original.userRole);
        expect(copied.shareAdherenceData, original.shareAdherenceData);
        expect(copied.shareMedicationList, original.shareMedicationList);
        expect(copied.allowCaregiverNotifications,
            original.allowCaregiverNotifications);
        expect(copied.missedDoseAlerts, original.missedDoseAlerts);
        expect(copied.lowStockAlerts, original.lowStockAlerts);
      });

      test('copies with modified language', () {
        final original = buildFull();
        final copied = original.copyWith(language: 'en');

        expect(copied.language, 'en');
        expect(copied.id, original.id);
      });

      test('copies with modified userRole', () {
        final original = buildFull();
        final copied = original.copyWith(userRole: 'patient');

        expect(copied.userRole, 'patient');
        expect(copied.id, original.id);
      });

      test('copies with onboardingComplete toggled', () {
        final original = buildMinimal();
        final copied = original.copyWith(onboardingComplete: true);

        expect(copied.onboardingComplete, true);
        expect(copied.id, original.id);
      });

      test('copies with null name clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(name: null);

        expect(copied.name, isNull);
        expect(copied.id, original.id);
      });

      test('copies with null homeTimezone clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(homeTimezone: null);

        expect(copied.homeTimezone, isNull);
        expect(copied.id, original.id);
      });

      test('copies with modified snoozeDuration', () {
        final original = buildFull();
        final copied = original.copyWith(snoozeDuration: 5);

        expect(copied.snoozeDuration, 5);
        expect(copied.id, original.id);
      });

      test('copies with travelModeEnabled toggled', () {
        final original = buildMinimal();
        final copied = original.copyWith(travelModeEnabled: true);

        expect(copied.travelModeEnabled, true);
        expect(copied.id, original.id);
      });

      test('copies with shareAdherenceData toggled', () {
        final original = buildFull();
        final copied = original.copyWith(shareAdherenceData: true);

        expect(copied.shareAdherenceData, true);
        expect(copied.shareMedicationList, original.shareMedicationList);
      });
    });

    group('equality', () {
      test('two instances with same fields are equal', () {
        final a = buildFull();
        final b = buildFull();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('two minimal instances with same id are equal', () {
        final a = buildMinimal();
        final b = buildMinimal();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('instances with different id are not equal', () {
        final a = buildFull();
        final b = a.copyWith(id: 'user-999');

        expect(a, isNot(equals(b)));
      });

      test('instances with different language are not equal', () {
        final a = buildFull();
        final b = a.copyWith(language: 'en');

        expect(a, isNot(equals(b)));
      });

      test('instances with different userRole are not equal', () {
        final a = buildFull();
        final b = a.copyWith(userRole: 'patient');

        expect(a, isNot(equals(b)));
      });

      test('instances with different onboardingComplete are not equal', () {
        final a = buildFull();
        final b = a.copyWith(onboardingComplete: false);

        expect(a, isNot(equals(b)));
      });

      test('instances with different snoozeDuration are not equal', () {
        final a = buildFull();
        final b = a.copyWith(snoozeDuration: 5);

        expect(a, isNot(equals(b)));
      });

      test('instances differing in shareAdherenceData are not equal', () {
        final a = buildFull();
        final b = a.copyWith(shareAdherenceData: true);

        expect(a, isNot(equals(b)));
      });
    });

    group('defaults', () {
      test('language defaults to en', () {
        expect(buildMinimal().language, 'en');
      });

      test('highContrast defaults to false', () {
        expect(buildMinimal().highContrast, false);
      });

      test('textSize defaults to normal', () {
        expect(buildMinimal().textSize, 'normal');
      });

      test('notificationsEnabled defaults to true', () {
        expect(buildMinimal().notificationsEnabled, true);
      });

      test('criticalAlerts defaults to false', () {
        expect(buildMinimal().criticalAlerts, false);
      });

      test('snoozeDuration defaults to 15', () {
        expect(buildMinimal().snoozeDuration, 15);
      });

      test('travelModeEnabled defaults to false', () {
        expect(buildMinimal().travelModeEnabled, false);
      });

      test('homeTimezone defaults to null', () {
        expect(buildMinimal().homeTimezone, isNull);
      });

      test('removeAds defaults to false', () {
        expect(buildMinimal().removeAds, false);
      });

      test('usesPrivateEmail defaults to false', () {
        expect(buildMinimal().usesPrivateEmail, false);
      });

      test('onboardingComplete defaults to false', () {
        expect(buildMinimal().onboardingComplete, false);
      });

      test('userRole defaults to patient', () {
        expect(buildMinimal().userRole, 'patient');
      });

      test('shareAdherenceData defaults to true', () {
        expect(buildMinimal().shareAdherenceData, true);
      });

      test('shareMedicationList defaults to true', () {
        expect(buildMinimal().shareMedicationList, true);
      });

      test('allowCaregiverNotifications defaults to true', () {
        expect(buildMinimal().allowCaregiverNotifications, true);
      });

      test('missedDoseAlerts defaults to true', () {
        expect(buildMinimal().missedDoseAlerts, true);
      });

      test('lowStockAlerts defaults to true', () {
        expect(buildMinimal().lowStockAlerts, true);
      });

      test('name defaults to null', () {
        expect(buildMinimal().name, isNull);
      });

      test('email defaults to null', () {
        expect(buildMinimal().email, isNull);
      });
    });
  });
}
