import 'package:flutter/material.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';

@immutable
class PhotoProvider extends BaseProvider {

  Future<ApiResponse> upload({required Map<String, dynamic> body, required String profileIdentifier}) async {
    String url = 'avatar/$profileIdentifier';
    return await this.post(url: url, body: body);
  }
}