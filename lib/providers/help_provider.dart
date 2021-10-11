import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class HelpProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetchHelpTickets({String query = "", String? paginateUrl}) async {
    final String url = paginateUrl == null
      ? '${ApiEndpoints.help}$query'
      : paginateUrl;
    return await this.getPaginated(url: url);
  }
  
  Future<ApiResponse> storeHelpTicket({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.help;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> storeReply({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.helpReply;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> updateReplies({required String ticketIdentifier, required Map<String, dynamic> body}) async {
    final String url = '${ApiEndpoints.helpReply}/$ticketIdentifier';
    return await this.patch(url: url, body: body);
  }

  Future<ApiResponse> deleteHelpTicket({required String identifier}) async {
    final String url = "${ApiEndpoints.help}/$identifier";
    return await this.delete(url: url);
  }
}