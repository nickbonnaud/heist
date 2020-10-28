import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class HelpProvider {
  final Api _api = Api();

  Future<PaginatedApiResponse> fetchHelpTickets({String query}) async {
    final String url = 'help?$query';

    try {
      Response response = await _api.get(url);
      return PaginatedApiResponse(body: response.data, error: null, isOK: true, nextPageString: response.extra['next'].toString());
    } on DioError catch (error) {
      return _formatErrorPaginated(error);
    }
  }
  
  Future<ApiResponse> storeHelpTicket({@required String subject, @required String message}) async {
    final String url = "help";
    final Map body = {
      'subject': subject,
      'message': message
    };

    try {
      Response response = await _api.post(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> storeReply({@required String identifier, @required String message}) async {
    final String url = 'help-reply';
    final Map body = {
      'ticket_identifier': identifier,
      'message': message
    };

    try {
      Response response = await _api.post(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> updateReplies({@required String ticketIdentifier, @required Map<String, dynamic> body}) async {
    final String url = 'help-reply/$ticketIdentifier';

    try {
      Response response = await _api.patch(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> deleteHelpTicket({@required String identifier}) async {
    final String url = "help/$identifier";

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

  PaginatedApiResponse _formatErrorPaginated(DioError error) {
    String errorMessage = error.response != null
      ? error.response.data
      : error.message;
    return PaginatedApiResponse(body: null, error: errorMessage, isOK: false, nextPageString: null);
  }
}