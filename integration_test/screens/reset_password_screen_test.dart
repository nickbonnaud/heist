import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/reset_password_screen/reset_password_screen.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class ResetPasswordScreenTest {
  final WidgetTester tester;

  const ResetPasswordScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Reset Password Screen Test");

    expect(find.byType(ResetPasswordScreen), findsOneWidget);

    await _enterErrorCredentials();
    await _tapSubmitButtonFail();
    
    await _enterInvalidResetCode();
    await _enterValidResetCode();

    await _enterInvalidPassword();
    await _enterValidPassword();

    await _enterInvalidPasswordConfirmation();
    await _enterValidPasswordConfirmation();

    await _tapSubmitButtonSuccess();

    await _dismissSnackBar();
  }

  Future<void> _enterErrorCredentials() async {
    await tester.enterText(find.byKey(const Key("resetCodeFormKey")), "error1");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key("passwordFormKey")), "jdhFS34#*fcm785!Sg");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key("passwordConfirmationKey")), "a");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key("passwordConfirmationKey")), "jdhFS34#*fcm785!Sg");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _tapSubmitButtonFail() async {
    expect(find.byKey(const Key("resetSnackBarKey")), findsNothing);
    
    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("resetSnackBarKey")), findsOneWidget);
    
    await tester.fling(find.byKey(const Key("resetSnackBarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _enterInvalidResetCode() async {
    expect(find.byKey(const Key("resetCodeFormKey")), findsOneWidget);
    expect(find.text("Invalid Reset Code"), findsNothing);

    await tester.tap(find.byKey(const Key("resetCodeFormKey")));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(const Key("resetCodeFormKey")), "@not ");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Invalid Reset Code"), findsOneWidget);
  }

  Future<void> _enterValidResetCode() async {
    expect(find.text("Invalid Reset Code"), findsOneWidget);

    await tester.enterText(find.byKey(const Key("resetCodeFormKey")), "123DGH");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Invalid Reset Code"), findsNothing);
  }

  Future<void> _enterInvalidPassword() async {
    expect(find.byKey(const Key("passwordFormKey")), findsOneWidget);
    expect(find.text('Min 8 characters, at least 1 uppercase, 1 number, 1 special character'), findsNothing);

    await tester.enterText(find.byKey(const Key("passwordFormKey")), "");
    await tester.pump(const Duration(milliseconds: 300));
    
    await tester.enterText(find.byKey(const Key("passwordFormKey")), "wrong");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Min 8 characters, at least 1 uppercase, 1 number, 1 special character'), findsOneWidget);
  }

  Future<void> _enterValidPassword() async {
    expect(find.text('Min 8 characters, at least 1 uppercase, 1 number, 1 special character'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("passwordFormKey")), "jdhFS34#*fcm785!Sg");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Min 8 characters, at least 1 uppercase, 1 number, 1 special character'), findsNothing);
  }

  Future<void> _enterInvalidPasswordConfirmation() async {
    expect(find.byKey(const Key("passwordConfirmationKey")), findsOneWidget);
    expect(find.text('Passwords do not match'), findsNothing);

    await tester.enterText(find.byKey(const Key("passwordConfirmationKey")), "no match");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Passwords do not match'), findsOneWidget);
  }

  Future<void> _enterValidPasswordConfirmation() async {
    expect(find.text('Passwords do not match'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("passwordConfirmationKey")), "jdhFS34#*fcm785!Sg");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Passwords do not match'), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _tapSubmitButtonSuccess() async {
    expect(find.byKey(const Key("submitButtonKey")), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  }

  Future<void> _dismissSnackBar() async {
    await tester.fling(find.byKey(const Key("resetSnackBarKey")), const Offset(0, 500), 500);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
    
    expect(find.byKey(const Key("resetSnackBarKey")), findsNothing);
  }
}