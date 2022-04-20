import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/help_ticket_screen/widgets/delete_ticket_button/bloc/delete_ticket_button_bloc.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockHelpRepository extends Mock implements HelpRepository {}
class MockHelpTicketsScreenBloc extends Mock implements HelpTicketsScreenBloc {}

void main() {
  group("Delete Ticket Button Bloc Tests", () {
    late HelpRepository helpRepository;
    late HelpTicketsScreenBloc helpTicketsScreenBloc;

    late DeleteTicketButtonBloc deleteTicketButtonBloc;

    late DeleteTicketButtonState _baseState;

    setUp(() {
      helpRepository = MockHelpRepository();
      helpTicketsScreenBloc = MockHelpTicketsScreenBloc();

      deleteTicketButtonBloc = DeleteTicketButtonBloc(helpRepository: helpRepository, helpTicketsScreenBloc: helpTicketsScreenBloc);
      _baseState = deleteTicketButtonBloc.state;
    });

    tearDown(() {
      deleteTicketButtonBloc.close();
    });

    test("Initial state of DeleteTicketButtonBloc is DeleteTicketButtonState.initial()", () {
      expect(deleteTicketButtonBloc.state, DeleteTicketButtonState.initial());
    });

    blocTest<DeleteTicketButtonBloc, DeleteTicketButtonState>(
      "DeleteTicketButtonBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () {
        when(() => helpRepository.deleteHelpTicket(identifier: any(named: "identifier")))
          .thenAnswer((_) async => true);
        return deleteTicketButtonBloc;
      },
      act: (bloc) => bloc.add(Submitted(ticketIdentifier: faker.guid.guid())),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<DeleteTicketButtonBloc, DeleteTicketButtonState>(
      "DeleteTicketButtonBloc Submitted event on unable to delete help ticket yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: Unable to remove Help Ticket. Please try again.]",
      build: () {
        when(() => helpRepository.deleteHelpTicket(identifier: any(named: "identifier")))
          .thenAnswer((_) async => false);
        return deleteTicketButtonBloc;
      },
      act: (bloc) => bloc.add(Submitted(ticketIdentifier: faker.guid.guid())),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "Unable to remove Help Ticket. Please try again.")]
    );

    blocTest<DeleteTicketButtonBloc, DeleteTicketButtonState>(
      "DeleteTicketButtonBloc Submitted event on api failure yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () {
        when(() => helpRepository.deleteHelpTicket(identifier: any(named: "identifier")))
          .thenThrow(const ApiException(error: "error"));
        return deleteTicketButtonBloc;
      },
      act: (bloc) => bloc.add(Submitted(ticketIdentifier: faker.guid.guid())),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<DeleteTicketButtonBloc, DeleteTicketButtonState>(
      "DeleteTicketButtonBloc Reset event yields state: [isSuccess: false, errorMessage: '']",
      build: () => deleteTicketButtonBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}