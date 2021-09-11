import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/global_widgets/search_identifier_modal/search_identifier_modal.dart';

import '../helpers/test_title.dart';

class SearchIdentifierModalTest {
  final WidgetTester tester;

  const SearchIdentifierModalTest({required this.tester});

  Future<void> initTransactions() async {
    TestTitle.write(testName: "Search Identifier Modal Transactions Tests");

    expect(find.byType(SearchIdentifierModal), findsOneWidget);
    expect(find.text("Transaction ID"), findsOneWidget);

    await _enterInvalidIdentifier();
    
    await _navigateBack();
    
    await _enterIdentifier();
  }

  Future<void> initRefundsTransactionId() async {
    TestTitle.write(testName: "Search Identifier Modal Refunds Transaction ID Tests");

    expect(find.byType(SearchIdentifierModal), findsOneWidget);
    expect(find.text("Transaction ID"), findsOneWidget);

    await _enterIdentifier();
  }

  Future<void> initRefundsId() async {
    TestTitle.write(testName: "Search Identifier Modal Refunds ID Tests");

    expect(find.byType(SearchIdentifierModal), findsOneWidget);
    expect(find.text("Refund ID"), findsOneWidget);

    await _enterIdentifier();
  }

  Future<void> _enterInvalidIdentifier() async {
    expect(find.text("Invalid ID"), findsNothing);

    await tester.enterText(find.byKey(Key("identifierFieldKey")), "!ndj ss");
    await tester.pump();
    expect(find.text("Invalid ID"), findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(Duration(milliseconds: 350));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.pumpAndSettle();
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(Key("transactionsFilterButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.receipt));
    await tester.pumpAndSettle();
  }
  
  Future<void> _enterIdentifier() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.enterText(find.byKey(Key("identifierFieldKey")), "bcbv8y2bbcbxbccsfds4tgghsf3unxhw");
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(Duration(milliseconds: 100));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  }
}