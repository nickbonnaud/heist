import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:meta/meta.dart';

@immutable
class BusinessProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetch({String query = "", String? paginateUrl}) async {
    final String url = paginateUrl == null
      ? 'business$query'
      : paginateUrl;

    return await this.getPaginated(url: url);
  }
}