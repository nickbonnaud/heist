import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/customer/photos.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Photos Tests", () {

    test("Photos can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateCustomerPhoto();
      var photos = Photos.fromJson(json: json);
      expect(photos, isA<Photos>());
    });

    test("Photos can create an empty placeholder", () {
      var photos = Photos.empty();
      expect(photos, isA<Photos>());
    });
  });
}