import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/help_tickets_screen_bloc.dart';
import 'widgets/help_tickets_screen_body.dart';

class HelpTicketsScreen extends StatelessWidget {
  final HelpRepository _helpRepository = HelpRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (BuildContext context) => DefaultAppBarBloc(),
      child: BlocProvider<HelpTicketsScreenBloc>(
        create: (BuildContext context) => HelpTicketsScreenBloc(helpRepository: _helpRepository)
          ..add(FetchAll()),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          body: HelpTicketsScreenBody(helpRepository: _helpRepository),
        )
      ),
    );
  }
}