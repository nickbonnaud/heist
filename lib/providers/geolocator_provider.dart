import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

@immutable
class GeolocatorProvider {

  Future<Position> fetch({required LocationAccuracy accuracy}) async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<Position> fetchRecent() async {
    Position? position;
    position = await Geolocator.getLastKnownPosition();
    if (position == null) {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    }
    return position;
  }
}