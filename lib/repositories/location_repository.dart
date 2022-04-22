import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/location_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class LocationRepository extends BaseRepository {
  final LocationProvider? _locationProvider;

  const LocationRepository({LocationProvider? locationProvider})
    : _locationProvider = locationProvider;

  Future<List<Business>> sendLocation({required double lat, required double lng, required bool startLocation}) async {
    LocationProvider locationProvider = _getLocationProvider();
    Map<String, dynamic> body = {
      "lat": lat,
      "lng": lng,
      "start_location": startLocation
    };

    PaginateDataHolder holder = await sendPaginated(request:  locationProvider.sendLocation(body: body));
    return deserialize(holder: holder);
  }

  LocationProvider _getLocationProvider() {
    return _locationProvider ?? const LocationProvider();
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.data.map((business) => Business.fromJson(json: business)).toList();
  }
}