import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/status.dart';
import 'package:heist/models/transaction/transaction.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:heist/screens/receipt_screen/widgets/widgets/pay_button/bloc/pay_button_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_data_generator.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockReceiptScreenBloc extends Mock implements ReceiptScreenBloc {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockTransactionResource extends Mock implements TransactionResource {}

void main() {
  group("Pay Button Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late ReceiptScreenBloc receiptScreenBloc;
    late OpenTransactionsBloc openTransactionsBloc;

    late MockDataGenerator _mockDataGenerator;
    late TransactionResource _transactionResource;

    late PayButtonBloc payButtonBloc;
    late PayButtonState _baseState;

    setUp(() {
      registerFallbackValue(TransactionChanged(transactionResource: MockTransactionResource()));
      registerFallbackValue(RemoveOpenTransaction(transaction: MockTransactionResource()));
      transactionRepository = MockTransactionRepository();
      receiptScreenBloc = MockReceiptScreenBloc();
      openTransactionsBloc = MockOpenTransactionsBloc();

      _mockDataGenerator = MockDataGenerator();

      _transactionResource = _mockDataGenerator.createTransactionResource();
      Transaction transaction = _transactionResource.transaction.update(status: Status(name: "name", code: 101));
      _transactionResource = _transactionResource.update(transaction: transaction);

      payButtonBloc = PayButtonBloc(transactionRepository: transactionRepository, receiptScreenBloc: receiptScreenBloc, openTransactionsBloc: openTransactionsBloc, transactionResource: _transactionResource);
      _baseState = payButtonBloc.state;
    });

    tearDown(() {
      payButtonBloc.close();
    });

    test("Initial state of PayButtonBloc is PayButtonState.initial", () {
      expect(payButtonBloc.state, PayButtonState.initial(isEnabled: true));
    });

    blocTest<PayButtonBloc, PayButtonState>(
      "PayButtonBloc TransactionStatusChanged event yields state: [isEnabled: false]",
      build: () => payButtonBloc,
      act: (bloc) {
        Transaction transaction = _transactionResource.transaction.update(status: Status(name: "name", code: 200));
        _transactionResource = _transactionResource.update(transaction: transaction);

        bloc.add(TransactionStatusChanged(transactionResource: _transactionResource));
      },
      expect: () => [_baseState.update(isEnabled: false)]
    );

    blocTest<PayButtonBloc, PayButtonState>(
      "PayButtonBloc Submitted event on return status code == 103 yields state: [isSubmitting: true], [isSubmitting: false, sSubmitSuccess: true, isEnabled: false]",
      build: () => payButtonBloc,
      act: (bloc) {
        TransactionResource transactionResource = _mockDataGenerator.createTransactionResource();
        Transaction transaction = _transactionResource.transaction.update(status: Status(name: "name", code: 103));
        transactionResource = _transactionResource.update(transaction: transaction);
        
        when(() => transactionRepository.approveTransaction(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => transactionResource);

        when(() => receiptScreenBloc.add(any(that: isA<TransactionChanged>())))
          .thenReturn(null);

        when(() => openTransactionsBloc.add(any(that: isA<RemoveOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(transactionId: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSubmitSuccess: true, isEnabled: false)]
    );

    blocTest<PayButtonBloc, PayButtonState>(
      "PayButtonBloc Submitted event on return status code != 103 yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: Oops! Something went wrong submitting payment., isEnabled: false]",
      build: () => payButtonBloc,
      act: (bloc) {
        TransactionResource transactionResource = _mockDataGenerator.createTransactionResource();
        Transaction transaction = _transactionResource.transaction.update(status: Status(name: "name", code: 500));
        transactionResource = _transactionResource.update(transaction: transaction);
        
        when(() => transactionRepository.approveTransaction(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => transactionResource);

        when(() => receiptScreenBloc.add(any(that: isA<TransactionChanged>())))
          .thenReturn(null);

        when(() => openTransactionsBloc.add(any(that: isA<RemoveOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(transactionId: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "Oops! Something went wrong submitting payment.", isEnabled: false)]
    );

    blocTest<PayButtonBloc, PayButtonState>(
      "PayButtonBloc Submitted event on return status code != 103 calls _receiptScreenBloc.add but does not call _openTransactionsBloc.add",
      build: () => payButtonBloc,
      act: (bloc) {
        TransactionResource transactionResource = _mockDataGenerator.createTransactionResource();
        Transaction transaction = _transactionResource.transaction.update(status: Status(name: "name", code: 500));
        transactionResource = _transactionResource.update(transaction: transaction);
        
        when(() => transactionRepository.approveTransaction(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => transactionResource);

        when(() => receiptScreenBloc.add(any(that: isA<TransactionChanged>())))
          .thenReturn(null);

        when(() => openTransactionsBloc.add(any(that: isA<RemoveOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(transactionId: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => receiptScreenBloc.add(any(that: isA<TransactionChanged>()))).called(1);
        verifyNever(() => openTransactionsBloc.add(any(that: isA<RemoveOpenTransaction>())));
      }
    );

    blocTest<PayButtonBloc, PayButtonState>(
      "PayButtonBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => payButtonBloc,
      act: (bloc) {
        when(() => transactionRepository.approveTransaction(transactionId: any(named: "transactionId")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(Submitted(transactionId: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<PayButtonBloc, PayButtonState>(
      "PayButtonBloc Reset event yields state: [errorMessage: '', isSubmitSuccess: false, isEnabled: bool]",
      build: () => payButtonBloc,
      act: (bloc) {
        bloc.add(Reset(transactionResource: _transactionResource));
      },
      expect: () => [_baseState.update(errorMessage: "", isSubmitSuccess: false, isEnabled: true)]
    );
  });
}