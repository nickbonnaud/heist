import 'package:heist/models/api_response.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/providers/transaction_issue_provider.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:meta/meta.dart';

class TransactionIssueRepository {
  final TransactionIssueProvider _issueProvider = TransactionIssueProvider();

  Future<TransactionResource> reportIssue({@required IssueType type, @required String transactionId, @required String message}) async {
    final ApiResponse response = await _issueProvider.postIssue(type: type, transactionId: transactionId, message: message);
    if (response.isOK) {
      return TransactionResource.fromJson(response.body);
    }
    return TransactionResource.withError(response.error);
  }

  Future<TransactionResource> changeIssue({@required IssueType type, @required String issueId, @required String message}) async {
    final ApiResponse response = await _issueProvider.patchIssue(type: type, issueId: issueId, message: message);
    if (response.isOK) {
      return TransactionResource.fromJson(response.body);
    }
    return TransactionResource.withError(response.error);
  }

  Future<TransactionResource> cancelIssue({@required String issueId}) async {
    final ApiResponse response = await _issueProvider.deleteIssue(issueId: issueId);
    if (response.isOK) {
      return TransactionResource.fromJson(response.body);
    }
    return TransactionResource.withError(response.error);
  }
}