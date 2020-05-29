import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class TransactionProvider {
  final Api _api = Api();

  Future<PaginatedApiResponse> fetch({@required String query}) async {
    final String url = 'transaction?$query';
    try {
      Response response = await _api.get(url);
      return PaginatedApiResponse(body: response.data, error: null, isOK: true, nextPageString: response.extra['next'].toString());
    } on DioError catch (error) {
      return _formatErrorPaginated(error);
    }
  }

  Future<ApiResponse> fetchUnassigned({@required String buinessIdentifier}) async {
    final String url = 'unassigned-transaction?business_id=$buinessIdentifier';
    try {
      Response response = await _api.get(url);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> patchUnassigned({@required String transactionId}) async {
    final String url = 'unassigned-transaction/$transactionId';
    try {
      Response response = await _api.patch(url, {});
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> patchStatus({@required String transactionId, @required int statusCode}) async {
    final String url = 'transaction/$transactionId';
    final Map body = {
      'status_code': statusCode
    };
    
    try {
      Response response = await _api.patch(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  PaginatedApiResponse _formatErrorPaginated(DioError error) {
    String errorMessage = error.response != null
      ? error.response.data
      : error.message;
    return PaginatedApiResponse(body: null, error: errorMessage, isOK: false, nextPageString: null);
  }

  ApiResponse _formatError(DioError error) {
    String errorMessage = error.response != null
      ? error.response.data
      : error.message;

    return ApiResponse(body: null, error: errorMessage, isOK: false);
  }
}