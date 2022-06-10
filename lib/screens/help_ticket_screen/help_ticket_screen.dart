import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'widgets/delete_ticket_button/bloc/delete_ticket_button_bloc.dart';
import 'widgets/delete_ticket_button/delete_ticket_button.dart';
import 'widgets/help_ticket_body/help_ticket_body.dart';
import 'widgets/help_ticket_body/widgets/message_list/bloc/message_list_bloc.dart';


class HelpTicketScreen extends StatelessWidget {
  final HelpTicket _helpTicket;

  const HelpTicketScreen({required HelpTicket helpTicket, Key? key})
    : _helpTicket = helpTicket,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      appBar: BottomModalAppBar(
        backgroundColor: Theme.of(context).colorScheme.scrollBackground,
        title: _helpTicket.subject,
        trailingWidget: _helpTicket.resolved
          ? null
          : _deleteTicketButton(context: context)
      ),
      body: BlocProvider<MessageListBloc>(
        create: (_) => MessageListBloc(
          helpTicket: _helpTicket,
          helpTicketsScreenBloc: BlocProvider.of<HelpTicketsScreenBloc>(context),
          helpRepository: RepositoryProvider.of<HelpRepository>(context)
        ),
        child: HelpTicketBody(helpTicket: _helpTicket),
      ),
    );
  }

  Widget _deleteTicketButton({required BuildContext context}) {
    return BlocProvider<DeleteTicketButtonBloc>(
      create: (_) => DeleteTicketButtonBloc(
        helpRepository: RepositoryProvider.of<HelpRepository>(context),
        helpTicketsScreenBloc: BlocProvider.of<HelpTicketsScreenBloc>(context)
      ),
      child: DeleteTicketButton(helpTicket: _helpTicket)
    );
  }
}