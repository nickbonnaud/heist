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

  Future<bool> checkPermission() async {
    GeolocationStatus status = await Geolocator().checkGeolocationPermissionStatus();
    return status == GeolocationStatus.granted;
  }
}