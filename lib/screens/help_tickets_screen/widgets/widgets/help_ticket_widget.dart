import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/screens/help_tickets_screen/models/help_ticket_args.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpTicketWidget extends StatelessWidget {
  final HelpTicket _helpTicket;
  final Key _key;

  HelpTicketWidget({
    required HelpTicket helpTicket,
    required Key key
  })
    : _helpTicket = helpTicket,
      _key = key;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      key: _key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(_setIcon(), color: _hasUnreadMessage() && !_helpTicket.resolved
              ? Theme.of(context).colorScheme.callToAction 
              : Theme.of(context).colorScheme.callToActionDisabled
            ),
            title: Text(
              _helpTicket.subject,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _hasUnreadMessage() && !_helpTicket.resolved
                  ? Theme.of(context).colorScheme.onPrimary 
                  : Theme.of(context).colorScheme.onPrimaryDisabled,
                fontSize: 22.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: _helpTicket.replies.length > 0 
              ? Text(
                _helpTicket.replies.last.message,
                style: TextStyle(
                  color: !_helpTicket.replies.last.fromCustomer && !_helpTicket.replies.last.read && !_helpTicket.resolved
                    ? Theme.of(context).colorScheme.onPrimary 
                    : Theme.of(context).colorScheme.onPrimaryDisabled,
                  fontSize: 16.sp
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
            )
              : Text(
                _helpTicket.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryDisabled,
                  fontSize: 16.sp
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _showFullHelpTicket(context: context),
          )
        ],
      ),
    );
  }

  bool _hasUnreadMessage() {
    return _helpTicket.replies.where((reply) {
      return !reply.fromCustomer && !reply.read;
    }).isNotEmpty;
  }

  IconData _setIcon() {
    return _helpTicket.resolved
      ? Icons.lock
      : Icons.chat;
  }

  void _showFullHelpTicket({required BuildContext context}) {
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());
    Navigator.of(context).pushNamed(
      Routes.helpTicketDetails,
      arguments: HelpTicketArgs(helpTicket: _helpTicket, helpTicketsScreenBloc: BlocProvider.of<HelpTicketsScreenBloc>(context)))
        .then((_) => BlocProvider.of<DefaultAppBarBloc>(context).add(Reset()));
  }
}