import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class LocationProvider {
  final Api _api = Api();

  Future<ApiResponse> sendLocation({@required double lat, @required double lng, @required bool startLocation}) async {
    String url = "geo-location";

    Map body = {
      "lat": lat,
      "lng": lng,
      "start_location": startLocation
    };

    try {
      Response response = await this._api.post(url, body);
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