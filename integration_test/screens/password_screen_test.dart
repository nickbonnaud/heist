import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/password_screen/password_screen.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class PasswordScreenTest {
  final WidgetTester tester;

  const PasswordScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Password Screen Tests");

    expect(find.byType(PasswordScreen), findsOneWidget);

    await _changeCurrentError();

    await _submitCurrentError();

    await _changeCurrentSuccess();

    await _submitCurrentSuccess();

    await _changeNewError();

    await _changeConfirmationError();

    await _submitNewError();

    await _changeNewSuccess();

    await _changeConfirmationSuccess();

    await _submitNewSuccess();

    await _navigateBack();

    await _cancelButton();
  }

  Future<void> _changeCurrentError() async {
    expect(find.text('Invalid Password'), findsNothing);

    await tester.enterText(find.byKey(const Key("currentPasswordFieldKey")), "not a password");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Invalid Password'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("currentPasswordFieldKey")), "error!&123jcKGFF9*");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Invalid Password'), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump();
  }

  Future<void> _submitCurrentError() async {
    expect(find.byKey(const Key("passwordFormSnackbarKey")), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key("passwordFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("passwordFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeCurrentSuccess() async {
    await tester.tap(find.byKey(const Key("currentPasswordFieldKey")));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(const Key("currentPasswordFieldKey")), "cfvv!&123jcKGFF9*");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump();
  }

  Future<void> _submitCurrentSuccess() async {
    expect(find.byKey(const Key("passwordFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(const Key("passwordFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("passwordFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeNewError() async {
    expect(find.text('Invalid Password'), findsNothing);

    await tester.enterText(find.byKey(const Key("newPasswordFieldKey")), "not a password");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Invalid Password'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("newPasswordFieldKey")), "error!&123jcKGFF9*");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Invalid Password'), findsNothing);
  }

  Future<void> _changeConfirmationError() async {
    expect(find.text('Confirmation does not match'), findsNothing);

    await tester.enterText(find.byKey(const Key("newPasswordConfirmationFieldKey")), "not a password");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Confirmation does not match'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("newPasswordConfirmationFieldKey")), "error!&123jcKGFF9*");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Confirmation does not match'), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump();
  }

  Future<void> _submitNewError() async {
    expect(find.byKey(const Key("passwordFormSnackbarKey")), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key("passwordFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("passwordFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeNewSuccess() async {
    await tester.enterText(find.byKey(const Key("newPasswordFieldKey")), "cfvv!&123jcKGFF9*");
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> _changeConfirmationSuccess() async {
    await tester.enterText(find.byKey(const Key("newPasswordConfirmationFieldKey")), "cfvv!&123jcKGFF9*");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump();
  }

  Future<void> _submitNewSuccess() async {
    expect(find.byKey(const Key("passwordFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(const Key("passwordFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("passwordFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(const Key("passwordTileKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _cancelButton() async {
    expect(find.byType(PasswordScreen), findsOneWidget);
    await tester.tap(find.byKey(const Key("cancelButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordScreen), findsNothing);
  }
}