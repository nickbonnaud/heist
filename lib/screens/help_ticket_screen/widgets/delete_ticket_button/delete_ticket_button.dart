import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/delete_ticket_button_bloc.dart';
import 'widgets/dialog_body.dart';

class DeleteTicketButton extends StatelessWidget {
  final HelpTicket _helpTicket;
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;

  DeleteTicketButton({required HelpTicket helpTicket, required HelpRepository helpRepository, required HelpTicketsScreenBloc helpTicketsScreenBloc})
    : _helpTicket = helpTicket,
      _helpRepository = helpRepository,
      _helpTicketsScreenBloc = helpTicketsScreenBloc;
   
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_forever), 
      onPressed: () => _deleteButtonPressed(context: context),
      color: Theme.of(context).colorScheme.danger,
      iconSize: SizeConfig.getWidth(8),
    );
  }

  void _deleteButtonPressed({required BuildContext context}) {
    showPlatformDialog(
      context: context, 
      builder: (_) => BlocProvider<DeleteTicketButtonBloc>(
        create: (_) => DeleteTicketButtonBloc(helpRepository: _helpRepository, helpTicketsScreenBloc: _helpTicketsScreenBloc),
        child: DialogBody(helpTicket: _helpTicket),
      )
    );
  }
}