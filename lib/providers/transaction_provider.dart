import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class TransactionProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetch({String query = "", String? paginateUrl}) async {
    final String url = paginateUrl == null
      ? '${ApiEndpoints.transaction}$query'
      : paginateUrl;

    return await this.getPaginated(url: url);
  }

  Future<PaginatedApiResponse> fetchUnassigned({required String businessIdentifier}) async {
    final String url = '${ApiEndpoints.unassignedTransaction}?business_id=$businessIdentifier';
    return await this.getPaginated(url: url);
  }

  Future<ApiResponse> patchUnassigned({required String transactionId}) async {
    final String url = '${ApiEndpoints.unassignedTransaction}/$transactionId';
    final Map<String, dynamic> body = {};
    return await this.patch(url: url, body: body);
  }

  Future<ApiResponse> patchStatus({required Map<String, dynamic> body, required String transactionId}) async {
    final String url = '${ApiEndpoints.transaction}/$transactionId';
    return await this.patch(url: url, body: body);
  }
}