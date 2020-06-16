import 'dart:io';

import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/providers/profile_provider.dart';
import 'package:meta/meta.dart';

class ProfileRepository {
  final ProfileProvider _profileProvider = ProfileProvider();

  Future<Customer> store({@required String firstName, @required String lastName}) async {
    final ApiResponse response = await _profileProvider.store(firstName: firstName, lastName: lastName);
    if (response.isOK) {
      return Customer.fromJson(response.body);
    }
    return Customer.withError(response.error);
  }

  Future<Profile> update({@required String firstName, @required String lastName, @required String profileIdentifier}) async {
    final ApiResponse response = await _profileProvider.update(firstName: firstName, lastName: lastName, profileIdentifier: profileIdentifier);
    if (response.isOK) {
      return Profile.fromJson(response.body);
    }
    return Profile.withError(response.error);
  }

  Future<Customer> uploadPhoto({@required File photo, @required String profileIdentifier}) async {
    final ApiResponse response = await _profileProvider.uploadPhoto(photo: photo, profileIdentifier: profileIdentifier);
    if (response.isOK) {
      return Customer.fromJson(response.body);
    }
    return Customer.withError(response.error);
  }
}