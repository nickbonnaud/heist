import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/splash_screen/splash_screen.dart';

import '../helpers/test_title.dart';

class SplashScreenTest {
  final WidgetTester tester;

  const SplashScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Splash Screen Tests");

    expect(find.byType(SplashScreen), findsOneWidget);

    await _finishAnimation();
    
    await _dragBetweenForms();

    await _toggleBetweenForms();
  }

  Future<void> _finishAnimation() async {
    // await tester.pumpAndSettle();
    
    while(!tester.any(find.byKey(const Key("loginFormKey")))) {
      await tester.pump();
    }
    await tester.pump();
  }

  Future<void> _dragBetweenForms() async {
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const Key("loginFormKey")), findsOneWidget);
    expect(find.byKey(const Key("registerFormKey")), findsNothing);

    expect(find.byKey(const Key("dragArrowKey")), findsOneWidget);
    await tester.tap(find.byKey(const Key("dragArrowKey")));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byKey(const Key("loginFormKey")), findsNothing);

    await tester.drag(find.byKey(const Key("stackKey")), const Offset(-500, 0));
    await tester.pump(const Duration(seconds: 2));

    expect(find.byKey(const Key("registerFormKey")), findsOneWidget);
    expect(find.byKey(const Key("loginFormKey")), findsNothing);

    await tester.tap(find.byKey(const Key("dragArrowKey")));
    await tester.pump(const Duration(seconds: 3));

    await tester.drag(find.byKey(const Key("stackKey")), const Offset(500, 0));
    await tester.pump(const Duration(seconds: 2));

    expect(find.byKey(const Key("loginFormKey")), findsOneWidget);
  }

  Future<void> _toggleBetweenForms() async {
    expect(find.byKey(const Key("registerFormKey")), findsNothing);

    await tester.pump();
    await tester.tap(find.text("Don't have an account?"));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byKey(const Key("registerFormKey")), findsOneWidget);
    expect(find.byKey(const Key("loginFormKey")), findsNothing);

    await tester.tap(find.text("Already have an Account?"));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byKey(const Key("registerFormKey")), findsNothing);
    expect(find.byKey(const Key("loginFormKey")), findsOneWidget);
  }
}