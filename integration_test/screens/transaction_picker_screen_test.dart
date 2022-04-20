import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/transaction_picker_screen/transaction_picker_screen.dart';

import '../helpers/test_title.dart';
import 'receipt_screen_test.dart';

class TransactionPickerScreenTest {
  final WidgetTester tester;

  const TransactionPickerScreenTest({required this.tester});

  Future<void> initBusinessScreen() async {
    TestTitle.write(testName: "Transaction Picker Screen Tests Business Screen");
    
    await tester.tap(find.byKey(const Key("claimTransactionButtonKey")));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    
    expect(find.byType(TransactionPickerScreen), findsOneWidget);

    await _tapInfoButton();

    await _swipeTransactions();

    await _dismiss();

    expect(find.byType(TransactionPickerScreen), findsNothing);
  }

  Future<void> initSideDrawer() async {
    TestTitle.write(testName: "Transaction Picker Screen Tests Side Drawer");
    
    await _tapSubmitButton();

    await _cancelDialog();

    await _tapSubmitButton();

    await _confirmDialog();

    await ReceiptScreenTest(tester: tester).initTransactionPicker();
  }

  Future<void> _tapSubmitButton() async {
    expect(find.byKey(const Key("confirmClaimDialogKey")), findsNothing);

    await tester.tap(find.byKey(const Key("claimSubmitButtonKey")));
    await tester.pump();

    expect(find.byKey(const Key("confirmClaimDialogKey")), findsOneWidget);
  }

  Future<void> _cancelDialog() async {
    await tester.tap(find.text(Platform.isIOS ? 'Cancel' : 'CANCEL'));
    await tester.pump();

    expect(find.byKey(const Key("confirmClaimDialogKey")), findsNothing);
  }

  Future<void> _confirmDialog() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Confirm' : 'CONFIRM'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  }

  Future<void> _tapInfoButton() async {
    expect(find.byKey(const Key("transactionPickerInfoDialog")), findsNothing);
    await tester.tap(find.byKey(const Key("infoButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("transactionPickerInfoDialog")), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key("transactionPickerInfoDialog")), findsNothing);
  }

  Future<void> _swipeTransactions() async {
    expect(find.byKey(const Key("overlayBodyKey-0")), findsOneWidget);

    await tester.drag(find.byKey(const Key("overlayBodyKey-0")), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("overlayBodyKey-0")), findsNothing);
    expect(find.byKey(const Key("overlayBodyKey-1")), findsOneWidget);
  }

  Future<void> _dismiss() async {
    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pumpAndSettle();
  }
}