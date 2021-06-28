import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockHelpRepository extends Mock implements HelpRepository {}

void main() {
  group("Help Tickets Screen Bloc Tests", () {
    late HelpRepository helpRepository;
    late HelpTicketsScreenBloc helpTicketsScreenBloc;

    late List<HelpTicket> _helpTickets;
    
    late MockDataGenerator _mockDataGenerator;

    setUp(() {
      helpRepository = MockHelpRepository();
      helpTicketsScreenBloc = HelpTicketsScreenBloc(helpRepository: helpRepository);
      _mockDataGenerator = MockDataGenerator();
    });

    tearDown(() {
      helpTicketsScreenBloc.close();
    });

    test("Initial state of HelpTicketsScreenBloc is Uninitialized()", () {
      expect(helpTicketsScreenBloc.state, Uninitialized());
    });

    test("HelpTicketsScreenBloc can check if pagination has reached end", () {
      expect(helpTicketsScreenBloc.paginateEnd, isA<bool>());
    });

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc can get List<HelpTicket>",
      build: () => helpTicketsScreenBloc,
      seed: () => Loaded(helpTickets: [], paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: ""),
      verify: (_) {
        expect(helpTicketsScreenBloc.helpTickets, isA<List<HelpTicket>>());
      }
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchAll(reset: false) event yields state: [Loading()], [Loaded()] when initial state is Uninitialized",
      build: () => helpTicketsScreenBloc,
      act: (bloc) {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        when(() => helpRepository.fetchAll())
          .thenAnswer((_) async => PaginateDataHolder(data: _helpTickets));
        bloc.add(FetchAll(reset: false));
      },
      expect: () => [isA<Loading>(), isA<Loaded>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchAll() event calls helpRepository.fetchAll when initial state is Uninitialized",
      build: () => helpTicketsScreenBloc,
      act: (bloc) {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        when(() => helpRepository.fetchAll())
          .thenAnswer((_) async => PaginateDataHolder(data: _helpTickets));
        bloc.add(FetchAll(reset: false));
      },
      verify: (_) {
        verify(() => helpRepository.fetchAll()).called(1);
      }
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchAll(reset: false) event on fail yields state: [Loading()], [FetchFailure()] when initial state is Uninitialized",
      build: () => helpTicketsScreenBloc,
      act: (bloc) {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        when(() => helpRepository.fetchAll())
          .thenThrow(ApiException(error: "error"));
        bloc.add(FetchAll(reset: false));
      },
      expect: () => [isA<Loading>(), isA<FetchFailure>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchAll(reset: false) event yields state: [Loading()], [Loaded()] when initial state is Loaded",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        when(() => helpRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket())));
        bloc.add(FetchAll(reset: false));
      },
      expect: () => [isA<Loaded>(), isA<Loaded>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchAll(reset: false) event calls helpRepository.paginate when initial state is Loaded",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        when(() => helpRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket())));
        bloc.add(FetchAll(reset: false));
      },
      verify: (_) {
        verify(() => helpRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchAll(reset: false) event on fail yields state: [Loading()], [FetchFailure()] when initial state is Loaded",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        when(() => helpRepository.paginate(url: any(named: "url")))
          .thenThrow(ApiException(error: "error"));
        bloc.add(FetchAll(reset: false));
      },
      expect: () => [isA<Loaded>(), isA<FetchFailure>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchResolved(reset: true) event yields state: [Loading()], [Loaded()]",
      build: () => helpTicketsScreenBloc,
      act: (bloc) {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        when(() => helpRepository.fetchResolved())
          .thenAnswer((_) async => PaginateDataHolder(data: _helpTickets));
        bloc.add(FetchResolved(reset: true));
      },
      expect: () => [isA<Loading>(), isA<Loaded>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchResolved(reset: true) event calls helpRepository.fetchResolved",
      build: () => helpTicketsScreenBloc,
      act: (bloc) {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        when(() => helpRepository.fetchResolved())
          .thenAnswer((_) async => PaginateDataHolder(data: _helpTickets));
        bloc.add(FetchResolved(reset: true));
      },
      verify: (_) {
        verify(() => helpRepository.fetchResolved()).called(1);
      }
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchResolved(reset: false) event yields state: [Loaded()], [Loaded()]",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        when(() => helpRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket())));
        
        bloc.add(FetchResolved(reset: false));
      },
      expect: () => [isA<Loaded>(), isA<Loaded>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchResolved(reset: false) event calls helpRepository.paginate",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        when(() => helpRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket())));
        
        bloc.add(FetchResolved(reset: false));
      },
      verify: (_) {
        verify(() => helpRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchResolved(reset: true) event on failure yields state: [Loading()], [FetchFailure()]",
      build: () => helpTicketsScreenBloc,
      act: (bloc) {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        when(() => helpRepository.fetchResolved())
          .thenThrow(ApiException(error: "error"));
        bloc.add(FetchResolved(reset: true));
      },
      expect: () => [isA<Loading>(), isA<FetchFailure>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchOpen(reset: true) event calls helpRepository.fetchOpen()",
      build: () => helpTicketsScreenBloc,
      act: (bloc) {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        when(() => helpRepository.fetchOpen())
          .thenAnswer((_) async => PaginateDataHolder(data: _helpTickets));
        bloc.add(FetchOpen(reset: true));
      },
      verify: (_) {
        verify(() => helpRepository.fetchOpen()).called(1);
      }
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchOpen(reset: true) event yields state: [Loading()], [Loaded()]",
      build: () => helpTicketsScreenBloc,
      act: (bloc) {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        when(() => helpRepository.fetchOpen())
          .thenAnswer((_) async => PaginateDataHolder(data: _helpTickets));
        bloc.add(FetchOpen(reset: true));
      },
      expect: () => [isA<Loading>(), isA<Loaded>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc FetchOpen(reset: false) event yields state: [Loaded()], [Loaded()]",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        when(() => helpRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket())));
        bloc.add(FetchOpen(reset: false));
      },
      expect: () => [isA<Loaded>(), isA<Loaded>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc HelpTicketUpdated event yields state: [Loaded()]",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        HelpTicket helpTicket = _helpTickets.first.update(message: faker.lorem.sentence());
        bloc.add(HelpTicketUpdated(helpTicket: helpTicket));
      },
      expect: () => [isA<Loaded>()]
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc HelpTicketAdded event yields state: [Loaded()] && adds new helpTicket",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        bloc.add(HelpTicketAdded(helpTicket: _mockDataGenerator.createHelpTicket()));
      },
      expect: () => [isA<Loaded>()],
      verify: (_) {
        expect(helpTicketsScreenBloc.helpTickets.length, 5);
      }
    );

    blocTest<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      "HelpTicketsScreenBloc HelpTicketDeleted event yields state: [Loaded()] && removes helpTicket",
      build: () => helpTicketsScreenBloc,
      seed: () {
        _helpTickets = List<HelpTicket>.generate(4, (_) => _mockDataGenerator.createHelpTicket());
        return Loaded(helpTickets: _helpTickets, paginating: false, hasReachedEnd: false, currentQuery: Option.all, queryParams: "", nextUrl: "next");
      },
      act: (bloc) {
        bloc.add(HelpTicketDeleted(helpTicketIdentifier: _helpTickets[1].identifier));
      },
      expect: () => [isA<Loaded>()],
      verify: (_) {
        expect(helpTicketsScreenBloc.helpTickets.length, 3);
      }
    );
  });
}