import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';
import 'package:heist/screens/historic_transactions_screen/widgets/filter_button/filter_button.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Historic Transactions Bloc Tests", () {
    late TransactionRepository transactionRepository;

    late HistoricTransactionsBloc historicTransactionsBloc;
    late HistoricTransactionsState _baseState;

    late MockDataGenerator _mockDataGenerator;

    setUp(() {
      registerFallbackValue(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
      transactionRepository = MockTransactionRepository();
      historicTransactionsBloc = HistoricTransactionsBloc(transactionRepository: transactionRepository);
      _baseState = historicTransactionsBloc.state;

      _mockDataGenerator = MockDataGenerator();
    });

    tearDown(() {
      historicTransactionsBloc.close();
    });

    test("Initial state of HistoricTransactionsBloc is Uninitialized()", () {
      expect(historicTransactionsBloc.state, Uninitialized());
    });

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchHistoricTransactions(reset: false) event when currentState is Uninitialized yields state: [Loading()], [TransactionsLoaded]",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchHistoric())
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchHistoricTransactions(reset: false));
      },
      expect: () => [isA<Loading>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchHistoricTransactions(reset: false) event when currentState is Uninitialized calls transactionRepository.fetchHistoric",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchHistoric())
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchHistoricTransactions(reset: false));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchHistoric()).called(1);
      }
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchHistoricTransactions(reset: false) event when currentState is TransactionsLoaded yields state: [TransactionsLoaded()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchHistoricTransactions(reset: false));
      },
      expect: () => [isA<TransactionsLoaded>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchHistoricTransactions(reset: false) event when currentState is TransactionsLoaded calls transactionRepository.paginate",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchHistoricTransactions(reset: false));
      },
      verify: (_) {
        verify(() => transactionRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchHistoricTransactions(reset: true) event yields state: [Loading()], [TransactionsLoaded]",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchHistoric())
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchHistoricTransactions(reset: true));
      },
      expect: () => [isA<Loading>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchHistoricTransactions() event when currentState is Uninitialized on fail yields state: [Loading()], [FetchFailure()]",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchHistoric())
          .thenThrow(ApiException(error: "error"));

        bloc.add(FetchHistoricTransactions(reset: false));
      },
      expect: () => [isA<Loading>(), isA<FetchFailure>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchHistoricTransactions(reset: false) event when currentState is TransactionsLoaded on fail yields state: [TransactionsLoaded()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(FetchHistoricTransactions(reset: false));
      },
      expect: () => [isA<TransactionsLoaded>(), isA<FetchFailure>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionsByDateRange(reset: true) event yields state: [Loading()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchDateRange(dateRange: any(named: "dateRange")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionsByDateRange(reset: true, dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now())));
      },
      expect: () => [isA<Loading>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionsByDateRange(reset: true) event calls transactionRepository.fetchDateRange",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchDateRange(dateRange: any(named: "dateRange")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionsByDateRange(reset: true, dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now())));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchDateRange(dateRange: any(named: "dateRange"))).called(1);
      }
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionsByDateRange(reset: false) event yields state: [TransactionsLoaded()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionsByDateRange(reset: false, dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now())));
      },
      expect: () => [isA<TransactionsLoaded>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionsByDateRange(reset: false) event calls transactionRepository.paginate",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionsByDateRange(reset: false, dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now())));
      },
      verify: (_) {
        verify(() => transactionRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionsByBusiness(reset: true) event yields state: [Loading()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchByBusiness(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionsByBusiness(reset: true, identifier: faker.guid.guid()));
      },
      expect: () => [isA<Loading>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionsByBusiness(reset: true) event calls transactionRepository.fetchByBusiness",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchByBusiness(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionsByBusiness(reset: true, identifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchByBusiness(identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionsByBusiness(reset: false) event yields state: [TransactionsLoaded()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionsByBusiness(reset: false, identifier: faker.guid.guid()));
      },
      expect: () => [isA<TransactionsLoaded>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionsByBusiness(reset: false) event calls transactionRepository.paginate",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionsByBusiness(reset: false, identifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => transactionRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionByIdentifier(reset: true) event yields state: [Loading()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionByIdentifier(reset: true, identifier: faker.guid.guid()));
      },
      expect: () => [isA<Loading>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionByIdentifier(reset: true) event calls transactionRepository.fetchByIdentifier",
      build: () => historicTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionByIdentifier(reset: true, identifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionByIdentifier(reset: false) event yields state: [TransactionsLoaded()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionByIdentifier(reset: false, identifier: faker.guid.guid()));
      },
      expect: () => [isA<TransactionsLoaded>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchTransactionByIdentifier(reset: false) event calls transactionRepository.paginate",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchTransactionByIdentifier(reset: false, identifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => transactionRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchMoreTransactions event yields state: [TransactionsLoaded()], [TransactionsLoaded()]",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchMoreTransactions());
      },
      expect: () => [isA<TransactionsLoaded>(), isA<TransactionsLoaded>()]
    );

    blocTest<HistoricTransactionsBloc, HistoricTransactionsState>(
      "HistoricTransactionsBloc FetchMoreTransactions event calls transactionRepository.paginate",
      build: () => historicTransactionsBloc,
      seed: () => TransactionsLoaded(
        transactions: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource()),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      ),
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: List<TransactionResource>.generate(5, (_) => _mockDataGenerator.createTransactionResource())));

        bloc.add(FetchMoreTransactions());
      },
      verify: (_) {
        verify(() => transactionRepository.paginate(url: any(named: "url"))).called(1);
      }
    );
  });
}