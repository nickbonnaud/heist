import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockTransactionResource extends Mock implements TransactionResource {}
class MockTransaction extends Mock implements Transaction {}

void main() {
  group("Open Transactions Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late OpenTransactionsBloc openTransactionsBloc;
    late AuthenticationBloc authenticationBloc;

    late TransactionResource _transaction;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      authenticationBloc = MockAuthenticationBloc();
      whenListen(authenticationBloc, Stream<AuthenticationState>.fromIterable([]));
      openTransactionsBloc = OpenTransactionsBloc(transactionRepository: transactionRepository, authenticationBloc: authenticationBloc);
    });

    tearDown(() {
      openTransactionsBloc.close();
    });

    test("Initial state of OpenTransactionsBloc is Uninitialized()", () {
      expect(openTransactionsBloc.state, isA<Uninitialized>());
    });

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc has openTransactions getter",
      build: () => openTransactionsBloc,
      seed: () => OpenTransactionsLoaded(transactions: [MockTransactionResource()]),
      verify: (_) {
        expect(openTransactionsBloc.openTransactions, isA<List<TransactionResource>>());
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc FetchOpenTransactions event yields state: [OpenTransactionsLoaded()]",
      build: () => openTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchOpen()).thenAnswer((_) async => [MockTransactionResource()]);
        bloc.add(FetchOpenTransactions());
      },
      expect: () => [isA<OpenTransactionsLoaded>()],
      verify: (_) {
        expect(openTransactionsBloc.state.openTransactions, isA<List<TransactionResource>>());
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc FetchOpenTransactions event calls transactionRepository.fetchOpen()",
      build: () => openTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchOpen()).thenAnswer((_) async => [MockTransactionResource()]);
        bloc.add(FetchOpenTransactions());
      },
      verify: (_) {
        verify(() => transactionRepository.fetchOpen()).called(1);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc FetchOpenTransactions event on error yields state: [FailedToFetchOpenTransactions()]",
      build: () => openTransactionsBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchOpen()).thenThrow(ApiException(error: "error"));
        bloc.add(FetchOpenTransactions());
      },
      expect: () => [isA<FailedToFetchOpenTransactions>()],
      verify: (_) {
        expect((openTransactionsBloc.state as FailedToFetchOpenTransactions).errorMessage, "error");
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc AddOpenTransaction event with no open transactions event yields state: [OpenTransactionsLoaded()]",
      build: () => openTransactionsBloc,
      seed: () => OpenTransactionsLoaded(transactions: []),
      act: (bloc) {
        bloc.add(AddOpenTransaction(transaction: MockTransactionResource()));
      },
      expect: () => [isA<OpenTransactionsLoaded>()],
      verify: (_) {
        expect(openTransactionsBloc.state.openTransactions, isA<List<TransactionResource>>());
        expect(openTransactionsBloc.openTransactions.length, 1);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc AddOpenTransaction event with different open transactions event yields state: [OpenTransactionsLoaded()]",
      build: () => openTransactionsBloc,
      seed: () => OpenTransactionsLoaded(transactions: [MockTransactionResource()]),
      act: (bloc) {
        bloc.add(AddOpenTransaction(transaction: MockTransactionResource()));
      },
      expect: () => [isA<OpenTransactionsLoaded>()],
      verify: (_) {
        expect(openTransactionsBloc.state.openTransactions, isA<List<TransactionResource>>());
        expect(openTransactionsBloc.openTransactions.length, 2);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc AddOpenTransaction event with same open transactions does not change state",
      build: () => openTransactionsBloc,
      seed: () {
        _transaction = MockTransactionResource();
        return OpenTransactionsLoaded(transactions: [_transaction]);
      },
      act: (bloc) {
        bloc.add(AddOpenTransaction(transaction: _transaction));
      },
      expect: () => [],
      verify: (_) {
        expect(openTransactionsBloc.openTransactions.length, 1);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc AddOpenTransaction event when state is notOpenTransactionsLoaded does not change state",
      build: () => openTransactionsBloc,
      act: (bloc) {
        bloc.add(AddOpenTransaction(transaction: MockTransactionResource()));
      },
      expect: () => [],
      verify: (_) {
        expect(openTransactionsBloc.openTransactions.length, 0);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc RemoveOpenTransaction with one transaction event yields state: [OpenTransactionsLoaded]",
      build: () => openTransactionsBloc,
      seed: () {
        _transaction = MockTransactionResource();
        return OpenTransactionsLoaded(transactions: [_transaction]);
      },
      act: (bloc) {
        bloc.add(RemoveOpenTransaction(transaction: _transaction));
      },
      expect: () => [isA<OpenTransactionsLoaded>()],
      verify: (_) {
        expect(openTransactionsBloc.openTransactions.length, 0);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc RemoveOpenTransaction with two transaction event yields state: [OpenTransactionsLoaded]",
      build: () => openTransactionsBloc,
      seed: () {
        _transaction = MockTransactionResource(); 
        var otherTransaction = MockTransactionResource();
        
        return OpenTransactionsLoaded(transactions: [_transaction, otherTransaction]);
      },
      act: (bloc) {
        bloc.add(RemoveOpenTransaction(transaction: _transaction));
      },
      expect: () => [isA<OpenTransactionsLoaded>()],
      verify: (_) {
        expect(openTransactionsBloc.openTransactions.length, 1);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc RemoveOpenTransaction does nothing if transactions list is empty",
      build: () => openTransactionsBloc,
      seed: () {
        return OpenTransactionsLoaded(transactions: []);
      },
      act: (bloc) {
        bloc.add(RemoveOpenTransaction(transaction: _transaction));
      },
      expect: () => [],
      verify: (_) {
        expect(openTransactionsBloc.openTransactions.length, 0);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc RemoveOpenTransaction does nothing if state is not OpenTransactionsLoaded",
      build: () => openTransactionsBloc,
      act: (bloc) {
        bloc.add(RemoveOpenTransaction(transaction: _transaction));
      },
      expect: () => [],
      verify: (_) {
        expect(openTransactionsBloc.openTransactions.length, 0);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc UpdateOpenTransaction event yields state: [OpenTransactionsLoaded]",
      build: () => openTransactionsBloc,
      seed: () {
        _transaction = MockTransactionResource(); 
        var otherTransaction = MockTransactionResource();
        
        return OpenTransactionsLoaded(transactions: [_transaction, otherTransaction]);
      },
      act: (bloc) {
        bloc.add(UpdateOpenTransaction(transaction: _transaction));
      },
      expect: () => [isA<OpenTransactionsLoaded>()],
      verify: (_) {
        expect(openTransactionsBloc.openTransactions.length, 2);
      }
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc UpdateOpenTransaction event does nothing is state is not OpenTransactionsLoaded",
      build: () => openTransactionsBloc,
      act: (bloc) {
        bloc.add(UpdateOpenTransaction(transaction: MockTransactionResource()));
      },
      expect: () => [],
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc authenticationBlocSubscription => [state is Authenticated && (_previousAuthenticationState is Unknown || _previousAuthenticationState is Unauthenticated)]",
      build: () {
        when(() => transactionRepository.fetchOpen()).thenAnswer((_) async => [MockTransactionResource()]);
        whenListen(authenticationBloc, Stream<AuthenticationState>.fromIterable([Unknown(), Authenticated()]));
        return OpenTransactionsBloc(transactionRepository: transactionRepository, authenticationBloc: authenticationBloc);
      },
      expect: () => [isA<OpenTransactionsLoaded>()],
    );

    blocTest<OpenTransactionsBloc, OpenTransactionsState>(
      "OpenTransactionsBloc authenticationBlocSubscription => [!state is Authenticated && (_previousAuthenticationState is Unknown || _previousAuthenticationState is Unauthenticated)]",
      build: () {
        when(() => transactionRepository.fetchOpen()).thenAnswer((_) async => [MockTransactionResource()]);
        whenListen(authenticationBloc, Stream<AuthenticationState>.fromIterable([Authenticated(), Authenticated()]));
        return OpenTransactionsBloc(transactionRepository: transactionRepository, authenticationBloc: authenticationBloc);
      },
      expect: () => [],
    );
  });
}