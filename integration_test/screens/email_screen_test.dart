import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/email_screen/email_screen.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class EmailScreenTest {
  final WidgetTester tester;

  const EmailScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Email Screen Tests");

    expect(find.byType(EmailScreen), findsOneWidget);

    await _changeEmailError();

    await _submitError();

    await _changeEmail();

    await _submitSuccess();

    await _navigateBack();

    await _cancelButton();
  }

  Future<void> _changeEmailError() async {
    expect(find.text("Invalid Email"), findsNothing);

    await tester.enterText(find.byKey(const Key("emailFieldKey")), "not an email");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text("Invalid Email"), findsOneWidget);

    await tester.enterText(find.byKey(const Key("emailFieldKey")), "error@nova.ai");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text("Invalid Email"), findsNothing);
  }

  Future<void> _submitError() async {
    expect(find.byKey(const Key("emailFormSnackbarKey")), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump();

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key("emailFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("emailFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _changeEmail() async {
    await tester.tap(find.byKey(const Key("emailFieldKey")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("emailFieldKey")), "john@nova.ai");
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> _submitSuccess() async {
    expect(find.byKey(const Key("emailFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(const Key("emailFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("emailFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(const Key("emailTileKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _cancelButton() async {
    expect(find.byType(EmailScreen), findsOneWidget);
    await tester.tap(find.byKey(const Key("cancelButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byType(EmailScreen), findsNothing);
  }
}