import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:meta/meta.dart';

@immutable
class TransactionIssueProvider extends BaseProvider {

  Future<ApiResponse> postIssue({required Map<String, dynamic> body}) async {
    final String url = 'transaction-issue';
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> patchIssue({required Map<String, dynamic> body, required String issueId}) async {
    final String url = 'transaction-issue/$issueId';
    return await this.patch(url: url, body: body);
  }

  Future<ApiResponse> deleteIssue({required String issueId}) async {
    final String url = 'transaction-issue/$issueId';
    return await this.delete(url: url);
  }
}