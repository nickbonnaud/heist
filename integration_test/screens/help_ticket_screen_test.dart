import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/help_ticket_screen/help_ticket_screen.dart';
import 'package:heist/screens/help_ticket_screen/widgets/delete_ticket_button/delete_ticket_button.dart';
import 'package:heist/screens/help_ticket_screen/widgets/help_ticket_body/widgets/message_input/message_input.dart';
import 'package:heist/screens/help_tickets_screen/help_tickets_screen.dart';

import '../helpers/test_title.dart';

class HelpTicketScreenTest {
  final WidgetTester tester;

  const HelpTicketScreenTest({required this.tester});

  Future<void> initOpen() async {
    TestTitle.write(testName: "Help Ticket Details Open Screen Tests");

    expect(find.byType(HelpTicketScreen), findsOneWidget);
    expect(find.byType(DeleteTicketButton), findsOneWidget);
    expect(find.byType(MessageInput), findsOneWidget);

    await _addNewReplyError();
    
    await _addNewReply();

    await _deleteOpenCancel();
    
    await _deleteOpenConfirm();

    await _navigateBack(); 

    await _dismiss();   
  }

  Future<void> _addNewReplyError() async {
    expect(find.byKey(const Key("newReplySnackbarKey")), findsNothing);
    await tester.enterText(find.byKey(const Key("messageFieldKey")), "error");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("newReplySnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("newReplySnackbarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle(); 
  }
  
  Future<void> _addNewReply() async {
    String newMessage = "A new message";
    expect(find.text(newMessage), findsNothing);

    await tester.enterText(find.byKey(const Key("messageFieldKey")), newMessage);
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text(newMessage), findsOneWidget);
  }

  Future<void> _dismiss() async {
    expect(find.byType(HelpTicketScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pumpAndSettle();
    expect(find.byType(HelpTicketScreen), findsNothing);
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(const Key("helpTicketKey-0")));
    await tester.pumpAndSettle();
    expect(find.byType(HelpTicketScreen), findsOneWidget);
  }

  Future<void> _deleteOpenCancel() async {
    expect(find.byKey(const Key("deleteTicketDialogKey")), findsNothing);
    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pump();
    expect(find.byKey(const Key("deleteTicketDialogKey")), findsOneWidget);

    await tester.tap(find.byKey(const Key("cancelDeleteTicketButtonKey")));
    await tester.pump();

    expect(find.byKey(const Key("deleteTicketDialogKey")), findsNothing);
  }
  
  Future<void> _deleteOpenConfirm() async {
    expect(find.byKey(const Key("deleteTicketDialogKey")), findsNothing);
    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pump();
    expect(find.byKey(const Key("deleteTicketDialogKey")), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(HelpTicketsScreen), findsNothing);

    await tester.tap(find.byKey(const Key("confirmDeleteTicketButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(HelpTicketsScreen), findsOneWidget);
  }
  
  Future<void> initResolved() async {
    TestTitle.write(testName: "Help Ticket Details Resolved Screen Tests");

    expect(find.byType(HelpTicketScreen), findsOneWidget);
    expect(find.byType(DeleteTicketButton), findsNothing);
    expect(find.byType(MessageInput), findsNothing);

    await _scroll();

    await _goBack();  
  }

  Future<void> _scroll() async {
    expect(find.byKey(const Key("messageBubbleKey-0")), findsOneWidget);
    await tester.fling(find.byKey(const Key("messageListKey")), const Offset(0, 800), 500);
    expect(find.byKey(const Key("messageBubbleKey-0")), findsNothing);
  }

  Future<void> _goBack() async {
    expect(find.byType(HelpTicketsScreen), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pumpAndSettle();
    
    expect(find.byType(HelpTicketsScreen), findsOneWidget);
  }
}