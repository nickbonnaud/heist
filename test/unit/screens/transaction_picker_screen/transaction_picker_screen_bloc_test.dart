import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/transaction_picker_screen/bloc/transaction_picker_screen_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockUnassignedTransactionResource extends Mock implements UnassignedTransactionResource {}
class MockTransactionResource extends Mock implements TransactionResource {}
class MockActiveLocationBloc extends Mock implements ActiveLocationBloc {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}

void main() {
  group("Transaction Picker Screen Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late ActiveLocationBloc activeLocationBloc;
    late OpenTransactionsBloc openTransactionsBloc;

    late TransactionPickerScreenBloc transactionPickerScreenBloc;

    late TransactionPickerScreenState _baseState;
    late TransactionResource _claimedTransaction;
    late List<UnassignedTransactionResource> _unclaimedTransactions;

    setUp(() {
      registerFallbackValue(TransactionAdded(business: MockDataGenerator().createBusiness(), transactionIdentifier: faker.guid.guid()));
      registerFallbackValue(AddOpenTransaction(transaction: MockTransactionResource()));

      transactionRepository = MockTransactionRepository();
      activeLocationBloc = MockActiveLocationBloc();
      openTransactionsBloc = MockOpenTransactionsBloc();

      when(() => activeLocationBloc.add(any(that: isA<TransactionAdded>())))
        .thenReturn(null);

      when(() => openTransactionsBloc.add(any(that: isA<AddOpenTransaction>())))
        .thenReturn(null);
      
      transactionPickerScreenBloc = TransactionPickerScreenBloc(
        transactionRepository: transactionRepository,
        activeLocationBloc: activeLocationBloc,
        openTransactionsBloc: openTransactionsBloc
      );
      _baseState = transactionPickerScreenBloc.state;
    });

    tearDown(() {
      transactionPickerScreenBloc.close();
    });

    List<UnassignedTransactionResource> _createTransactions() {
      return List<UnassignedTransactionResource>.generate(5, (_) => MockDataGenerator().createUnassignedTransaction());
    }
    
    test("Initial state of TransactionPickerScreenBloc is Uninitialized()", () {
      expect(transactionPickerScreenBloc.state, TransactionPickerScreenState.initial());
    });

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Fetch event changes state: [loading: true], [loading: false, transactions: transactions]",
      build: () => transactionPickerScreenBloc,
      act: (bloc) {
        _unclaimedTransactions = _createTransactions();
        when(() => transactionRepository.fetchUnassigned(businessIdentifier: any(named: "businessIdentifier")))
          .thenAnswer((_) async => _unclaimedTransactions);
        
        bloc.add(Fetch(businessIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(loading: true), _baseState.update(loading: false, transactions: _unclaimedTransactions)]
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
      "TransactionPickerScreenBloc Fetch event on fail changes state: [loading: true], [loading: false, errorMessage: error]",
      build: () => transactionPickerScreenBloc,
      act: (bloc) {
        when(() => transactionRepository.fetchUnassigned(businessIdentifier: any(named: "businessIdentifier")))
          .thenThrow(const ApiException(error: "error"));
        
        bloc.add(Fetch(businessIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(loading: true), _baseState.update(loading: false, errorMessage: "error")]
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Claim event changes state: [claiming: true], [claiming: false, claimSuccess: true, transaction: transaction]",
      build: () => transactionPickerScreenBloc,
      seed: () {
        _unclaimedTransactions = _createTransactions();
        _baseState = _baseState.update(transactions: _unclaimedTransactions);
        return _baseState;
      },
      act: (bloc) {
        _claimedTransaction = MockDataGenerator().createTransactionResource();
        when(() => transactionRepository.claimUnassigned(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => _claimedTransaction);
        
        bloc.add(Claim(unassignedTransaction: _unclaimedTransactions.first));
      },
      expect: () => [_baseState.update(claiming: true), _baseState.update(claiming: false, claimSuccess: true, transaction: _claimedTransaction)]
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Claim event calls transactionRepository.claimUnassigned, activeLocationBloc.add, openTransactionsBloc.add",
      build: () => transactionPickerScreenBloc,
      seed: () {
        _unclaimedTransactions = _createTransactions();
        _baseState = _baseState.update(transactions: _unclaimedTransactions);
        return _baseState;
      },
      act: (bloc) {
        _claimedTransaction = MockDataGenerator().createTransactionResource();
        when(() => transactionRepository.claimUnassigned(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => _claimedTransaction);
        
        bloc.add(Claim(unassignedTransaction: _unclaimedTransactions.first));
      },
      verify: (_) {
        verify(() => transactionRepository.claimUnassigned(transactionId: any(named: "transactionId"))).called(1);
        verify(() => activeLocationBloc.add(any(that: isA<TransactionAdded>()))).called(1);
        verify(() => openTransactionsBloc.add(any(that: isA<AddOpenTransaction>()))).called(1);
      }
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Claim event on fail changes state: [claiming: true], [claiming: false, errorMessage: error]",
      build: () => transactionPickerScreenBloc,
      seed: () {
        _unclaimedTransactions = _createTransactions();
        _baseState = _baseState.update(transactions: _unclaimedTransactions);
        return _baseState;
      },
      act: (bloc) {
        when(() => transactionRepository.claimUnassigned(transactionId: any(named: "transactionId")))
          .thenThrow(const ApiException(error: "error"));
        
        bloc.add(Claim(unassignedTransaction: _unclaimedTransactions.first));
      },
      expect: () => [_baseState.update(claiming: true), _baseState.update(claiming: false, errorMessage: "error")]
    );

    blocTest<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      "TransactionPickerScreenBloc Reset event changes state: [claiming: false, errorMessage: "", claimSuccess: false]",
      build: () => transactionPickerScreenBloc,
      seed: () {
        _baseState = _baseState.update(transactions: _createTransactions(), claiming: true, errorMessage: "error", claimSuccess: true);
        return _baseState;
      },
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(claiming: false, errorMessage: "", claimSuccess: false)]
    );
  });
}