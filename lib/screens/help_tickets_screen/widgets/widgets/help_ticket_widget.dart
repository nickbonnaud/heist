import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import '../../../help_ticket_screen/help_ticket_screen.dart';

class HelpTicketWidget extends StatelessWidget {
  final HelpTicket _helpTicket;
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;

  HelpTicketWidget({
    required HelpTicket helpTicket,
    required HelpRepository helpRepository,
    required HelpTicketsScreenBloc helpTicketsScreenBloc
  })
    : _helpTicket = helpTicket,
      _helpRepository = helpRepository,
      _helpTicketsScreenBloc = helpTicketsScreenBloc;
  

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(_setIcon(), color: _hasUnreadMessage() && !_helpTicket.resolved
              ? Theme.of(context).colorScheme.callToAction 
              : Theme.of(context).colorScheme.callToActionDisabled
            ),
            title: PlatformText(
              _helpTicket.subject,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _hasUnreadMessage() && !_helpTicket.resolved
                  ? Theme.of(context).colorScheme.onPrimary 
                  : Theme.of(context).colorScheme.onPrimaryDisabled,
                fontSize: SizeConfig.getWidth(6),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: _helpTicket.replies.length > 0 
              ? PlatformText(
                _helpTicket.replies.last.message,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !_helpTicket.replies.last.fromCustomer && !_helpTicket.replies.last.read && !_helpTicket.resolved
                    ? Theme.of(context).colorScheme.onPrimary 
                    : Theme.of(context).colorScheme.onPrimaryDisabled,
                  fontSize: SizeConfig.getWidth(4)
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
            )
              : PlatformText(
                _helpTicket.message,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryDisabled,
                  fontSize: SizeConfig.getWidth(4)
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
    return _helpTicket.replies.where((ticket) {
      return !ticket.fromCustomer && !ticket.read;
    }).isNotEmpty;
  }

  IconData _setIcon() {
    return _helpTicket.resolved
      ? Icons.lock
      : Icons.chat;
  }

  void _showFullHelpTicket({required BuildContext context}) {
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());
    
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => HelpTicketScreen(
        helpRepository: _helpRepository,
        helpTicket: _helpTicket,
        helpTicketsScreenBloc: _helpTicketsScreenBloc,
      )
    )).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}