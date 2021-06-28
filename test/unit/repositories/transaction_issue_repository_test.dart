import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/providers/transaction_issue_provider.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionIssueProvider extends Mock implements TransactionIssueProvider {}

void main() {
  group("Transaction Issue Repository Tests", () {
    late TransactionIssueRepository transactionIssueRepository;
    late TransactionIssueProvider mockTransactionIssueProvider;
    late TransactionIssueRepository transactionIssueRepositoryWithMock;

    setUp(() {
      transactionIssueRepository = TransactionIssueRepository(issueProvider: TransactionIssueProvider());
      mockTransactionIssueProvider = MockTransactionIssueProvider();
      transactionIssueRepositoryWithMock = TransactionIssueRepository(issueProvider: mockTransactionIssueProvider);
    });

    test("Transaction Issue Repository can report an issue", () async {
      var transaction = await transactionIssueRepository.reportIssue(type: IssueType.error_in_bill, transactionId: "transactionId", message: "message");
      expect(transaction, isA<TransactionResource>());
    });

    test("Transaction Issue Repository throws error on report an issue fail", () async {
      when(() => mockTransactionIssueProvider.postIssue(body: any(named: "body")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        transactionIssueRepositoryWithMock.reportIssue(type: IssueType.error_in_bill, transactionId: "transactionId", message: "message"),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Issue Repository can change issue", () async {
      var transaction = await transactionIssueRepository.changeIssue(type: IssueType.wrong_bill, issueId: "issueId", message: "message");
      expect(transaction, isA<TransactionResource>());
    });

    test("Transaction Issue Repository throws error on change issue fail", () async {
      when(() => mockTransactionIssueProvider.patchIssue(body: any(named: "body"), issueId: any(named: "issueId")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        transactionIssueRepositoryWithMock.changeIssue(type: IssueType.wrong_bill, issueId: "issueId", message: "message"),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Issue Repository can cancel issue", () async {
      var transaction = await transactionIssueRepository.cancelIssue(issueId: "issueId");
      expect(transaction, isA<TransactionResource>());
    });

    test("Transaction Issue Repository throws error on cancel issue fail", () async {
      when(() => mockTransactionIssueProvider.deleteIssue(issueId: any(named: "issueId")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        transactionIssueRepositoryWithMock.cancelIssue(issueId: "issueId"),
        throwsA(isA<ApiException>())
      );
    });

  });
}