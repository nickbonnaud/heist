import 'package:flutter/material.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';

@immutable
class AuthenticationProvider extends BaseProvider {

  Future<ApiResponse> register({required Map<String, dynamic> body}) async {
    final String url = "auth/register";
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> login({required Map<String, dynamic> body}) async {
    final String url = "auth/login";
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> logout() async {
    final String url = "auth/logout";
    return await this.get(url: url);
  }

  Future<ApiResponse> checkPassword({required Map<String, dynamic> body}) async {
    final String url = "auth/password-check";
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> requestPasswordReset({required Map<String, dynamic> body}) async {
    final String url = "auth/request-reset";
    return await this.post(url: url, body: body);
  }
}