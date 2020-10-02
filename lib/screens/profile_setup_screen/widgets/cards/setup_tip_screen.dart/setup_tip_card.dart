import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/account_repository.dart';

import 'bloc/setup_tip_card_bloc.dart';
import 'widgets/setup_tip_body.dart';

class SetupTipCard extends StatelessWidget {
  final AccountRepository _accountRepository = AccountRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BlocProvider<SetupTipCardBloc>(
        create: (BuildContext context) => SetupTipCardBloc(accountRepository: _accountRepository, authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: SetupTipBody(),
      ),
    );
  }
}