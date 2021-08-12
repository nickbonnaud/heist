import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_title.dart';
import 'permissions_screen_test.dart';
import 'profile_setup_screen_test.dart';
import 'tutorial_screen_test.dart';

class OnboardScreenTest {
  final WidgetTester tester;

  const OnboardScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Onboard Screen Tests");

    expect(find.byKey(Key("onboardStepperKey")), findsOneWidget);

    await _goToProfileSetup();
    await _goToTutorialScreen();
    
    await tester.tap(find.byKey(Key("stepperButtonKey")).at(3));
    await tester.pump(Duration(milliseconds: 500));

    await _finishOnboarding();
  }

  Future<void> initLogin() async {
    await tester.tap(find.byKey(Key("stepperButtonKey")).at(2));
    await tester.pump(Duration(milliseconds: 250));

    await TutorialScreenTest(tester: tester).initLogin();

    await _goToPermissionsScreen();

    await _finishOnboarding();
  }

  Future<void> _goToProfileSetup() async {
    await tester.tap(find.byKey(Key("stepperButtonKey")).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("stepperButtonKey")).at(1));
    await tester.pumpAndSettle();

    await ProfileSetupScreenTest(tester: tester).init();
  }

  Future<void> _goToTutorialScreen() async {
    await tester.tap(find.byKey(Key("stepperButtonKey")).at(2));
    await tester.pump(Duration(milliseconds: 250));

    await TutorialScreenTest(tester: tester).init();
  }

  Future<void> _goToPermissionsScreen() async {
    await tester.tap(find.byKey(Key("stepperButtonKey")).at(3));
    await tester.pump(Duration(milliseconds: 500));
    
    await PermissionsScreenTest(tester: tester).init();
  }

  Future<void> _finishOnboarding() async {
    await tester.tap(find.byKey(Key("stepperButtonKey")).at(4));
    await tester.pumpAndSettle();
  }
}