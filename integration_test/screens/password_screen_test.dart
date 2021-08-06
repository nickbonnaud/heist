import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/password_screen/password_screen.dart';

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

    await tester.enterText(find.byKey(Key("currentPasswordFieldKey")), "not a password");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Invalid Password'), findsOneWidget);

    await tester.enterText(find.byKey(Key("currentPasswordFieldKey")), "error!&123jcKGFF9*");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Invalid Password'), findsNothing);

    await tester.tap(find.text("Done"));
    await tester.pump();
  }

  Future<void> _submitCurrentError() async {
    expect(find.byKey(Key("passwordFormSnackbarKey")), findsNothing);

    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("passwordFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("passwordFormSnackbarKey")), Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeCurrentSuccess() async {
    await tester.enterText(find.byKey(Key("currentPasswordFieldKey")), "cfvv!&123jcKGFF9*");
    await tester.pump(Duration(milliseconds: 300));

    await tester.tap(find.text("Done"));
    await tester.pump();
  }

  Future<void> _submitCurrentSuccess() async {
    expect(find.byKey(Key("passwordFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pump(Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(Key("passwordFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("passwordFormSnackbarKey")), Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeNewError() async {
    expect(find.text('Invalid Password'), findsNothing);

    await tester.enterText(find.byKey(Key("newPasswordFieldKey")), "not a password");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Invalid Password'), findsOneWidget);

    await tester.enterText(find.byKey(Key("newPasswordFieldKey")), "error!&123jcKGFF9*");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Invalid Password'), findsNothing);
  }

  Future<void> _changeConfirmationError() async {
    expect(find.text('Confirmation does not match'), findsNothing);

    await tester.enterText(find.byKey(Key("newPasswordConfirmationFieldKey")), "not a password");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Confirmation does not match'), findsOneWidget);

    await tester.enterText(find.byKey(Key("newPasswordConfirmationFieldKey")), "error!&123jcKGFF9*");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Confirmation does not match'), findsNothing);

    await tester.tap(find.text("Done"));
    await tester.pump();
  }

  Future<void> _submitNewError() async {
    expect(find.byKey(Key("passwordFormSnackbarKey")), findsNothing);

    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("passwordFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("passwordFormSnackbarKey")), Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeNewSuccess() async {
    await tester.enterText(find.byKey(Key("newPasswordFieldKey")), "cfvv!&123jcKGFF9*");
    await tester.pump(Duration(milliseconds: 300));
  }

  Future<void> _changeConfirmationSuccess() async {
    await tester.enterText(find.byKey(Key("newPasswordConfirmationFieldKey")), "cfvv!&123jcKGFF9*");
    await tester.pump(Duration(milliseconds: 300));

    await tester.tap(find.text("Done"));
    await tester.pump();
  }

  Future<void> _submitNewSuccess() async {
    expect(find.byKey(Key("passwordFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pump(Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(Key("passwordFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("passwordFormSnackbarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(Key("passwordTileKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _cancelButton() async {
    expect(find.byType(PasswordScreen), findsOneWidget);
    await tester.tap(find.byKey(Key("cancelButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordScreen), findsNothing);
  }
}