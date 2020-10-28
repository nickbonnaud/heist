import 'package:heist/models/api_response.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/help_provider.dart';
import 'package:meta/meta.dart';

class HelpRepository {
  final HelpProvider _helpProvider = HelpProvider();

  Future<PaginateDataHolder> fetchAll({@required int nextPage}) async {
    final PaginatedApiResponse response = await _helpProvider.fetchHelpTickets(query: 'page=$nextPage');
    if (response.isOK) {
      return _handlePaginatedSuccess(response: response);
    }
    return _handlePaginatedFailure(error: response.error);
  }

  Future<PaginateDataHolder> fetchResolved({@required int nextPage}) async {
    final PaginatedApiResponse response = await _helpProvider.fetchHelpTickets(query: 'resolved=true&page=$nextPage');
    if (response.isOK) {
      return _handlePaginatedSuccess(response: response);
    }
    return _handlePaginatedFailure(error: response.error);
  }

  Future<PaginateDataHolder> fetchOpen({@required int nextPage}) async {
    final PaginatedApiResponse response = await _helpProvider.fetchHelpTickets(query: 'resolved=false&page=$nextPage');
    if (response.isOK) {
      return _handlePaginatedSuccess(response: response);
    }
    return _handlePaginatedFailure(error: response.error);
  }
  
  Future<HelpTicket> storeHelpTicket({@required String subject, @required String message}) async {
    final ApiResponse response = await _helpProvider.storeHelpTicket(subject: subject, message: message);
    if (response.isOK) {
      return HelpTicket.fromJson(response.body);
    }
    return HelpTicket.withError(response.error);
  }

  Future<HelpTicket> storeReply({@required String identifier, @required String message}) async {
    final ApiResponse response = await _helpProvider.storeReply(identifier: identifier, message: message);
    if (response.isOK) {
      return HelpTicket.fromJson(response.body);
    }
    return HelpTicket.withError(response.error);
  }

  Future<HelpTicket> updateRepliesAsRead({@required String ticketIdentifier}) async {
    final Map<String, bool> body = {'read': true};
    final ApiResponse response = await _helpProvider.updateReplies(ticketIdentifier: ticketIdentifier, body: body);
    if (response.isOK) {
      return HelpTicket.fromJson(response.body);
    }
    return HelpTicket.withError(response.error);
  }

  Future<bool> deleteHelpTicket({@required String identifier}) async {
    final ApiResponse response = await _helpProvider.deleteHelpTicket(identifier: identifier);
    if (response.isOK) {
      return response.body['deleted'];
    }
    return response.isOK;
  }

  PaginateDataHolder _handlePaginatedSuccess({@required PaginatedApiResponse response}) {
    final rawData = response.body as List;
    List<HelpTicket> data = rawData.map((rawHelpTicket) => HelpTicket.fromJson(rawHelpTicket)).toList();
    return PaginateDataHolder(data: data, nextPage: response.nextPage);
  }

  PaginateDataHolder _handlePaginatedFailure({@required String error}) {
    return PaginateDataHolder(data: [HelpTicket.withError(error)].toList(), nextPage: null);
  }
}