import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/base_provider.dart';
import 'package:meta/meta.dart';

@immutable
class HelpProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetchHelpTickets({String query = "", String? paginateUrl}) async {
    final String url = paginateUrl == null
      ? 'help$query'
      : paginateUrl;
    return await this.getPaginated(url: url);
  }
  
  Future<ApiResponse> storeHelpTicket({required Map<String, dynamic> body}) async {
    final String url = "help";
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> storeReply({required Map<String, dynamic> body}) async {
    final String url = 'help-reply';
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> updateReplies({required String ticketIdentifier, required Map<String, dynamic> body}) async {
    final String url = 'help-reply/$ticketIdentifier';
    return await this.patch(url: url, body: body);
  }

  Future<ApiResponse> deleteHelpTicket({required String identifier}) async {
    final String url = "help/$identifier";
    return await this.delete(url: url);
  }
}