import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/auth_screen/auth_screen.dart';
import 'package:heist/screens/sign_out_screen/sign_out_screen.dart';

import '../helpers/test_title.dart';

class SignOutScreenTest {
  final WidgetTester tester;

  const SignOutScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Sign Out Screen Tests");

    expect(find.byType(SignOutScreen), findsOneWidget);

    await _cancel();

    await _navigateBack();

    await _signOut();
  }

  Future<void> _cancel() async {
    await tester.tap(find.byKey(const Key("cancelButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byType(SignOutScreen), findsNothing);
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(const Key("signOutTileKey")));
    await tester.pumpAndSettle();
    expect(find.byType(SignOutScreen), findsOneWidget);
  }

  Future<void> _signOut() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(AuthScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  }
}