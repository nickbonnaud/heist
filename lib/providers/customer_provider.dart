import 'package:heist/models/api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:meta/meta.dart';

@immutable
class CustomerProvider extends BaseProvider {
  Future<ApiResponse> fetchCustomer() async {
    String url = 'me';
    return await this.get(url: url);
  }

  Future<ApiResponse> updateEmail({required Map<String, dynamic> body, required String customerId}) async {
    String url = 'me/$customerId';
    return await this.patch(url: url, body: body);
  }

  Future<ApiResponse> updatePassword({required Map<String, dynamic> body, required String customerId}) async {
    String url = 'me/$customerId';
    return await this.patch(url: url, body: body);
  }
}