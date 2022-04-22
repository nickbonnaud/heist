import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/transaction_issue_provider.dart';

void main() {
  group("Transaction Issue Provider Tests", () {
    late TransactionIssueProvider transactionIssueProvider;

    setUp(() {
      transactionIssueProvider = const TransactionIssueProvider();
    });

    test("Posting issue returns ApiResponse", () async {
      var response = await transactionIssueProvider.postIssue(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Patching issue returns ApiResponse", () async {
      var response = await transactionIssueProvider.patchIssue(body: {}, issueId: 'issueId');
      expect(response, isA<ApiResponse>());
    });

    test("Deleting issue returns ApiResponse", () async {
      var response = await transactionIssueProvider.deleteIssue(issueId: "issueId");
      expect(response, isA<ApiResponse>());
    });
  });
}