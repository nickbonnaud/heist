import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/providers/active_location_provider.dart';
import 'package:meta/meta.dart';

class ActiveLocationRepository {
  final ActiveLocationProvider _activeLocationProvider = ActiveLocationProvider();

  Future<ActiveLocation> enterBusiness({@required String beaconIdentifier}) async {
    final ApiResponse response = await _activeLocationProvider.enterBusiness(beaconIdentifier: beaconIdentifier);
    if (response.isOK) {
      return ActiveLocation.fromJson(response.body);
    }
    return ActiveLocation.withError(response.error);
  }

  Future<bool> exitBusiness({@required String activeLocationId}) async {
    final ApiResponse response = await _activeLocationProvider.exitBusiness(activeLocationId: activeLocationId);
    if (response.isOK) {
      return response.body['deleted'].toString() == 'true';
    }
    return false;
  }
}