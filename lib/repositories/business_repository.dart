import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/business_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class BusinessRepository extends BaseRepository {
  final BusinessProvider _businessProvider;

  BusinessRepository({required BusinessProvider businessProvider})
    : _businessProvider = businessProvider;

  Future<PaginateDataHolder> fetchByName({required String name}) async {
    String query = formatQuery(baseQuery: 'name=$name');
    PaginateDataHolder holder = await sendPaginated(request: _businessProvider.fetch(query: query));
    
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByIdentifier({required String identifier}) async {
    String query = formatQuery(baseQuery: 'id=$identifier');
    PaginateDataHolder holder = await sendPaginated(request: _businessProvider.fetch(query: query));
    
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByBeaconIdentifier({required String identifier}) async {
    String query = formatQuery(baseQuery: 'beacon=$identifier');
    PaginateDataHolder holder = await sendPaginated(request: _businessProvider.fetch(query: query));
    
    return deserialize(holder: holder);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((business) => Business.fromJson(json: business)).toList()
    );
  }
}