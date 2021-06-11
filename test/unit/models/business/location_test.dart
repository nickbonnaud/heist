import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/location.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Location Tests", () {
    
    test("Location can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateLocation();
      var location = Location.fromJson(json: json);
      expect(location, isA<Location>());
    });
  });
}