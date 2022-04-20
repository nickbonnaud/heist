import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:heist/screens/receipt_screen/widgets/widgets/keep_open_button/bloc/keep_open_button_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockReceiptScreenBloc extends Mock implements ReceiptScreenBloc {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockTransactionResource extends Mock implements TransactionResource {}

void main() {
  group("Keep Open Button Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late ReceiptScreenBloc receiptScreenBloc;
    late OpenTransactionsBloc openTransactionsBloc;

    late KeepOpenButtonBloc keepOpenButtonBloc;
    late KeepOpenButtonState _baseState;

    setUp(() {
      registerFallbackValue(TransactionChanged(transactionResource: MockTransactionResource()));
      registerFallbackValue(UpdateOpenTransaction(transaction: MockTransactionResource()));
      transactionRepository = MockTransactionRepository();
      receiptScreenBloc = MockReceiptScreenBloc();
      openTransactionsBloc = MockOpenTransactionsBloc();

      keepOpenButtonBloc = KeepOpenButtonBloc(transactionRepository: transactionRepository, receiptScreenBloc: receiptScreenBloc, openTransactionsBloc: openTransactionsBloc);
      _baseState = keepOpenButtonBloc.state;
    });

    tearDown(() {
      keepOpenButtonBloc.close();
    });

    test("Initial state of KeepOpenButtonBloc is KeepOpenButtonState.initial()", () {
      expect(keepOpenButtonBloc.state, KeepOpenButtonState.initial());
    });

    blocTest<KeepOpenButtonBloc, KeepOpenButtonState>(
      "KeepOpenButtonBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSubmitSuccess: true]",
      build: () => keepOpenButtonBloc,
      act: (bloc) {
        when(() => transactionRepository.keepBillOpen(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => MockTransactionResource());

        when(() => receiptScreenBloc.add(any(that: isA<TransactionChanged>())))
          .thenReturn(null);

        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(transactionId: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSubmitSuccess: true)]
    );

    blocTest<KeepOpenButtonBloc, KeepOpenButtonState>(
      "KeepOpenButtonBloc Submitted event calls transactionRepository.keepBillOpen && receiptScreenBloc.add && openTransactionsBloc.add",
      build: () => keepOpenButtonBloc,
      act: (bloc) {
        when(() => transactionRepository.keepBillOpen(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => MockTransactionResource());

        when(() => receiptScreenBloc.add(any(that: isA<TransactionChanged>())))
          .thenReturn(null);

        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(transactionId: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => transactionRepository.keepBillOpen(transactionId: any(named: "transactionId"))).called(1);
        verify(() => receiptScreenBloc.add(any(that: isA<TransactionChanged>()))).called(1);
        verify(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>()))).called(1);
      }
    );

    blocTest<KeepOpenButtonBloc, KeepOpenButtonState>(
      "KeepOpenButtonBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => keepOpenButtonBloc,
      act: (bloc) {
        when(() => transactionRepository.keepBillOpen(transactionId: any(named: "transactionId")))
          .thenThrow(const ApiException(error: "error"));

        bloc.add(Submitted(transactionId: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<KeepOpenButtonBloc, KeepOpenButtonState>(
      "KeepOpenButtonBloc Reset event yields state: [isSubmitting: false, isSubmitSuccess: false, errorMessage: '']",
      build: () => keepOpenButtonBloc,
      seed: () => _baseState.update(isSubmitting: true, isSubmitSuccess: false, errorMessage: "error"),
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSubmitting: false, isSubmitSuccess: false, errorMessage: "")]
    );
  });
}