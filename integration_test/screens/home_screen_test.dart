import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_title.dart';

class HomeScreenTest {
  final WidgetTester tester;

  const HomeScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Home Screen Tests");

    expect(find.byKey(Key("homeScreenKey")), findsOneWidget);
  }
}