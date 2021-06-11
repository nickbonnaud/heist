import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/hours.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Hours Tests", () {

    test("Hours can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateHours();
      var hours = Hours.fromJson(json: json);
      expect(hours, isA<Hours>());
    });
  });
}