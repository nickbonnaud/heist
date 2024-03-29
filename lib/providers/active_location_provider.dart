import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class ActiveLocationProvider extends BaseProvider {

  const ActiveLocationProvider();
  
  Future<ApiResponse> enterBusiness({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.activeLocation;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> exitBusiness({required String activeLocationId}) async {
    String url = "${ApiEndpoints.activeLocation}/$activeLocationId";
    return await delete(url: url);
  }
}