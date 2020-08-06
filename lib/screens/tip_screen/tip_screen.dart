import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/tip_form_bloc.dart';
import 'widgets/tip_form.dart';

class TipScreen extends StatelessWidget {
  final AccountRepository _accountRepository = AccountRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: BottomModalAppBar(backgroundColor: Theme.of(context).colorScheme.topAppBar),
      body: BlocProvider<TipFormBloc>(
        create: (BuildContext context) => TipFormBloc(accountRepository: _accountRepository, authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: TipForm(customer: BlocProvider.of<AuthenticationBloc>(context).customer),
      )
    );
  }
}