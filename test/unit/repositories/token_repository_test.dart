import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/repositories/token_repository.dart';

class MockStorageProvider extends Mock implements StorageProvider {}

void main() {
  group("Token Repository Tests", () {
    late StorageProvider tokenProvider;
    late TokenRepository tokenRepository;
    late Token token;

    setUp(() {
      tokenProvider = MockStorageProvider();
      tokenRepository = TokenRepository(tokenProvider: tokenProvider);
      token = Token(value: "value");
    });

    test("Token Repository can save token", () async {
      when(() => tokenProvider.write(key: any(named: "key"), value: any(named: "value")))
        .thenAnswer((_) async => null);
      
      await tokenRepository.saveToken(token: token);
      verify(() => tokenProvider.write(key: any(named: "key"), value: any(named: "value"))).called(1);
    });

    test("Token Repository can delete token", () async {
      when(() => tokenProvider.delete(key: any(named: "key")))
        .thenAnswer((_) async => null);
      
      await tokenRepository.deleteToken();
      verify(() => tokenProvider.delete(key: any(named: "key"))).called(1);
    });

    test("Token Repository can fetch token", () async {
      when(() => tokenProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => "token");
      
      var token = await tokenRepository.fetchToken();
      expect(token, isA<Token>());
    });

    test("Token Repository can fetch token returns null if no token present", () async {
      when(() => tokenProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => null);
      
      var token = await tokenRepository.fetchToken();
      expect(token == null, true);
    });

    test("Token Repository can check if token valid", () async {
      when(() => tokenProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => "token");
      
      var valid = await tokenRepository.hasValidToken();
      expect(valid, isA<bool>());
    });
  });
}