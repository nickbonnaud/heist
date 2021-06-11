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
    final String query = this.formatQuery(baseQuery: 'name=$name');
    final PaginateDataHolder holder = await this.sendPaginated(request: _businessProvider.fetch(query: query));
    
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByIdentifier({required String identifier}) async {
    final String query = this.formatQuery(baseQuery: 'id=$identifier');
    final PaginateDataHolder holder = await this.sendPaginated(request: _businessProvider.fetch(query: query));
    
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByBeaconIdentifier({required String identifier}) async {
    final String query = this.formatQuery(baseQuery: 'beacon=$identifier');
    final PaginateDataHolder holder = await this.sendPaginated(request: _businessProvider.fetch(query: query));
    
    return deserialize(holder: holder);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((business) => Business.fromJson(json: business)).toList()
    );
  }
}