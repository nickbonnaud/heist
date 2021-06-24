import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/issue_screen/widgets/cancel_issue_form/bloc/cancel_issue_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionIssueRepository extends Mock implements TransactionIssueRepository {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockTransaction extends Mock implements TransactionResource {}

void main() {
  group("Cancel Issue Form Bloc Tests", () {
    late TransactionIssueRepository issueRepository;
    late OpenTransactionsBloc openTransactionsBloc;

    late CancelIssueFormBloc cancelIssueFormBloc;

    late CancelIssueFormState _baseState;
    late TransactionResource _transaction;

    setUp(() {
      registerFallbackValue(UpdateOpenTransaction(transaction: MockTransaction()));

      issueRepository = MockTransactionIssueRepository();
      openTransactionsBloc = MockOpenTransactionsBloc();

      _transaction = MockTransaction();

      cancelIssueFormBloc = CancelIssueFormBloc(issueRepository: issueRepository, openTransactionsBloc: openTransactionsBloc, transactionResource: _transaction);
      _baseState = cancelIssueFormBloc.state;
    });

    tearDown(() {
      cancelIssueFormBloc.close();
    });

    test("Initial state of CancelIssueFormBloc is CancelIssueFormState.initial", () {
      expect(cancelIssueFormBloc.state, CancelIssueFormState.initial(transactionResource: _transaction));
    });

    blocTest<CancelIssueFormBloc, CancelIssueFormState>(
      "CancelIssueFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, transactionResource: transaction]",
      build: () => cancelIssueFormBloc,
      act: (bloc) {
        when(() => issueRepository.cancelIssue(issueId: any(named: "issueId")))
          .thenAnswer((_) async {
            _transaction = MockTransaction();
            return _transaction;
          });

        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(issueIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, transactionResource: _transaction)]
    );

    blocTest<CancelIssueFormBloc, CancelIssueFormState>(
      "CancelIssueFormBloc Submitted event calls issueRepository.cancelIssue",
      build: () => cancelIssueFormBloc,
      act: (bloc) {
        when(() => issueRepository.cancelIssue(issueId: any(named: "issueId")))
          .thenAnswer((_) async {
            _transaction = MockTransaction();
            return _transaction;
          });

        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(issueIdentifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => issueRepository.cancelIssue(issueId: any(named: "issueId"))).called(1);
      }
    );

    blocTest<CancelIssueFormBloc, CancelIssueFormState>(
      "CancelIssueFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => cancelIssueFormBloc,
      act: (bloc) {
        when(() => issueRepository.cancelIssue(issueId: any(named: "issueId")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(Submitted(issueIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<CancelIssueFormBloc, CancelIssueFormState>(
      "CancelIssueFormBloc Reset event yields state: [isSuccess: false, errorMessage: '']",
      build: () => cancelIssueFormBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error"),
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}