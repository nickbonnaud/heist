import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

class GeolocatorProvider {

  Future<Position> fetch({@required LocationAccuracy accuracy}) async {
    try {
      return await Geolocator().getCurrentPosition(desiredAccuracy: accuracy);
    } catch (e) {
      return null;
    }
  }

  Future<GeolocationStatus> checkPermission() async {
    return await Geolocator().checkGeolocationPermissionStatus();
  }

  Future<Position> fetchRecent() async {
    try {
      Position position;
      position = await Geolocator().getLastKnownPosition();
      if (position == null) {
        position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      }
      return position;
    } catch (e) {
      return null;
    }
  }
}