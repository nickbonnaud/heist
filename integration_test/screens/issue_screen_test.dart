import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/issue_screen/issue_screen.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class IssueScreenTest {
  final WidgetTester tester;

  const IssueScreenTest({required this.tester});

  Future<void> initCancel() async {
    TestTitle.write(testName: "Issue Screen Tests");
    
    expect(find.byType(IssueScreen), findsOneWidget);
    expect(find.text('Wrong Bill'), findsOneWidget);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(Key("cancelButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byType(IssueScreen), findsNothing);
  }
  
  Future<void> initWrongBill() async {
    await _enterIssueInvalid();
    await _enterIssueError();
    await _enterValidIssue();
  }
  
  Future<void> initErrorInBillCancel() async {
    expect(find.byType(IssueScreen), findsOneWidget);
    expect(find.text("Something's wrong"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(IssueScreen), findsNothing);
  }

  Future<void> initErrorInBill() async {
    await _enterIssueInvalid();
    await _enterIssueError();
    await _enterValidIssue();
  }

  Future<void> initOther() async {
    expect(find.byType(IssueScreen), findsOneWidget);
    expect(find.text("What's wrong?"), findsOneWidget);
    await _enterIssueInvalid();
    await _enterIssueError();
    await _enterValidIssue();
  }

  Future<void> initCancelIssueDismiss() async {
    expect(find.byType(IssueScreen), findsOneWidget);
    expect(find.text("Cancel Issue?"), findsOneWidget);

    await tester.tap(find.byKey(Key("cancelButtonKey")));
    await tester.pumpAndSettle();
  }

  Future<void> initCancelIssueSubmit() async {
    expect(find.byKey(Key("cancelIssueSnackbarKey")), findsNothing);

    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byKey(Key("cancelIssueSnackbarKey")).last, findsOneWidget);

    await tester.fling(find.byKey(Key("cancelIssueSnackbarKey")).last.last, Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _enterIssueInvalid() async {
    expect(find.text('Issue must be at least 5 characters long'), findsNothing);
    await tester.enterText(find.byKey(Key("issueFieldKey")), "asd");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Issue must be at least 5 characters long'), findsOneWidget);
  }

  Future<void> _enterIssueError() async {
    expect(find.byKey(Key("snackBarKey")), findsNothing);

    await tester.enterText(find.byKey(Key("issueFieldKey")), "error");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Issue must be at least 5 characters long'), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byKey(Key("snackBarKey")).last, findsOneWidget);

    await tester.fling(find.byKey(Key("snackBarKey")).last, Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _enterValidIssue() async {
    await tester.tap(find.byKey(Key("issueFieldKey")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key("issueFieldKey")), "Some Issue");
    await tester.pump(Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pumpAndSettle();

    await tester.fling(find.byKey(Key("snackBarKey")).last, Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }
}