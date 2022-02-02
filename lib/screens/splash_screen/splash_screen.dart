import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/app/bloc/app_ready_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/screens/splash_screen/widgets/bloc/splash_screen_bloc.dart';

import 'widgets/splash_screen_body.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PermissionsBloc>(context).add(CheckPermissions());
    BlocProvider.of<AuthenticationBloc>(context).add(InitAuthentication());
    return BlocProvider<SplashScreenBloc>(
      create: (_) => SplashScreenBloc(
        appReadyBloc: BlocProvider.of<AppReadyBloc>(context)
      ),
      child: SplashScreenBody(),
    );
  }
}