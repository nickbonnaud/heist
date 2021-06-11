import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/geo.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Geo Tests", () {

    test("Geo can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateGeo();
      var geo = Geo.fromJson(json: json);
      expect(geo, isA<Geo>());
    });
  });
}