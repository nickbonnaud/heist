import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/business/profile.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/providers/profile_provider.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

class MockProfileProvider extends Mock implements ProfileProvider {}

void main() {
  group("Profile Repository Tests", () {
    late ProfileRepository profileRepository;
    late ProfileProvider mockProfileProvider;
    late ProfileRepository profileRepositoryWithMock;

    setUp(() {
      profileRepository = ProfileRepository(profileProvider: ProfileProvider());
      mockProfileProvider = MockProfileProvider();
      profileRepositoryWithMock = ProfileRepository(profileProvider: mockProfileProvider);
    });

    test("Profile Repository can store profile", () async {
      var customer = await profileRepository.store(firstName: "firstName", lastName: "lastName");
      expect(customer, isA<Customer>());
    });

    test("Profile Repository throws error on store profile fail", () async {
      when(() => mockProfileProvider.store(body: any(named: "body")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        profileRepositoryWithMock.store(firstName: "firstName", lastName: "lastName"), 
        throwsA(isA<ApiException>())
      );
    });

    test("Profile Repository can update profile", () async {
      var customer = await profileRepository.update(firstName: "firstName", lastName: "lastName", profileIdentifier: "profileIdentifier");
      expect(customer, isA<Customer>());
    });

    test("Profile Repository throws error on update profile fail", () async {
      when(() => mockProfileProvider.update(body: any(named: "body"), profileIdentifier: any(named: "profileIdentifier")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        profileRepositoryWithMock.update(firstName: "firstName", lastName: "lastName", profileIdentifier: "profileIdentifier"), 
        throwsA(isA<ApiException>())
      );
    });
  });
}