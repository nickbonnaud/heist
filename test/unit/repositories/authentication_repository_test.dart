import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/authentication_provider.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/token_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationProvider extends Mock implements AuthenticationProvider {}
class MockTokenRepository extends Mock implements TokenRepository {}
class MockToken extends Mock implements Token {}

void main() {
  group("Authentication Repository Tests", () {
    late TokenRepository mockTokenRepository;
    late AuthenticationRepository authenticationRepository;
    late AuthenticationProvider mockAuthenticationProvider;
    late AuthenticationRepository authenticationRepositoryWithMock;

    setUp(() {
      registerFallbackValue<Token>(MockToken());
      mockTokenRepository = MockTokenRepository();
      when(() => mockTokenRepository.saveToken(token: any(named: "token"))).thenAnswer((_) async => null);
      when(() => mockTokenRepository.deleteToken()).thenAnswer((_) async => null);
      when(() => mockTokenRepository.hasValidToken()).thenAnswer((_) async => true);
      authenticationRepository = AuthenticationRepository(tokenRepository: mockTokenRepository, authenticationProvider: AuthenticationProvider());
      mockAuthenticationProvider = MockAuthenticationProvider();
      authenticationRepositoryWithMock = AuthenticationRepository(tokenRepository: mockTokenRepository, authenticationProvider: mockAuthenticationProvider);
    });

    test("Authentication Repository can register customer", () async {
      var customer = await authenticationRepository.register(email: "email", password: "password", passwordConfirmation: "passwordConfirmation");
      expect(customer, isA<Customer>());
    });

    test("Registering a customer saves token to tokenRepository", () async {
      await authenticationRepository.register(email: "email", password: "password", passwordConfirmation: "passwordConfirmation");
      verify(() => mockTokenRepository.saveToken(token: any(named: "token"))).called(1);
    });

    test("Authentication Repository throws error on register customer fail", () async {
      when(() => mockAuthenticationProvider.register(body: any(named: "body")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        authenticationRepositoryWithMock.register(email: "email", password: "password", passwordConfirmation: "passwordConfirmation"), 
        throwsA(isA<ApiException>())
      );
    });

    test("Authentication Repository can login customer", () async {
      var customer = await authenticationRepository.login(email: "email", password: "password");
      expect(customer, isA<Customer>());
    });

    test("Logging in a customer saves token to tokenRepository", () async {
      await authenticationRepository.login(email: "email", password: "password");
      verify(() => mockTokenRepository.saveToken(token: any(named: "token"))).called(1);
    });

    test("Authentication Repository throws error on login customer fail", () async {
      when(() => mockAuthenticationProvider.login(body: any(named: "body")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        authenticationRepositoryWithMock.login(email: "email", password: "password"), 
        throwsA(isA<ApiException>())
      );
    });

    test("Authentication Repository can logout customer", () async {
      var loggedOut = await authenticationRepository.logout();
      expect(loggedOut, isA<bool>());
    });

    test("Authentication Repository throws error on logout customer fail", () async {
      when(() => mockAuthenticationProvider.logout())
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        authenticationRepositoryWithMock.logout(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Authentication Repository can check customers password", () async {
      var valid = await authenticationRepository.checkPassword(password: "password");
      expect(valid, isA<bool>());
    });

    test("Authentication Repository throws error on check password fail", () async {
      when(() => mockAuthenticationProvider.checkPassword(body: any(named: "body")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        authenticationRepositoryWithMock.checkPassword(password: "password"), 
        throwsA(isA<ApiException>())
      );
    });

    test("Authentication Repository can request password reset", () async {
      var resetSent = await authenticationRepository.requestPasswordReset(email: "email");
      expect(resetSent, isA<bool>());
    });

    test("Authentication Repository throws error on request password reset fail", () async {
      when(() => mockAuthenticationProvider.requestPasswordReset(body: any(named: "body")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        authenticationRepositoryWithMock.requestPasswordReset(email: "email"), 
        throwsA(isA<ApiException>())
      );
    });

    test("Authentication Repository can check if token is valid", () async {
      var signedIn = await authenticationRepository.isSignedIn();
      expect(signedIn, isA<bool>());
    });
  });
}