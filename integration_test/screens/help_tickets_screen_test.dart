import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/help_ticket_screen/help_ticket_screen.dart';
import 'package:heist/screens/help_tickets_screen/help_tickets_screen.dart';
import 'package:heist/screens/help_tickets_screen/widgets/widgets/help_ticket_widget.dart';
import 'package:heist/screens/help_tickets_screen/widgets/widgets/new_help_ticket_screen/new_help_ticket_screen.dart';

import '../helpers/test_title.dart';
import 'help_ticket_screen_test.dart';
import 'new_help_ticket_screen_test.dart';

class HelpTicketsScreenTest {
  final WidgetTester tester;

  const HelpTicketsScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Help Tickets Screen Tests");

    await _loadHelpTickets();
    
    await _scroll();

    await _fetchOpen();
    await _goToDetailsOpen();

    await _fetchResolved();
    await _goToDetailsResolved();

    await _fetchAll();

    await _goToNewHelpTicket();
  }

  Future<void> _loadHelpTickets() async {
    expect(find.byType(HelpTicketsScreen), findsNothing);
    await tester.tap(find.byKey(const Key("helpDrawerItemKey")));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(HelpTicketsScreen), findsOneWidget);

    expect(find.byType(HelpTicketWidget), findsWidgets);
  }

  Future<void> _scroll() async {
    expect(find.byKey(const Key("helpTicketKey-0")), findsOneWidget);
    await tester.fling(find.byKey(const Key("helpTicketsListKey")), const Offset(0, -800), 500);
    expect(find.byKey(const Key("helpTicketKey-0")), findsNothing);
  }

  Future<void> _fetchOpen() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key("helpTicketsFilterButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.lock_open));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);


    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }

  Future<void> _goToDetailsOpen() async {
    expect(find.byType(HelpTicketScreen), findsNothing);
    await tester.tap(find.byKey(const Key("helpTicketKey-0")));
    await tester.pumpAndSettle();

    await HelpTicketScreenTest(tester: tester).initOpen();
  }

  Future<void> _fetchResolved() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key("helpTicketsFilterButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.lock_outline));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);


    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }

  Future<void> _goToDetailsResolved() async {
    expect(find.byType(HelpTicketScreen), findsNothing);
    await tester.tap(find.byKey(const Key("helpTicketKey-0")));
    await tester.pumpAndSettle();

    await HelpTicketScreenTest(tester: tester).initResolved();
  }

  Future<void> _fetchAll() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key("helpTicketsFilterButtonKey")));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);


    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }

  Future<void> _goToNewHelpTicket() async {
    expect(find.byType(NewHelpTicketScreen), findsNothing);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    await NewHelpTicketScreenTest(tester: tester).init();
  }
}