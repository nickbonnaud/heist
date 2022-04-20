import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/help_ticket/reply.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/help_ticket_screen/widgets/help_ticket_body/widgets/message_list/bloc/message_list_bloc.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockHelpTicketsScreenBloc extends Mock implements HelpTicketsScreenBloc {}
class MockHelpRepository extends Mock implements HelpRepository {}

void main() {
  group("Message List Bloc Tests", () {
    late HelpTicketsScreenBloc helpTicketsScreenBloc;
    late HelpTicket helpTicket;
    late HelpRepository helpRepository;

    late MessageListBloc messageListBloc;

    late MockDataGenerator _mockDataGenerator;
    late MessageListState _baseState;

    setUp(() {
      _mockDataGenerator = MockDataGenerator();
      helpTicketsScreenBloc = MockHelpTicketsScreenBloc();
      whenListen(helpTicketsScreenBloc, Stream<HelpTicketsScreenState>.fromIterable([]));
      
      helpTicket = _mockDataGenerator.createHelpTicket();
      
      List<Reply> replies = helpTicket.replies;
      replies = replies.map((reply) => reply.update(fromCustomer: false, read: false)).toList();
      helpTicket = helpTicket.update(replies: replies, resolved: false);

      helpRepository = MockHelpRepository();

      messageListBloc = MessageListBloc(helpTicket: helpTicket, helpTicketsScreenBloc: helpTicketsScreenBloc, helpRepository: helpRepository);
      _baseState = messageListBloc.state;

      registerFallbackValue(HelpTicketUpdated(helpTicket: helpTicket));
    });

    tearDown((){
      messageListBloc.close();
    });

    test("Initial state of MessageListBloc is MessageListState.initial", () {
      expect(messageListBloc.state, MessageListState.initial(helpTicket: helpTicket));
    });

    blocTest<MessageListBloc, MessageListState>(
      "MessageListBloc ReplyAdded event yields state: [helpTicket: helpTicket]",
      build: () => messageListBloc,
      act: (bloc) {
        helpTicket = helpTicket.update(replies: helpTicket.replies..add(Reply(message: faker.lorem.sentence(), fromCustomer: true, createdAt: DateTime.now(), read: false)));
        bloc.add(ReplyAdded(helpTicket: helpTicket));
      },
      expect: () => [_baseState.update(helpTicket: helpTicket)]
    );

    blocTest<MessageListBloc, MessageListState>(
      "MessageListBloc RepliesViewed event yields state: [helpTicket: helpTicket]",
      build: () => messageListBloc,
      act: (bloc) {
        List<Reply> replies = helpTicket.replies.map((reply) => reply.update(read: true)).toList();
        helpTicket = helpTicket.update(replies: replies);
        
        when(() => helpRepository.updateRepliesAsRead(ticketIdentifier: any(named: "ticketIdentifier")))
          .thenAnswer((_) async => helpTicket);

        bloc.add(RepliesViewed());
      },
      expect: () => [_baseState.update(helpTicket: helpTicket)]
    );

    blocTest<MessageListBloc, MessageListState>(
      "MessageListBloc RepliesViewed event calls helpTicketsScreenBloc.add && helpRepository.updateRepliesAsRead",
      build: () => messageListBloc,
      act: (bloc) {
        List<Reply> replies = helpTicket.replies.map((reply) => reply.update(read: true)).toList();
        helpTicket = helpTicket.update(replies: replies);
        
        when(() => helpRepository.updateRepliesAsRead(ticketIdentifier: any(named: "ticketIdentifier")))
          .thenAnswer((_) async => helpTicket);

        bloc.add(RepliesViewed());
      },
      verify: (_) {
        verify(() => helpRepository.updateRepliesAsRead(ticketIdentifier: any(named: "ticketIdentifier"))).called(1);
        verify(() => helpTicketsScreenBloc.add(any(that: isA<HelpTicketUpdated>())));
      }
    );

    blocTest<MessageListBloc, MessageListState>(
      "MessageListBloc RepliesViewed event on error yields state: [errorMessage: error]",
      build: () => messageListBloc,
      act: (bloc) {
        List<Reply> replies = helpTicket.replies.map((reply) => reply.update(read: true)).toList();
        helpTicket = helpTicket.update(replies: replies);
        
        when(() => helpRepository.updateRepliesAsRead(ticketIdentifier: any(named: "ticketIdentifier")))
          .thenThrow(const ApiException(error: "error"));

        bloc.add(RepliesViewed());
      },
      expect: () => [_baseState.update(errorMessage: "error")]
    );

    blocTest<MessageListBloc, MessageListState>(
      "MessageListBloc helpTicketsScreenBloc stream yields state: [helpTicket: helpTicket]",
      build: () {
        whenListen(helpTicketsScreenBloc, Stream<HelpTicketsScreenState>.fromIterable([Loaded(
          queryParams: "",
          paginating: false,
          hasReachedEnd: false,
          currentQuery: Option.all,
          helpTickets: [helpTicket]
        )]));
        
        return MessageListBloc(helpRepository: helpRepository, helpTicketsScreenBloc: helpTicketsScreenBloc, helpTicket: helpTicket);
      },
      seed: () {
        return MessageListState(
          helpTicket: helpTicket.update(replies: []), 
          errorMessage: ""
        );
      },
      expect: () => [_baseState.update(helpTicket: helpTicket)]
    );
  });
}