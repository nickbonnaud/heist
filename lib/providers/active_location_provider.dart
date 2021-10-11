import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class ActiveLocationProvider extends BaseProvider {

  Future<ApiResponse> enterBusiness({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.activeLocation;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> exitBusiness({required String activeLocationId}) async {
    String url = "${ApiEndpoints.activeLocation}/$activeLocationId";
    return await this.delete(url: url);
  }
}