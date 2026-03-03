/// Screenshot tests for App Store — Home screen (Japanese locale)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/test_app.dart';
import '../utils/test_data.dart';
import '../robots/home_robot.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot_01_home', (tester) async {
    final jaProfile =
        TestData.completedOnboardingPatient.copyWith(language: 'ja');

    final config = TestAppConfig(
      onboardingComplete: true,
      userRole: 'patient',
      userProfile: jaProfile,
      medications: TestData.sampleMedications,
      schedules: [
        TestData.dailySchedule,
        TestData.specificDaysSchedule,
        TestData.intervalSchedule,
      ],
      reminders: TestData.todayReminders(),
      isAuthenticated: true,
    );

    await tester.pumpWidget(buildPatientShellTestApp(config));

    final robot = HomeRobot(tester);
    await robot.goToHome();

    await binding.takeScreenshot('01_home');
  });
}
