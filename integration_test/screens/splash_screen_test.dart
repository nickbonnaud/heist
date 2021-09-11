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
    
    while(!tester.any(find.byKey(Key("loginFormKey")))) {
      await tester.pump();
    }
    await tester.pump();
  }

  Future<void> _dragBetweenForms() async {
    await tester.pump(Duration(milliseconds: 500));
    expect(find.byKey(Key("loginFormKey")), findsOneWidget);
    expect(find.byKey(Key("registerFormKey")), findsNothing);

    expect(find.byKey(Key("dragArrowKey")), findsOneWidget);
    await tester.tap(find.byKey(Key("dragArrowKey")));
    await tester.pump(Duration(milliseconds: 500));

    expect(find.byKey(Key("loginFormKey")), findsNothing);

    await tester.drag(find.byKey(Key("stackKey")), Offset(-500, 0));
    await tester.pump(Duration(seconds: 2));

    expect(find.byKey(Key("registerFormKey")), findsOneWidget);
    expect(find.byKey(Key("loginFormKey")), findsNothing);

    await tester.tap(find.byKey(Key("dragArrowKey")));
    await tester.pump(Duration(seconds: 3));

    await tester.drag(find.byKey(Key("stackKey")), Offset(500, 0));
    await tester.pump(Duration(seconds: 2));

    expect(find.byKey(Key("loginFormKey")), findsOneWidget);
  }

  Future<void> _toggleBetweenForms() async {
    expect(find.byKey(Key("registerFormKey")), findsNothing);

    await tester.pump();
    await tester.tap(find.text("Don't have an account?"));
    await tester.pump(Duration(seconds: 3));
    await tester.pump(Duration(seconds: 3));
    await tester.pump(Duration(seconds: 3));

    expect(find.byKey(Key("registerFormKey")), findsOneWidget);
    expect(find.byKey(Key("loginFormKey")), findsNothing);

    await tester.tap(find.text("Already have an Account?"));
    await tester.pump(Duration(seconds: 3));
    await tester.pump(Duration(seconds: 3));
    await tester.pump(Duration(seconds: 3));

    expect(find.byKey(Key("registerFormKey")), findsNothing);
    expect(find.byKey(Key("loginFormKey")), findsOneWidget);
  }
}