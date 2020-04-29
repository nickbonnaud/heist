import 'package:dio/dio.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class RefundProvider {
  final Api _api = Api();

  Future<PaginatedApiResponse> fetch({@required String query}) async {
    String url = 'refund?$query';
    try {
      Response response = await this._api.get(url);
      return PaginatedApiResponse(body: response.data, error: null, isOK: true, nextPageString: response.extra['next'].toString());
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  PaginatedApiResponse _formatError(DioError error) {
    String errorMessage = error.response != null
      ? error.response.data
      : error.message;
    return PaginatedApiResponse(body: null, error: errorMessage, isOK: false, nextPageString: null);
  }
}