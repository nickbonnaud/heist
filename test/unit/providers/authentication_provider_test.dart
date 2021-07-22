import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/authentication_provider.dart';

void main() {
  group("Authentication Provider Tests", () {
    late AuthenticationProvider authenticationProvider;

    setUp(() {
      authenticationProvider = AuthenticationProvider();
    });

    test("Registering a customer returns ApiResponse", () async {
      var response = await authenticationProvider.register(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Logging in a customer returns ApiResponse", () async {
      var response = await authenticationProvider.login(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Logging out a customer returns ApiResponse", () async {
      var response = await authenticationProvider.logout();
      expect(response, isA<ApiResponse>());
    });

    test("Checking customer Password returns ApiResponse", () async {
      var response = await authenticationProvider.checkPassword(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Requesting a password reset returns ApiResponse", () async {
      var response = await authenticationProvider.requestPasswordReset(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Reseting password returns ApiResponsee",() async {
      var response = await authenticationProvider.resetPassword(body: {});
      expect(response, isA<ApiResponse>());
    });
  });
}