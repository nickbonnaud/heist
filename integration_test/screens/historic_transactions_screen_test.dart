import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/historic_transactions_screen/historic_transactions_screen.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';

import '../helpers/test_title.dart';
import 'receipt_screen_test.dart';
import 'search_business_name_modal_test.dart';
import 'search_identifier_modal_test.dart';

class HistoricTransactionsScreenTest {
  final WidgetTester tester;

  const HistoricTransactionsScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Historic Transactions Screen Tests");

    await _loadTransactions();

    await _scroll();

    await _searchByBusinessName();

    await _searchByIdentifier();

    await _searchByDate();

    await _reset();

    await _showReceipt();

    await _dismiss();
  }

  Future<void> _loadTransactions() async {
    await tester.tap(find.byKey(Key("transactionsDrawerItemKey")));
    await tester.pumpAndSettle();
    expect(find.byType(HistoricTransactionsScreen), findsOneWidget);
  } 

  Future<void> _scroll() async {
    expect(find.byKey(Key("transactionKey-0")), findsOneWidget);
    await tester.fling(find.byKey(Key("transactionsListKey")), Offset(0, -800), 500);
    expect(find.byKey(Key("transactionKey-0")), findsNothing);
  }

  Future<void> _searchByBusinessName() async {
    await tester.tap(find.byKey(Key("transactionsFilterButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.business));
    await tester.pumpAndSettle();

    await SearchBusinessNameModalTest(tester: tester).initTransactions();
  }

  Future<void> _searchByIdentifier() async {
    await tester.tap(find.byKey(Key("transactionsFilterButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.receipt));
    await tester.pumpAndSettle();

    await SearchIdentifierModalTest(tester: tester).initTransactions();
  }

  Future<void> _searchByDate() async {
    await tester.tap(find.byKey(Key("transactionsFilterButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.event));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(Key("transactionsFilterButtonKey")));
    await tester.pumpAndSettle();

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

  Future<void> _reset() async {
    await tester.tap(find.byKey(Key("transactionsFilterButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  }

  Future<void> _showReceipt() async {
    expect(find.byType(ReceiptScreen), findsNothing);

    await tester.tap(find.byKey(Key("transactionKey-0")));
    await tester.pumpAndSettle();

    await ReceiptScreenTest(tester: tester).initHistoricTransactions();
  }

  Future<void> _dismiss() async {
    expect(find.byType(HistoricTransactionsScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(HistoricTransactionsScreen), findsNothing);
  }
}