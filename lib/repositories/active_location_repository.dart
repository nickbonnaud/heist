import 'package:heist/models/business/beacon.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/active_location_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class ActiveLocationRepository extends BaseRepository {
  final ActiveLocationProvider _activeLocationProvider;

  ActiveLocationRepository({required ActiveLocationProvider activeLocationProvider})
    : _activeLocationProvider = activeLocationProvider;

  Future<ActiveLocation> enterBusiness({required Beacon beacon}) async {
    final Map<String, dynamic> body = {
      'proximity_uuid': beacon.proximityUUID,
      'major': beacon.major,
      'minor': beacon.minor
    };
    
    final Map<String, dynamic> json = await send(request: _activeLocationProvider.enterBusiness(body: body));
    return deserialize(json: json);
  }

  Future<bool> exitBusiness({required String activeLocationId}) async {
    final Map<String, dynamic> json = await send(request: _activeLocationProvider.exitBusiness(activeLocationId: activeLocationId));
    return json['deleted'];
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return ActiveLocation.fromJson(json: json!);
  }
}