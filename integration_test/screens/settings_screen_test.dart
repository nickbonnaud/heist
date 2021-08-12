import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/email_screen/email_screen.dart';
import 'package:heist/screens/password_screen/password_screen.dart';
import 'package:heist/screens/profile_screen/profile_screen.dart';
import 'package:heist/screens/settings_screen/settings_screen.dart';
import 'package:heist/screens/sign_out_screen/sign_out_screen.dart';
import 'package:heist/screens/tip_screen/tip_screen.dart';

import '../helpers/test_title.dart';
import 'profile_screen_test.dart';
import 'email_screen_test.dart';
import 'password_screen_test.dart';
import 'sign_out_screen_test.dart';
import 'tip_screen_test.dart';

class SettingsScreenTest {
  final WidgetTester tester;

  const SettingsScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Settings Screen Tests");

    expect(find.byType(SettingsScreen), findsNothing);

    await tester.tap(find.byKey(Key("settingsDrawerItemKey")));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    
    await _goToProfile();

    await _goToEmail();

    await _goToPassword();

    await _goToTips();

    await _signOut();
  }

  Future<void> _goToProfile() async {
    expect(find.byType(ProfileScreen), findsNothing);

    await tester.tap(find.byKey(Key("profileTileKey")));
    await tester.pumpAndSettle();

    await ProfileScreenTest(tester: tester).init();
  }

  Future<void> _goToEmail() async {
    expect(find.byType(EmailScreen), findsNothing);

    await tester.tap(find.byKey(Key("emailTileKey")));
    await tester.pumpAndSettle();

    await EmailScreenTest(tester: tester).init();
  }

  Future<void> _goToPassword() async {
    expect(find.byType(PasswordScreen), findsNothing);

    await tester.tap(find.byKey(Key("passwordTileKey")));
    await tester.pumpAndSettle();

    await PasswordScreenTest(tester: tester).init();
  }

  Future<void> _goToTips() async {
    expect(find.byType(TipScreen), findsNothing);

    await tester.tap(find.byKey(Key("tipTileKey")));
    await tester.pumpAndSettle();

    await TipScreenTest(tester: tester).init();
  }

  Future<void> _signOut() async {
    expect(find.byType(SignOutScreen), findsNothing);

    await tester.tap(find.byKey(Key("signOutTileKey")));
    await tester.pumpAndSettle();

    await SignOutScreenTest(tester: tester).init();
  }
}