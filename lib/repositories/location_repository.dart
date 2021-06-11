import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/location_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class LocationRepository extends BaseRepository {
  final LocationProvider _locationProvider;

  LocationRepository({required LocationProvider locationProvider})
    : _locationProvider = locationProvider;

  Future<List<Business>> sendLocation({required double lat, required double lng, required bool startLocation}) async {
    final Map<String, dynamic> body = {
      "lat": lat,
      "lng": lng,
      "start_location": startLocation
    };

    final PaginateDataHolder holder = await this.sendPaginated(request:  _locationProvider.sendLocation(body: body));
    return deserialize(holder: holder);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.data.map((business) => Business.fromJson(json: business)).toList();
  }
}