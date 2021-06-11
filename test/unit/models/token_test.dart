import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/token.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Token Tests", () {

    test("Token can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateJWTToken();
      var token = Token.fromJson(json: json);
      expect(token, isA<Token>());
    });

    test("Token can check if expired", () {
      final Map<String, dynamic> json = MockResponses.generateJWTToken();
      var token = Token.fromJson(json: json);
      expect(token.expired, isA<bool>());
    });

    test("Token expired returns false if not expired", () {
      final Map<String, dynamic> json = MockResponses.generateJWTToken();
      var token = Token.fromJson(json: json);
      expect(token.expired, false);
    });

    test("Token expired returns true if token expired", () {
      final Map<String, dynamic> json = MockResponses.generateJWTToken(expired: true);
      var token = Token.fromJson(json: json);
      expect(token.expired, true);
    });

    test("Token can check if invalid", () {
      final Map<String, dynamic> json = MockResponses.generateJWTToken();
      var token = Token.fromJson(json: json);
      expect(token.valid, isA<bool>());
    });

    test("Token valid returns true if token is valid", () {
      final Map<String, dynamic> json = MockResponses.generateJWTToken();
      var token = Token.fromJson(json: json);
      expect(token.valid, true);
    });

    test("Token valid returns false if token is invalid", () {
      final Map<String, dynamic> json = {'token': "invalid_token"};
      var token = Token.fromJson(json: json);
      expect(token.valid, false);
    });
  });
}