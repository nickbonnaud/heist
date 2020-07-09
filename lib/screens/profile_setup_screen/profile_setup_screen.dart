import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';

import 'bloc/profile_setup_screen_bloc.dart';
import 'widgets/profile_setup_screen_body.dart';

class ProfileSetupScreen extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomPadding: false,
      body: BlocProvider<ProfileSetupScreenBloc>(
        create: (context) => ProfileSetupScreenBloc()
          ..add(Init(customer: BlocProvider.of<AuthenticationBloc>(context).customer)),
        child: ProfileSetupScreenBody()
      )
    );
  }
}