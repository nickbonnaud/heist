import 'package:dio/dio.dart';
import 'package:heist/resources/http/mock_responses.dart';
import 'package:meta/meta.dart';

class ApiInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  ApiInterceptors({@required Dio dio})
    : assert(dio != null),
      _dio = dio;

  @override
  Future onRequest(RequestOptions options) {
    return new Future.delayed(Duration(seconds: 2), () => _dio.resolve(MockResponses.mockResponse(options)));
    // return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    response.data = response.data['data'] ?? response.data;
    return super.onResponse(response);
  }

  @override
  Future onError(DioError error) {
    return super.onError(_formatError(error));
  }


  DioError _formatError(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        error.response.data = "Request to server was cancelled.";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        error.response.data = "Connection timeout with server.";
        break;
      case DioErrorType.DEFAULT:
        error.response.data = "Connection to server failed due to internet connection.";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        error.response.data = "Receive timeout in connection with server";
        break;
      case DioErrorType.RESPONSE:
        error.response.data = "Received invalid status code: ${error.response.statusCode}.";
        break;
      case DioErrorType.SEND_TIMEOUT:
        error.response.data = "Send timeout in connection with server";
        break;
    }
    return error;
  }
}