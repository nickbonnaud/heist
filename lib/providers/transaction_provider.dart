import 'package:dio/dio.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class TransactionProvider {
  final Api _api = Api();

  Future<PaginatedApiResponse> fetch({@required String query}) async {
    String url = 'transaction?$query';
    try {
      Response response = await this._api.get(url);
      int nextPage = response.extra['next'].toString() == 'null' ? null : response.data.links.next;
      return PaginatedApiResponse(body: response.data, error: null, isOK: true, nextPage: nextPage);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  PaginatedApiResponse _formatError(DioError error) {
    String errorMessage = error.response != null
      ? error.response.data
      : error.message;
    return PaginatedApiResponse(body: null, error: errorMessage, isOK: false, nextPage: null);
  }
}