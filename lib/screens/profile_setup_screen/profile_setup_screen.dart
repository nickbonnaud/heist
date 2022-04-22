import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/screens/profile_setup_screen/widgets/profile_setup_cards.dart';

import 'bloc/profile_setup_screen_bloc.dart';

class ProfileSetupScreen extends StatelessWidget {

  const ProfileSetupScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("profileSetupScreenKey"),
      body: BlocProvider<ProfileSetupScreenBloc>(
        create: (context) => ProfileSetupScreenBloc()
          ..add(Init(status: BlocProvider.of<CustomerBloc>(context).customer!.status)),
        child: const SafeArea(
          bottom: false,
          child: ProfileSetupCards()
        )
      )
    );
  }
}