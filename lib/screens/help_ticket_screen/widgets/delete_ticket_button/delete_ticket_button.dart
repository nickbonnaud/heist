import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/delete_ticket_button_bloc.dart';

class DeleteTicketButton extends StatelessWidget {
  final HelpTicket _helpTicket;
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;

  DeleteTicketButton({@required HelpTicket helpTicket, @required HelpRepository helpRepository, @required HelpTicketsScreenBloc helpTicketsScreenBloc})
    : assert(helpTicket != null && helpRepository != null && helpTicketsScreenBloc != null),
      _helpTicket = helpTicket,
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

  void _deleteButtonPressed({@required BuildContext context}) {
    showPlatformDialog(
      context: context, 
      builder: (_) => BlocProvider<DeleteTicketButtonBloc>(
        create: (_) => DeleteTicketButtonBloc(helpRepository: _helpRepository, helpTicketsScreenBloc: _helpTicketsScreenBloc),
        child: DialogBody(helpTicket: _helpTicket),
      )
    );
  }
}

class DialogBody extends StatelessWidget {
  final HelpTicket _helpTicket;

  DialogBody({@required HelpTicket helpTicket})
    : assert(helpTicket != null),
      _helpTicket = helpTicket;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteTicketButtonBloc, DeleteTicketButtonState>(
      listener: (context, state) {
        
        if (state.isFailure) {
          BlocProvider.of<DeleteTicketButtonBloc>(context).add(Reset());
        } else if (state.isSuccess) {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ == 2);
        }
      },
      child: BlocBuilder<DeleteTicketButtonBloc, DeleteTicketButtonState>(
        builder: (context, state) {
          return PlatformAlertDialog(
            title: state.isSubmitting
              ? PlatformText('Deleting...')
              : PlatformText('Delete Help Ticket'),
            content: state.isSubmitting
              ? Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: SizeConfig.getWidth(10),
                    width: SizeConfig.getWidth(10),
                    child: CircularProgressIndicator(),
                  )
                ],
              )
              : Container(
                margin: EdgeInsets.only(top: 10),
                child: PlatformText("Are you sure?"),
              ),
            actions: [
              PlatformDialogAction(
                child: PlatformText("Cancel"), 
                onPressed: state.isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(false)
              ),
              PlatformDialogAction(
                child: PlatformText(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.danger
                  ),
                ), 
                onPressed: state.isSubmitting
                  ? null
                  : () => BlocProvider.of<DeleteTicketButtonBloc>(context).add(Submitted(ticketIdentifier: _helpTicket.identifier))
              )
            ],
          );
        }
      )
    );
  }
}