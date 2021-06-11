import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/photos.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Photos Tests", () {

    test("Photos can deserialize json", () {
      Map<String, dynamic> json = MockResponses.generateBusinessPhotos();
      var photos = Photos.fromJson(json: json);
      expect(photos, isA<Photos>());
    });
  });
}