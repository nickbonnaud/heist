import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class RegisterScreenTest {
  final WidgetTester tester;

  const RegisterScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Register Screen Tests");

    expect(find.text("Don't have an account?"), findsOneWidget);

    await _tapGotToRegisterButton();

    expect(find.byKey(Key("registerButtonTextKey")), findsNothing);

    await _enterErrorCredentials();
    await _tapSubmitButtonFail();
    
    await _enterInvalidEmail();
    await _enterValidEmail();

    await _enterInvalidPassword();
    await _enterValidPassword();

    await _enterInvalidPasswordConfirmation();
    await _enterValidPasswordConfirmation();

    await _tapSubmitButtonSuccess();
    await tester.pumpAndSettle();
  }

  Future<void> _tapGotToRegisterButton() async {
    expect(find.byKey(Key("registerFormKey")), findsNothing);

    await tester.pump();
    await tester.tap(find.text("Don't have an account?"));
    await tester.pump(Duration(seconds: 3));
    await tester.pump(Duration(seconds: 3));

    expect(find.byKey(Key("registerFormKey")), findsOneWidget);
  }

  Future<void> _enterErrorCredentials() async {
    await tester.enterText(find.byKey(Key("emailFormFieldKey")), "error@gmail.com");
    await tester.pump(Duration(milliseconds: 300));

    await tester.enterText(find.byKey(Key("passwordFormFieldKey")), "s^!hHd34Gjs76@");
    await tester.pump(Duration(milliseconds: 300));

    await tester.enterText(find.byKey(Key("passwordConfirmationFormFieldKey")), "f");
    await tester.pump(Duration(milliseconds: 300));

    await tester.enterText(find.byKey(Key("passwordConfirmationFormFieldKey")), "s^!hHd34Gjs76@");
    await tester.pump(Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump(Duration(seconds: 3));
    await tester.pump(Duration(seconds: 1));
  }

  Future<void> _tapSubmitButtonFail() async {
    expect(find.byKey(Key("errorRegisterSnackbarKey")), findsNothing);
    await tester.tap(find.byKey(Key("registerButtonTextKey")).first);
    await tester.pump(Duration(seconds: 3));
    await tester.pump();
    expect(find.byKey(Key("errorRegisterSnackbarKey")), findsOneWidget);
    
    await tester.fling(find.byKey(Key("errorRegisterSnackbarKey")), Offset(0, 500), 500);
    await tester.pump();
  }
  
  Future<void> _enterInvalidEmail() async {
    expect(find.byKey(Key("emailFormFieldKey")), findsOneWidget);

    expect(find.text("Invalid Email"), findsNothing);

    await tester.enterText(find.byKey(Key("emailFormFieldKey")), "not * email");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text("Invalid Email"), findsOneWidget);
  }

  Future<void> _enterValidEmail() async {
    expect(find.text("Invalid Email"), findsOneWidget);

    await tester.enterText(find.byKey(Key("emailFormFieldKey")), "nick@yahoo.com");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text("Invalid Email"), findsNothing);
  }

  Future<void> _enterInvalidPassword() async {
    expect(find.byKey(Key("passwordFormFieldKey")), findsOneWidget);

    expect(find.text("Min 8 characters, at least 1 uppercase, 1 number, 1 special character"), findsNothing);

    await tester.enterText(find.byKey(Key("passwordFormFieldKey")), "password");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text("Min 8 characters, at least 1 uppercase, 1 number, 1 special character"), findsOneWidget);
  }

  Future<void> _enterValidPassword() async {
    expect(find.text("Min 8 characters, at least 1 uppercase, 1 number, 1 special character"), findsOneWidget);

    await tester.enterText(find.byKey(Key("passwordFormFieldKey")), "s^!hHd34Gjs76@");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text("Min 8 characters, at least 1 uppercase, 1 number, 1 special character"), findsNothing);
  }

  Future<void> _enterInvalidPasswordConfirmation() async {
    expect(find.byKey(Key("passwordConfirmationFormFieldKey")), findsOneWidget);

    expect(find.text("Passwords do not match"), findsNothing);

    await tester.enterText(find.byKey(Key("passwordConfirmationFormFieldKey")), "password");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text("Passwords do not match"), findsOneWidget);
  }

  Future<void> _enterValidPasswordConfirmation() async {
    expect(find.text("Passwords do not match"), findsOneWidget);

    await tester.enterText(find.byKey(Key("passwordConfirmationFormFieldKey")), "s^!hHd34Gjs76@");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text("Passwords do not match"), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump(Duration(seconds: 3));
    await tester.pump(Duration(seconds: 1));
  }

  Future<void> _tapSubmitButtonSuccess() async {
    expect(find.byKey(Key("registerButtonTextKey")), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(Key("registerButtonTextKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }
}