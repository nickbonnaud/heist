import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/profile.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  
  group("Profile Tests", () {
    test("Profile can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateBusinessProfile();
      var profile = Profile.fromJson(json: json);
      expect(profile, isA<Profile>());
    });
  });
}