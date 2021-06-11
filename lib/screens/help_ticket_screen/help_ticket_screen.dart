import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'widgets/delete_ticket_button/bloc/delete_ticket_button_bloc.dart';
import 'widgets/delete_ticket_button/delete_ticket_button.dart';
import 'widgets/help_ticket_body.dart';
import 'widgets/message_list/bloc/message_list_bloc.dart';


class HelpTicketScreen extends StatelessWidget {
  final HelpTicket _helpTicket;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;
  final HelpRepository _helpRepository;

  HelpTicketScreen({
    required HelpTicket helpTicket,
    required HelpTicketsScreenBloc helpTicketsScreenBloc,
    required HelpRepository helpRepository
  })
    : _helpTicket = helpTicket,
      _helpTicketsScreenBloc = helpTicketsScreenBloc,
      _helpRepository = helpRepository;
  
@override
  Widget build(BuildContext context) {
    return BlocProvider<DeleteTicketButtonBloc>(
      create: (_) => DeleteTicketButtonBloc(helpRepository: _helpRepository, helpTicketsScreenBloc: _helpTicketsScreenBloc),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scrollBackground,
        appBar: BottomModalAppBar(
          context: context,
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          title: _helpTicket.subject,
          trailingWidget: _helpTicket.resolved
            ? null
            : DeleteTicketButton(helpTicket: _helpTicket, helpRepository: _helpRepository, helpTicketsScreenBloc: _helpTicketsScreenBloc)
        ),
        body: BlocProvider<MessageListBloc>(
          create: (_) => MessageListBloc(helpTicket: _helpTicket, helpTicketsScreenBloc: _helpTicketsScreenBloc, helpRepository: _helpRepository),
          child: HelpTicketBody(helpTicketsScreenBloc: _helpTicketsScreenBloc, helpTicket: _helpTicket, helpRepository: _helpRepository),
        )
      ),
    );
  }
}