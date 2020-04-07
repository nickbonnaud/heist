import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class CustomerProvider {
  final Api _api = Api();

  Future<ApiResponse> register({@required String email, @required String password, @required String passwordConfirmation}) async {
    String url = "auth/register";
    Map data = {
      "email": email,
      "password": password,
      'passwordConfirmation': passwordConfirmation
    };
    try {
      Response response = await this._api.post(url, data);
      return ApiResponse(body: response.data['customer'], error: null, isOK: true);
    } on DioError catch(error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> login({@required String email, @required String password}) async {
    String url = "auth/login";
    Map data = {
      "email": email,
      "password": password
    };
    try {
      Response response = await this._api.post(url, data);
      return ApiResponse(body: response.data['customer'], error: null, isOK: true);
    } on DioError catch(error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> logout() async {
    String url = "auth/logout";
    try {
      await this._api.get(url);
      return ApiResponse(body: null, error: null, isOK: true);
    } on DioError catch(error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> requestPassword({@required String email}) async {
    String url = "auth/request-reset";
    Map data = {"email": email};

    try {
      Response response = await this._api.post(url, data);
      return ApiResponse(body: response.data['email_sent'], error: null, isOK: true);
    } on DioError catch(error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> checkPassword({@required String password}) async {
    String url = "auth/password-check";
    Map data = {"password": password};

    try {
      Response response = await this._api.post(url, data);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> getCustomer() async {
    String url = 'me';
    try {
      Response response = await this._api.get(url);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch(error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> updateEmail(String email, String customerId) async {
    String url = 'me/$customerId';
    Map body = {
      'email': email
    };
    try {
      Response response = await this._api.patch(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> updatePassword(String oldPassword, String password, String passwordConfirmation, String customerId) async {
    String url = 'me/$customerId';
    Map body = {
      'old_password': oldPassword,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    try {
      Response response = await this._api.patch(url, body);
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