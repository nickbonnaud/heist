import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class LocationProvider extends BaseProvider {

  Future<PaginatedApiResponse> sendLocation({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.geoLocation;
    return await postPaginated(url: url, body: body);
  }
}