import 'package:flutter/material.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';

@immutable
class AuthenticationProvider extends BaseProvider {

  Future<ApiResponse> register({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.register;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> login({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.login;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> logout() async {
    final String url = ApiEndpoints.logout;
    return await this.get(url: url);
  }

  Future<ApiResponse> checkPassword({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.checkPassword;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> requestPasswordReset({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.requestPasswordReset;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> resetPassword({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.resetPassword;
    return await this.post(url: url, body: body);
  }
}