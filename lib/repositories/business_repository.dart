import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/business_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class BusinessRepository extends BaseRepository {
  final BusinessProvider? _businessProvider;

  const BusinessRepository({BusinessProvider? businessProvider})
    : _businessProvider = businessProvider;

  Future<PaginateDataHolder> fetchByName({required String name}) async {
    BusinessProvider businessProvider = _getBusinessProvider();
    String query = formatQuery(baseQuery: 'name=$name');

    PaginateDataHolder holder = await sendPaginated(request: businessProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByIdentifier({required String identifier}) async {
    BusinessProvider businessProvider = _getBusinessProvider();
    String query = formatQuery(baseQuery: 'id=$identifier');

    PaginateDataHolder holder = await sendPaginated(request: businessProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByBeaconIdentifier({required String identifier}) async {
    BusinessProvider businessProvider = _getBusinessProvider();
    String query = formatQuery(baseQuery: 'beacon=$identifier');
    
    PaginateDataHolder holder = await sendPaginated(request: businessProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  BusinessProvider _getBusinessProvider() {
    return _businessProvider ?? const BusinessProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((business) => Business.fromJson(json: business)).toList()
    );
  }
}