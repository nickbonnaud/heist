import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/help_tickets_screen/widgets/widgets/new_help_ticket_screen/new_help_ticket_screen.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class NewHelpTicketScreenTest {
  final WidgetTester tester;

  const NewHelpTicketScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "New Help Ticket Screen Tests");

    expect(find.byType(NewHelpTicketScreen), findsOneWidget);

    await _enterInvalidSubject();
    await _enterInvalidMessage();

    await _enterErrorSubject();
    await _enterMessage();

    await _submit();
    await _dismissSnackbar();

    await _enterSubject();
    
    await _submit();
    await _dismissSnackbar();

    expect(find.byType(NewHelpTicketScreen), findsNothing);

    await _navigateBack();

    await _cancel();

    await _navigateToSideDrawer();
  }

  Future<void> _enterInvalidSubject() async {
    expect(find.text('A Subject is required!'), findsNothing);
    await tester.enterText(find.byKey(Key("subjectFieldKey")), "  ");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('A Subject is required!'), findsOneWidget);
  }

  Future<void> _enterInvalidMessage() async {
    expect(find.text('Please include details about the issue.'), findsNothing);
    await tester.enterText(find.byKey(Key("messageFieldKey")), "  ");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Please include details about the issue.'), findsOneWidget);
  }

  Future<void> _enterErrorSubject() async {
    expect(find.text('A Subject is required!'), findsOneWidget);
    await tester.enterText(find.byKey(Key("subjectFieldKey")), "error");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('A Subject is required!'), findsNothing);
  }

  Future<void> _enterMessage() async {
    expect(find.text('Please include details about the issue.'), findsOneWidget);
    await tester.enterText(find.byKey(Key("messageFieldKey")), faker.lorem.sentence());
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Please include details about the issue.'), findsNothing);
  }

  Future<void> _submit() async {
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(Key("newHelpTicketSnackbarKey")), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump();
    
    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pump(Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(Key("newHelpTicketSnackbarKey")), findsOneWidget);
  }

  Future<void> _dismissSnackbar() async {
    await tester.fling(find.byKey(Key("newHelpTicketSnackbarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _enterSubject() async {
    await tester.enterText(find.byKey(Key("subjectFieldKey")), "Start new issue");
    await tester.pump(Duration(milliseconds: 300));
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.byType(NewHelpTicketScreen), findsOneWidget);
  }

  Future<void> _cancel() async {
    expect(find.byType(NewHelpTicketScreen), findsOneWidget);
    await tester.tap(find.byKey(Key("cancelButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byType(NewHelpTicketScreen), findsNothing);
  }

  Future<void> _navigateToSideDrawer() async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  }
}