import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/help_ticket/reply.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Help Ticket Tests", () {

    test("Help Ticket can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateHelpTicket();
      var helpTicket = HelpTicket.fromJson(json: json);
      expect(helpTicket, isA<HelpTicket>());
    });

    test("Help Ticket formats updatedAt to dateTime", () {
      final Map<String, dynamic> json = MockResponses.generateHelpTicket();
      var helpTicket = HelpTicket.fromJson(json: json);
      expect(helpTicket.updatedAt, isA<DateTime>());
    });

    test("Help Ticket formats replies to List<Reply>", () {
      final Map<String, dynamic> json = MockResponses.generateHelpTicket();
      var helpTicket = HelpTicket.fromJson(json: json);
      expect(helpTicket.replies, isA<List<Reply>>());
    });

    test("Help Ticket can update it's attributes", () {
      Map<String, dynamic> json = MockResponses.generateHelpTicket();
      while (json['read'] == true) {
        json = MockResponses.generateHelpTicket();
      }

      var helpTicket = HelpTicket.fromJson(json: json);
      expect(helpTicket.read == true, false);

      helpTicket = helpTicket.update(read: true);
      expect(helpTicket.read == true, true);
    });
  });
}