import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/transaction/issue.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/http/api.dart';
import 'package:heist/screens/issue_screen/bloc/issue_form_bloc.dart';
import 'package:meta/meta.dart';

class TransactionIssueProvider {
  final Api _api = Api();

  Future<ApiResponse> postIssue({@required IssueType type, @required String transactionId, @required String message}) async {
    final String url = 'transaction-issue';

    Map<String, dynamic> body = {
      'transaction_identifier': transactionId,
      'type': Issue.enumToString(type),
      'issue': message
    };

    try {
      Response response = await _api.post(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> patchIssue({@required IssueType type, @required String issueId, @required String message}) async {
    final String url = 'transaction-issue/$issueId';

    Map<String, dynamic> body = {
      'type': type.toString(),
      'issue': message
    };

    try {
      Response response = await _api.patch(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> deleteIssue({@required String issueId}) async {
    final String url = 'transaction-issue/$issueId';

    try {
      Response response = await _api.delete(url);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  ApiResponse _formatError(DioError error) {
    String errorMessage = error.response != null
      ? error.response.data
      : error.message;

    return ApiResponse(body: null, error: errorMessage, isOK: false);
  }
}