import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/screens/help_tickets_screen/widgets/widgets/new_help_ticket_screen/bloc/help_ticket_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockHelpRepository extends Mock implements HelpRepository {}
class MockHelpTicketsScreenBloc extends Mock implements HelpTicketsScreenBloc {}
class MockHelpTicket extends Mock implements HelpTicket {}

void main() {
  group("Help Ticket Form Bloc Tests", () {
    late HelpRepository helpRepository;
    late HelpTicketsScreenBloc helpTicketsScreenBloc;

    late HelpTicketFormBloc helpTicketFormBloc;
    late HelpTicketFormState _baseState;

    late String subject;
    late String message;

    setUp(() {
      registerFallbackValue(HelpTicketAdded(helpTicket: MockHelpTicket()));
      helpRepository = MockHelpRepository();
      helpTicketsScreenBloc = MockHelpTicketsScreenBloc();

      helpTicketFormBloc = HelpTicketFormBloc(helpRepository: helpRepository, helpTicketsScreenBloc: helpTicketsScreenBloc);
      _baseState = helpTicketFormBloc.state;
    });

    tearDown(() {
      helpTicketFormBloc.close();
    });

    test("Initial state of HelpTicketFormBloc is HelpTicketFormState.initial()", () {
      expect(helpTicketFormBloc.state, HelpTicketFormState.initial());
    });

    blocTest<HelpTicketFormBloc, HelpTicketFormState>(
      "HelpTicketFormBloc SubjectChanged event yields state: [isSubjectValid: true]",
      build: () => helpTicketFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        subject = faker.lorem.sentence();
        bloc.add(SubjectChanged(subject: subject));
      },
      expect: () => [_baseState.update(subject: subject, isSubjectValid: true)]
    );

    blocTest<HelpTicketFormBloc, HelpTicketFormState>(
      "HelpTicketFormBloc MessageChanged event yields state: [isMessageValid: true]",
      build: () => helpTicketFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        message = faker.lorem.sentence();
        bloc.add(MessageChanged(message: message));
      },
      expect: () => [_baseState.update(message: message, isMessageValid: true)]
    );

    blocTest<HelpTicketFormBloc, HelpTicketFormState>(
      "HelpTicketFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => helpTicketFormBloc,
      seed: () {
        subject = faker.lorem.sentence();
        message = faker.lorem.sentence();
        _baseState = _baseState.update(subject: subject, message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => helpRepository.storeHelpTicket(subject: any(named: "subject"), message: any(named: "message")))
          .thenAnswer((_) async => MockHelpTicket());
        when(() => helpTicketsScreenBloc.add(any(that: isA<HelpTicketAdded>())))
          .thenReturn(null);

        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<HelpTicketFormBloc, HelpTicketFormState>(
      "HelpTicketFormBloc Submitted event calls helpRepository.storeHelpTicket && helpTicketsScreenBloc.add",
      build: () => helpTicketFormBloc,
      seed: () {
        subject = faker.lorem.sentence();
        message = faker.lorem.sentence();
        _baseState = _baseState.update(subject: subject, message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => helpRepository.storeHelpTicket(subject: any(named: "subject"), message: any(named: "message")))
          .thenAnswer((_) async => MockHelpTicket());
        when(() => helpTicketsScreenBloc.add(any(that: isA<HelpTicketAdded>())))
          .thenReturn(null);

        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => helpRepository.storeHelpTicket(subject: any(named: "subject"), message: any(named: "message"))).called(1);
        verify(() => helpTicketsScreenBloc.add(any(that: isA<HelpTicketAdded>()))).called(1);
      }
    );

    blocTest<HelpTicketFormBloc, HelpTicketFormState>(
      "HelpTicketFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => helpTicketFormBloc,
      seed: () {
        subject = faker.lorem.sentence();
        message = faker.lorem.sentence();
        _baseState = _baseState.update(subject: subject, message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => helpRepository.storeHelpTicket(subject: any(named: "subject"), message: any(named: "message")))
          .thenThrow(const ApiException(error: "error"));

        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<HelpTicketFormBloc, HelpTicketFormState>(
      "HelpTicketFormBloc Reset event on yields state: [isSuccess: false, errorMessage: '']",
      build: () => helpTicketFormBloc,
      seed: () {
        subject = faker.lorem.sentence();
        message = faker.lorem.sentence();
        _baseState = _baseState.update(subject: subject, message: message, isSuccess: true, errorMessage: "error");
        return _baseState;
      },
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(subject: subject, message: message, isSuccess: false, errorMessage: "")]
    );
  });
}