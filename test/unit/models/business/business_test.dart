import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Business Test", () {
    test("Business can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateBusiness();
      var business = Business.fromJson(json: json);
      expect(business, isA<Business>());
    });
  });
}