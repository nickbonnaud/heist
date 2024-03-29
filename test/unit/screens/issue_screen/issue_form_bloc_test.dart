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

import '../../../helpers/mock_data_generator.dart';

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

    late IssueType issueType;
    late String message;

    setUp(() {
      registerFallbackValue(UpdateOpenTransaction(transaction: MockTransaction()));
      registerFallbackValue(IssueType.errorInBill);

      issueRepository = MockTransactionIssueRepository();
      openTransactionsBloc = MockOpenTransactionsBloc();

      _transaction = MockDataGenerator().createTransactionResource();
      issueType = IssueType.errorInBill;

      issueFormBloc = IssueFormBloc(issueType: issueType, issueRepository: issueRepository, openTransactionsBloc: openTransactionsBloc, transactionResource: _transaction);
      _baseState = issueFormBloc.state;
    });

    tearDown(() {
      issueFormBloc.close();
    });

    test("Initial state of IssueFormBloc is IssueFormState.initial", () {
      expect(issueFormBloc.state, IssueFormState.initial(issueType: issueType, transactionResource: _transaction));
    });

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc MessageChanged event yields state: [isMessageValid: true]",
      build: () => issueFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        message = faker.lorem.sentence();
        bloc.add(MessageChanged(message: message));
      },
      expect: () => [_baseState.update(message: message, isMessageValid: true)]
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, transactionResource: transaction]",
      build: () => issueFormBloc,
      seed: () {
        message = faker.lorem.sentence();
        _baseState = _baseState.update(message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => issueRepository.reportIssue(type: any(named: "type"), transactionId: any(named: "transactionId"), message: any(named: "message")))
          .thenAnswer((_) async {
            _transaction = MockTransaction();
            return _transaction;
          });
        
        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, transactionResource: _transaction)]
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Submitted event calls issueRepository.reportIssue",
      build: () => issueFormBloc,
      seed: () {
        message = faker.lorem.sentence();
        _baseState = _baseState.update(message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => issueRepository.reportIssue(type: any(named: "type"), transactionId: any(named: "transactionId"), message: any(named: "message")))
          .thenAnswer((_) async {
            _transaction = MockTransaction();
            return _transaction;
          });
        
        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => issueRepository.reportIssue(type: any(named: "type"), transactionId: any(named: "transactionId"), message: any(named: "message"))).called(1);
      }
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Submitted event on error yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => issueFormBloc,
      seed: () {
        message = faker.lorem.sentence();
        _baseState = _baseState.update(message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => issueRepository.reportIssue(type: any(named: "type"), transactionId: any(named: "transactionId"), message: any(named: "message")))
          .thenThrow(const ApiException(error: "error"));

        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Updated event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, transactionResource: transaction]",
      build: () => issueFormBloc,
      seed: () {
        message = faker.lorem.sentence();
        _baseState = _baseState.update(message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => issueRepository.changeIssue(type: any(named: "type"), issueId: any(named: "issueId"), message: any(named: "message")))
          .thenAnswer((_) async {
            _transaction = MockTransaction();
            return _transaction;
          });
        
        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Updated());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, transactionResource: _transaction)]
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Updated event calls issueRepository.changeIssue",
      build: () => issueFormBloc,
      seed: () {
        message = faker.lorem.sentence();
        _baseState = _baseState.update(message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => issueRepository.changeIssue(type: any(named: "type"), issueId: any(named: "issueId"), message: any(named: "message")))
          .thenAnswer((_) async {
            _transaction = MockTransaction();
            return _transaction;
          });
        
        when(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>())))
          .thenReturn(null);

        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => issueRepository.changeIssue(type: any(named: "type"), issueId: any(named: "issueId"), message: any(named: "message"))).called(1);
      }
    );

    blocTest<IssueFormBloc, IssueFormState>(
      "IssueFormBloc Updated event on error yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => issueFormBloc,
      seed: () {
        message = faker.lorem.sentence();
        _baseState = _baseState.update(message: message);
        return _baseState;
      },
      act: (bloc) {
        when(() => issueRepository.changeIssue(type: any(named: "type"), issueId: any(named: "issueId"), message: any(named: "message")))
          .thenThrow(const ApiException(error: "error"));

        bloc.add(Updated());
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