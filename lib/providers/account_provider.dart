import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class AccountProvider extends BaseProvider {
  
  const AccountProvider();
  
  Future<ApiResponse> update({required Map<String, dynamic> body, required String accountIdentifier}) async {
    final String url = '${ApiEndpoints.account}/$accountIdentifier';
    return await patch(url: url, body: body);
  }
}