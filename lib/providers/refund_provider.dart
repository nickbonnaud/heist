import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:meta/meta.dart';

@immutable
class RefundProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetch({String query = "", String? paginateUrl}) async {
    String url = paginateUrl == null
      ? 'refund$query'
      : paginateUrl;

    return await this.getPaginated(url: url);
  }
}