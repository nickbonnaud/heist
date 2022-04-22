import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/delete_ticket_button_bloc.dart';
import 'widgets/dialog_body.dart';

class DeleteTicketButton extends StatelessWidget {
  final HelpTicket _helpTicket;

  const DeleteTicketButton({required HelpTicket helpTicket, Key? key})
    : _helpTicket = helpTicket,
      super(key: key);
   
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_forever), 
      onPressed: () => _deleteButtonPressed(context: context),
      color: Theme.of(context).colorScheme.danger,
      iconSize: 40.sp,
    );
  }

  void _deleteButtonPressed({required BuildContext context}) {
    DeleteTicketButtonBloc deleteTicketButtonBloc = BlocProvider.of<DeleteTicketButtonBloc>(context);
    
    showPlatformDialog(
      context: context,
      builder: (_) =>  BlocProvider.value(
        value: deleteTicketButtonBloc,
        child: DialogBody(helpTicket: _helpTicket),
      )
    );
  }
}