import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class ActiveLocationProvider {
  final Api _api = Api();

  Future<ApiResponse> enterBusiness({@required String beaconIdentifier}) async {
    String url = "location";
    Map body = {
      'beacon_identifier': beaconIdentifier
    };

    try {
      Response response = await this._api.post(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error); 
    }
  }

  Future<ApiResponse> exitBusiness({@required String activeLocationId}) async {
    String url = "location/$activeLocationId";

    try {
      Response response = await this._api.delete(url);
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