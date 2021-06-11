import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/help_provider.dart';

void main() {
  group("Help Provider Tests", () {
    late HelpProvider helpProvider;

    setUp(() {
      helpProvider = HelpProvider();
    });

    test("Fetching Help Tickets returns PaginatedApiResponse", () async {
      var response = await helpProvider.fetchHelpTickets();
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Help Provider can fetch by query", () async {
      var response = await helpProvider.fetchHelpTickets(query: "?resolved=true");
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Help Provider can paginate", () async {
      var response = await helpProvider.fetchHelpTickets(paginateUrl: "http://novapay.ai/api/customer/help?resolved=true&page=2");
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Storing Help Ticket returns ApiResponse", () async {
      var response = await helpProvider.storeHelpTicket(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Storing Help Ticket Reply returns ApiResponse", () async {
      var response = await helpProvider.storeReply(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating Help Ticket Reply returns ApiResponse", () async {
      var response = await helpProvider.updateReplies(ticketIdentifier: "ticketIdentifier", body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Deleting Help Ticket returns ApiResponse", () async {
      var response = await helpProvider.deleteHelpTicket(identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });
  });
}