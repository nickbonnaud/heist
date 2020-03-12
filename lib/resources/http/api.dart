import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:heist/resources/http/api_interceptors.dart';

class Api {
  final Dio _dio = Dio();
  final String baseUrl = 'http://pockeyt.local/api/customer';

  Api() {
    _dio.interceptors.add(ApiInterceptors(dio: _dio));
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  }

  Future get(String url) async {
    return await _dio.get('$baseUrl/$url');
  }

  Future post(String url, Map body) async {
    return await _dio.post('$baseUrl/$url', data: body);
  }

  Future patch(String url, FormData body) async {
    return await _dio.patch('$baseUrl/$url', data: body);
  }

  Future delete(String url) async {
    return await _dio.delete('$baseUrl/$url');
  }
}

_parseAndDecode(String response) {
    return jsonDecode(response);
  }

parseJson(String text) {
  return compute(_parseAndDecode, text);
}