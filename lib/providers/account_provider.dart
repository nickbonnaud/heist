import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:meta/meta.dart';

@immutable
class AccountProvider extends BaseProvider {
  
  Future<ApiResponse> update({required Map<String, dynamic> body, required String accountIdentifier}) async {
    final String url = 'account/$accountIdentifier';
    return await this.patch(url: url, body: body);
  }
}