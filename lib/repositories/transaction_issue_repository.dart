import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/issue.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/providers/transaction_issue_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:meta/meta.dart';

@immutable
class TransactionIssueRepository extends BaseRepository {
  final TransactionIssueProvider _issueProvider;

  TransactionIssueRepository({required TransactionIssueProvider issueProvider})
    : _issueProvider = issueProvider;

  Future<TransactionResource> reportIssue({required IssueType type, required String transactionId, required String message}) async {
    Map<String, dynamic> body = {
      'transaction_identifier': transactionId,
      'type': Issue.enumToString(type: type),
      'issue': message
    };

    Map<String, dynamic> json = await send(request: _issueProvider.postIssue(body: body));
    return deserialize(json: json);
  }

  Future<TransactionResource> changeIssue({required IssueType type, required String issueId, required String message}) async {
    Map<String, dynamic> body = {
      'type': Issue.enumToString(type: type),
      'issue': message
    };

    Map<String, dynamic> json = await send(request: _issueProvider.patchIssue(body: body, issueId: issueId));
    return deserialize(json: json);
  }

  Future<TransactionResource> cancelIssue({required String issueId}) async {
    Map<String, dynamic> json = await send(request: _issueProvider.deleteIssue(issueId: issueId));
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return TransactionResource.fromJson(json: json!);
  }
}