import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/help_provider.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockHelpProvider extends Mock implements HelpProvider {}

void main() {
  group("Help Repository Tests", () {
    late HelpRepository helpRepository;
    late HelpProvider mockHelpProvider;
    late HelpRepository helpRepositoryWithMock;

    setUp(() {
      helpRepository = HelpRepository(helpProvider: HelpProvider());
      mockHelpProvider = MockHelpProvider();
      helpRepositoryWithMock = HelpRepository(helpProvider: mockHelpProvider);
    });

    test("Help Repository can fetch all help tickets", () async {
      var holder = await helpRepository.fetchAll();
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<HelpTicket>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Help Repository fetch all on error throws exception", () async {
      when(() => mockHelpProvider.fetchHelpTickets()).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false));
      
      expect(
        helpRepositoryWithMock.fetchAll(),
        throwsA(isA<ApiException>())
      );
    });

    test("Help Repository can fetch resolved help tickets", () async {
      var holder = await helpRepository.fetchResolved();
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<HelpTicket>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Help Repository fetch resolved on error throws exception", () async {
      when(() => mockHelpProvider.fetchHelpTickets(query: "?resolved=true")).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false));
      
      expect(
        helpRepositoryWithMock.fetchResolved(),
        throwsA(isA<ApiException>())
      );
    });

    test("Help Repository can fetch open help tickets", () async {
      var holder = await helpRepository.fetchOpen();
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<HelpTicket>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Help Repository fetch open on error throws exception", () async {
      when(() => mockHelpProvider.fetchHelpTickets(query: "?resolved=false")).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false));
      
      expect(
        helpRepositoryWithMock.fetchOpen(),
        throwsA(isA<ApiException>())
      );
    });

    test("Help Repository can paginate", () async {
      var holder = await helpRepository.paginate(url: "http://novapay.ai/api/customer/help?page=2");
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<HelpTicket>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Help Repository paginate on error throws exception", () async {
      when(() => mockHelpProvider.fetchHelpTickets(paginateUrl: "http://novapay.ai/api/customer/help?page=2")).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false));
      
      expect(
        helpRepositoryWithMock.paginate(url: "http://novapay.ai/api/customer/help?page=2"),
        throwsA(isA<ApiException>())
      );
    });

    test("Help Repository can store help ticket", () async {
      var helpTicket = await helpRepository.storeHelpTicket(subject: "subject", message: "message");
      expect(helpTicket, isA<HelpTicket>());
    });

    test("Help Repository on store help ticket error throws exception", () async {
      when(() => mockHelpProvider.storeHelpTicket(body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        helpRepositoryWithMock.storeHelpTicket(subject: "subject", message: "message"),
        throwsA(isA<ApiException>())
      );
    });

    test("Help Repository can store reply", () async {
      var helpTicket = await helpRepository.storeReply(identifier: "identifier", message: "message");
      expect(helpTicket, isA<HelpTicket>());
    });

    test("Help Repository on store reply error throws exception", () async {
      when(() => mockHelpProvider.storeReply(body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        helpRepositoryWithMock.storeReply(identifier: "identifier", message: "message"),
        throwsA(isA<ApiException>())
      );
    });

    test("Help Repository can update replies as read", () async {
      var helpTicket = await helpRepository.updateRepliesAsRead(ticketIdentifier: "ticketIdentifier");
      expect(helpTicket, isA<HelpTicket>());
    });

    test("Help Repository on update replies as read error throws exception", () async {
      when(() => mockHelpProvider.updateReplies(ticketIdentifier: any(named: "ticketIdentifier"), body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        helpRepositoryWithMock.updateRepliesAsRead(ticketIdentifier: "ticketIdentifier"),
        throwsA(isA<ApiException>())
      );
    });

    test("Help Repository can delete help ticket", () async {
      var deleted = await helpRepository.deleteHelpTicket(identifier: "identifier");
      expect(deleted, isA<bool>());
    });

    test("Help Repository on delete help ticket error throws exception", () async {
      when(() => mockHelpProvider.deleteHelpTicket(identifier: any(named: "identifier"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        helpRepositoryWithMock.deleteHelpTicket(identifier: "identifier"),
        throwsA(isA<ApiException>())
      );
    });
  });
}