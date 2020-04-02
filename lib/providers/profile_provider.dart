import 'dart:io';

import 'package:dio/dio.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/resources/http/api.dart';
import 'package:meta/meta.dart';

class ProfileProvider {
  final Api _api = Api();

  Future<ApiResponse> store({@required String firstName, @required String lastName}) async {
    String url = 'profile';
    Map body = {
      'first_name': firstName,
      'last_name': lastName
    };

    try {
      Response response = await this._api.post(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> update({@required String firstName, @required String lastName, @required String profileIdentifier}) async {
    String url = 'profile/$profileIdentifier';
    Map body = {
      'first_name': firstName,
      'last_name': lastName
    };

    try {
      Response response = await this._api.patch(url, body);
      return ApiResponse(body: response.data, error: null, isOK: true);
    } on DioError catch (error) {
      return _formatError(error);
    }
  }

  Future<ApiResponse> uploadPhoto({@required File photo, @required String profileIdentifier}) async {
    String url = 'avatar/$profileIdentifier';
    Map body = {
      'avatar': photo
    };

    try {
      Response response = await this._api.post(url, body);
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