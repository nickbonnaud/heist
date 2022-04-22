import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class RefundProvider extends BaseProvider {

  const RefundProvider();
  
  Future<PaginatedApiResponse> fetch({String query = "", String? paginateUrl}) async {
    String url = paginateUrl ?? '${ApiEndpoints.refund}$query';
    return await getPaginated(url: url);
  }
}