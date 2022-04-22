import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';

import 'bloc/help_ticket_form_bloc.dart';
import 'widgets/help_ticket_form.dart';

class NewHelpTicketScreen extends StatelessWidget {

  const NewHelpTicketScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const BottomModalAppBar(),
      body: BlocProvider<HelpTicketFormBloc>(
        create: (_) => HelpTicketFormBloc(
          helpRepository: RepositoryProvider.of<HelpRepository>(context),
          helpTicketsScreenBloc: BlocProvider.of<HelpTicketsScreenBloc>(context)
        ),
        child: const HelpTicketForm(),
      ),
    );
  }
}