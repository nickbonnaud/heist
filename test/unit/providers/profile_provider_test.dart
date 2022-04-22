import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/profile_provider.dart';

void main() {
  group("Profile Provider Tests", () {
    late ProfileProvider profileProvider;

    setUp(() {
      profileProvider = const ProfileProvider();
    });

    test("Storing Profile data returns ApiResponse", () async {
      var response = await profileProvider.store(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating Profile data returns ApiResponse", () async {
      var response = await profileProvider.update(body: {}, profileIdentifier: "profileIdentifier");
      expect(response, isA<ApiResponse>());
    });
  });
}