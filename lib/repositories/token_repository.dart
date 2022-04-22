import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/resources/helpers/invalid_token_exception.dart';

@immutable
class TokenRepository {
  static const String tokenKey = 'token';
  final StorageProvider? _storageProvider;

  const TokenRepository({StorageProvider? storageProvider})
    : _storageProvider = storageProvider;
  
  Future<void> saveToken({required Token token}) async {
    StorageProvider storageProvider = _getStorageProvider();
    return await storageProvider.write(key: tokenKey, value: jsonEncode(token.value));
  }

  Future<void> deleteToken() async {
    StorageProvider storageProvider = _getStorageProvider();
    return await storageProvider.delete(key: tokenKey);
  }

  Future<Token?> fetchToken() async {
    StorageProvider storageProvider = _getStorageProvider();

    String? value = await storageProvider.read(key: tokenKey);
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

  StorageProvider _getStorageProvider() {
    return _storageProvider ?? const StorageProvider();
  }
}