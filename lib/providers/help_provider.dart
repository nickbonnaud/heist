import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:heist/resources/http/api_endpoints.dart';
import 'package:meta/meta.dart';

@immutable
class HelpProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetchHelpTickets({String query = "", String? paginateUrl}) async {
    String url = paginateUrl ?? '${ApiEndpoints.help}$query';
    return await getPaginated(url: url);
  }
  
  Future<ApiResponse> storeHelpTicket({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.help;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> storeReply({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.helpReply;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> updateReplies({required String ticketIdentifier, required Map<String, dynamic> body}) async {
    String url = '${ApiEndpoints.helpReply}/$ticketIdentifier';
    return await patch(url: url, body: body);
  }

  Future<ApiResponse> deleteHelpTicket({required String identifier}) async {
    String url = "${ApiEndpoints.help}/$identifier";
    return await delete(url: url);
  }
}