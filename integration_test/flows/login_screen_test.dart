/// E2E tests for LoginScreen
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';
import '../utils/test_helpers.dart';
import '../robots/login_robot.dart';

void main() {
  ensureTestInitialized();

  group('LoginScreen', () {
    // LS-01: 画面初期表示
    testWidgets(
      'LS-01: appIcon, Google ボタン, continueAnonymously ボタンが表示される',
      (tester) async {
        await tester.pumpWidget(buildLoginTestApp(TestAppConfig.patient()));
        final robot = LoginRobot(tester);

        await robot.verifyOnLoginScreen();
        expect(robot.googleSignInButton, findsOneWidget);
      },
    );

    // LS-02: localDataOnlyNotice 表示
    testWidgets(
      'LS-02: 匿名ログインの説明文 (localDataOnlyNotice) が表示される',
      (tester) async {
        await tester.pumpWidget(buildLoginTestApp(TestAppConfig.patient()));
        final robot = LoginRobot(tester);

        await robot.verifyOnLoginScreen();
        expect(robot.localDataOnlyNotice, findsOneWidget);
      },
    );

    // LS-03: English ボタンでハイライト変化
    testWidgets(
      'LS-03: Japanese → English の順でタップすると English がプライマリ色になる',
      (tester) async {
        await tester.pumpWidget(buildLoginTestApp(TestAppConfig.patient()));
        final robot = LoginRobot(tester);
        await robot.verifyOnLoginScreen();

        // Change to Japanese first, then back to English
        await robot.tapJapanese();
        await robot.tapEnglish();

        robot.verifyEnglishHighlighted();
      },
    );

    // LS-04: 日本語ボタンでハイライト変化
    testWidgets(
      'LS-04: 日本語タップ後に日本語がプライマリ色、English はミュート色になる',
      (tester) async {
        await tester.pumpWidget(buildLoginTestApp(TestAppConfig.patient()));
        final robot = LoginRobot(tester);
        await robot.verifyOnLoginScreen();

        await robot.tapJapanese();

        robot.verifyJapaneseHighlighted();
        robot.verifyEnglishNotHighlighted();
      },
    );

    // LS-05: 匿名ログイン → HomeScreen 遷移
    testWidgets(
      'LS-05: 匿名ログイン成功 → /home に遷移する',
      (tester) async {
        await tester.pumpWidget(buildLoginTestApp(TestAppConfig.patient()));
        final robot = LoginRobot(tester);
        await robot.verifyOnLoginScreen();

        await robot.tapContinueAnonymously();

        // Test router's /home stub shows 'Home'
        expect(find.text('Home'), findsOneWidget);
      },
    );

    // LS-06: 匿名ログイン失敗 → エラー Snackbar
    testWidgets(
      'LS-06: 匿名ログイン失敗時にエラー Snackbar が表示される',
      (tester) async {
        final (widget, authService) =
            buildLoginTestAppWithContainer(TestAppConfig.patient());
        await tester.pumpWidget(widget);
        final robot = LoginRobot(tester);
        await robot.verifyOnLoginScreen();

        authService.setNextAnonymousSignInToFail();

        await tester.tap(robot.continueAnonymouslyButton);

        await robot.verifyErrorSnackbar();
      },
    );

    // LS-07: Google ログイン失敗 → エラー Snackbar
    testWidgets(
      'LS-07: Google ログイン失敗時にエラー Snackbar が表示される',
      (tester) async {
        final (widget, authService) =
            buildLoginTestAppWithContainer(TestAppConfig.patient());
        await tester.pumpWidget(widget);
        final robot = LoginRobot(tester);
        await robot.verifyOnLoginScreen();

        authService.setNextGoogleSignInToFail();

        await tester.tap(robot.googleSignInButton.first);

        await robot.verifyErrorSnackbar();
      },
    );

    // LS-08: ログイン中のローディングインジケーター
    testWidgets(
      'LS-08: ログイン処理中は CircularProgressIndicator が表示されボタンが隠れる',
      (tester) async {
        final (widget, authService) =
            buildLoginTestAppWithContainer(TestAppConfig.patient());
        await tester.pumpWidget(widget);
        final robot = LoginRobot(tester);
        await robot.verifyOnLoginScreen();

        // Hold sign-in in-flight so loading state persists
        authService.holdNextSignIn();

        await tester.tap(robot.continueAnonymouslyButton);
        await tester.pump(); // Process setState(_isLoading = true)

        robot.verifyLoadingShown();

        // Release and settle
        authService.releaseSignIn();
        await tester.pumpAndSettle();
      },
    );

    // LS-iOS: iOS プラットフォームでの Apple Sign-In ボタン表示
    // NOTE: LoginScreen uses Platform.isIOS (dart:io), not defaultTargetPlatform,
    // so this test only runs on an actual iOS device / iOS simulator.
    testWidgets(
      'LS-iOS: iOS プラットフォームでは Apple Sign-In ボタンが表示される',
      skip: !Platform.isIOS,
      (tester) async {
        await tester.pumpWidget(buildLoginTestApp(TestAppConfig.patient()));
        final robot = LoginRobot(tester);
        await robot.verifyOnLoginScreen();

        expect(robot.appleSignInButton, findsOneWidget);
      },
    );
  });
}
