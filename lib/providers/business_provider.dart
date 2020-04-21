import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class BusinessProvider {
  final Api _api = Api();

  Future<ApiResponse> fetch({@required String query}) async {
    String url = 'business?$query';
    try {
      Response response = await this._api.get(url);
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