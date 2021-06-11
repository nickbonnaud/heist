import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Profile Tests", () {
    test("Profile can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateCustomerProfile();
      var profile = Profile.fromJson(json: json);
      expect(profile, isA<Profile>());
    });

    test("Profile can create an empty placeholder", () {
      var profile = Profile.empty();
      expect(profile, isA<Profile>());
    });

    test("Profile can update it's attributes", () {
      final Map<String, dynamic> json = MockResponses.generateCustomerProfile();
      var profile = Profile.fromJson(json: json);

      final String firstName = faker.person.firstName();
      final String lastName = faker.person.lastName();

      expect(profile.firstName == firstName, false);
      expect(profile.lastName == lastName, false);

      profile = profile.update(firstName: firstName, lastName: lastName);

      expect(profile.firstName == firstName, true);
      expect(profile.lastName == lastName, true);
    });
  });
}