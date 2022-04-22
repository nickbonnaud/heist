import 'package:flutter/material.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/help_provider.dart';
import 'package:heist/repositories/base_repository.dart';

@immutable
class HelpRepository extends BaseRepository {
  final HelpProvider? _helpProvider;

  const HelpRepository({HelpProvider? helpProvider})
    : _helpProvider = helpProvider;

  Future<PaginateDataHolder> fetchAll() async {
    HelpProvider helpProvider = _getHelpProvider();
    
    PaginateDataHolder holder = await sendPaginated(request: helpProvider.fetchHelpTickets());
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchResolved() async {
    HelpProvider helpProvider = _getHelpProvider();
    String query = formatQuery(baseQuery: "resolved=true");

    PaginateDataHolder holder = await sendPaginated(request: helpProvider.fetchHelpTickets(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchOpen() async {
    HelpProvider helpProvider = _getHelpProvider();
    String query = formatQuery(baseQuery: "resolved=false");

    PaginateDataHolder holder = await sendPaginated(request: helpProvider.fetchHelpTickets(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    HelpProvider helpProvider = _getHelpProvider();
    
    PaginateDataHolder holder = await sendPaginated(request: helpProvider.fetchHelpTickets(paginateUrl: url));
    return deserialize(holder: holder);
  }
  
  Future<HelpTicket> storeHelpTicket({required String subject, required String message}) async {
    HelpProvider helpProvider = _getHelpProvider();
    Map<String, dynamic> body = {
      'subject': subject,
      'message': message
    };

    Map<String, dynamic> json = await send(request: helpProvider.storeHelpTicket(body: body));
    return deserialize(json: json);
  }

  Future<HelpTicket> storeReply({required String identifier, required String message}) async {
    HelpProvider helpProvider = _getHelpProvider();
    Map<String, dynamic> body = {
      'ticket_identifier': identifier,
      'message': message
    };

    Map<String, dynamic> json = await send(request: helpProvider.storeReply(body: body));
    return deserialize(json: json);
  }

  Future<HelpTicket> updateRepliesAsRead({required String ticketIdentifier}) async {
    HelpProvider helpProvider = _getHelpProvider();
    Map<String, dynamic> body = {'read': true};

    Map<String, dynamic> json = await send(request: helpProvider.updateReplies(body: body, ticketIdentifier: ticketIdentifier));
    return deserialize(json: json);
  }

  Future<bool> deleteHelpTicket({required String identifier}) async {
    HelpProvider helpProvider = _getHelpProvider();
    
    return await send(request: helpProvider.deleteHelpTicket(identifier: identifier))
      .then((json) => json['deleted']);
  }

  HelpProvider _getHelpProvider() {
    return _helpProvider ?? const HelpProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    if (holder != null) {
      return holder.update(
        data: holder.data.map((helpTicket) => HelpTicket.fromJson(json: helpTicket)).toList()
      );
    }

    return HelpTicket.fromJson(json: json!);
  }
}