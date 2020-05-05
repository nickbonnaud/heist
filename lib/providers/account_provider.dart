import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class AccountProvider {
  final Api _api = Api();
  
  Future<ApiResponse> update({@required Map body, @required String accountIdentifier}) async {
    String url = 'account/$accountIdentifier';

    try {
      Response response = await this._api.patch(url, body);
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