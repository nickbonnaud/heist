import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/transaction_business_picker_screen/transaction_business_picker_screen.dart';
import 'package:heist/screens/transaction_picker_screen/transaction_picker_screen.dart';

import '../helpers/test_title.dart';
import 'transaction_picker_screen_test.dart';

class TransactionBusinessPickerScreenTest {
  final WidgetTester tester;

  const TransactionBusinessPickerScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Transaction Business Picker Screen Tests");
    expect(find.byType(TransactionBusinessPickerScreen), findsNothing);

    await tester.tap(find.byKey(Key("transactionBusinessPickerItemKey")));
    await tester.pumpAndSettle();
    expect(find.byType(TransactionBusinessPickerScreen), findsOneWidget);

    await _selectBusiness();
  }

  Future<void> _selectBusiness() async {
    expect(find.byKey(Key("businessCardKey-0")), findsOneWidget);
    expect(find.byType(TransactionPickerScreen), findsNothing);

    await tester.tap(find.byKey(Key("businessCardKey-0")));
    await tester.pump(Duration(milliseconds: 300));
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byKey(Key("businessCardKey-0")), findsNothing);
    expect(find.byType(TransactionPickerScreen), findsOneWidget);

    await TransactionPickerScreenTest(tester: tester).initSideDrawer();
  }
}