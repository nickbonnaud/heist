import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/help_ticket_screen/widgets/delete_ticket_button/bloc/delete_ticket_button_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogBody extends StatelessWidget {
  final HelpTicket _helpTicket;

  const DialogBody({required HelpTicket helpTicket, Key? key})
    : _helpTicket = helpTicket,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteTicketButtonBloc, DeleteTicketButtonState>(
      listener: (context, state) {
        
        if (state.errorMessage.isNotEmpty) {
          BlocProvider.of<DeleteTicketButtonBloc>(context).add(Reset());
        } else if (state.isSuccess) {
          Navigator.popUntil(context, ModalRoute.withName(Routes.helpTickets));
        }
      },
      child: BlocBuilder<DeleteTicketButtonBloc, DeleteTicketButtonState>(
        builder: (context, state) {
          return PlatformAlertDialog(
            key: const Key("deleteTicketDialogKey"),
            title: state.isSubmitting
              ? PlatformText('Deleting...')
              : PlatformText('Delete Help Ticket'),
            content: state.isSubmitting
              ? Column(
                mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      height: 45.sp,
                      width: 45.sp,
                      child: const CircularProgressIndicator(),
                    )
                  ],
                )
              : Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: PlatformText("Are you sure?"),
                ),
            actions: [
              PlatformDialogAction(
                key: const Key("cancelDeleteTicketButtonKey"),
                child: PlatformText("Cancel"), 
                onPressed: state.isSubmitting
                  ? null
                  : () => Navigator.of(context).pop()
              ),
              PlatformDialogAction(
                key: const Key("confirmDeleteTicketButtonKey"),
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