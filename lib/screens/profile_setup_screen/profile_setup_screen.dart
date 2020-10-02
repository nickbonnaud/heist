import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/screens/profile_setup_screen/widgets/profile_setup_cards.dart';

import 'bloc/profile_setup_screen_bloc.dart';

class ProfileSetupScreen extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocProvider<ProfileSetupScreenBloc>(
        create: (context) => ProfileSetupScreenBloc()
          ..add(Init(customer: BlocProvider.of<AuthenticationBloc>(context).customer)),
        child: ProfileSetupCards()
      )
    );
  }
}