import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/home_screen/widgets/side_drawer/widgets/drawer_body.dart';

import '../helpers/test_title.dart';
import 'help_tickets_screen_test.dart';
import 'historic_transactions_screen_test.dart';
import 'refunds_screen_test.dart';
import 'settings_screen_test.dart';
import 'tutorial_screen_test.dart';

class SideDrawerTest {
  final WidgetTester tester;

  const SideDrawerTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Side Drawer Tests");

    await tester.tap(find.byKey(Key("menuFabKey")));
    await tester.pumpAndSettle();

    expect(find.byType(DrawerBody), findsOneWidget);

    await HistoricTransactionsScreenTest(tester: tester).init();

    await RefundsScreenTest(tester: tester).init();

    await TutorialScreenTest(tester: tester).initFromDrawer();

    await HelpTicketsScreenTest(tester: tester).init();

    await SettingsScreenTest(tester: tester).init();
  }
}