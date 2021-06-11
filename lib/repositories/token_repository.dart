import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/resources/helpers/invalid_token_exception.dart';

@immutable
class TokenRepository {
  final StorageProvider _tokenProvider;
  static const String TOKEN_KEY = 'token';

  TokenRepository({required StorageProvider tokenProvider})
    : _tokenProvider = tokenProvider;
  
  Future<void> saveToken({required Token token}) async {
    return await _tokenProvider.write(key: TOKEN_KEY, value: jsonEncode(token.value));
  }

  Future<void> deleteToken() async {
    return await _tokenProvider.delete(key: TOKEN_KEY);
  }

  Future<Token?> fetchToken() async {
    final String? value = await _tokenProvider.read(key: TOKEN_KEY);
    return value != null ? Token(value: value) : null; 
  }

  Future<bool> hasValidToken() async {
    final Token? token = await fetchToken();
    if (token == null) return false;
    
    try {
      return token.valid;
    } on InvalidTokenException catch (_) {
      return false;
    } 
  }
}