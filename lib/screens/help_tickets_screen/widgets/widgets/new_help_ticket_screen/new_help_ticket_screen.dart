import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';

import 'bloc/help_ticket_form_bloc.dart';
import 'widgets/help_ticket_form.dart';

class NewHelpTicketScreen extends StatelessWidget {
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc; 

  NewHelpTicketScreen({required HelpRepository helpRepository, required HelpTicketsScreenBloc helpTicketsScreenBloc})
    : _helpRepository = helpRepository,
      _helpTicketsScreenBloc = helpTicketsScreenBloc;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: BottomModalAppBar(context: context),
      body: BlocProvider<HelpTicketFormBloc>(
        create: (_) => HelpTicketFormBloc(helpRepository: _helpRepository, helpTicketsScreenBloc: _helpTicketsScreenBloc),
        child: HelpTicketForm(),
      ),
    );
  }
}