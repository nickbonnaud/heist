import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:meta/meta.dart';

@immutable
class LocationProvider extends BaseProvider {

  Future<PaginatedApiResponse> sendLocation({required Map<String, dynamic> body}) async {
    String url = "geo-location";
    return await this.postPaginated(url: url, body: body);
  }
}