import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/receipt_screen/widgets/call_button.dart';
import 'package:heist/screens/receipt_screen/widgets/receipt_screen_body.dart';

import '../helpers/test_title.dart';
import 'issue_screen_test.dart';

class ReceiptScreenTest {
  final WidgetTester tester;

  const ReceiptScreenTest({required this.tester});

  Future<void> initLogo() async {
    TestTitle.write(testName: "Receipt Screen Tests");

    expect(find.byType(ReceiptScreenBody), findsWidgets);
    await _scroll();

    await _goToWrongBillScreen();

    await _goToErrorInBillScreen();

    await _goToOtherErrorScreen();

    await _goToCancelIssueScreen();

    await _dismiss();

    expect(find.byType(ReceiptScreenBody), findsNothing);
  }

  Future<void> initDetails() async {
    expect(find.byType(ReceiptScreenBody), findsWidgets);
    await _dismiss();
    expect(find.byType(ReceiptScreenBody), findsNothing);
  }

  Future<void> _dismiss() async {
    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pumpAndSettle();
  }

  Future<void> _scroll() async {
    Offset initialPositionPurchasedItem = tester.getCenter(find.byKey(Key('purchasedItemKey-0')));
    
    await tester.pump(Duration(milliseconds: 500));
    await tester.drag(find.byKey(Key("receiptBodyWithAppBarKey")), Offset(0, -1000));
    await tester.pumpAndSettle();
    
    expect(initialPositionPurchasedItem.dy != tester.getCenter(find.byKey(Key('purchasedItemKey-0'))).dy, true);

    await tester.drag(find.byKey(Key("receiptBodyWithAppBarKey")), Offset(0, 1000));
    await tester.pumpAndSettle();
  }

  Future<void> _goToWrongBillScreen() async {
    IssueScreenTest issueScreenTest = IssueScreenTest(tester: tester);
    
    await tester.tap(find.byKey(Key("reportIssueButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wrong Bill'));
    await tester.pumpAndSettle();

    await issueScreenTest.initCancel();

    await tester.tap(find.byKey(Key("reportIssueButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wrong Bill'));
    await tester.pumpAndSettle();

    expect(find.text("Issue reported"), findsNothing);
    expect(find.byType(CallButton), findsNothing);
    
    await issueScreenTest.initWrongBill();

    expect(find.text("Issue reported"), findsOneWidget);
    expect(find.byType(CallButton), findsOneWidget);
  }

  Future<void> _goToErrorInBillScreen() async {
    IssueScreenTest issueScreenTest = IssueScreenTest(tester: tester);
    
    await tester.tap(find.byKey(Key("changeIssueButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Change to Error in Bill"));
    await tester.pumpAndSettle();

    await issueScreenTest.initErrorInBillCancel();

    await tester.tap(find.byKey(Key("changeIssueButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Change to Error in Bill"));
    await tester.pumpAndSettle();

    await issueScreenTest.initErrorInBill();
  }

  Future<void> _goToOtherErrorScreen() async {
    await tester.tap(find.byKey(Key("changeIssueButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Change to Other"));
    await tester.pumpAndSettle();

    await IssueScreenTest(tester: tester).initOther();
  }

  Future<void> _goToCancelIssueScreen() async {
    IssueScreenTest issueScreenTest = IssueScreenTest(tester: tester);
    
    await tester.tap(find.byKey(Key("changeIssueButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Cancel Issue"));
    await tester.pumpAndSettle();

    await issueScreenTest.initCancelIssueDismiss();

    expect(find.text("Issue reported"), findsOneWidget);
    expect(find.byType(CallButton), findsOneWidget);

    await tester.tap(find.byKey(Key("changeIssueButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Cancel Issue"));
    await tester.pumpAndSettle();
    
    await issueScreenTest.initCancelIssueSubmit();

    expect(find.text("Issue reported"), findsNothing);
    expect(find.byType(CallButton), findsNothing);
  }
}