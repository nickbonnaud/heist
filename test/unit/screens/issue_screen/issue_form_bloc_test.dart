import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/issue_screen/bloc/issue_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionIssueRepository extends Mock implements TransactionIssueRepository {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockTransaction extends Mock implements TransactionResource {}

void main() {
  group("Issue Form Bloc Tests", () {
    late TransactionIssueRepository issueRepository;
    late OpenTransactionsBloc openTransactionsBloc;

    late IssueFormBloc issueFormBloc;

    late IssueFormState _baseState;
    late TransactionResource _transaction;

    setUp(() {
      registerFallbackValue(UpdateOpenTransaction(transaction: MockTransaction()));
      registerFallbackValue(IssueType.error_in_bill);

      issueRepository = MockTransactionIssueRepository();
      openTransactionsBloc = MockOpenTransactionsBloc();

      _transaction = MockTransaction();

      issueFormBloc = IssueFormBloc(issueRepository: issueRepository, openTransactionsBloc: openTransactionsBloc, transactionResource: _transaction);
      _baseState = issueFormBloc.state;
    });

    tearDown(() {
      issueFormBloc.close();
    });

    test("Initial state of IssueFormBloc is IssueFormState.initial", () {
      expect(issueFormBloc.state, IssueFormState.initial(transactionResource: _transaction));
    });

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc MessageChanged event yields state: [isMessageValid: true]",
      build: () => issueFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(MessageChanged(message: faker.lorem.sentence())),
      expect: () => [_baseState.update(isMessageValid: true)]
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, transactionResource: transaction]",
      build: () => issueFormBloc,
      act: (bloc) {
        when(() => issueRepository.reportIssue(type: any(named: "type"), transactionId: any(named: "transactionId"), message: any(named: "message")))
          .thenAnswer((_) async {
            _transaction = MockTransaction();
            return _transaction;
          });
        
        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(message: faker.lorem.sentence(), type: IssueType.error_in_bill, transactionIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, transactionResource: _transaction)]
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Submitted event calls issueRepository.reportIssue",
      build: () => issueFormBloc,
      act: (bloc) {
        when(() => issueRepository.reportIssue(type: any(named: "type"), transactionId: any(named: "transactionId"), message: any(named: "message")))
          .thenAnswer((_) async {
            _transaction = MockTransaction();
            return _transaction;
          });
        
        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted(message: faker.lorem.sentence(), type: IssueType.error_in_bill, transactionIdentifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => issueRepository.reportIssue(type: any(named: "type"), transactionId: any(named: "transactionId"), message: any(named: "message"))).called(1);
      }
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Submitted event on error yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => issueFormBloc,
      act: (bloc) {
        when(() => issueRepository.reportIssue(type: any(named: "type"), transactionId: any(named: "transactionId"), message: any(named: "message")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(Submitted(message: faker.lorem.sentence(), type: IssueType.error_in_bill, transactionIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Reset event yields state: [isSuccess: false, errorMessage: ""]",
      build: () => issueFormBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: faker.lorem.sentence()),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}