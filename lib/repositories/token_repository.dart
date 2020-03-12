import 'dart:convert';

import 'package:heist/models/token.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class TokenRepository {
  final StorageProvider _tokenProvider = StorageProvider();
  static const String TOKEN_KEY = 'token';

  Future<void> saveToken(Token token) async {
    return await _tokenProvider.write(TOKEN_KEY, jsonEncode(token.toJson()));
  }

  Future<void> deleteToken() async {
    return await _tokenProvider.delete(TOKEN_KEY);
  }

  Future<Token> fetchToken() async {
    return jsonDecode(await _tokenProvider.read(TOKEN_KEY));
  }

  Future<bool> hasValidToken() async {
    Token token = await fetchToken();
    return _isValidToken(token.value);
  }


  bool _isValidToken(String token) {
    int expiry = getExpiry(token);
    if (expiry == null) return false;
    int now = DateTime.now().millisecondsSinceEpoch;
    return expiry > now;
  }

  static int getExpiry(String token) {
    final parts = token.split('.');
    final payload = parts[1];
    final decoded = jsonDecode(B64urlEncRfc7515.decodeUtf8(payload));
    return decoded['exp'] ?? null;
  }
}