import 'package:dio/dio.dart';


class ApiInterceptors extends InterceptorsWrapper {

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Response res = Response(
      requestOptions: response.requestOptions,
      data: response.data['data'] ?? response.data,
      extra: response.data['links']
    );
    return handler.resolve(res);
  }
}