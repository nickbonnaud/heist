import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/help_ticket_screen/widgets/message_input/bloc/message_input_bloc.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';

class MockHelpRepository extends Mock implements HelpRepository {}
class MockHelpTicketsScreenBloc extends Mock implements HelpTicketsScreenBloc {}
class MockHelpTicket extends Mock implements HelpTicket {}

void main() {
  group("Message Input Bloc Tests", () {
    late HelpRepository helpRepository;
    late HelpTicketsScreenBloc helpTicketsScreenBloc;

    late MessageInputBloc messageInputBloc;
    late MessageInputState _baseState;

    setUp(() {
      registerFallbackValue(HelpTicketUpdated(helpTicket: MockHelpTicket()));
      helpRepository = MockHelpRepository();
      helpTicketsScreenBloc = MockHelpTicketsScreenBloc();

      messageInputBloc = MessageInputBloc(helpRepository: helpRepository, helpTicketsScreenBloc: helpTicketsScreenBloc);
      _baseState = messageInputBloc.state;
    });

    tearDown(() {
      messageInputBloc.close();
    });

    test("Initial state of MessageInput Bloc is MessageInputState.initial()", () {
      expect(messageInputBloc.state, MessageInputState.initial());
    });

    blocTest<MessageInputBloc, MessageInputState>(
      "MessageInput Bloc MessageChanged event changes yields state: [isInputValid: true]",
      build: () => messageInputBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(MessageChanged(message: faker.lorem.sentence())),
      expect: () => [_baseState.update(isInputValid: true)]
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "MessageInput Bloc Submitted event changes yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => messageInputBloc,
      act: (bloc) {
        when(() => helpRepository.storeReply(identifier: any(named: "identifier"), message: any(named: "message")))
          .thenAnswer((_) async => MockHelpTicket());
        when(() => helpTicketsScreenBloc.add(any(that: isA<HelpTicketUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted(message: faker.lorem.sentence(), helpTicketIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "MessageInput Bloc Submitted event calls helpRepository.storeReply and helpTicketsScreenBloc.add",
      build: () => messageInputBloc,
      act: (bloc) {
        when(() => helpRepository.storeReply(identifier: any(named: "identifier"), message: any(named: "message")))
          .thenAnswer((_) async => MockHelpTicket());
        when(() => helpTicketsScreenBloc.add(any(that: isA<HelpTicketUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted(message: faker.lorem.sentence(), helpTicketIdentifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => helpRepository.storeReply(identifier: any(named: "identifier"), message: any(named: "message"))).called(1);
        verify(() => helpTicketsScreenBloc.add(any(that: isA<HelpTicketUpdated>()))).called(1);
      }
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "MessageInput Bloc Submitted event on error changes yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => messageInputBloc,
      act: (bloc) {
        when(() => helpRepository.storeReply(identifier: any(named: "identifier"), message: any(named: "message")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(Submitted(message: faker.lorem.sentence(), helpTicketIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "MessageInput Bloc Submitted event on error does not call helpTicketsScreenBloc.add",
      build: () => messageInputBloc,
      act: (bloc) {
        when(() => helpRepository.storeReply(identifier: any(named: "identifier"), message: any(named: "message")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(Submitted(message: faker.lorem.sentence(), helpTicketIdentifier: faker.guid.guid()));
      },
      verify: (_) {
        verifyNever(() => helpTicketsScreenBloc.add(any(that: isA<HelpTicketUpdated>())));
      }
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "MessageInput Bloc Reset event yields state: [isSuccess: false, errorMessage: '']",
      build: () => messageInputBloc,
      act: (bloc) => bloc.add(Reset()),
      seed: () => _baseState.update(errorMessage: "Error Message", isSuccess: true),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}