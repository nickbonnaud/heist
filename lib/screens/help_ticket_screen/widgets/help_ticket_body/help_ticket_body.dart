import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';

import 'widgets/message_input/bloc/message_input_bloc.dart';
import 'widgets/message_input/message_input.dart';
import 'widgets/message_list/bloc/message_list_bloc.dart';
import 'widgets/message_list/message_list.dart';

class HelpTicketBody extends StatefulWidget {
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;
  final HelpTicket _helpTicket;
  final HelpRepository _helpRepository;

  HelpTicketBody({required HelpTicketsScreenBloc helpTicketsScreenBloc, required HelpTicket helpTicket, required HelpRepository helpRepository})
    : _helpTicketsScreenBloc = helpTicketsScreenBloc,
      _helpTicket = helpTicket,
      _helpRepository = helpRepository;

  @override
  State<HelpTicketBody> createState() => _HelpTicketBodyState();
}

class _HelpTicketBodyState extends State<HelpTicketBody> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _markRepliesAsRead();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            MessageList(scrollController: _scrollController),
            if (!widget._helpTicket.resolved)
              BlocProvider<MessageInputBloc>(
                create: (_) => MessageInputBloc(
                  helpRepository: widget._helpRepository,
                  helpTicketsScreenBloc: widget._helpTicketsScreenBloc
                ),
                child: MessageInput(ticketIdentifier: widget._helpTicket.identifier, scrollController: _scrollController),
              )
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _markRepliesAsRead() {
    BlocProvider.of<MessageListBloc>(context).add(RepliesViewed());
  }
}