import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/request_reset_password_screen/request_reset_password_screen.dart';

import '../helpers/test_title.dart';

class RequestResetPasswordScreenTest {
  final WidgetTester tester;

  const RequestResetPasswordScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Request Reset Password Screen Test");

    expect(find.text("Forgot your password?"), findsOneWidget);

    await _tapGoToRequestResetPasswordButton();

    await _enterInvalidEmail();
    
    await _enterErrorEmail();
    await _tapSubmitButtonFail();
    
    await _enterValidEmail();

    await _tapSubmitButtonSuccess();
    await tester.pumpAndSettle();

    await _dismissSnackBar();
  }

  Future<void> _tapGoToRequestResetPasswordButton() async {
    expect(find.byType(RequestResetPasswordScreen), findsNothing);

    await tester.pump();
    await tester.tap(find.text("Forgot your password?"));
    await tester.pumpAndSettle();

    expect(find.byType(RequestResetPasswordScreen), findsOneWidget);
  }

  Future<void> _enterInvalidEmail() async {
    expect(find.byKey(const Key("emailFormFieldKey")), findsOneWidget);

    expect(find.text("Invalid Email"), findsNothing);
    
    await tester.enterText(find.byKey(const Key("emailFormFieldKey")), "not 7 email");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Invalid Email"), findsOneWidget);
  }

  Future<void> _enterErrorEmail() async {
    await tester.enterText(find.byKey(const Key("emailFormFieldKey")), "error@gmail.com");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Invalid Email"), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _tapSubmitButtonFail() async {
    expect(find.byKey(const Key("requestResetSnackBarKey")), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("requestResetSnackBarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("requestResetSnackBarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _enterValidEmail() async {
    await tester.tap(find.byKey(const Key("emailFormFieldKey")));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(const Key("emailFormFieldKey")), "nick@yahoo.com");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _tapSubmitButtonSuccess() async {
    expect(find.byKey(const Key("submitButtonKey")), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  Future<void> _dismissSnackBar() async {
    expect(find.byKey(const Key("requestResetSnackBarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("requestResetSnackBarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
    
    expect(find.byKey(const Key("requestResetSnackBarKey")), findsNothing);
  }
}