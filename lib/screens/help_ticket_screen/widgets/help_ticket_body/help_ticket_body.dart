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
  final HelpTicket _helpTicket;

  const HelpTicketBody({required HelpTicket helpTicket, Key? key})
    : _helpTicket = helpTicket,
      super(key: key);

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
                  helpRepository: RepositoryProvider.of<HelpRepository>(context),
                  helpTicketsScreenBloc: BlocProvider.of<HelpTicketsScreenBloc>(context)
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