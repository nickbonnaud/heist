import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:heist/resources/http/test_api_interceptors.dart';

@immutable
class BaseProvider {
  final String _baseUrl = ApiEndpoints.base;
  final Dio? _dio;

  const BaseProvider({Dio? dio})
    : _dio = dio;

  Dio _initDio() {
    if (_dio != null) return _dio!;

    Dio dio = Dio();
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    // TODO
    // For testing purposes only
    dio.interceptors.add(TestApiInterceptors());
    // dio.interceptors.add(ApiInterceptors());
    
    return dio;
  }

  Future<ApiResponse> get({required String url}) async {
    Dio dio = _initDio();

    try {
      Response response = await dio.get('$_baseUrl/$url');
      return _formatSuccess(response: response);
    } on DioError catch (error) {
      return _formatError(error: error);
    }

  }
  
  Future<PaginatedApiResponse> getPaginated({required String url}) async {
    Dio dio = _initDio();
    
    final String fullUrl = url.contains(_baseUrl) ? url : '$_baseUrl/$url';
    try {      
      Response response = await dio.get(fullUrl);
      return _formatSuccessPaginated(response: response);
    } on DioError catch (error) {
      return _formatErrorPaginated(error: error);
    }
  }

  Future<ApiResponse> post({required String url, required Map<String, dynamic> body}) async {
    Dio dio = _initDio();

    try {
      final Response response = await dio.post('$_baseUrl/$url', data: body);
      return _formatSuccess(response: response);
    } on DioError catch (error) {
      return _formatError(error: error);
    }
  }

  Future<PaginatedApiResponse> postPaginated({required String url, required Map<String, dynamic> body}) async {
    Dio dio = _initDio();

    try {
      final Response response = await dio.post('$_baseUrl/$url', data: body);
      return _formatSuccessPaginated(response: response);
    } on DioError catch (error) {
      return _formatErrorPaginated(error: error);
    }
  }

  Future<ApiResponse> patch({required String url, required Map<String, dynamic> body}) async {
    Dio dio = _initDio();
    
    try {
      final Response response = await dio.patch('$_baseUrl/$url', data: body);
      return _formatSuccess(response: response);
    } on DioError catch (error) {
      return _formatError(error: error);
    }
  }

  Future<ApiResponse> delete({required String url}) async {
    Dio dio = _initDio();
    
    try {
      final Response response = await dio.delete('$_baseUrl/$url');
      return _formatSuccess(response: response);
    } on DioError catch (error) {
      return _formatError(error: error);
    }
  }

  ApiResponse _formatSuccess({required Response response}) {
    return ApiResponse(body: response.data, error: "", isOK: true); 
  }

  PaginatedApiResponse _formatSuccessPaginated({required Response response}) {
    var data = response.data;
    if (data is !List<Map<String, dynamic>>) {
      data = (response.data as List).map((entry) => entry as Map<String, dynamic>).toList();
    }
    return PaginatedApiResponse(body: data, error: "", isOK: true, next: response.extra['next']);
  }

  ApiResponse _formatError({required DioError error}) {
    String errorMessage = error.response?.data ?? error.message;
    
    return ApiResponse(body: const {}, error: errorMessage, isOK: false);
  }
  
  PaginatedApiResponse _formatErrorPaginated({required DioError error}) {
    String errorMessage = error.response?.data ?? error.message;
    return PaginatedApiResponse(body: const [], error: errorMessage, isOK: false, next: null);
  }
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

_parseAndDecode(String response) {
    return jsonDecode(response);
}