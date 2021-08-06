import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_title.dart';

class SearchBusinessNameModalTest {
  final WidgetTester tester;

  const SearchBusinessNameModalTest({required this.tester});

  Future<void> initTransactions() async {
    TestTitle.write(testName: "Search Business Name Modal Transactions Tests");

    await _enterErrorName();

    await _enterValidName();

    await _scroll();

    await _selectBusiness();
  }

  Future<void> initRefunds() async {
    TestTitle.write(testName: "Search Business Name Modal Refunds Tests");

    await _enterValidName();

    await _selectBusiness();
  }

  Future<void> _enterErrorName() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(Key("errorSearchBusinessNameKey")), findsNothing);

    await tester.enterText(find.byKey(Key("businessNameFieldKey")), "error");
    await tester.pump(Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(Key("errorSearchBusinessNameKey")), findsOneWidget);
  }

  Future<void> _enterValidName() async {
    expect(find.byKey(Key("businessNameCardKey-0")), findsNothing);

    await tester.enterText(find.byKey(Key("businessNameFieldKey")), "name");
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("businessNameCardKey-0")), findsOneWidget);
  }

  Future<void> _scroll() async {
    expect(find.byKey(Key("businessNameCardKey-0")), findsOneWidget);

    await tester.fling(find.byKey(Key("searchBusinessNameBodyKey")), Offset(0, -800), 500);
    await tester.pumpAndSettle();
    expect(find.byKey(Key("businessNameCardKey-0")), findsNothing);

    await tester.fling(find.byKey(Key("searchBusinessNameBodyKey")), Offset(0, 800), 500);
    await tester.pumpAndSettle();
    expect(find.byKey(Key("businessNameCardKey-0")), findsOneWidget);
  }

  Future<void> _selectBusiness() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.byKey(Key("businessNameCardKey-0")));
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  }
}