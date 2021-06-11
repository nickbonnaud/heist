import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/photo.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Photo Tests", () {

    test("Business Photo can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateLogo();
      var photo = Photo.fromJson(json: json);
      expect(photo, isA<Photo>());
    });
  });
}