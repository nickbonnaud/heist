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
    await _enterValidEmail();

    await _tapSubmitButton();
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

    await tester.tap(find.text("Done"));
    await tester.pumpAndSettle();
  }

  Future<void> _tapSubmitButton() async {
    expect(find.byKey(Key("submitButtonKey")), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  Future<void> _dismissSnackBar() async {
    expect(find.byKey(Key("requestResetSnackBarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("requestResetSnackBarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();
    
    expect(find.byKey(Key("requestResetSnackBarKey")), findsNothing);
  }
}