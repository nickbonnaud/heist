import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/resources/helpers/invalid_token_exception.dart';

@immutable
class TokenRepository {
  final StorageProvider _tokenProvider;
  static const String tokenKey = 'token';

  const TokenRepository({required StorageProvider tokenProvider})
    : _tokenProvider = tokenProvider;
  
  Future<void> saveToken({required Token token}) async {
    return await _tokenProvider.write(key: tokenKey, value: jsonEncode(token.value));
  }

  Future<void> deleteToken() async {
    return await _tokenProvider.delete(key: tokenKey);
  }

  Future<Token?> fetchToken() async {
    String? value = await _tokenProvider.read(key: tokenKey);
    return value != null ? Token(value: value) : null; 
  }

  Future<bool> hasValidToken() async {
    Token? token = await fetchToken();
    if (token == null) return false;
    
    try {
      return token.valid;
    } on InvalidTokenException catch (_) {
      return false;
    } 
  }
}