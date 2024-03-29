import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/repositories/token_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageProvider extends Mock implements StorageProvider {}

void main() {
  group("Token Repository Tests", () {
    late StorageProvider storageProvider;
    late TokenRepository tokenRepository;
    late Token token;

    setUp(() {
      storageProvider = MockStorageProvider();
      tokenRepository = TokenRepository(storageProvider: storageProvider);
      token = const Token(value: "value");
    });

    test("Token Repository can save token", () async {
      when(() => storageProvider.write(key: any(named: "key"), value: any(named: "value")))
        .thenAnswer((_) async => true);
      
      await tokenRepository.saveToken(token: token);
      verify(() => storageProvider.write(key: any(named: "key"), value: any(named: "value"))).called(1);
    });

    test("Token Repository can delete token", () async {
      when(() => storageProvider.delete(key: any(named: "key")))
        .thenAnswer((_) async => true);
      
      await tokenRepository.deleteToken();
      verify(() => storageProvider.delete(key: any(named: "key"))).called(1);
    });

    test("Token Repository can fetch token", () async {
      when(() => storageProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => "token");
      
      var token = await tokenRepository.fetchToken();
      expect(token, isA<Token>());
    });

    test("Token Repository can fetch token returns null if no token present", () async {
      when(() => storageProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => null);
      
      var token = await tokenRepository.fetchToken();
      expect(token == null, true);
    });

    test("Token Repository can check if token valid", () async {
      when(() => storageProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => "token");
      
      var valid = await tokenRepository.hasValidToken();
      expect(valid, isA<bool>());
    });
  });
}