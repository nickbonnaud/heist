import 'package:heist/models/api_response.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/providers/location_provider.dart';
import 'package:meta/meta.dart';

class LocationRepository {
  final LocationProvider _locationProvider = LocationProvider();

  Future<List<Business>> sendLocation({@required double lat, @required double lng, @required bool startLocation}) async {
    final ApiResponse response = await _locationProvider.sendLocation(lat: lat, lng: lng, startLocation: startLocation);
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return [Business.withError(response.error)].toList();
  }

  List<Business> _handleSuccess(ApiResponse response) {
    final data = response.body as List;
    return data.map((business) {
      return Business.fromJson(business);
    }).toList();
  }
}