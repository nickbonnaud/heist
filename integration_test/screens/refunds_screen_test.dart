import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:heist/screens/refunds_screen/refunds_screen.dart';

import '../helpers/test_title.dart';
import 'receipt_screen_test.dart';
import 'search_business_name_modal_test.dart';
import 'search_identifier_modal_test.dart';

class RefundsScreenTest {
  final WidgetTester tester;

  const RefundsScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Refunds Screen Tests");

    await _loadRefunds();

    await _scroll();

    await _searchByBusinessName();

    await _searchByTransactionId();

    await _searchByDate();

    await _searchByRefundId();

    await _reset();

    await _showReceipt();

    await _dismiss();

  }

  Future<void> _loadRefunds() async {
    await tester.tap(find.byKey(const Key("refundsDrawerItemKey")));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(RefundsScreen), findsOneWidget);
  }

  Future<void> _scroll() async {
    expect(find.byKey(const Key("refundKey-0")), findsOneWidget);
    await tester.fling(find.byKey(const Key("refundsListKey")), const Offset(0, -800), 500);
    expect(find.byKey(const Key("refundKey-0")), findsNothing);
  }

  Future<void> _searchByBusinessName() async {
    await tester.tap(find.byKey(const Key("refundsFilterButtonKey")));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(Icons.business));
    await tester.pumpAndSettle();

    await SearchBusinessNameModalTest(tester: tester).initRefunds();
  }

  Future<void> _searchByTransactionId() async {
    await tester.tap(find.byKey(const Key("refundsFilterButtonKey")));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(Icons.receipt));
    await tester.pumpAndSettle();
    
    await SearchIdentifierModalTest(tester: tester).initRefundsTransactionId();
  }

  Future<void> _searchByDate() async {
    await tester.tap(find.byKey(const Key("refundsFilterButtonKey")));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(Icons.event));
    await tester.pumpAndSettle();

    await tester.tap(find.text("1"));
    await tester.pump();

    await tester.tap(find.text("1"));
    await tester.pump();

    await tester.tap(find.text("SUBMIT"));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  }

  Future<void> _searchByRefundId() async {
    await tester.tap(find.byKey(const Key("refundsFilterButtonKey")));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(Icons.receipt_long));
    await tester.pumpAndSettle();

    await SearchIdentifierModalTest(tester: tester).initRefundsId();
  }

  Future<void> _reset() async {
    await tester.tap(find.byKey(const Key("refundsFilterButtonKey")));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  }

  Future<void> _showReceipt() async {
    expect(find.byType(ReceiptScreen), findsNothing);

    await tester.tap(find.byKey(const Key("refundKey-0")));
    await tester.pumpAndSettle();

    await ReceiptScreenTest(tester: tester).initRefunds();
  }

  Future<void> _dismiss() async {
    expect(find.byType(RefundsScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(RefundsScreen), findsNothing);
  }
}