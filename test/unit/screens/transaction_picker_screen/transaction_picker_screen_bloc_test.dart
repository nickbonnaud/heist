import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/transaction_picker_screen/bloc/transaction_picker_screen_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockUnassignedTransactionResource extends Mock implements UnassignedTransactionResource {}
class MockTransactionResource extends Mock implements TransactionResource {}

void main() {
  group("Transaction Picker Screen Bloc Tests", () {
    late TransactionRepository transactionRepository;

    late TransactionPickerScreenBloc transactionPickerScreenBloc;
    late TransactionPickerScreenState _baseState;

    late TransactionResource _claimedTransaction;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      transactionPickerScreenBloc = TransactionPickerScreenBloc(transactionRepository: transactionRepository);
      _baseState = transactionPickerScreenBloc.state;
    });

    tearDown(() {
      transactionPickerScreenBloc.close();
    });

    List<UnassignedTransactionResource> _createTransactions() {
      return List<UnassignedTransactionResource>.generate(5, (_) => MockUnassignedTransactionResource());
    }
    
    test("Initial state of TransactionPickerScreenBloc is Uninitialized()", () {
      expect(transactionPickerScreenBloc.state, Uninitialized());
    });

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Fetch event changes state: [Loading()], [TransactionsLoaded()]",
      build: () => transactionPickerScreenBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchUnassigned(businessIdentifier: any(named: "businessIdentifier")))
          .thenAnswer((_) async => _createTransactions());
        
        bloc.add(Fetch(businessIdentifier: faker.guid.guid()));
      },
      expect: () => [isA<Loading>(), isA<TransactionsLoaded>()]
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Fetch event calls transactionRepository.fetchUnassigned",
      build: () => transactionPickerScreenBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchUnassigned(businessIdentifier: any(named: "businessIdentifier")))
          .thenAnswer((_) async => _createTransactions());
        
        bloc.add(Fetch(businessIdentifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchUnassigned(businessIdentifier: any(named: "businessIdentifier"))).called(1);
      }
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Fetch event on fail changes state: [Loading()], [FetchFailure()]",
      build: () => transactionPickerScreenBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchUnassigned(businessIdentifier: any(named: "businessIdentifier")))
          .thenThrow(ApiException(error: "error"));
        
        bloc.add(Fetch(businessIdentifier: faker.guid.guid()));
      },
      expect: () => [isA<Loading>(), isA<FetchFailure>()]
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Claim event changes state: [TransactionsLoaded(claiming: true)], [TransactionsLoaded(claiming: false, claimSuccess: true, transaction: transaction)]",
      build: () => transactionPickerScreenBloc,
      seed: () {
        _baseState = TransactionsLoaded(transactions: _createTransactions());
        return _baseState;
      },
      act: (bloc) {
        _claimedTransaction = MockTransactionResource();
        when(() => transactionRepository.claimUnassigned(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => _claimedTransaction);
        
        bloc.add(Claim(transactionIdentifier: faker.guid.guid()));
      },
      expect: () => [(_baseState as TransactionsLoaded).update(claiming: true), (_baseState as TransactionsLoaded).update(claiming: false, claimSuccess: true, transaction: _claimedTransaction)]
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Claim event calls transactionRepository.claimUnassigned",
      build: () => transactionPickerScreenBloc,
      seed: () {
        _baseState = TransactionsLoaded(transactions: _createTransactions());
        return _baseState;
      },
      act: (bloc) {
        _claimedTransaction = MockTransactionResource();
        when(() => transactionRepository.claimUnassigned(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => _claimedTransaction);
        
        bloc.add(Claim(transactionIdentifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => transactionRepository.claimUnassigned(transactionId: any(named: "transactionId"))).called(1);
      }
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Claim event on fail changes state: [TransactionsLoaded(claiming: true)], [TransactionsLoaded(claiming: false, errorMessage: error)]",
      build: () => transactionPickerScreenBloc,
      seed: () {
        _baseState = TransactionsLoaded(transactions: _createTransactions());
        return _baseState;
      },
      act: (bloc) {
        _claimedTransaction = MockTransactionResource();
        when(() => transactionRepository.claimUnassigned(transactionId: any(named: "transactionId")))
          .thenThrow(ApiException(error: "error"));
        
        bloc.add(Claim(transactionIdentifier: faker.guid.guid()));
      },
      expect: () => [(_baseState as TransactionsLoaded).update(claiming: true), (_baseState as TransactionsLoaded).update(claiming: false, errorMessage: "error")]
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Reset event changes state: [claiming: false, errorMessage: "", claimSuccess: false]",
      build: () => transactionPickerScreenBloc,
      seed: () {
        _baseState = TransactionsLoaded(transactions: _createTransactions(), claiming: true, errorMessage: "error", claimSuccess: true);
        return _baseState;
      },
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [(_baseState as TransactionsLoaded).update(claiming: false, errorMessage: "", claimSuccess: false)]
    );
  });
}