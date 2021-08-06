import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/email_screen/email_screen.dart';

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

    await tester.enterText(find.byKey(Key("emailFieldKey")), "not an email");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text("Invalid Email"), findsOneWidget);

    await tester.enterText(find.byKey(Key("emailFieldKey")), "error@nova.ai");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text("Invalid Email"), findsNothing);
  }

  Future<void> _submitError() async {
    expect(find.byKey(Key("emailFormSnackbarKey")), findsNothing);

    await tester.tap(find.text("Done"));
    await tester.pump();

    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("emailFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("emailFormSnackbarKey")), Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeEmail() async {
    await tester.enterText(find.byKey(Key("emailFieldKey")), "john@nova.ai");
    await tester.pump(Duration(milliseconds: 300));
  }

  Future<void> _submitSuccess() async {
    expect(find.byKey(Key("emailFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.text("Done"));
    await tester.pump();

    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pump(Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(Key("emailFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("emailFormSnackbarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(Key("emailTileKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _cancelButton() async {
    expect(find.byType(EmailScreen), findsOneWidget);
    await tester.tap(find.byKey(Key("cancelButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byType(EmailScreen), findsNothing);
  }
}