import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';

import 'bloc/onboard_bloc.dart';
import 'widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<OnboardBloc>(
        create: (BuildContext context) => OnboardBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          permissionsBloc: BlocProvider.of<PermissionsBloc>(context)
        ),
        child: OnboardBody(),
      ),
    );
  }
}