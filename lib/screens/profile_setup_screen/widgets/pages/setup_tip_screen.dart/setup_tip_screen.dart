import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/screens/profile_setup_screen/widgets/pages/setup_tip_screen.dart/bloc/setup_tip_screen_bloc.dart';

import 'widgets/setup_tip_body.dart';

class SetupTipScreen extends StatelessWidget {
  final AnimationController _controller;
  final AccountRepository _accountRepository = AccountRepository();

  SetupTipScreen({@required AnimationController controller})
    : assert(controller != null),
      _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BlocProvider<SetupTipScreenBloc>(
        create: (BuildContext context) => SetupTipScreenBloc(accountRepository: _accountRepository, authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: SetupTipBody(controller: _controller,),
      ),
    );
  }
}