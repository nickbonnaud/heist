import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class TransactionIssueProvider extends BaseProvider {

  Future<ApiResponse> postIssue({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.transactionIssue;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> patchIssue({required Map<String, dynamic> body, required String issueId}) async {
    String url = '${ApiEndpoints.transactionIssue}/$issueId';
    return await patch(url: url, body: body);
  }

  Future<ApiResponse> deleteIssue({required String issueId}) async {
    String url = '${ApiEndpoints.transactionIssue}/$issueId';
    return await delete(url: url);
  }
}