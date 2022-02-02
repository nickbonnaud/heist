import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

@immutable
class GeolocatorProvider {
  final bool _testing;

  const GeolocatorProvider({bool testing: false})
    : _testing = testing;

  Future<Position> fetch({required LocationAccuracy accuracy}) async {
    // TEST CHANGE
    
    if (_testing) {
      return Position(latitude: 35.926341, longitude: -79.039744, timestamp: DateTime.now(), accuracy: 10, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
  }
}