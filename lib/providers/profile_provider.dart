import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class ProfileProvider extends BaseProvider {

  Future<ApiResponse> store({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.profile;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> update({required Map<String, dynamic> body, required String profileIdentifier}) async {
    String url = '${ApiEndpoints.profile}/$profileIdentifier';
    return await this.patch(url: url, body: body);
  }
}