import 'dart:io';

import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/photos.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/providers/profile_provider.dart';
import 'package:meta/meta.dart';

class ProfileRepository {
  final ProfileProvider _profileProvider = ProfileProvider();

  Future<Profile> store({@required String firstName, @required String lastName}) async {
    final ApiResponse response = await _profileProvider.store(firstName: firstName, lastName: lastName);
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return Profile.withError(response.error);
  }

  Future<Profile> update({@required String firstName, @required String lastName, @required String profileIdentifier}) async {
    final ApiResponse response = await _profileProvider.update(firstName: firstName, lastName: lastName, profileIdentifier: profileIdentifier);
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return Profile.withError(response.error);
  }

  Profile _handleSuccess(ApiResponse response) {
    return Profile.fromJson(response.body);
  }

  Future<Photos> uploadPhoto({@required File photo, @required String profileIdentifier}) async {
    final ApiResponse response = await _profileProvider.uploadPhoto(photo: photo, profileIdentifier: profileIdentifier);
    if (response.isOK) {
      return Photos.fromJson(response.body);
    }
    return Photos.withError(response.error);
  }
}