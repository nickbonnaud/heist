import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class BusinessProvider extends BaseProvider {

  const BusinessProvider();
  
  Future<PaginatedApiResponse> fetch({String query = "", String? paginateUrl}) async {
    final String url = paginateUrl ?? '${ApiEndpoints.business}$query';

    return await getPaginated(url: url);
  }
}